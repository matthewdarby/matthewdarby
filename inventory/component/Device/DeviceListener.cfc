<cfcomponent displayname="DeviceListener" output="true" hint="I a the Device Controller" extends="component.InventoryListener" >

	<!--- EVENT LISTENER METHODS --->
<!---  	<cffunction name="init" access="public" returntype="any"
				hint="Though Mach-II uses configure I am an inializer for other applications to use">

		<cfif StructKeyExists(arguments, "isMachIICall") and not arguments.isMachIICall>
			<cfset configure() />
			<cfreturn this />
		<cfelse>
			<cfreturn super.init() />
		</cfif>
	</cffunction>  --->

	<cffunction name="configure" access="public" output="false" returntype="void" 
				hint="Configures the listener as par of the Mach-II framework" >
		<cfset variables.serviceFactory = getProperty("serviceFactory")>
 		<cfset setManager(serviceFactory.getBean("deviceManager")) /> 
	</cffunction>

	<cffunction name="getSearchResults" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getSearchResults(searchTxt=arguments.event.getArg("searchTxt")) />
	</cffunction>

	<cffunction name="getDevice" access="public" returntype="any" output="false" hint="I get a single device TO object">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getDevice(parent_key=arguments.event.getArg('parent_key')) /> 
	</cffunction>

</cfcomponent>