
<cfcomponent hint="I am the database agnostic custom Record object for the md_media object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Record.md_mediaRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	<cffunction name="save" access="public" output="false" returntype="void">
		<cfif getKey() gt 0>
			<cfset super.setdate_updated(Now()) />
		</cfif>
		<cfset super.save() />
	</cffunction>	
	
	<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="useTransaction" hint="I indicate if this delete should be executed within a transaction." required="no" type="boolean" default="true" />
		
		<cfset var local = StructNew() />
		<cfset local.iterator = getmd_media_itemIterator() />
		<cfset local.iterator.deleteAll() />
		<cfset local.store = getSt_Store() />
		<cfset local.store.delete() />
		<cfset super.delete() />
	</cffunction>
</cfcomponent>
	
