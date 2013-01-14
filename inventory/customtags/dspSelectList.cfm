<!--- 	I return the html for a select field the info passed to me.
		
		<query name="qry" 				    	 required="true"     comments="query that contains possible descriptions for the code" />
		<string name="selectName" 	 	   default="code" 		 comments="what the select field will be named" />
		<string name="valueToMatch" 		 required="true"	   comments="the value to compare with the qry's columnToMatch to have the selected attribute in the option tag"/>
		<string name="columnToMatch" 	   default="code" 		 comments="the column within the qry that needs to match the valueToMatch to have the selected attributes in the option tag"/>
		<string name="columnToShow" 		 default="long_desc" comments="the column within the qry that will show as the text in the option tag" />
		<boolean name="showSelectOption" default="true" 	   comments="when true, the first option will be '-- Select option --'  />
		<boolean name="showCode"         default="false"     comments="when true, the code will display after the columnToShow" />

 --->
<cfsetting enablecfoutputonly="true"/>
<cfif thisTag.ExecutionMode is 'start'>
 <cfparam name="attributes.selectName"        default="code" />
 <cfparam name="attributes.columnToMatch"     default="code" />
 <cfparam name="attributes.columnToShow"      default="long_desc" />
 <cfparam name="attributes.valueToSend"       default="code" />
 <cfparam name="attributes.showSelectOption"  default="true" />
 <cfparam name="attributes.showCode"          default="false" />
<cfparam name="attributes.class" 			  default="populate" />
 <cfset hasMatch = false />
 <!--- for readability --->
 <cfset columnToMatch = attributes.columnToMatch />
 <cfset columnToShow  = attributes.columnToShow />
 <cfset valueToSend   = attributes.valueToSend />
 <cfset showCode      = attributes.showCode />
 <cfset qry           = attributes.qry />
	<!--- standard code formatting is not used to eliminate white space --->
	<cfoutput><select name="#attributes.selectName#" id="#attributes.selectName#" <cfif StructKeyExists(attributes, 'class')>class="#attributes.class#"</cfif>><cfif attributes.showSelectOption><option value="" >-- Select option --</option></cfif>
	<cfloop query="qry"><cfif (attributes.valueToMatch is qry[columnToMatch][currentrow]) or (attributes.valueToMatch is "" and qry.recordcount is 1)><cfset hasMatch = true />
			<option value="#qry[valueToSend][currentrow]#" selected><cfoutput>#qry[columnToShow][currentrow]# <cfif showCode>(#qry[columnToMatch][currentrow]#)</cfif></cfoutput></option>
		<cfelse><option value="#qry[valueToSend][currentrow]#"><cfoutput>#qry[columnToShow][currentrow]#  <cfif showCode>(#qry[columnToMatch][currentrow]#)</cfif></cfoutput></option></cfif>
	</cfloop>
	<cfif (not hasMatch) and attributes.valueToMatch is not ""><option value="#attributes.valueToMatch#" selected><cfoutput>#attributes.valueToMatch# is no longer valid</cfoutput></option></cfif>
	</select></cfoutput>
 </cfif>
<cfsetting enablecfoutputonly="false"/>