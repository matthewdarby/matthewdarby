<cfsetting enablecfoutputonly="true" />
<!---
<fusedoc fuse="layPortal.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I am the layout for the internal site that uses the same layout as the public site
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">		
				<structure name="content">
					<string name="mainMenu" />
					<string name="secondaryNavContent" />
					<string name="pageBody" />
					<string name="pageTitle" />
					<string name="statusContent" />
				</stucture>
				<structure name="appConstants" />
				<string name="messages" />
			</stucture>
		</in>
	</io>
</fusedoc>
--->

<cfset myConstants = event.getArg('appConstants') />
<cfset content.messages = event.getArg('messages') />
<cfset content.mainMenu = event.getArg("content.mainMenu") />
<cfset content.pageTitle = event.getArg("content.pageTitle") />
<cfset content.mainMenu = event.getArg("content.mainMenu") />
<cfset content.pageBody = event.getArg("content.pageBody") />
<cfset type = event.getArg('type') />
<cfset content.seondaryNavContent = event.getArg("content.seondaryNavContent") />
<cfset content.StatusContent = event.getArg("content.StatusContent") />

<cfimport prefix="ui" taglib="/customtags" />

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>#content.pageTitle# - Matthew Darby.com</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta name="keywords" content="personal, matthew, darby, development, coldfusion, blog, weblog, technology, development" />
	<meta name="description" content="This is the personal website of Matthew Darby.  You can view my portfolio, follow the link to my blog and find out more backgroudn information about who I am" />
	<link href="#myConstants.cssHome#base.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="#myConstants.jsHome#engine.js"></script>
	<script> 
		function recursiveSelect_request(fld,subFld,mthd){ 
			var params = "type="+fld.options[fld.selectedIndex].value; 
			var callback = function(obj){ 
				clearSelect(subFld); 
				addOptions(subFld,obj); 
			} 
			http( 'post', 'JSMXManager.cfc?method='+mthd, addOptions, params); 
		} 
		
		function clearSelect(elm){ 
			for(var x=elm.options.length;x>0;x--){ 
		  		elm.options[x]=null; 
		 	} 
			elm.options[0].selected=true; 		
		} 
		
		function addOptions(elm,obj){ 
			for(var x=0; x < obj.length; x++){ 
				opt = new Option(obj[x][1],obj[x][0]); 
				elm.options[elm.options.length] = opt; 
			} 		
		} 
	</script> 	
	<script type="text/javascript" src="#myConstants.jsHome#behaviour.js"></script>
	<script type="text/javascript" src="#myConstants.jsHome#actions.js"></script>		
</head>
<body>
	<div id="pageTop">
		<div id="header">
			<img src="http://matthewdarby.com/Darby/images/header-logo.gif" alt="MatthewDarby.com" />
		</div>
		<div align="center" id="menurow">
			#content.mainMenu#
		</div>
	</div>
	<div id="workspace">
		<div id="contentarea">
			<div id="contentbody">		
				<p class="pageTitle">#content.pageTitle#</p>	
				<p><ui:dspFormatReactorMessage messages="#content.messages#" /></p>
				<br />
				#content.pageBody#
			</div>
		</div>
		<div id="sideBar">
			#content.seondaryNavContent#

			#content.StatusContent#
		</div>
	</div>
	<div id="pageBottom">
		<div id="footer">
			<p>Copyright #datePart("yyyy", now())# of MatthewDarby.com and Blue Trane Web Design Unless Otherwise Noted.</p>
		</div>
	</div>
	<iframe width=174 height=189 name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="#myConstants.jsHome#Calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
	</iframe>
</body>
</html>
</cfoutput>
<cfsetting enablecfoutputonly="false" />
