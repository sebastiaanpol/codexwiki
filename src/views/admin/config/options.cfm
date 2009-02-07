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
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
	$(document).ready(function() {
		/* Form Validation */
		$('##optionForm').formValidation({
			err_class 	: "invalidLookupInput",
			err_list	: true,
			alias		: 'dName',
			callback	: 'prepareSubmit'
		});
		
		//Page Filter
		theTable = $('##wikiPagesTable');
		$("##pageFilter").keyup(function(){
			$.uiTableFilter(theTable,this.value);
		})

				
	});
	function prepareSubmit(){
		$('##_buttonbar').slideUp("fast");
		$('##_loader').fadeIn("slow");
		return true;
	}
	function selectPage(thePage){
		$('##wiki_defaultpage').val(thePage);
		$('##wikiPageListing').slideToggle();
	}
	function selectSearch(engine){
		$('##wiki_search_engine').val(engine);
	}
	function submitReinit(){
		$('##_loader2').toggle();
		$('##ReinitSubmit').toggle();
	}
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<!--- create a non found wiki page --->
<cfoutput>
<h2><img src="includes/images/cog.png" align="absmiddle"> Codex Options</h2>
<p>
	Below you can see the Codex general options and version information. Please be careful when editing the main options as it affects the entire wiki installation.
</p>
<!--- Messagebox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.xehonSubmit)#" method="post" id="optionForm" name="optionForm">
	<fieldset>
	<legend><strong>General Options</strong></legend>
	 	<!--- Wiki Name --->
		<label for="wiki_name">Wiki Name</label>
		The global name for this wiki.<br />
		<input type="text"
			   dName="Wiki Name"
			   name="wiki_name" id="wiki_name" 
			   value="#rc.CodexOptions.wiki_name#" size="60" required="true">
     	<br /><br />
	
		<!--- Wiki Metadata --->
		<label for="wiki_metadata">Wiki Metadata Description</label>
		The global metadata description content to place in the metadata tag.<br />
		<textarea dName="Wiki Metadata"
			      name="wiki_metadata" id="wiki_metadata"
			   	  rows="2"  required="true">#rc.CodexOptions.wiki_metadata#</textarea>
     	<br />
	
		<!--- Wiki Keywords --->
		<label for="wiki_metadata">Wiki Metadata Keywords</label>
		The global metadata keywords to place in the metadata tag.<br />
		<textarea dName="Wiki Metadata Keywords"
			      name="wiki_metadata_keywords" id="wiki_metadata_keywords"
			   	  rows="2" required="true">#rc.CodexOptions.wiki_metadata_keywords#</textarea>
     	<br />
		
		<!--- Wiki Outgoing Email --->
		<label for="wiki_name">Wiki Outgoing Email</label>
		The email to use to send out email.<br />
		<input type="text"
			   dName="Wiki Outgoing Email"
			   name="wiki_outgoing_email" id="wiki_outgoing_email" 
			   value="#rc.CodexOptions.wiki_outgoing_email#" 
			   size="60" required="true" mask="email">

		<br /><br />
		<!--- Default Page --->
		<label for="wiki_defaultpage_label">Wiki Default Page Label</label>
     	The label for the menu item for the default wiki page.<br />
		<input type="text" 
		 	   dName="Default Page Label"
		 	   name="wiki_defaultpage_label" id="wiki_defaultpage_label" 
		 	   value="#rc.CodexOptions.wiki_defaultpage_label#" size="60" required="true"> 
		<br /><br />
		<label for="wiki_defaultpage">Wiki Default Page</label>
     	The actual wiki page name to link to.<br />
		<input type="text" 
		 	   dName="Default Page"
		 	   name="wiki_defaultpage" id="wiki_defaultpage" 
		 	   value="#rc.CodexOptions.wiki_defaultpage#" size="60" required="true"> 
		<input type="button" name="pageChooser" id="pageChooser" 
			   onClick="$('##wikiPageListing').slideToggle()" value="Choose Page">
		<div id="wikiPageListing" class="wikiChooser">
			<table id="wikiPagesTable" class="tablelisting" width="100%">
				<thead>
					<tr>
						<th>
						<strong>Wiki Page: </strong>
						<input name="pageFilter" id="pageFilter" value="Type Here To Filter" 
							   size="50" type="text"
							   onClick="if(this.value='Type Here To Filter'){this.value='';}">
						</th>
					</tr>
				</thead>
				<tbody>
				<cfloop query="rc.qPages">
					<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
						<td><a href="javascript:selectPage('#name#')">#name#</a></td>
					</tr>
				</cfloop>
				</tbody>
				
			</table>
		</div>
		
		<br /><br />
		<!--- Default Page --->
		<label for="wiki_search_engine">Wiki Search Engine</label>
     	The wiki search engine class to use. You can create your own search engine adapters
	    as long as they implement <em>codex.model.search.adapters.ISearchAdapter</em>.  If you change 
	    this setting, please make sure that you re-initialize Codex in order for the changes to take
	    effect.
	    <br /><br />
	    Codex comes bundled with the following search engine adapters:<br />
		<ul>
			<li><strong>Database Search</strong><br /><a href="javascript:selectSearch('codex.model.search.adapters.DBSearch')">codex.model.search.adapters.DBSearch</a></li>
			<li><strong>Verity Search</strong><br /><a href="javascript:selectSearch('codex.model.search.adapters.VeritySearch')">codex.model.search.adapters.VeritySearch</a></li>
		</ul>
		<input type="text" 
		 	   dName="Search Engine"
		 	   name="wiki_search_engine" id="wiki_search_engine" 
		 	   value="#rc.CodexOptions.wiki_search_engine#" size="60" required="true"> 
		<br /><br />
		
		<!--- Comments  --->
		<label for="wiki_comments_mandatory">Mandatory Page Comments</label> 
		Whether edit comments for pages should be mandatory or not.<br />
		<input type="radio" 
			   name="wiki_comments_mandatory" id="wiki_comments_mandatory"
			   <cfif rc.CodexOptions.wiki_comments_mandatory>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="wiki_comments_mandatory" id="wiki_comments_mandatory"
			   <cfif not rc.CodexOptions.wiki_comments_mandatory>checked="checked"</cfif>
			   value="0">No
		
		<br /><br />
	</fieldset>
	
	<fieldset>
		<legend>Wiki Registration</legend>
		
		<!--- Wiki Registration --->
		<label for="wiki_registration">Enable/Disable Wiki Registration</label> 
		Activate wiki user registration or not.<br />
		<input type="radio" 
			   name="wiki_registration" id="wiki_registration"
			   <cfif rc.CodexOptions.wiki_registration>checked="checked"</cfif>
			   value="1">Yes
		<input type="radio" 
			   name="wiki_registration" id="wiki_registration"
			   <cfif not rc.CodexOptions.wiki_registration>checked="checked"</cfif>
			   value="0">No

		<!--- Wiki Default Role --->
		<label for="wiki_defaultrole_id">Default Role</label>
		The default role assigned to users when they register for this wiki.<br />
		<select name="wiki_defaultrole_id" id="wiki_defaultrole_id" required="true" dName="Default Role" style="width:200px">
			<cfloop query="rc.qRoles">
				<option value="#roleid#" <cfif roleid eq rc.CodexOptions.wiki_defaultrole_id>selected="selected"</cfif>>#role#</option>
			</cfloop>
		</select>
		
	</fieldset>
	
	<fieldset>
		<legend>Paging Options</legend>
		<!--- Max Rows --->
		<label for="wiki_paging_maxrows">Paging Max Rows</label>
		The maximum number of rows for paging.<br />
		<select dName="Paging Max Rows" 
				name="wiki_paging_maxrows" id="wiki_paging_maxrows" 
				required="true">
			<cfloop from="5" to="50" step="5" index="i">
				<option value="#i#" <cfif i eq rc.CodexOptions.wiki_paging_maxrows>selected="selected"</cfif>>#i#</option>
			</cfloop>
		</select>
		
		<br /><br />
		<!--- Max Band Gap --->
		<label for="wiki_paging_bandgap">Paging Band Gap</label>
		The number of pages to have in the paging carrousel.<br />
		<select dName="Paging Band Gap"
				name="wiki_paging_bandgap" id="wiki_paging_bandgap" 
				required="true">
			<cfloop from="5" to="50" step="5" index="i">
				<option value="#i#" <cfif i eq rc.CodexOptions.wiki_paging_bandgap>selected="selected"</cfif>>#i#</option>
			</cfloop>
		</select>
		
	</fieldset>
	
	<!--- Loader --->
	<div id="_loader" class="align-center formloader">
		<p>
			Submitting...<br />
			<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
			<img src="includes/images/ajax-loader-horizontal.gif" align="absmiddle">
		</p>
	</div>

	<!--- Management Toolbar --->
	<div id="_buttonbar" class="buttons">
		<input type="submit" class="submitButton" value="Save Wiki Options"></input>
   	</div>
</form>
</cfoutput>