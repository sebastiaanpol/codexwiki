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
<!--- create a non found wiki page --->
<cfsetting showdebugoutput="false">
<!--- js --->
<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript">
function CodexPreview()
{
	var content = $("##content");

	var preview = $('<div style="text-align: center; padding-top: 20px"><span class="loading">Loading Preview...</a></div>').modal({
		close:false,
		onOpen: function(dialog)
			{
			 	dialog.overlay.fadeIn("normal", function()
				 	{
				 		dialog.container.fadeIn("fast");
				 		dialog.data.fadeIn("fast");
				 	}
				 )
			},
		onShow: function(dialog)
			{
				var data = {content: content.val(), pagename: "#rc.content.getPage().getName()#"};
				//Post Preview
				$.post("#event.BuildLink(rc.onPreview)#.cfm", data,
					function(string, status)
					{
						dialog.container.html('<div><p class="align-right"><img src="includes/images/cross.png" align="absmiddle"><a href="javascript:$.modal.close();">close</a></p><div class="modalContent">' + string + '</div></div>');
					}
				);
			}
		}
		);
}

function submitForm(){
	needToConfirm=false;
	$('##_buttonbar').slideUp("fast");
	$('##_loader').fadeIn("slow");
}
function askLeaveConfirmation(){
	if (needToConfirm){
   		return "You have unsaved changes.";
   	}    
}
function markupInserted(){
	needToConfirm = true;
}
$(document).ready(function() {
	$("##content").markItUp(mySettings);
	needToConfirm = false;
	window.onbeforeunload = askLeaveConfirmation;
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<!--- Title --->
<h1>
	<img src="includes/images/page_edit.png" align="absmiddle"> Editing:
	"<a href="#pageShowRoot(URLEncodedFormat(rc.content.getPage().getName()))#.cfm">#rc.content.getPage().getCleanName()#</a>"
</h1>
<!--- MessageBox --->
#getPlugin("messagebox").renderit()#

<!--- Form --->
<form action="#event.buildLink(rc.onSubmit)#.cfm" method="post" class="uniForm" onsubmit="submitForm()">

	<input type="hidden" name="pageName" value="#rc.content.getPage().getName()#" />
	
	<!--- Control Holder & Text Area --->
	<div class="float-right">
		<a href="#pageShowRoot('Help:Cheatsheet')#.cfm">Markup Cheatsheet</a>
		| 
		<a href="#pageShowRoot('Help:Contents')#.cfm">Wiki Help</a>
	</div>
	<label for="content"><em>*</em> Wiki Content</label>
	<textarea name="content" id="content" class="resizable" rows="20" cols="50">#rc.content.getContent()#</textarea>
	
	<!--- Comment Editing --->
	<fieldset title="Change Information">
		<legend>Change Information & Options</legend>
		<label for="comment"><cfif rc.CodexOptions.wiki_comments_mandatory><em>*</em></cfif> Comment about this change
		<cfif not rc.codexOptions.wiki_comments_mandatory>(Optional)</cfif></label>
		<textarea name="comment" id="comment" rows="2" cols="50"></textarea>
		
		<label>
		<input value="true" id="isReadOnly" type="checkbox" name="isReadOnly" <cfif rc.content.getIsReadOnly()>checked="checked"</cfif>/>
		Page is read-only
		</label> 
		If checked, only page author <strong>#rc.oUser.getUsername()#</strong> and a user with WIKI_ADMIN privileges can edit a read-only page.
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
		<input type="button" class="cancelButton" onclick="window.location='#pageShowRoot(rc.content.getPage().getName())#.cfm'" value="cancel"></input>
   		<input type="button" class="previewButton" onclick="javascript:CodexPreview();" value="preview">
   		<input type="submit" class="submitButton" value="submit"></input>
   	</div>
</form>
</cfoutput>