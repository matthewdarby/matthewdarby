<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<!--- RBB 11/02/2005: Added new website parameter --->
<cfparam name="form.website" default="http://">
<cfparam name="form.comments" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.captchaText" default="">

<!--- validate boolean --->
<cfif not isBoolean(form.subscribe)>
	<cfset form.subscribe = false />
</cfif>
<cfif not isBoolean(form.rememberme)>
	<cfset form.rememberme = false />
</cfif>
		
<cfset closeMe = false>
<cfif not isDefined("url.id")>
	<cfset closeMe = true>
<cfelse>
	<cftry>
		<cfset entry = application.blog.getEntry(url.id,true)>
		<cfcatch>
			<cfset closeMe = true>
		</cfcatch>
	</cftry>
</cfif>

<cfif isDefined("form.addcomment") and entry.allowcomments>
	<cfset form.name = trim(form.name)>
	<cfset form.email = trim(form.email)>
	<!--- RBB 11/02/2005: Added new website option --->
	<cfset form.website = trim(form.website)>
	<cfset form.comments = trim(form.comments)>

	<!-- if website is just http://, remove it --->
	<cfif form.website is "http://">
		<cfset form.website = "">
	</cfif>
	<!---// track the errors //--->
	<cfset aErrors = arrayNew(1) />
	
	<cfif not len(form.name)>
		<cfset arrayAppend(aErrors, rb("mustincludename")) />
	</cfif>
	<cfif not len(form.email) or not isEmail(form.email)>
		<cfset arrayAppend(aErrors, rb("mustincludeemail")) />
	</cfif>
	<cfif len(form.website) and not isURL(form.website)>
		<cfset arrayAppend(aErrors, rb("invalidurl")) />
	</cfif>
		
	<cfif not len(form.comments)>
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
	<!--- cfformprotect --->
	<cfif application.usecfp>
		<cfset cffp = createObject("component","cfformprotect.cffpVerify").init() />
		<!--- now we can test the form submission --->
		<cfif not cffp.testSubmission(form)>
			<cfset arrayAppend(aErrors, "Your comment has been flagged as spam.") />
		</cfif> 
	</cfif>
			
	<cfif not arrayLen(aErrors)>
	  <!--- RBB 11/02/2005: added website to commentID --->
	  	<cftry>
			<cfset commentID = application.blog.addComment(url.id,left(form.name,50), left(form.email,50), left(form.website,255), form.comments, form.subscribe)>
			<!--- Form a message about the comment --->
			<cfset subject = rb("commentaddedtoblog") & ": " & application.blog.getProperty("blogTitle") & " / " & rb("entry") & ": " & entry.title>
			<cfset commentTime = dateAdd("h", application.blog.getProperty("offset"), now())>
			<cfsavecontent variable="email">
			<cfoutput>
#rb("commentaddedtoblogentry")#:	#application.utils.htmlToPlainText(entry.title)#
#rb("commentadded")#: 		#application.localeUtils.dateLocaleFormat(commentTime)# / #application.localeUtils.timeLocaleFormat(commentTime)#
#rb("commentmadeby")#:	 	#form.name# <cfif len(form.website)>(#form.website#)</cfif>
#rb("ipofposter")#:			#cgi.REMOTE_ADDR#
URL: #application.blog.makeLink(url.id)###c#commentID#


#form.comments#

------------------------------------------------------------
#rb("unsubscribe")#: %unsubscribe%
This blog powered by BlogCFC #application.blog.getVersion()#
Created by Raymond Camden (http://www.coldfusionjedi.com)
			</cfoutput>
			</cfsavecontent>

			<cfinvoke component="#application.blog#" method="notifyEntry">
				<cfinvokeargument name="entryid" value="#entry.id#">
				<cfinvokeargument name="message" value="#trim(email)#">
				<cfinvokeargument name="subject" value="#subject#">
				<cfinvokeargument name="from" value="#form.email#">
				<cfif application.commentmoderation>
					<cfinvokeargument name="adminonly" value="true">
				</cfif>										
				<cfinvokeargument name="commentid" value="#commentid#">
			</cfinvoke>
								
			<cfcatch>
				<cfif cfcatch.message is not "Comment blocked for spam.">
					<cfrethrow>
				<cfelse>
					<cfset arrayAppend(aErrors, "Your comment has been flagged as spam.") />		
				</cfif>
			</cfcatch>
				
			</cftry>
					
		<cfif not arrayLen(aErrors)>		
			<cfmodule template="tags/scopecache.cfm" scope="application" clearall="true">
			<cfset comments = application.blog.getComments(url.id)>
			<!--- clear form data --->
			<cfif form.rememberMe>
				<cfcookie name="blog_name" value="#trim(htmlEditFormat(form.name))#" expires="never">
				<cfcookie name="blog_email" value="#trim(htmlEditFormat(form.email))#" expires="never">
	      		<!--- RBB 11/02/2005: Added new website cookie --->
				<cfcookie name="blog_website" value="#trim(htmlEditFormat(form.website))#" expires="never">
			<cfelse>
				<cfcookie name="blog_name" expires="now">
				<cfcookie name="blog_email" expires="now">
				<!--- RBB 11/02/2005: Added new website form var --->
				<cfset form.name = "">
				<cfset form.email = "">
				<cfset form.website = "">
			</cfif>
			<cfset form.comments = "">
		</cfif>
	</cfif>	
</cfif>