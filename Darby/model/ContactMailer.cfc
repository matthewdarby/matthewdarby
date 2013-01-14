<cfcomponent name="ContactMailer" hint="I send out the email to Matt">

<cffunction name="SendEmail" hint="I process the email">
    <cfargument name="Contact">
    
    <cfset senderInfo = "'#contact.getNameTitle()# #contact.getFirstName()# #contact.getLastName()#'<#contact.getEmailAddy()#>" />
    
    <cfmail to="admin@matthewdarby.com"
			from="#senderInfo#"
			failto="admin@matthewdarby.com"
			subject="[MBD Web] #contact.getEmailSubject()#"
			type="plain"
			port="25"
			username="admin"
			password="cytron">
Mail From: #contact.getNameTitle()# #contact.getFirstName()# #contact.getLastName()#
#contact.getEmailMessage()#
	</cfmail>
</cffunction>

</cfcomponent>