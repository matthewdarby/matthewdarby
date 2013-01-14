<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 //EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<cfoutput>
	<title>Matthew Darby.com: #request.pagetitle#</title>
	</cfoutput>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta name="verify-v1" content="zRglGiZ4K0j4LMXxHavasjzM5rnivVWxUD8hTSrI/VA=" />
	<meta name="keywords" content="personal, matthew, darby, development, coldfusion, blog, weblog, technology, development">
	<meta name="description" content="This is the personal website of Matthew Darby.  You can view my portfolio, follow the link to my blog and find out more backgroudn information about who I am">
	<link href="Darby/css/main.css" rel="stylesheet" type="text/css">
	<cfinclude template="../css/ieHacks.cfm" />
</head>
 
<body>
	<div id="header">
		<img src="Darby/images/header-logo.gif" alt="MatthewDarby.com">
	</div>
	<div id="menurow">
		<ul>
			<li><a href="index.cfm?page=contact">Contact</a></li>	
			<li><a href="http://blog.matthewdarby.com">Blog</a></li>
			<li><a href="index.cfm?page=about">About Me</a></li>	
			<li><a href="index.cfm?page=portfolio">Portfolio</a></li>	
			<li><a href="index.cfm">Home</a></li>
		</ul>
	</div>
	<div id="contentarea">
	<div id="contentbody">
		<cfif viewCollection.exists("body")>
	  		<cfoutput>#viewCollection.getView("body")#</cfoutput>
		</cfif>
	</div>
	</div>
	<div id="footer">
	<cfoutput>
		<p>Copyright #datePart("yyyy", now())# of MatthewDarby.com and Blue Trane Web Design Unless Otherwise Noted.</p>
	</cfoutput>
	</div>
</body>
</html>
