<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head>	<cfoutput>	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />	<meta name="Robots" content="index,follow" />	<!--- Main CSS --->	<link rel="stylesheet" type="text/css" href="#getSetting('htmlBaseURL')#/includes/style.css" />	<!--- loop around the cssAppendList, to add page specific css --->	<cfloop list="#event.getValue("cssAppendList", "")#" index="css">		<link rel="stylesheet" type="text/css" href="#getSetting('htmlBaseURL')#/includes/css/#css#.css" />	</cfloop>	<!--- Page Title --->	<title>CodeX Wiki - </title>	</cfoutput></head><body>	<!-- wrap starts here -->	<div id="wrap">	<cfoutput>		<!-- header -->		#renderView('tags/header')#		<!-- Sidebar -->		<div id="sidebar" >			#renderView('tags/sidebar')#		</div>		<div id="main">			#renderView()#		</div>	</cfoutput>	</div>	<!-- wrap ends here -->	<!-- footer starts here -->	<div class="footer">		<cfoutput>#renderView('tags/footer')#</cfoutput>	</div></body></html>