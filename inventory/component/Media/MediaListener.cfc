<cfcomponent displayname="MediaListener" output="true" hint="I a the Device Controller" extends="component.InventoryListener" >

	<!--- EVENT LISTENER METHODS --->

	<cffunction name="configure" access="public" output="false" returntype="void" 
				hint="Configures the listener as par of the Mach-II framework" >
		<cfset variables.serviceFactory = getProperty("serviceFactory")>
 		<cfset setManager(serviceFactory.getBean("mediaManager")) /> 
	</cffunction>

	<cffunction name="getStatus" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfreturn getManager().getStatus() />
	</cffunction>

	<cffunction name="getSearchResults" access="public" output="false" returntype="query">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getSearchResults(type=arguments.event.getArg('type'), name=arguments.event.getArg('name')
					, genre=arguments.event.getArg('genre'), binding=arguments.event.getArg('binding')) />
	</cffunction>
	
	<cffunction name="getAmazonResults" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		<cfset var local = StructNew() />
		<cfset local.keyword = arguments.event.getArg('keyword') />
		<cfset local.category = arguments.event.getArg('category') />
		<cfset local.messages = StructNew() />
		
		<cftry>
			<cfinvoke component="#getManager().getAmazonService()#" method="getProductsByCategory" returnvariable="local.productInfo">
				<cfinvokeargument name="keyword" value="#local.keyword#" />
				<cfinvokeargument name="category" value="#local.category#" />
			</cfinvoke>
			<cfset announceEvent("media.amazonList", local) /> 
			<cfcatch>
				<cfif Len(local.keyword) eq 0 or Len(local.category) eq 0>
					<cfset local.messages.customError = 'A keyword and category must be provided' />
				<cfelse>
					<cfset local.messages.customError = 'There is a problem with communicating with Amazon.  Please try again later.' />					
				</cfif>
				<cfset announceEvent("media.amazonSearch", local) /> 
			</cfcatch>									
		</cftry>
	</cffunction>
	
	<cffunction name="getAmazonInfoAndTo" access="public" output="false" returntype="void">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var local = StructNew() />
		<cfset var ret = StructNew()>
		<cfset local.asin = arguments.event.getArg('asin') />
		<cfset local.type = arguments.event.getArg('type') />
		<cfset ret.messages = StructNew() />
		<cfset ret.action = "Add" />				
		<cfset ret.hasOptions = "false" />
		<cfset ret.displayData = arguments.event.getArg('displayData') />
		<cfset ret.matchType = 'short_desc' />
		<cftry>
			<cfinvoke component="#getManager().getAmazonService()#" method="getItemInformation" returnvariable="local.productInfo">
				<cfinvokeargument name="itemId" value="#local.asin#" />
				<cfinvokeargument name="type" value="#local.type#" />
			</cfinvoke>

			<cfinvoke component="#getManager()#" method="assignAmazonValues" returnvariable="local.formValues">
				<cfinvokeargument name="amazonStruct" value="#local.productInfo#" />
				<cfinvokeargument name="asin" value="#local.asin#" />
				<cfinvokeargument name="type" value="#local.type#" />
			</cfinvoke>		
			<cfset StructAppend(ret, local.formValues) />
			<cfset ret.isCommunicated = true />	
			<cfset local.qryMedia = getManager().getSimpleSearch(asin=local.asin) />
			<cfif local.qryMedia.recordcount gt 0>
				<cfset ret.messages.customError = 'A product with this Amazon product number already exists in the database.' />
			</cfif>
			<cfset announceEvent("media.showform", ret) /> 
			<cfcatch>
					<cfset ret.messages.customError = 'There is a problem with communicating with Amazon.  Please try again later.' />
					<cfset ret.To = getManager().getTO()/>
					<cfset announceEvent("media.showform", ret) /> 								
			</cfcatch>
		</cftry>	
	</cffunction>
	
	<cffunction name="getMedium" access="public" returntype="any" output="false" hint="I get a single device TO object">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn getManager().getMedium(parent_key=arguments.event.getArg('parent_key')) /> 
	</cffunction>	
	
	<cffunction name="getItemData" access="public" output="false" returntype="struct">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var local = StructNew() />
		<cfset local.module = '' />
		<cfif arguments.event.isArgDefined('type')>
			<cfset local.type = arguments.event.getArg('type') />
			<cfset local.qry = getManager().getSupportingGateway("reference").getByFields(module=getManager().getModule(), reference_type='MEDIA_TYPE', short_desc=local.type) />
			<cfset local.module = local.qry.code />
			<cfset local.parent_key = 0 />
		<cfelseif arguments.event.isArgDefined('TO') >
			<cfset local.TO = arguments.event.getArg('TO') />
			<cfset local.module = local.TO.type />
			<cfset local.parent_key = local.TO.key />
		</cfif>
		
		<cfreturn getManager().getItemData(module=local.module, parent_key = local.parent_key) />
	</cffunction>	
	

</cfcomponent>