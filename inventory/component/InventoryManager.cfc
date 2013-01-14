<cfcomponent name="InventoryManager" displayname="Inventory Manager" output="false" hint="I an abstract Inventory Controller"  >
	<cffunction name="init" access="public" output="false" returntype="component.InventoryManager" 
				hint="Configures the Manager to be incorporated wiht reactor" >
		<cfargument name="reactor" required="true" type="reactor.reactorFactory" />
		<cfargument name="utility" type="component.Utility" required="false"> 		
		<cfargument name="amazonService" type="component.AmazonWebService" required="false" />
		<cfargument name="setManager" type="component.SetManager" required="false" />		
		<cfargument name="table"  type="string" default="dv_device" />
		<cfargument name="module" type="string" default="DV" />
		<cfargument name="gateways" default="reference" type="string" hint="delimited by ~" />
		<cfargument name="childTable" type="string" default="st_store" />
		<cfargument name="referenceList" type="string" default="" />
		
 		<cfset setReactor(arguments.reactor) />  
		<cfset setUtility(arguments.utility) />
		<cfif  StructKeyExists(arguments, "setManager") >
			<cfset setSetManager(arguments.setManager) />
		</cfif>
		<cfif  StructKeyExists(arguments, "amazonService")>		
			<cfset setAmazonService(arguments.amazonService) />
		</cfif>
		<cfset setTableName(arguments.table)>
		<cfset setModule(arguments.module) />
 		<cfset setGateway(getReactor().createGateway(getTableName())) />		
		<cfset setSupportingGateways(arguments.gateways) />
		<cfset setChildTables(arguments.childTable) />
		<cfset setReferenceList(arguments.referenceList) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getTO" access="public" returntype="reactor.base.abstractTO" output="false" hint="I return a TO." >
		<cfargument name="TOData" type="struct" required="false" />
		
		<cfset var local = StructNew() />
		<cfset local.TO = getReactor().createTO( getTableName() ) />
		
		<cfif StructKeyExists(arguments,'TOData')>
			<cfset structAppend(local.TO, arguments.TOData, true) />
		</cfif>
		
		<cfreturn local.TO />
	</cffunction>
	
	<cffunction name="getRecord" access="public" returntype="reactor.base.abstractRecord" output="false">
		<cfargument name="eventArgs" type="struct" required="true" />
		
		<cfset var local = getUtility().extendedTrim(arguments.eventArgs) />
		<cfreturn getReactor().createRecord(getTableName()).init(argumentCollection=local) />
	</cffunction>
	
 	<cffunction name="setSupportingGateways" access="public" output="false" returntype="void"
				hint="I set and create supporting gateways for a manager">
		<cfargument name="gatewayList" type="string" required="true" />
		
		<cfset var local = StructNew() />
		<cfset variables.object.gatewayList = StructNew() />
		<cfloop index="local.item" list="#arguments.gatewayList#" delimiters="~">
			<cfset StructInsert(variables.object.gatewayList, local.item,  getReactor().createGateway(local.item)) />
		</cfloop>
	</cffunction>
	<cffunction name="getSupportingGateway" access="public" output="false" returntype="reactor.base.abstractGateway">
		<cfargument name="gatewayName" type="string" required="true" />
		
		<cfreturn StructFind(variables.object.gatewayList, arguments.gatewayName) />
	</cffunction>

	<cffunction name="getCommonValues" access="public" output="false" returntype="struct">
		<cfset var local = StructNew() />
		
		<cfif Len(getReferenceList()) gt 0>
			<cfloop list="#getReferenceList()#" delimiters="~" index="local.listElement">
				<cfset local.qryList[local.listElement] = getSupportingGateway("reference").getByFields(module=getModule(), reference_type=local.listElement) />
			</cfloop>
		<cfelse>
			<cfthrow type="component.Managers.InventoryManager.EmptyReferenceList"
					 message="Call to the method  getCommnoValues has an empty reference list"
					 detail="getRefereenceList() contains no data" /> 
		</cfif>
		
		<cfreturn local.qryList />
	</cffunction>

	<cffunction name="getSetRuleCodes" access="public" output="false" returntype="struct">
		<cfargument name="module" type="string" default="#getModule()#" />
		<cfargument name="set_code" type="string" default="" />
		<cfargument name="subset_code" type="string" default="" />
		<cfargument name="item_code" type="string" default="" />
		
		<cfreturn getSetManager().getSetRuleCodes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="getItemData" access="public" output="false" returntype="struct">
		<cfargument name="module" type="string" default="" />
		<cfargument name="set_code" type="string" default="" />
		<cfargument name="parent_key" type="string" default="" />
		<cfargument name="tableName" type="string" default="#getTableName()#_item" />

		<cfreturn getSetManager().getItemData(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="validateAndProcess" access="public" output="false" returntype="struct" hint="I validate and process a single record">
		<cfargument name="form"  type="struct" required="true" />
		
		<cfset var local = StructNew() />
		<cfset var throwBack = StructNew() />
		<cfset local.record = getRecord(arguments.form) />
		
		<cfif arguments.form.action is 'Delete'>
			<cfset local.record.delete() />
			<cfset throwBack.messages.successText = "The information has been deleted" />
		<cfelse>
			<cfset local.record.validate() />
			<cfif local.record.hasErrors() >
				<cfset throwBack.messages.errorCollection = local.record._getErrorCollection() />
				<cfset throwBack.action = arguments.form.action />
				<cfset throwBack.hasOptions = arguments.form.hasOptions />
			<cfelse>
				<cfset local.record.save() />
				<cfset throwBack.messages.successText = 'Your changes have been saved!' />
				<cfset throwBack.action = 'Update' />
				<cfset throwBack.hasOptions = true />
				<cfset throwBack.matchType = 'code' />				
			</cfif>
			<cfset throwBack.TO = local.record._getTO() />			
			<cfset throwback.parent_key = local.record.getKey() />
			<cfset throwback.parent_module = local.record.getModule() />
		</cfif>
		<cfreturn throwBack />
	</cffunction>
	
	<cffunction name="validateAndProcessRecordAndItems" access="public" output="false" returntype="struct" 
				hint="I validate and process a parent record and it's child records in an item record">
		<cfargument name="form" type="struct" required="true" />
		
		<cfset var local = StructNew() />
		<cfset var throwBack = StructNew() />
	
		<cfif StructKeyExists(arguments.form, 'listOfSetCode')>
			<cfset local.record = getRecord(arguments.form) />		
			<cfinvoke component="#local.record#" method="get#getItemTableName()#Iterator" returnvariable="local.itemIterator" />
			
			<cfif arguments.form.action eq 'Delete'>
				<cfset local.record.delete() />
				<cfset throwBack.messages.successText = 'The information has been deleted' />
				<cfset throwBack.action = arguments.form.action />
				<cfset throwBack.hasOptions = arguments.form.hasOptions />
			<cfelse>
				<cfset local.record.validate() />
				<cfinvoke component="#getSetManager()#" method="validateItems" returnvariable="throwBack">
					<cfinvokeargument name="iterator" value="#local.itemIterator#" />
					<cfinvokeargument name="tableName" value="#getItemTableName()#" />
					<cfinvokeargument name="form" value="#arguments.form#" />
				</cfinvoke>
				<cfif throwBack.errors or local.record.hasErrors() >
					<cfif local.record.hasErrors() and throwBack.errors>
						<!--- Ensure the parent record collection merges the set error collection to keep the parents translated errors --->
						<cfset local.record._getErrorCollection().merge(throwBack.messages.errorCollection) />
						<cfset throwBack.messages.errorCollection = local.record._getErrorCollection() />
					<cfelseif local.record.hasErrors() and not throwBack.errors>
						<cfset throwBack.messages.errorCollection = local.record._getErrorCollection() />
					</cfif>
					<cfset throwBack.displayData.lookup = getReactor().createGateway('setRule').getLookupData(throwBack.displayData.qrySetItems) />				
					<cfset throwBack.action = arguments.form.action />
					<cfset throwBack.hasOptions = arguments.form.hasOptions />								
				<cfelse>
					<cfset local.record.save() />
					<cfset throwBack.messages.successText = 'Your information has been saved' />				
					<cfinvoke method="getItemData"  returnvariable="throwBack.displayData">
						<cfinvokeargument name="parent_key" value="#local.record.getKey()#" />
						<cfinvokeargument name="module" value="#arguments.form.SET_MODULE#" />
					</cfinvoke>
					<cfset throwBack.action = 'Update' />
					<cfset throwBack.hasOptions = true />
				</cfif>
				<cfset throwBack.TO = local.record._getTO() />
				<cfset throwBack.matchType = 'code' />
				<cfset throwBack.parent_key = local.record.getKey() />
				<cfset throwBack.parent_module = local.record.getModule() />	
			</cfif>
	
			<cfreturn throwBack />
		<cfelse>
			<cfreturn validateAndProcess(argumentCollection=arguments) />
		</cfif>
	</cffunction>

	<!--- REACTOR SETTERS AND GETTERS --->
	<cffunction name="getTableName" access="public"  output="false" returntype="string">
		<cfreturn variables.instance.tableName />
	</cffunction>
	<cffunction name="setTableName" access="public" output="false" returntype="void">
		<cfargument name="tableName" type="string" required="true" />
		<cfset variables.instance.tableName = arguments.tableName />
	</cffunction>
	
	<cffunction name="getModule" access="public"  output="false" returntype="string">
		<cfreturn variables.instance.module />
	</cffunction>
	<cffunction name="setModule" access="public" output="false" returntype="void">
		<cfargument name="module" type="string" required="true" />
		<cfset variables.instance.module = arguments.module />
	</cffunction>
	
	<cffunction name="getReactor" access="public"  output="false" returntype="reactor.reactorFactory">
		<cfreturn variables.instance.reactor />
	</cffunction>
	<cffunction name="setReactor" access="public" output="false" returntype="void">
		<cfargument name="reactor" type="reactor.reactorFactory" required="true" />
		<cfset variables.instance.reactor = arguments.reactor />
	</cffunction>
	
	<cffunction name="getGateway" access="public"  output="false" returntype="reactor.base.abstractGateway">
		<cfreturn variables.instance.gateway />
	</cffunction>
	<cffunction name="setGateway" access="public" output="false" returntype="void">
		<cfargument name="gateway" type="reactor.base.abstractGateway" required="true" />
		<cfset variables.instance.gateway = arguments.gateway />
	</cffunction>

	<cffunction name="getFieldNames" access="public"  output="false" returntype="string">
		<cfreturn variables.object.fieldNames />
	</cffunction>
	<cffunction name="setFieldNames" access="public" output="false" returntype="void">
		<cfargument name="fieldNames" type="string" required="true" />
		<cfset variables.object.fieldNames = arguments.fieldNames />
	</cffunction>

	<cffunction name="getChildTables" access="public"  output="false" returntype="string">
		<cfreturn variables.object.chldTables />
	</cffunction>
	<cffunction name="setChildTables" access="public" output="false" returntype="void">
		<cfargument name="chldTables" type="string" required="true" />
		<cfset variables.object.chldTables = arguments.chldTables />
	</cffunction>

	<cffunction name="getUtility" access="public"  output="false" returntype="component.Utility">
		<cfreturn variables.object.utility />
	</cffunction>
	<cffunction name="setUtility" access="public" output="false" returntype="void">
		<cfargument name="utility" type="component.Utility" required="true" />
		<cfset variables.object.utility = arguments.utility />
	</cffunction>

	<cffunction name="getReferenceList" access="public"  output="false" returntype="string">
		<cfreturn variables.instance.referenceList />
	</cffunction>
	<cffunction name="setReferenceList" access="public" output="false" returntype="void">
		<cfargument name="referenceList" type="string" required="true" />
		<cfset variables.instance.referenceList = arguments.referenceList />
	</cffunction>

	<cffunction name="getSetManager" access="public"  output="false" returntype="component.SetManager">
		<cfreturn variables.instance.setManager />
	</cffunction>
	<cffunction name="setSetManager" access="public" output="false" returntype="void">
		<cfargument name="setManager" type="component.SetManager" required="true" />
		<cfset variables.instance.setManager = arguments.setManager />
	</cffunction>

	<cffunction name="getItemTableName" access="private"  output="false" returntype="string">
		<cfreturn variables.instance.itemTableName />
	</cffunction>
	<cffunction name="setItemTableName" access="public" output="false" returntype="void">
		<cfargument name="itemTableName" type="string" required="true" />
		<cfset variables.instance.itemTableName = arguments.itemTableName />
	</cffunction>
	
	<cffunction name="getAmazonService" access="public"  output="false" returntype="component.AmazonWebService">
		<cfreturn variables.instance.amazaonService />
	</cffunction>
	<cffunction name="setAmazonService" access="public" output="false" returntype="void">
		<cfargument name="amazaonService" type="component.AmazonWebService" required="true" />
		<cfset variables.instance.amazaonService = arguments.amazaonService />
	</cffunction>
</cfcomponent>