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
<cfoutput>
<h2><img src="includes/images/plugin_icon.png" align="absmiddle"> 
CodeX Wiki Plugins</h2>
<p>
	From this panel you can see the installed Wiki Plugins, reload the plugins index,
	remove plugins and even install new plugins.
</p>

<!--- Box --->
#getPlugin("messagebox").renderit()#

<form name="uploadForm" id="uploadForm" 
	  action="#event.buildLink(rc.xehUpload)#.cfm" 
	  enctype="multipart/form-data"
	  method="post">
	<h3>Upload/Install Plugin</h3>
	<p>
	<label>Plugin File</label>
	<input type="file" name="filePlugin" id="filePlugin" size="60">
	
	<input type="submit" value="Upload/Install Plugin">
	</p>
</form>

<table class="tablelisting center" width="98%" align="center">
	<tr>
		<th>Installed Plugins</th>
		<th class="center" width="50">Actions</th>
	</tr>
	<cfloop query="rc.qPlugins">
		<tr <cfif currentrow mod 2 eq 0>class="even"</cfif>>
			<td>#name#</td>
			<td class="center">
				<a href="#event.buildLink(rc.xehRemove)#/plugin/#getPlugin('Utilities').ripExtension(name)#.cfm" 
				   onClick="return confirm('Do you really want to delete this plugin?')"
				   title="Remove Plugin"><img src="includes/images/bin_closed.png" align="absmiddle" border="0"></a>
			</td>
		</tr>
	</cfloop>
</table>

<br />

<!--- Reload Button --->
<div class="align-center">
	<a href="#event.buildLink(rc.xehReload)#.cfm" id="buttonLinks">
		<span>
			<img src="includes/images/arrow_refresh.png" border="0" align="absmiddle">
			Reload Plugins Index
		</span>
	</a>
</div>

<br />
<!--- Plugin Docs --->
#rc.oWikiPlugin.renderit(title="Installed Plugins Documentation")#
</cfoutput>