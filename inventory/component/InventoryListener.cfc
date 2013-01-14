<cfcomponent displayname="InventoryListener" output="false" hint="I Inventory Controller" extends="MachII.framework.Listener" >

	<!--- EVENT LISTENER METHODS --->

	<cffunction name="configure" access="public" output="false" returntype="void" 
				hint="Configures the listener as par of the Mach-II framework" >
	  	<cfset variables.serviceFactory = getProperty("serviceFactory")>
	</cffunction>

	<cffunction name="getTO" access="public" returntype="reactor.base.abstractTO" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getTO(event.getArgs()) />		
	</cffunction>

	<cffunction name="getRecord" access="public" returntype="reactor.base.abstractRecord" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getRecord(event.getArgs()) />		
	</cffunction>

	<cffunction name="getCommonListValues" access="public" returntype="struct" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getCommonValues() />		
	</cffunction>
	
	<cffunction name="validateAndProcess" access="public" returntype="void" output="true" hint="I handled the validation for a single record">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var local = structNew() />
		<cfset local.action = arguments.event.getArg('action') />
		<cfset local.prev = arguments.event.getArg('xfa.prev') />
		<cfset local.form = arguments.event.getArg('xfa.form') />
		<cfset local.hasOptions = arguments.event.getArg('hasOptions') />
		<cfset local.ret = StructNew() />
		<cfset local.ret['hasOptions'] = local.hasOptions />
		
		<cfinvoke component="#getManager()#" method="validateAndProcess" returnvariable="local.ret">
			<cfinvokeargument name="form" value="#arguments.event.getArgs()#" />
		</cfinvoke>
	
		<cfif local.action eq 'Delete'>
			<cfset announceEvent(local.prev, local.ret) />
		<cfelse>
			<cfset announceEvent(local.form, local.ret) />
		</cfif>
	</cffunction>		
	
	<cffunction name="validateAndProcessRecordAndItems" access="public" returntype="void" output="true" 
				hint="I handle the validation a parent record and child items of an item table">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var local = StructNew() />
		<cfset var ret = StructNew() />
		<cfset local.prev = arguments.event.getArg('xfa.prev') />
		<cfset local.form = arguments.event.getArg('xfa.form') />
				
		<cfinvoke component="#getManager()#" method="validateAndProcessRecordAndItems" returnvariable="ret">
			<cfinvokeargument name="form" value="#arguments.event.getArgs()#" />
		</cfinvoke>	
		
		<cfif ret.action eq 'Delete'>
			<cfset announceEvent(local.prev, ret) />
		<cfelse>
			<cfset announceEvent(local.form, ret) />
		</cfif>			
	</cffunction>
	
	<cffunction name="getSetRuleCodes" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getSetRuleCodes(argumentCollection=event.getArgs()) />
	</cffunction>	
	
	<!--- getters and setters --->
	<cffunction name="getManager" access="public"  output="false" returntype="any">
		<cfreturn variables.instance.manager />
	</cffunction>
	<cffunction name="setManager" access="public" output="false" returntype="void">
		<cfargument name="manager" type="any" required="true" />
		<cfset variables.instance.manager = arguments.manager />
	</cffunction>
</cfcomponent>