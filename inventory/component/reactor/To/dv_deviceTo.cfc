
<cfcomponent hint="I am the database agnostic custom TO object for the dv_device object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.To.dv_deviceTO">
	<!--- Place custom code here, it will not be overwritten --->
		<cfset this.date_created = "#Now()#" />
	
		<cfset this.date_updated = "#Now()#" />
	
		<cfset this.module = "DV" />	
</cfcomponent>
	
