<cfcomponent displayname="DeviceManager" output="false" hint="I a the Device Controller" extends="component.InventoryManager" >

	<cffunction name="init" access="public" output="false" returntype="component.Device.DeviceManager" 
				hint="Configures the listener as par of the Mach-II framework" >
		<cfargument name="reactor" required="true" type="reactor.reactorFactory" />
		<cfargument name="utility" type="component.Utility" required="false"> 		
		<cfargument name="table"  type="string" default="dv_device" />
		<cfargument name="module" type="string" default="DV" />
		<cfargument name="gateways" default="reference" type="string" hint="delimited by ~" />
		<cfargument name="childTables" type="string" default="st_store" hint="delimited by ~" />
		<cfargument name="referenceList" type="string" required="false" hint="delimited by ~" />
		
		<cfreturn super.init(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getSearchResults" access="public" output="false" returntype="query">
		<cfargument name="searchTxt" type="string" required="true" />
		
		<cfreturn getGateway().getSearchResults(searchTxt=arguments.searchTxt) />
	</cffunction>

	<cffunction name="getDevice" access="public" returntype="reactor.base.abstractTO" output="false" hint="I get a single device TO object">
		<cfargument name="parent_key" type="string" required="true" />
		
		<cfscript>
			var local = StructNew();
			local.record = getReactor().createRecord(getTableName());
			local.record.setKey(arguments.parent_key);
			local.record.load();
		</cfscript> 
		
		<cfreturn local.record._getTO() /> 
	</cffunction>
	
</cfcomponent>