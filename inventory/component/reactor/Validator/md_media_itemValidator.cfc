
<cfcomponent hint="I am the validator object for the md_media_item object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Validator.md_media_itemValidator">
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="validate" access="public" hint="I validate an  record" output="false" returntype="reactor.util.ErrorCollection">
		<cfargument name="md_media_itemRecord" hint="I am the Record to validate." required="no" type="reactor.project.Matt.Record.md_media_itemRecord" />
		<cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.md_media_itemRecord._getDictionary())#" />
		
		<cfset validateitem_value(arguments.md_media_itemRecord, arguments.ErrorCollection) />
		
		<cfreturn super.validate(argumentCollection=arguments) />
	</cffunction>	
	
	<cffunction name="validateitem_value" access="public" hint="I validate the item_value field" output="false" returntype="reactor.util.ErrorCollection">
		<cfargument name="md_media_itemRecord" hint="I am the Record to validate." required="no" type="reactor.project.Matt.Record.md_media_itemRecord" />
		<cfargument name="ErrorCollection" hint="I am the error collection to populate. If not provided a new collection is created." required="no" type="reactor.util.ErrorCollection" default="#createErrorCollection(arguments.md_media_itemRecord._getDictionary())#" />
		
		<cfif arguments.md_media_itemRecord.getIs_Required() and Len(arguments.md_media_itemRecord.getItem_value()) lte 0>
			<cfset arguments.errorCollection.addError('The value for ' & arguments.md_media_itemRecord.getLong_Description() & ' is required.' )>
		<cfelse>
			<cfswitch expression="#arguments.md_media_itemRecord.getData_type()#">
				<cfcase value="NUM">
					<cfif not IsNumeric(arguments.md_media_itemRecord.getItem_value()) >
						<cfset arguments.errorCollection.addError('The value for ' & arguments.md_media_itemRecord.getLong_Description() & ' is not numeric') />
					</cfif>
				</cfcase>
				<cfcase value="DATE">
					<cfif not IsDate(arguments.md_media_itemRecord.getItem_value())>
						<cfset arguments.errorCollection.addError('The value for ' & arguments.md_media_itemRecord.getLong_Description() & ' is not a valid date in the format of YYYY-MM-DD') />
					<cfelse>
						<cfset arguments.md_media_itemRecord.SetItem_value(DateFormat(arguments.md_media_itemRecord.getItem_value(), 'yyyy-mm-dd'))/>
					</cfif>
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfreturn arguments.ErrorCollection />
	</cffunction>			
</cfcomponent>
	
