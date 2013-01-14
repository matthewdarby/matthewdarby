<cfcomponent name="JSMXManager" hint="I am the manager for AJAX calls using JSMX">
	<cffunction name="getGenreAndBinding" access="remote" returntype="void">
		<cfargument name="type" type="string" required="true" />
		
		<cfset var local.queries = getQuery(arguments.type) />
		<cfset local.wddxArray = ArrayNew(2) />
		
		<cfloop query="local.queries.qryBinding">
			<cfset local.wddxArray[currentRow][1] = code />
			<cfset local.wddxArray[currentRow][2] = long_desc />
		</cfloop>
		<cfwddx action="cfml2js" input="#local.wddxArray#" toplevelvariable="r"> 
	</cffunction>
	
	<cffunction name="getQuery" access="private" returntype="struct">
		<cfargument name="type" type="string" required="true" />
		
		<cfset var local=StructNew() />
		<cfquery name="local.qryBinding" 
				 datasource="mbdinventory" 
				 username="blueTrane" 
				 password="groupie">
			SELECT code, long_desc, short_desc 
			FROM r_reference 
			WHERE reference_type = 'BINDING' 
			AND module = <cfqueryparam value="#arguments.type#" cfsqltype="cf_sql_varchar" />
		</cfquery>	
		
		<cfquery name="local.qryGenre" 
				 datasource="mbdinventory" 
				 username="blueTrane" 
				 password="groupie">
			SELECT code, long_desc, short_desc 
			FROM r_reference 
			WHERE reference_type = 'GENRE' 
			AND module = <cfqueryparam value="#arguments.type#" cfsqltype="cf_sql_varchar" />'				 
		</cfquery>
		
		<cfreturn local />
	</cffunction>
</cfcomponent>