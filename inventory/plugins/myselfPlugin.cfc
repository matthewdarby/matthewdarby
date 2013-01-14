<!---
Copyright: Mach-II Corporation
$Id: SimplePlugin.cfc 507 2005-09-27 21:35:43Z pfarrell $

Created version: 1.0.0
Updated version: 1.1.0

Notes:
The PluginManager only calls plugin points at are utilized.
Remove any un-implemented plugin point methods (i.e. preProcess(), etc.)
to improve application performance as fewer plugin points will
be called on each request.  For example if your plugin only implements the
preEvent plugin point, then remove the remaining points. (pfarrell)
--->
<cfcomponent 
	displayname="SimplePlugin" 
	extends="MachII.framework.Plugin" 
	output="false"
	hint="A simple Plugin example.">

	<!---
	PROPERTIES
	--->
	
	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="configure" access="public" returntype="void" output="false"
		hint="Configures the plugin.">
	</cffunction>
	
	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="preEvent" access="public" returntype="void" output="true">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		<cfset var currentEvent = arguments.eventContext.getCurrentEvent() />
		<cfset currentEvent.setArg('myself','#getProperty('defaultTemplate')#?#getProperty('eventParameter')#=') />
	</cffunction>
	
	<cffunction name="handleException" access="public" returntype="void" output="false">
		<cfargument name="eventContext" type="MachII.framework.EventContext" required="true" />
		<cfargument name="exception" type="MachII.util.Exception" required="true" />
		<!---<cfoutput>&nbsp;SimplePlugin.handleException()<br /></cfoutput> --->
	</cffunction>

	<!---
	PROTECTED FUNCTIONS
	--->

	<!---
	ACCESSORS
	--->

</cfcomponent>