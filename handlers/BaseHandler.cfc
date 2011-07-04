/**
********************************************************************************
* Copyright Since 2011 CodexPlatform
* www.codexplatform.com | www.coldbox.org | www.ortussolutions.com
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
*********************************************************************************/
component{

	// TODO: Remove this
	function setNextRoute(route,persist,varStruct,addToken,suffix=""){
		var _event = getController().getRequestService().getContext();
		arguments.event = arguments.route & _event.getRewriteExtension() & arguments.suffix;
		getController().setNextEvent(argumentCollection=arguments);
	}
	
	// TODO: Update to new standards
	function setNextEvent(event="",queryString="",addToken,persist,varStruct){
		var _event = getController().getRequestService().getContext();
		
		if( len(arguments.queryString) ){
			arguments.queryString = arguments.queryString & _event.getRewriteExtension();
		}
		else{
			arguments.event = arguments.event & _event.getRewriteExtension();
		}
		getController().setNextEvent(argumentCollection=arguments);
	}

}