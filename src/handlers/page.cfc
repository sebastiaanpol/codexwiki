<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
********************************************************************************
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
<cfcomponent name="page"
			 extends="baseHandler"
			 output="false"
			 hint="This is our main page handler"
			 autowire="true"
			 cache="true" cacheTimeout="0">

	<!--- dependencies --->
	<cfproperty name="WikiService" 		type="ioc" scope="instance" />
	<cfproperty name="SearchEngine" 	type="ioc" scope="instance" />
	<cfproperty name="SecurityService" 	type="ioc" scope="instance" />

	<!--- IMPLICIT PROPERTIES --->
	<cfset this.prehandler_only = "show">

<!------------------------------------------- CONSTRUCTOR ------------------------------------------->

	<cffunction name="init" access="public" returntype="page" output="false">
		<cfargument name="controller" type="any" required="yes">
		<cfscript>
			super.init(arguments.controller);
			/* Show Key */
			instance.showKey = getSetting('showKey') & "/";

			return this;
		</cfscript>
	</cffunction>

<!------------------------------------------- IMPLICIT ------------------------------------------>

	<!--- preHandler --->
	<cffunction name="preHandler" access="public" returntype="void" output="false" hint="handler interceptor">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>
			/* Printable Doctype Check */
			isPrintFormat(arguments.event);
			
			/* Test For Space Route, if found, create virtual page. */
			if( event.valueExists("space") and event.valueExists("pageName") ){
				rc.page = rc.space & ":" & rc.pagename;
			}
		</cfscript>
	</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------>
	
	<!--- showNamespace --->
	<cffunction name="showNamespace" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any" required="yes">
		<cfset var rc = event.getCollection()>
		<cfscript>	
			/* ui table filter js */
			rc.jsAppendList = 'jquery.uitablefilter';
			/* Param incoming value, jsut in case */
			event.paramValue("namespace","");
			/* Get All Pages for the incoming namespace */
			rc.qPages = getWikiService().getPages(namespace=rc.namespace);
			/* Page Title */
			rc.pageTitle = "Namespace Viewer For: #rc.namespace#";
			/* View */
			event.setView(name='wiki/spaceViewer',nolayout=event.getValue("nolayout",false));
		</cfscript>
	</cffunction>

	<cffunction name="show" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any" required="yes">
		<cfscript>
			var rc = arguments.event.getCollection();

			/* Exit Handlers */
			rc.onEditWiki="page/edit";
			rc.onCreateWiki="page/create";
			rc.onDeleteWiki="page/delete";
			rc.onShowHistory="page/showHistory";

			//default page comes from the settings
			arguments.event.paramValue("page", rc.CodexOptions.wiki_defaultpage );

			/* Appends CSS & JS */
			rc.cssAppendList = "wiki.show";
			rc.jsAppendList = "jquery.simplemodal,confirm";

			/* Get Content For Page */
			rc.content = getWikiService().getContent(pageName=rc.page);

			/* Page */
			rc.urlPage = URLEncodedFormat(rc.page);
			
			/* Set views according to persistance */
			if(rc.content.getIsPersisted()){
				/* Check for page protection */
				if( rc.content.getPage().isProtected() AND NOT instance.securityService.isPageViewable(rc.content.getPage()) ){
					/* JS */
					rc.jsAppendList = "formvalidation";
					/* Exit Handler */
					rc.xehPasswordCheck = "page/passwordCheck";
					/* View */
					arguments.event.setView("wiki/showProtected");
				}
				/* Check for printing */
				else if( event.getValue("print","") eq "markup"){
					arguments.event.setView("wiki/showMarkup");
				}
				/* Normal Display */
				else{
					arguments.event.setView("wiki/show");
				}
			}
			else{
				/* Just creation page */
				arguments.event.setView("wiki/create");
			}
		</cfscript>
	</cffunction>
	
	<!--- passwordCheck --->
	<cffunction name="passwordCheck" access="public" returntype="void" output="false" hint="">
		<cfargument name="Event" type="any" required="yes">
		<cfscript>	
			var rc = event.getCollection();
			/* Get The Page submitted */
			var page = getWikiService().getPage(pageName=event.getValue("pageName",""));
			
			/* Check page exists */
			if( page.getIsPersisted() ){
				/* Check if password is valid? */
				if( compare(page.getPassword(),event.getValue("PagePassword")) eq 0 ){
					/* Store protected cookie */
					instance.securityService.authorizePage(page);
					setNextRoute(route=instance.showKey & page.getName());
				}
				else{
					getPlugin("messagebox").setMessage(type="warning", message="The password you entered is incorrect.");
					setNextRoute(route=instance.showKey & page.getName());				
				}
			}
			else{
				/* Message and take home */
				getPlugin("messagebox").setMessage(type="error", message="Page not found in our system");
				setNextEvent(instance.showKey);
			}
			
		</cfscript>
	</cffunction>

	<cffunction name="create" access="public" returntype="void" output="false" hint="Show the Create a new page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			manage(arguments.event);
		</cfscript>
	</cffunction>

	<cffunction name="doCreate" access="public" returntype="void" output="false" hint="Create a new page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			process(arguments.event);
		</cfscript>
	</cffunction>

	<cffunction name="edit" access="public" returntype="void" output="false" hint="Show the edit page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			manage(arguments.event);
		</cfscript>
	</cffunction>

	<cffunction name="doEdit" access="public" returntype="void" output="false" hint="Update a page">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			/* Dispatch manage */
			process(arguments.event);
		</cfscript>
	</cffunction>

	<cffunction name="renderContent" access="public" returntype="void" output="false" hint="Render Content">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var content = getWikiService().getContent(arguments.event.getValue('contentid',0));
			/* Render Data */
			event.renderData(type='PLAIN', data=content.render(),contentType='text/html');
		</cfscript>
	</cffunction>
	
	<cffunction name="renderPage" access="public" returntype="void" output="false" hint="Render a Page's Content">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var content = getWikiService().getContent(pageName=event.getValue("page",""));
			/* Render Data */
			event.renderData(type='PLAIN', data=content.render(),contentTYpe='text/html');
		</cfscript>
	</cffunction>

	<cffunction name="renderPreview" access="public" returntype="void" output="false" hint="Render Content Previews">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
		    var oContent = getWikiService().getContent();
			var page = 0;
			
			/* Check if sending Page */
			if( event.valueExists("pagename") ){
				/* Get and set it for preview rendering. */
				page = getWikiService().getPage(pageName=event.getValue("pageName"));
				oContent.setPage(page);
			}
			
			/* Get Content */
			oContent.populate(arguments.event.getCollection());
			
			/* Render Data */
			event.renderData(data=oContent.render());
		</cfscript>
	</cffunction>

	<cffunction name="showHistory" hint="shows a page's history" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var pageName = arguments.event.getValue("page");

			/* Get the Page */
			rc.page = getWikiService().getPage(pageName=pageName);
			/* Get the History */
			rc.History = getWikiService().getPageHistory(pageName);

			/* CSS & JS */
			rc.cssAppendList = "page.showHistory";
			rc.jsAppendList = "jquery.simplemodal,confirm";

			/* Exit Handlers */
			rc.onReplaceActive ="page/replaceActive";
			rc.onDelete ="page/deleteContent";
			rc.onPreview = "page/renderContent";
			rc.onDiff = "page/diff";

			/* View */
			arguments.event.setView("wiki/showHistory");
		</cfscript>
	</cffunction>

	<!--- diff --->
	<cffunction name="diff" access="public" returntype="void" output="false" hint="Diff pages">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
		    var rc = event.getCollection();
			var pageName = arguments.event.getValue("page");
			var oDiffer = getMyPlugin("diff");

			/* Validate Versions */
			if( not event.valueExists("version") OR not event.valueExists("old_version") ){
				getPlugin("messagebox").setMessage(type="warning", message="No version information passed in.");
				setNextRoute('page/showHistory/#rc.page#');
			}

			/* CSS & JS */
			rc.cssAppendList = "page.showHistory";
			rc.jsAppendList = "jquery.simplemodal,confirm";

			/* Exit Handler */
			rc.onShowHistory = "page/showHistory";

			/* Get the Page content */
			rc.page = getWikiService().getPage(pageName=pageName);
			rc.CurrentContent = getWikiService().getContentByPageVersion(pageName=pagename,version=rc.version);
			rc.oldContent = getWikiService().getContentByPageVersion(pageName=pagename,version=rc.old_version);

			/* Diff Setup */
			rc.diff = oDiffer.DiffArrays(listToArray(rc.oldContent.getContent(),chr(10)), listToArray(rc.CurrentContent.getContent(),chr(10)));
			rc.parallel = oDiffer.parallelize(rc.diff,listToArray(rc.oldContent.getContent(),chr(10)), listToArray(rc.CurrentContent.getContent(),chr(10)));
			
			/* Diff CSS */
			rc.diffcss = structnew();
			rc.diffcss["+"] = "ins";
			rc.diffcss["-"] = "del";
			rc.diffcss["!"] = "upd";
			rc.diffcss[""] = "";

			/* View */
			event.setView("wiki/showDiff");
		</cfscript>
	</cffunction>

	<cffunction name="deleteContent" hint="delete's a content object" access="public" returntype="string" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var content = getWikiService().getContent(arguments.event.getValue("contentid"));
			var page = content.getPage();

			getWikiService().deleteContent(content);

			setNextRoute(route="page/showHistory/" & page.getName());
		</cfscript>
	</cffunction>

	<cffunction name="replaceActive" hint="delete's a content object" access="public" returntype="string" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var content = getWikiService().getContent(arguments.event.getValue("contentid"));
			var page = content.getPage();

			content.replaceActive();

			setNextRoute(route="page/showHistory/" & page.getName());
		</cfscript>
	</cffunction>

	<cffunction name="delete" hint="delete a wiki page" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			//s'not really a content id, it's a page id
			var pageid = arguments.event.getValue("contentid");
			var page = getWikiService().getPage(pageid);

			getWikiService().deletePage(pageid);

			setNextRoute(route=instance.showKey & page.getName(), persist="page");
		</cfscript>
	</cffunction>

	<cffunction name="search" hint="searchs active pages" access="public" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var search_query = arguments.event.getValue("search_query", "");
			var result = instance.SearchEngine.search(search_query);

			/* Messagebox when search is not available */
			if ( StructKeyExists(result, "error") ){
				getPlugin("messagebox").setMessage("error", result.error );
			}
			else{
				/* Render Results */
				rc.searchResults = instance.SearchEngine.renderSearch(result,arguments.event,getController());
			}
			/* Set View to render */
			arguments.event.setView("wiki/search");
		</cfscript>
	</cffunction>

	<!--- directory --->
	<cffunction name="directory" access="public" returntype="void" output="false" hint="Pages Directory">
		<cfargument name="Event" type="any" required="yes">
	    <cfscript>
			var rc = event.getCollection();
			var ids = "";
			var qDefault = 0;

			/* Required */
			rc.jsAppendList = 'jquery.uitablefilter';
			/* Get All Pages */
			rc.qPages = getWikiService().getPages();
			rc.qNameSpaces = getWikiService().getNamespaces();

			qDefault = getPlugin("queryHelper").filterQuery(qry=rc.qPages,field="isDefault",value=1,cfsqltype="cf_sql_integer");

			/* Filter */
			ids = event.getValue("namespaces",qDefault.namespace_id);
			if( right(ids,1) eq "," ){
				ids = left(ids, len(ids)-1 );
			}
			rc.qPages = getPlugin("queryHelper").filterQuery(qry=rc.qPages,field="namespace_id",value=ids,list=true);

			/* View */
			if( event.valueExists('pagesTable') ){

				/* View */
				event.setView('wiki/directoryPagesTable',true);
			}
			else{
				event.setView('wiki/directory');
			}
		</cfscript>
	</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

	<cffunction name="process" hint="processes the wiki details as a save or update" access="private" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = event.getCollection();
			var messages = 0;
			var oContent = 0;
			var activeContent = 0;
			
			/* Params */
			event.paramValue("isReadOnly",false);
			event.paramValue("RenamePageName","");
			
			/* Get Page */
			rc.page = getWikiService().getPage(pageName=rc.pageName);
			/* Get Content */
			oContent = rc.page.getNewContentVersion(rc);
			/* Get Active Content */
			oActiveContent = getWikiService().getContent(pageName=rc.pageName);
			/* Validate Content */
			messages = oContent.validate(isCommentsMandatory=rc.CodexOptions.wiki_comments_mandatory);
			if(ArrayLen(messages))
			{
				/* MB & content set */
				getPlugin("messagebox").setMessage(type="warning", messageArray=messages);
				rc.content = oContent;
				/* Save Version for non dirty edits */
				rc.content.setVersion(oActiveContent.getVersion());
				/* ReRoute with persistence */
				setNextRoute(route="page/edit/" & rc.pageName, persist="content");
			}
			else
			{
				/* Check for Version Modifications just before saving */
				if( oActiveContent.getVersion() neq rc.pageVersion ){
					getPlugin("messagebox").setMessage(type="warning", message="Page was not saved as you where editing an old version of the page. Displaying current version");
					/* ReRoute */
					setNextRoute(route=instance.showKey & rc.pageName);
				}
				
				/* Save New Content to page */
				rc.page.addContentVersion(oContent);
				/* Check for Page Renaming */
				if( rc.page.getIsPersisted() and len(event.getTrimValue("renamePageName","")) ){
					rc.page.setName(rc.RenamePageName);
					rc.pageName = rc.RenamePageName;
				}
				/* Page Extra Properties */
				rc.page.setTitle(event.getTrimValue("title"));
				rc.page.setPassword(event.getTrimValue("PagePassword"));
				rc.page.setDescription(event.getTrimValue("Description"));
				rc.page.setKeywords(event.getTrimValue("Keywords"));
				/* Save this Page */
				getWikiService().save(rc.page);
				
				/* Re Route */
				setNextRoute(route=instance.showKey & rc.pageName, persist="page");
			}
		</cfscript>
	</cffunction>

	<cffunction name="manage" hint="manage a wiki page" access="private" returntype="void" output="false">
		<cfargument name="event" type="any">
		<cfscript>
			var rc = arguments.event.getCollection();
			var content = 0;

			/* Custom JS */
			rc.jsAppendList = "jquery.simplemodal,jquery.textarearesizer.compressed,markitup/jquery.markitup.pack,markitup/sets/wiki/set";
			/* Markitup Editor */
			rc.cssFullAppendList = "includes/scripts/markitup/skins/markitup/style,includes/scripts/markitup/sets/wiki/style";

			/* if no content, get for management */
			if( not arguments.event.valueExists("content") ){
				rc.content = getWikiService().getContent(pageName=rc.page);
			}

			/* Check Persistence and set Exit Handlers */
			if( rc.content.getPage().getIsPersisted() ) {
				rc.onSubmit = "page/doEdit";
			}
			else{
				rc.onSubmit = "page/doCreate";
			}
			rc.onPreview = "page/renderPreview";
			rc.onPageRender = "page/renderPage";
			rc.onCancel = "wiki";
			rc.onCheatSheet = "Help:Cheatsheet";

			/* View */
			arguments.event.setView("wiki/manage");
		</cfscript>
	</cffunction>

	<cffunction name="getWikiService" access="private" returntype="codex.model.wiki.WikiService" output="false">
		<cfreturn instance.wikiService />
	</cffunction>

	<cffunction name="isPrintFormat" access="private" returntype="void" hint="Check for print in the event and change layout">
		<cfargument name="Event" type="any">
		<cfscript>
		if( not reFindNoCase("^(flashpaper|pdf|HTML|markup)$",event.getValue("print","")) ){
			return;
		}
		else{
			/* Change Layout */
			Event.setLayout("Layout.Print");
			/* Set Extensions */
			if ( Event.getValue("print") eq "pdf" )
			{
				event.setValue("layout_extension","pdf");
			}
			else if( event.getValue("print") eq "flashpaper"){
				event.setValue("layout_extension","swf");
			}
			else if( event.getValue("print") eq "markup"){
				event.setLayout("Layout.MarkupExport");
			}
			else{
				Event.setLayout("Layout.html");
			}
		}
		</cfscript>
	</cffunction>
</cfcomponent>