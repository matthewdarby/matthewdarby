<cfset request.pagetitle = "Contact  Me" />
<cfset thisContact = viewState.getValue('contact') />  
<cfset val = viewState.getValue("contactValidation", structNew()) />

<cfoutput>
<p class="pageTitle">#request.pagetitle#</p>
<p>I welcome all comments, praise, critism or whatever you have to throw at me.</p>

<div>
	<cfif structKeyExists(val, "emailAddy")><font color="##FF0000">#val.emailAddy[1]#</font><br /></cfif>
	<cfif structKeyExists(val, "firstName")><font color="##FF0000">#val.firstName[1]#</font><br /></cfif>	
	<cfif structKeyExists(val, "emailMessage")><font color="##FF0000">#val.emailMessage[1]#</font><br /></cfif>
</div>

<form id="userEmailForm" method="post" action="index.cfm?page=Submission">
	<fieldset id="contactForm">
		<label for="firstName">First Name:</label>
		<input class="textField" id="firstName" name="firstName" type="text" value="#thisContact.getFirstName()#" />
		<br />
		<br />
		<label for="lastName">Last Name:</label>
		<input class="textField" id="lastName" name="lastName" type="text"value="#thisContact.getLastName()#" />
		<br />
		<br />	
		<label for="emailAddy">Email Address:</label>
		<input class="textField" id="emailAddy" name="emailAddy" type="text" value="#thisContact.getEmailAddy()#"/>
		<br />
		<br />	
		<label for="emailSubject">Subject:</label>
		<input class="textField" id="emailSubject" name="emailSubject" type="text" value="#thisContact.getEmailSubject()#"/>
		<br />
		<br />	
		<label for="emailMessage">Message:</label>
		<textarea id="emailMessage" name="emailMessage" >#thisContact.getEmailMessage()#</textarea>
		<br/>
		<br />
		<div align="center">
		<input align="center" type="submit" value="Send Email" id="submit" name="submit" class="submit" />
		<input align="center" type="reset" value="Reset" class="submit"/>
		</div>
	</fieldset>
</form>
</cfoutput>