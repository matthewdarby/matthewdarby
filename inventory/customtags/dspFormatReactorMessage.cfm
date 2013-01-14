<cfif thisTag.ExecutionMode is 'start'>
	<cfparam name="attributes.messages" />
	<cfset local = StructNew() />
	<cfset local.messages = attributes.messages />
	<cfset local.newMessages = "" />
	
	<cfif IsStruct(local.messages)>
		<cfif StructKeyExists(local.messages, "successText")>
			<cfset local.newMessages = '<span class="goodMessage">' & local.messages.successText & '</span>' />
		<cfelseif StructKeyExists(local.messages, "errorCollection")>
			<cfif local.messages.errorCollection.hasErrors()>
				<cfset local.errors = local.messages.ERRORCOLLECTION.GETTRANSLATEDERRORS() />
				<cfsavecontent variable="local.newMessages">
					<cfoutput>
					<ul>
						<cfloop index="i" from="1" to="#ArrayLen(local.errors)#">
							<li class="redFlag">#local.errors[i]#</li>
						</cfloop>
					</ul>
					</cfoutput>
				</cfsavecontent>
			</cfif>
		<cfelseif StructKeyExists(local.messages, 'customError')>
			<cfset local.newMessages = '<span class="redFlag">' & local.messages.customError & '</span>' />
		</cfif>
	</cfif>
	<cfoutput>#local.newMessages#</cfoutput>
</cfif>