
<cfcomponent hint="I am the database agnostic custom Record object for the md_media_item object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Record.md_media_itemRecord" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="reactor.project.Matt.Record.md_media_itemRecord">
		<cfargument name="is_required" type="boolean" default="false" />
		<cfargument name="data_type" type="string" default="" />
		<cfargument name="long_description" type="string" default="" />
		
		<cfset setIs_required(arguments.is_required) />		
		<cfset setData_type(arguments.data_type) />
		<cfset setLong_description(arguments.long_description) />
				
		<cfreturn  super.init(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="save" access="public" output="false" returntype="void">
		
		<cfif getKey() gt 0>
			<cfset super.setdate_updated(Now()) />
		</cfif>
		<cfset super.save() />
	</cffunction>		
	
	<cffunction name="getIs_required" access="public"  output="false" returntype="boolean">
		<cfreturn _getTo().is_required />
	</cffunction>
	<cffunction name="setIs_required" access="public" output="false" returntype="void">
		<cfargument name="is_required" type="boolean" required="true" />
		<cfset _getTo().is_required = arguments.is_required />
	</cffunction>
	
	<cffunction name="getData_type" access="public"  output="false" returntype="string">
		<cfreturn _getTo().data_type />
	</cffunction>
	<cffunction name="setData_type" access="public" output="false" returntype="void">
		<cfargument name="data_type" type="string" required="true" />
		<cfset _getTo().data_type = arguments.data_type />
	</cffunction>
	
	<cffunction name="getLong_description" access="public"  output="false" returntype="string">
		<cfreturn _getTo().long_description />
	</cffunction>
	<cffunction name="setLong_description" access="public" output="false" returntype="void">
		<cfargument name="long_description" type="string" required="true" />
		<cfset _getTo().long_description = arguments.long_description />
	</cffunction>
</cfcomponent>
	
