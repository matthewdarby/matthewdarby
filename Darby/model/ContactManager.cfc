<cfcomponent name="ContactManager" output="false" hint="I manager the Contact Form">

<cfset variables.contact = StructNew() />

<cffunction name="newContact" hint="I call for a new contact form instance">
	<cfreturn createObject('component', 'Darby.model.Contact').init() />  
</cffunction>

<cffunction name="contactValidator" hint="I control the process of form submission">
	<cfargument name="contact">
	
	<cfset var errorHandler = createObject('component', 'Darby.model.ContactValidator') />
	<cfset var thisValidator = errorHandler.validate(arguments.contact) />
	
	<cfreturn thisValidator />
</cffunction>

<cffunction name="processEmail"  hint="I send out the email">
	<cfargument name="contact">
	<cfset var messageMailer = createObject('component', 'Darby.model.ContactMailer') />
	<cfset var thisMailer = messageMailer.SendEmail(arguments.contact) />
</cffunction>
		
</cfcomponent>