<cfcomponent displayname="StoreListener" output="true" hint="I a the Store Listener" extends="component.InventoryListener" >

	<!--- EVENT LISTENER METHODS --->

	<cffunction name="configure" access="public" output="false" returntype="void" 
				hint="Configures the listener as par of the Mach-II framework" >
		<cfset variables.serviceFactory = getProperty("serviceFactory")>
 		<cfset setManager(serviceFactory.getBean("storeManager")) /> 
	</cffunction>
	
	<cffunction name="checkForView" access="public" output="false" returntype="reactor.base.abstractTO">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var local = StructNew() />
		<cfset local.storeTO = "" />
		<cfset local.storeInfo = getManager().getStoreByQuery(parent_key=arguments.event.getArg('parent_key')
				                                   , parent_module=arguments.event.getArg('parent_module')) />	
		<cfif local.storeInfo.recordcount eq 1>
			<cfset arguments.event.setArg("key", local.storeInfo.key) />			
			<cfset local.storeTO = getStore(arguments.event) />
		</cfif>
		
		<cfreturn local.storeTO />		                  
	</cffunction>
	
	<cffunction name="checkExistingStore" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var local = StructNew() />
		
		<cfset local.storeInfo = getManager().getStoreByQuery(parent_key=arguments.event.getArg('parent_key')
				                                            , parent_module=arguments.event.getArg('parent_module') ) />		
		<cfif local.storeInfo.recordcount eq 1>
			<cfset arguments.event.setArg('action', 'Update') />
			<cfset arguments.event.setArg("key", local.storeInfo.key) />
			<cfset arguments.event.setArg('TO', getStore(arguments.event)) />
		<cfelse>
			<cfset arguments.event.setArg('TO', getTO(arguments.event)) />				
			<cfset arguments.event.setArg('action', "Add") />
		</cfif>	    		
	</cffunction>
	
	<cffunction name="getStore" access="public" returntype="reactor.base.abstractTO" output="false" hint="I get a single device TO object">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getStore(key=arguments.event.getArg('key')) /> 
	</cffunction>	

</cfcomponent>