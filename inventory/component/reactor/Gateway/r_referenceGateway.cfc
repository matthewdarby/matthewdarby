
<cfcomponent hint="I am the database agnostic custom Gateway object for the r_reference object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Gateway.r_referenceGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getCodeAndDesc" access="public" output="true" returntype="query">
		<cfargument  name="reference_type" type="string" default="" />		
		<cfargument  name="module" type="string" default="" />	
		<cfargument  name="code" type="string" default="" required="false" />	

		<cfset var local = StructNew() />
 		<cfquery name="local.qrySelectOptions" password="cytron" username="root" datasource="mbdinventory" >  		
			SELECT code, long_desc
			FROM r_reference
			WHERE reference_type = '#arguments.reference_type#'
			AND module = '#arguments.module#'	
			<cfif StructKeyExists(arguments, "code")>
				<cfif arguments.code is not "">
				AND code = '#arguments.code#'
				</cfif>
			</cfif>
			ORDER BY long_desc	 
		</cfquery> 
		
		<cfreturn local.qrySelectOptions />
	</cffunction>
</cfcomponent>
	
