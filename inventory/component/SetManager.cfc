<cfcomponent name="SetManager" extends="component.InventoryManager"
			 hint="I manage Sets, Subset and Items within the Chemtrack Framework and provide the interface to reactor.">
	
	<cffunction name="init" access="public" returntype="component.SetManager" hint="Constructor.">
		<cfargument name="reactor" type="reactor.reactorFactory" required="true" />
		<cfargument name="setGateway" type="string" required="true" />
		<cfargument name="referenceGateway" type="string" required="true" />
		
		<cfset setReactor(arguments.reactor) />
		<cfset setReferenceGateway(getReactor().createGateway(arguments.referenceGateway)) />
		<cfset setSetGateway(getReactor().createGateway(arguments.setGateway)) />
	
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getSetRuleCodes" access="public" output="false" returntype="struct">
		<cfargument name="module" type="string" default="#getModule()#" />
		<cfargument name="set_code" type="string" default="" />
		<cfargument name="subset_code" type="string" default="" />
		<cfargument name="item_code" type="string" default="" />
		
		<cfset var ret = StructNew() />
		<cfset ret.qrySetItems = getSetGateway().getSetRuleCodes(argumentCollection=arguments) />
 		<cfset ret.lookup = getSetGateway().getLookupData(ret.qrySetItems) /> 
		<cfreturn ret />
	</cffunction>	
	
	<cffunction name="getItemData" access="public" output="false" returntype="struct">
		<cfargument name="tableName" type="string" required="true" />			
		<cfargument name="module" type="string" default="" />
		<cfargument name="set_code" type="string" default="" />
		<cfargument name="parent_key" type="string" default="" />
		
		<cfset var ret = StructNew() />
		<cfset ret.qrySetItems = getSetGateway().getItemData(argumentCollection=arguments) />
 		<cfset ret.lookup = getSetGateway().getLookupData(ret.qrySetItems) /> 
		<cfreturn ret />
	</cffunction>
	
	<cffunction name="validateItems" access="public" output="false" returntype="struct">
		<cfargument name="iterator" required="true" type="reactor.iterator.iterator" />
		<cfargument name="tableName" required="true" type="string" />
		<cfargument name="form" required="true" type="struct" />
		
		<cfset var local = StructNew() />
		<cfset var throwBack = StructNew() />
		<cfinvoke component="#getSetGateway()#" method="getValidateItems" returnvariable="local.qryValidateItems">
			<cfinvokeargument name="qryValues" value="#createSetQuery(arguments.form)#" />
			<cfinvokeargument name="tableName" value="#arguments.tableName#" />
			<cfinvokeargument name="module" value="#arguments.form.set_module#" />
		</cfinvoke> 
		<cfreturn loadItemIterator(arguments.iterator, local.qryValidateItems) />
	</cffunction>
	
	<cffunction name="loadItemIterator" access="private" output="false" returntype="struct">
		<cfargument name="iterator" type="reactor.iterator.iterator"  required="true" />
		<cfargument name="qryItems" type="query" required="true" />
		
		<cfset var local = StructNew() />
		<cfset var throwBack = StructNew() />
		<cfset local.i = 0 />
		<cfset local.keyList = '' />
		<cfset throwBack.errors = false />
		<cfset local.iterator = arguments.iterator />
		<cfset throwBack.displayData.qrySetItems = arguments.qryItems />
		
 		<cfloop from="1" to="#ArrayLen(local.iterator.getArray())#" index="local.i">
			<cfset local.record = local.iterator.getAt(local.i) />
			<cfset local.keyList = ListAppend(local.keyList, local.record.getKey(), '~') />
			<cfset local.record.validate() />
			<cfif local.record.hasErrors() >
				<cfif throwBack.errors >
					<cfset throwBack.messages.errorCollection.merge(local.record._getErrorCollection()) />
				<cfelse>
					<cfset throwBack.messages.errorCollection = local.record._getErrorCollection() />
					<cfset throwBack.errors = true />
				</cfif>
			</cfif>
		</cfloop> 
		<cfloop query="throwBack.displayData.qrySetItems">
			<cfif item_value neq '' or is_required>
				<cfset local.arrayIndex = ListFind(local.keyList, key, '~') />
				<cfif local.arrayIndex gt 0>
					<cfset local.record = local.iterator.getAt(local.arrayIndex) />
					<cfset local.record.setItem_value(item_value) />
					<cfset local.record.setIs_required(is_required) />
					<cfset local.record.setLong_description(item_long_desc) />
					<cfset local.record.setData_Type(data_type) />
				<cfelse>
					<cfinvoke component="#local.iterator#" method="add" returnvariable="local.record">
						<cfinvokeargument name="parent_key" value="#parent_key#" />
						<cfinvokeargument name="module" value="#module#" />
						<cfinvokeargument name="set_code" value="#set_code#" />
						<cfinvokeargument name="subset_code" value="#subset_code#" />
						<cfinvokeargument name="item_code" value="#item_code#" />
						<cfinvokeargument name="item_value" value="#item_value#" />
						<cfinvokeargument name="date_created" value="#Now()#" />
						<cfinvokeargument name="date_updated" value="#Now()#" />
						<cfinvokeargument name="is_required" value="#is_required#" />
						<cfinvokeargument name="data_type" value="#data_type#" />
						<cfinvokeargument name="long_description" value="#item_long_desc#" />
					</cfinvoke>
				</cfif>
				<cfset local.record.validate() />
				<cfif local.record.hasErrors() >
					<cfif throwBack.errors >
						<cfset throwBack.messages.errorCollection.merge(local.record._getErrorCollection()) />
					<cfelse>
						<cfset throwBack.messages.errorCollection = local.record._getErrorCollection() />
						<cfset throwBack.errors = true />
					</cfif>
				</cfif>				
			</cfif>
		</cfloop>
		
		<cfreturn throwBack />
	</cffunction>
	
	<cffunction name="createSetQuery" access="public" output="false" returntype="query" hint="I create a temporary query for the item collection">
		<cfargument name="form" required="true" type="struct" />
		
		<cfset var local = StructNew() />
		<cfset local.i = '' />
		<cfset local.j = '' />
		<cfset local.k = '' />
		<cfset local.columnNames = 'key,parent_key,date_created,date_updated,item_value,set_code,subset_code,item_code,set_code' & 
		       ',subset_code,item_code,module,set_long_desc,subset_long_desc,is_requried,sqllookup,display_type,set_order,subset_order,item_sort' />
		<cfset local.qrySet = QueryNew(local.columnNames) />
		
		<!--- Loop Through list of set, subsets, and items for item values --->
		<cfloop list="#arguments.form.listOfSetCode#" index="local.i" delimiters="~">
			<cfloop list="#arguments.form.listOfSubsetCode#" index="local.j" delimiters="~">
				<cfloop list="#arguments.form.listOfItemCode#" index="local.k" delimiters="~">
					<cfif StructKeyExists(arguments.form, local.i & '_' & local.j & '_' & local.k & '_value')>
						<cfset local.item_value = arguments.form[local.i & '_' & local.j & '_' & local.k & '_value'] />
						<cfset local.item_key = arguments.form[local.i & '_' & local.j & '_' & local.k & '_key'] />
						<cfset QueryAddRow(local.qrySet) />
						<cfset QuerySetCell(local.qrySet, 'item_value', local.item_value) />
						<cfset QuerySetCell(local.qrySet, 'key', local.item_key) />
						<cfset QuerySetCell(local.qrySet, 'parent_key', arguments.form.set_parent_key) />
						<cfset QuerySetCell(local.qrySet, 'set_code', local.i) />
						<cfset QuerySetCell(local.qrySet, 'subset_code', local.j) />
						<cfset QuerySetCell(local.qrySet, 'item_code', local.k) />
					</cfif>	
				</cfloop>
			</cfloop>
		</cfloop>
		<cfreturn local.qrySet />
	</cffunction>
	
	<!--- Getters and Setters --->
	<cffunction name="getSetGateway" access="private"  output="false" returntype="reactor.base.abstractgateway">
		<cfreturn variables.instance.setGateway />
	</cffunction>
	<cffunction name="setSetGateway" access="private" output="false" returntype="void">
		<cfargument name="setGateway" type="reactor.base.abstractgateway" required="true" />
		<cfset variables.instance.setGateway = arguments.setGateway />
	</cffunction>
	
	<cffunction name="getReferenceGateway" access="private"  output="false" returntype="reactor.base.abstractgateway">
		<cfreturn variables.instance.referenceGateway />
	</cffunction>
	<cffunction name="setReferenceGateway" access="private" output="false" returntype="void">
		<cfargument name="referenceGateway" type="reactor.base.abstractgateway" required="true" />
		<cfset variables.instance.referenceGateway = arguments.referenceGateway />
	</cffunction>
""</cfcomponent>