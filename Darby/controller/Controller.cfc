<cfcomponent displayname="Controller" output="false" hint="I am a sample model-glue controller." extends="ModelGlue.Core.Controller">

<!--- WARNING

The following are "reserved" terms, used by the base
ModelGlue.Core.Controller.

Do not name functions any of the following:

GetModelGlue
GetControllerName
AddToCache
ExistsInCache
GetFromCache
RemoveFromCache

Do not declare variables in the variables scope named the following:

variables.ModelGlue


		 /WARNING --->


<!--- Constructor --->
<cffunction name="Init" access="Public" returnType="Controller" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
  <cfargument name="InstanceName" required="true" type="string" />
  <cfset super.Init(arguments.ModelGlue) />

	<!--- Controllers are in the application scope:  Put any application startup code here. --->
  <cfset variables.ContactManager = createObject("component", "Darby.model.ContactManager") />
  <cfreturn this />
</cffunction>

<!--- Functions specified by <message-listener> tags --->
<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
	<cfargument name="event" type="ModelGlue.Core.Event" required="true">
	
	<cfset arguments.event.setValue('imageHome', '/Darby/images/') /> 
	<cfset arguments.event.setValue('cssHome', '/Darby/css/') /> 
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
</cffunction>

<cffunction name="ShowContactForm" access="public" returntype="ModelGlue.Core.Event" output="false" hint="I display the Contact Form">
	<cfargument name="event" type="ModelGlue.Core.Event" required="true" />
	
	<cfset arguments.event.setValue('submitValue', 'Send Email') />  
	
	<cfreturn arguments.event />  
</cffunction>

<cffunction name="InitContactForm" access="public" returntype="ModelGlue.Core.Event" output="false" hint="I initialize all of the necessary variables for the Contact Form">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">	

  <cfset arguments.event.setValue('contact', GetContactManager().NewContact()) />
  <cfset arguments.event.addResult('success') />  
  
  <cfreturn arguments.event />  
</cffunction>

<cffunction name="ContactSubmission" access="public" returntype="ModelGlue.Core.Event" output="false" hint="I submit the contact form">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">	
  
  <cfset var contact = GetContactManager().NewContact() />  	
  <cfset var validation = "" />
  <cfset contact = arguments.event.makeEventBean(contact, 'nameTitle,firstName,lastName,emailAddy,emailSubject,emailMessage') />
  <cfset validation = GetContactManager().ContactValidator(contact) />
  
  <cfif validation.hasErrors()>
    <cfset arguments.event.addResult("invalid") />
    <cfset arguments.event.setValue("contactValidation", validation.getErrors()) />
    <cfset arguments.event.setValue("contact", contact) />  
  <cfelse>
    <cfset GetContactManager().processEmail(contact) />
    <cfset arguments.event.addResult("success") />
  </cfif>

  <cfreturn arguments.event />
</cffunction>

<cffunction name="GetContactManager" access="private">
	<cfreturn variables.ContactManager>
</cffunction>

</cfcomponent>

