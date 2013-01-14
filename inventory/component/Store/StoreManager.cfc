<cfcomponent displayname="StoreManager" output="false" hint="I a the Device Controller" extends="component.InventoryManager" >

	<cffunction name="init" access="public" output="false" returntype="component.Store.StoreManager" 
				hint="Configures the listener as par of the Mach-II framework" >
		<cfargument name="reactor" type="reactor.reactorFactory" required="true" />
		<cfargument name="utility" type="component.Utility" required="true"> 
		<cfargument name="table"  type="string" required="true" />
		<cfargument name="module" type="string" required="true" />
		<cfargument name="gateways" type="string" required="true" hint="delimited by ~" />		
		
 		<cfset setReactor(arguments.reactor) />  
		<cfset setUtility(arguments.utility) />
		<cfset setTableName(arguments.table)>
		<cfset setModule(arguments.module) />
 		<cfset setGateway(getReactor().createGateway(getTableName())) />		
		<cfset setSupportingGateways(arguments.gateways) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getStoreByQuery" access="public" output="false" returntype="query"
				hint="I return a single store record based on the parent key and parent module">
		<cfargument name="parent_key" type="string" required="true" />
		<cfargument name="parent_module" type="string" required="true" />

		<cfreturn getGateway().getByFields(parent_key=arguments.parent_key, parent_module=arguments.parent_module) /> />
	</cffunction>
	
	<cffunction name="getStore" access="public" returntype="reactor.base.abstractTO" output="false" hint="I get a single device TO object">
		<cfargument name="key" type="string" required="true" />
		
		<cfscript>
			var local = StructNew();
			local.record = getReactor().createRecord(getTableName());
			local.record.setKey(arguments.key);
			local.record.load();
		</cfscript> 
		
		<cfreturn local.record._getTO() /> 
	</cffunction>	

	<cffunction name="validateAndProcessRecordAndItems" access="public" output="false" returntype="struct">
		<cfargument name="form" type="struct" required="true" />
		
		<cfset var throwBack = super.validateAndProcessRecordAndItems(argumentCollection=arguments)/>	
		<cfset throwBack.parent_key = arguments.form.parent_key />
		<cfset throwBack.parent_module = arguments.form.parent_module />
		
		<cfreturn throwBack />
	</cffunction>
</cfcomponent>