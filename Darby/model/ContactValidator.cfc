<cfcomponent name="ContactValidator" output="false" hint="I validate the Contact Form">
  <cffunction name="Validate" hint="I check the required fields">
    <cfargument name="Contact">
    <cfset var val = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />

    <cfif not len(contact.getFirstName())>
      <cfset val.addError("firstname", "First name is required.") />
    </cfif>

    <cfif not len(contact.getEmailAddy())>
      <cfset val.addError("emailAddy", "Email Address is required.") />
    <cfelseif not IsEmail("#emailAddy#")>
      <cfset val.addError("emailAddy", "You must use proper format for an email address.") />   
    </cfif>

    <cfif not len(trim(contact.getEmailMessage()))>
      <cfset val.addError("emailMessage", "You must type a message before sending an email.") />
    </cfif>

    <cfreturn val>
  </cffunction>
  
  <cffunction name="IsEmail" returntype="boolean" access="private" hint="I check the string passed in to be a valid email address">
  	<cfargument name="addy" required="true" type="string">
  	
  	<cfscript>
	  	var val = "false";
	  	var at = "@";
	  	var dot = ".";
	  	var atSpot = FindNoCase(at, addy);
	  	var addyLength = Len(addy);
	  	var dotSpot = FindNoCase(dot, addy);
	  	
	  	if (atSpot lte 0) {
	  		return  val;
	  	}
	  	if (dotSpot lte 0) {
	  		return val;
	  	}
	  	if (FindNoCase("@@", addy) gt 0) {
	  		return val;
	  	}	  	
	  	if (FindNoCase(".@", addy) gt 0) {
	  		return val;
	  	}
	  	if (FindNoCase("@.", addy) gt 0){
	  		return val;
	  	}
	  	if (FindNoCase(" ", addy) gt 0) {
	  		return val;
	  	}
	  	if(FindNoCase("..", addy) gt 0) {
	  		return val;
	  	}
	  	
	  	val = true;
	  	
	  	return val;
  	</cfscript>

  <!---
		function echeck(str) {

		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   alert("Invalid E-mail ID")
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   alert("Invalid E-mail ID")
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    alert("Invalid E-mail ID")
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    alert("Invalid E-mail ID")
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    alert("Invalid E-mail ID")
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    alert("Invalid E-mail ID")
		    return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		    alert("Invalid E-mail ID")
		    return false
		 }

 		 return true					
	} --->
  
  </cffunction>
</cfcomponent>