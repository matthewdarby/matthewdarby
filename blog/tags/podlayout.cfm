<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : podlayout.cfm
	Author       : Raymond Camden 
	Created      : October 29, 2003
	Last Updated : July 22, 2005
	History      : PaulH added cfproc (rkc 7/22/05)
	Purpose		 : Pod Layout
--->

<cfparam name="attributes.title" type="string" />
<cfparam name="attributes.classname" type="string" default="widget" />

<cfif thisTag.executionMode is "start">

	<cfoutput>
	<div class="#attributes.classname#">
		<h3>#attributes.title#</h3>
	</cfoutput>		

<cfelse>

	<cfoutput>
	<!-- end:#attributes.classname# --></div>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly=false>