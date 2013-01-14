<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : addcomment.cfm
	Author       : Raymond Camden 
	Created      : February 11, 2003
	Last Updated : October 8, 2007
	History      : Reset history for version 5.0
				 : Lengths allowed for name/email were 100, needed to be 50
				 : Cancel confirmation (rkc 8/1/06)
				 : rb use (rkc 8/20/06)
				 : Scott updates the design a bit (ss 8/24/06)
				 : Default form.captchaText (rkc 10/21/06)
				 : Don't log the getentry (rkc 2/28/07)
				 : Don't mail if moderating (rkc 4/13/07)
	Purpose		 : Adds comments
--->

<cfif not isDefined("form.addcomment")>
	<cfif isDefined("cookie.blog_name")>
		<cfset form.name = cookie.blog_name>
		<cfset form.rememberMe = true>
	</cfif>
	<cfif isDefined("cookie.blog_email")>
		<cfset form.email = cookie.blog_email>
		<cfset form.rememberMe = true>
	</cfif>
	<!--- RBB 11/02/2005: Added new website check --->
	<cfif isDefined("cookie.blog_website")>
		<cfset form.website = cookie.blog_website>
		<cfset form.rememberMe = true>
	</cfif>	
</cfif>

<cfparam name="form.name" default="">
<cfparam name="form.email" default="">
<!--- RBB 11/02/2005: Added new website parameter --->
<cfparam name="form.website" default="http://">
<cfparam name="form.comments" default="">
<cfparam name="form.rememberMe" default="false">
<cfparam name="form.subscribe" default="false">
<cfparam name="form.captchaText" default="">

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
<cfif closeMe>
	<cfabort>
</cfif>

<cfoutput>
<div class="form"><a name="add-comment"></a>
</cfoutput>

<cfif entry.allowcomments>
	
	
		<cfif isDefined("aErrors") and arrayLen(aErrors)>
			<cfoutput>
				<div id="CommentError">
					<b>#rb("correctissues")#:</b>
					<ul class="error"><li>#arrayToList(aErrors, "</li><li>")#</li></ul>
				</div>
			</cfoutput>
		</cfif>
	<cfoutput>
	<form action="#application.blog.makeLink(url.id)##cgi.query_string#" method="post">
	<cfif application.usecfp>
		<cfinclude template="cfformprotect/cffp.cfm">
	</cfif>
  <fieldset id="commentForm">
    	<legend>#rb("postyourcomments")#</legend>
<ol>    	
  <li>
		<label for="name">#rb("name")#:</label>
		<input type="text" id="name" class="textfield" name="name" value="#form.name#">
  </li>
  <li>
		<label for="email">#rb("emailaddress")#:</label>
		<input type="text" id="email" class="textfield" name="email" value="#form.email#">
  </li>
  <li>
		<label for="website">#rb("website")#:</label>
		<input type="text" id="website" class="textfield" name="website" value="#form.website#">
  </li>
  <li>
		<label for="comments">#rb("comments")#:</label>
		<textarea name="comments" id="comments" class="textarea">#form.comments#</textarea>
  </li>
	<cfif application.useCaptcha>
    <li>
		<cfset variables.captcha = application.captcha.createHashReference() />
		<input type="hidden" name="captchaHash" value="#variables.captcha.hash#" />
		<label for="captchaText" class="longLabel">#rb("captchatext")#:</label>
		<input type="text" name="captchaText" size="6" /><br>
		<img src="#application.blog.getRootURL()#showCaptcha.cfm?hashReference=#variables.captcha.hash#" align="right" vspace="5"/>
  </li>
	</cfif>
  <li>
		<label for="rememberMe" class="longLabel">#rb("remembermyinfo")#:</label>
		<input type="checkbox" class="checkBox" id="rememberMe" name="rememberMe" value="1" <cfif isBoolean(form.rememberMe) and form.rememberMe>checked</cfif>>
  </li>
  <li>
		<label for="subscribe" class="longLabel">#rb("subscribe")#:</label>
		<input type="checkbox" class="checkBox" id="subscribe" name="subscribe" value="1" <cfif isBoolean(form.subscribe) and form.subscribe>checked</cfif>>
  </li>
</ol>  
	<p style="clear:both">#rb("subscribetext")#</p>
	
	<input type="submit" id="submit" name="addcomment" class="button" value="#rb("post")#" />	
	<input type="reset" id="reset" value="#rb("cancel")#" class="button"  /> 

</fieldset>
	</form>
	</cfoutput>
	
<cfelse>

	<cfoutput>
	<p>#rb("commentsnotallowed")#</p>
	</cfoutput>
	
</cfif>
<!--end:form--></div>