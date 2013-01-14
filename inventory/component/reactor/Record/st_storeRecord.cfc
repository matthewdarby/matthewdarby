
<cfcomponent hint="I am the database agnostic custom Record object for the st_store object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Record.st_storeRecord" >
	<!--- Place custom code here, it will not be overwritten --->

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfif getKey() gt 0>
			<cfset super.setdate_updated(Now()) />
		</cfif>
		<cfset super.save() />
	</cffunction>	
</cfcomponent>
	
