<cfsetting enablecfoutputonly='true'>
<cfprocessingdirective pageencoding='utf-8'>
<!---
   Name : twitter.cfm
   Author : PodGenerator (based on archives.cfm by Raymond Camden) 
--->
<cfinclude template="/includes/udf.cfm">
<cfmodule template="../../tags/podlayout.cfm" title="Twitter Updates">

<cfmodule template="../../tags/scopecache.cfm" scope="application" cachename="feed" timeout="#60*60#">

 	<cftry> 
		<cfset theURL = "http://twitter.com/statuses/user_timeline/15042936.atom">
		<cfhttp url="#theURL#" timeout="5">

		<cfset xml = xmlParse(cfhttp.filecontent)>
		<cfset items = xmlSearch(xml, "//*[local-name() = 'entry']")>
		<cfoutput><ul></cfoutput>
		<cfloop index="x" from="1" to="#min(arrayLen(items),5)#">
			<cfset item = items[x]>

			<cfoutput>
			<li><span>#ReplaceNoCase(item.content.xmlText, 'matthew_darby: ', '')#</span> <a href="#item.link.xmlAttributes.href#">#getElaspsedTime(DateAdd('h', -5, ISODateToTS(item.published.xmlText)))# ago</a></li>
			</cfoutput>
		</cfloop>
		<cfoutput></ul>
			<p><a href="http://twitter.com/matthew_darby">More Updates</a></p>
		</cfoutput>
	<cfcatch>
			<cfoutput>
			Feed temporarily down.
			</cfoutput>
		</cfcatch>
	</cftry>
			 
</cfmodule>
	
</cfmodule>
<cfsetting enablecfoutputonly='false'/>
	
