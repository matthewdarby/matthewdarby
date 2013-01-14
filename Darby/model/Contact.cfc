<cfcomponent output="false" displayname="Contact" hint="I setup the Contact Form" >

<cfset variables.nameTitle = "" />
<cfset variables.firstName = "" />
<cfset variables.lastName = "" />
<cfset variables.emailAddy = "" />
<cfset variables.emailSubject = "" />
<cfset variables.emailMessage = "" />

<cffunction name="init" hint="I initilize the variables">
	<cfargument name="nameTitle" type="string" required="false" default="" />
	<cfargument name="firstName" type="string" required="false" default="" />
	<cfargument name="lastName" type="string" required="false" default="" />
	<cfargument name="emailAddy" type="string" required="false" default="" />
	<cfargument name="emailSubject" type="string" required="false" default="" />
	<cfargument name="emailMessage" type="string" required="false" default="" />
	
	<cfinvoke component="#this#" method="setMyContact" thisContact="#arguments#"  />
	
	<cfreturn this />  
</cffunction>

<!--- Setters --->

<cffunction name="setMyContact" hint="I set the intialized variables" access="public" >
	<cfargument name="thisContact" type="struct" required="true" />
	
	<cfset setNameTitle(arguments.thisContact.nameTitle) />
	<cfset setFirstName(arguments.thisContact.firstName) />
	<cfset setLastName(arguments.thisContact.lastName) /> 
	<cfset setEmailAddy(arguments.thiscontact.emailAddy) />
	<cfset setEmailSubject(arguments.thisContact.emailSubject) />
	<cfset setEmailMessage(arguments.thisContact.emailMessage) />
</cffunction>

<cffunction name="setNameTitle" access="public" output="false">
	<cfargument name="nameTitle" type="string" required="true" />
	<cfset variables.nameTitle = arguments.nameTitle />
</cffunction>

<cffunction name="setFirstName" access="public" output="false">
	<cfargument name="firstName" type="string" required="true" />
	<cfset variables.firstName = arguments.firstName />
</cffunction>

<cffunction name="setLastName" access="public" output="false">
	<cfargument name="lastName" type="string" required="true" />
	<cfset variables.lastName = arguments.lastName />
</cffunction>

<cffunction name="setEmailAddy" access="public" output="false">
	<cfargument name="emailAddy" type="string" required="true" />
	<cfset variables.emailAddy = trim(arguments.emailAddy) />
</cffunction>

<cffunction name="setEmailSubject" access="public" output="false">
	<cfargument name="emailSubject" type="string" required="true" />
	<cfset variables.emailSubject = arguments.emailSubject />
</cffunction>

<cffunction name="setEmailMessage" access="public" output="false">
	<cfargument name="emailMessage" type="string" required="true" />
	<cfset variables.emailMessage = arguments.emailMessage />
</cffunction>

<!--- Getters --->
<cffunction name="getContact" access="public" output="false">
	<cfreturn variables />  
</cffunction>

<cffunction name="getNameTitle" access="public" returntype="string" output="false">
	<cfreturn variables.nameTitle />
</cffunction>

<cffunction name="getFirstName" access="public" returntype="string" output="false">
	<cfreturn variables.firstName />
</cffunction>

<cffunction name="getLastName" access="public" returntype="string" output="false">
	<cfreturn variables.lastName />
</cffunction>

<cffunction name="getEmailAddy" access="public" returntype="string" output="false">
	<cfreturn variables.emailAddy />
</cffunction>

<cffunction name="getEmailSubject" access="public" returntype="string" output="false">
	<cfreturn variables.emailSubject />
</cffunction>

<cffunction name="getEmailMessage" access="public" returntype="string" output="false">
	<cfreturn variables.emailMessage />
</cffunction>

</cfcomponent>