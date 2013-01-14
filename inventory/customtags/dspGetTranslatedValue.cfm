<cfif thisTag.ExecutionMode is 'start'>
	<cfparam name="attributes.qryValue" type="query" />
	<cfparam name="attributes.valueToMatch" type="string" />
	<cfparam name="attributes.valueToShow" type="string" default="long_desc"/>	
	<cfparam name="attributes.columnToMatch" type="string" default="code" />
	<cfparam name="attributes.inputName" type="string" default="#attributes.valueToMatch#" />
	<cfparam name="attributes.isFormElement"  type="boolean" default="false" />
	
	<cfset qry = attributes.qryValue />
	<cfset show = attributes.valueToShow />
	<cfset value = attributes.valueToMatch />
	<cfset match = attributes.columnToMatch />

	<cfloop query="qry">
		<cfif qry[match][currentrow] is value><cfoutput>#qry[show][currentrow]# 
		<cfif attributes.isFormElement><input name="#attributes.inputName#" type="hidden" value="#qry.code#" /></cfif></cfoutput></cfif>
	</cfloop>
</cfif>