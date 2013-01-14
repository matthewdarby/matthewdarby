<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Contact
	Author       : Raymond Camden 
	Created      : October 9, 2007
	Last Updated : 
	History      : 
	Purpose		 : Sends email to blog owner
--->

<cfset showForm = true>
<cfparam name="form.email" default="">
<cfparam name="form.name" default="">
<cfparam name="form.comments" default="">
<cfparam name="form.captchaText" default="">

<cfif structKeyExists(form, "send")>
	<cfset aErrors = arrayNew(1) />
	<cfif not len(trim(form.name))>
		<cfset arrayAppend(aErrors, rb("mustincludename")) />
	</cfif>
	<cfif not len(trim(form.email)) or not isEmail(form.email)>
		<cfset arrayAppend(aErrors, rb("mustincludeemail")) />
	</cfif>
	<cfif not len(trim(form.comments))>
		<cfset arrayAppend(aErrors, rb("mustincludecomments")) />
	</cfif>

	<!--- captcha validation --->
	<cfif application.useCaptcha>
		<cfif not len(form.captchaText)>
			<cfset arrayAppend(aErrors, "Please enter the Captcha text.") />
		<cfelseif NOT application.captcha.validateCaptcha(form.captchaHash,form.captchaText)>
			<cfset arrayAppend(aErrors, "The captcha text you have entered is incorrect.") />
		</cfif>
	</cfif>
	
	<cfif not arrayLen(aErrors)>
		<cfset commentTime = dateAdd("h", application.blog.getProperty("offset"), now())>
		<cfsavecontent variable="body">
			<cfoutput>
#rb("commentadded")#: 		#application.localeUtils.dateLocaleFormat(commentTime)# / #application.localeUtils.timeLocaleFormat(commentTime)#
#rb("commentmadeby")#:	 	#form.name# (#form.email#)
#rb("ipofposter")#:			#cgi.REMOTE_ADDR#

#form.comments#
	
------------------------------------------------------------
This blog powered by BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (ray@camdenfamily.com)
			</cfoutput>
		</cfsavecontent>
		
		<cfset application.utils.mail(
				to=application.blog.getProperty("owneremail"),
				from=form.email,
				subject="#rb("contactform")#",
				body=body,
				mailserver=application.blog.getProperty("mailserver"),
				mailusername=application.blog.getProperty("mailusername"),
				mailpassword=application.blog.getProperty("mailpassword")
					)>
												
		<cfset showForm = false>

	</cfif>
	
</cfif>

<cfmodule template="tags/layout.cfm" title="#rb("contactowner")#">
	
	
	<cfoutput>
	<h2>#rb("contactowner")#</h2>
	
	<div class="body">
	
	<cfif showForm>

	<p>
	#rb("contactownerform")#
	</p>

	<cfif isDefined("aErrors") and arrayLen(aErrors)>
		<cfoutput><b>#rb("correctissues")#:</b><ul class="error"><li>#arrayToList(aErrors, "</li><li>")#</li></ul></cfoutput>
	</cfif>
	
		<form action="#cgi.script_name#?#cgi.query_string#" method="post">
    <fieldset id="sendForm">
	<ol>	
	     <li>
	      <label for="name">#rb("name")#:
	      <input type="text" id="name" name="name" class="textfield" value="#form.name#" />
	      </label>
	    </li>
	     <li>
	      <label for="email">#rb("youremailaddress")#:
	      <input type="text" id="email" name="email" class="textfield" value="#form.email#" />
	      </label>
	    </li>
	     <li>
	      <label for="comments">#rb("comments")#:
	      <textarea name="comments" id="comments" class="textarea">#form.comments#</textarea>
	      </label>
	    </li>
		<cfif application.useCaptcha>
			<cfset variables.captcha = application.captcha.createHashReference() />
	    <li>
				<input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
				<label for="captchaText" class="longLabel">#rb("captchatext")#:</label>
				<input type="text" name="captchaText" size="6" class="textfield"/><br>
				<img src="#application.blog.getRootURL()#showCaptcha.cfm?hashReference=#variables.captcha.hash#" vspace="5"/>
	    </li>
		</cfif>	
	</ol>    
	      <input type="submit" id="submit" name="send" value="#rb("sendcontact")#" class="button" />
	     
    </fieldset>

		</form>

	<cfelse>
	
		<p>
		#rb("contactsent")#
		</p>
		
	</cfif>
	
	</div>
	</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>