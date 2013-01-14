
<cfcomponent hint="I am the database agnostic custom Gateway object for the dv_device object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Gateway.dv_deviceGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getSearchResults" access="public" output="true" returntype="query"  
				hint="I return the results from a search">
		<cfargument name="searchTxt" type="string" required="false" />
		
		<cfset var local = StructNew() />	

		<cfquery name="local.qryDeviceSearch" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			SELECT  d.key
			      , d.type
			      , d.name
			      , d.manufacturer
			      , d.module
			FROM dv_device d
			WHERE  d.type LIKE <cfqueryparam value="%#arguments.searchTxt#%" cfsqltype="cf_sql_varchar" />
			 	or d.name LIKE <cfqueryparam value="%#arguments.searchTxt#%" cfsqltype="cf_sql_varchar" />
			 	or d.manufacturer LIKE <cfqueryparam value="%#arguments.searchTxt#%" cfsqltype="cf_sql_varchar" />
		</cfquery>	

		<cfreturn local.qryDeviceSearch />
	</cffunction>	
	
</cfcomponent>
	
