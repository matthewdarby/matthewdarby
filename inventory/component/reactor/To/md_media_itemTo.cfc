
<cfcomponent hint="I am the database agnostic custom TO object for the md_media_item object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.To.md_media_itemTo">
	<!--- Place custom code here, it will not be overwritten --->
	
	<cfproperty name="is_required" type="boolean" />
	<cfproperty name="data_type" type="string" />
	<cfproperty name="long_description" type="string" />
	
	<cfset this.is_required = false />
	<cfset this.data_type = "TXT" />
	<cfset this.long_description = "" />
	
</cfcomponent>
	
