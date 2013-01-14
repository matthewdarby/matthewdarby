<cfoutput><h1>Model-Glue Application</h1>

<cfif viewCollection.exists("body")>
  <cfoutput>#viewCollection.getView("body")#</cfoutput>
</cfif>

<p>
Model-Glue is copyright #datePart("yyyy", now())#, Joe Rinehart, http://clearsoftware.net.
</p>
</cfoutput>
