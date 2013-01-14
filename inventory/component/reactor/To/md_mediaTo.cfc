
<cfcomponent hint="I am the database agnostic custom TO object for the md_media object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.To.md_mediaTo">
	<!--- Place custom code here, it will not be overwritten --->
		<cfset this.date_created = "#Now()#" />
	
		<cfset this.date_updated = "#Now()#" />
	
		<cfset this.module = "MD" />	
</cfcomponent>
	
