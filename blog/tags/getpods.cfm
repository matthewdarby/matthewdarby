<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : GetPods.cfm
	Author       : Scott Pinkston 
	Created      : October 13, 2006
	Last Updated : October 16, 2006
	Purpose		 : Add pod controls
	History      : Added fileExists check
				   boyzoid -changed structSort to numeric sort 

--->
  
	<cfparam name="attributes.fname" type="string" default="leftpods" />  
  
	<cfset podDir = getDirectoryFromPath(getCurrentTemplatePath()) & "../includes/#attributes.fname#/">

	<cfset podList = application.pod.getpods(podDir)>
	<cfset podList = structsort(podlist.pods,"numeric")>
	
	<!--- see if the metadata exists, if not we will load all pods --->
	<cfif arraylen(podlist)>
		<cfloop from="1" to="#arraylen(podlist)#" index="pod">
			<cfif fileExists(podDir & "/#podlist[pod]#")>
				<cfinclude template="../includes/#attributes.fname#/#podlist[pod]#">
			</cfif>
		</cfloop>

	<cfelse>
			<cfdirectory action="list" filter="*.cfm" directory="#podDir#" name="Pods">

			<cfoutput query="pods">
				<cfif fileExists(podDir & "/#name#")>
					<cfinclude template="../includes/#attributes.fname#/#name#">
				</cfif>
			</cfoutput>
	</cfif>	

<cfsetting enablecfoutputonly=false>

<!--- eof --->