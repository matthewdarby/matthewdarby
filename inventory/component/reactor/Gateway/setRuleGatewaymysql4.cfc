
<cfcomponent hint="I am the mysql4 custom Gateway object for the setRule object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="setRuleGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getItemData" access="public" output="false" returntype="query" hint="I return item info for a particular item table">
		<cfargument name="module" type="string" required="true" />
		<cfargument name="tableName" type="string" required="true" />
		<cfargument name="parent_key" type="string" default="0" />
		<cfargument name="set_code" type="string" default="" />
		<cfargument name="subset_code" type="string" default="" />
		<cfargument name="item_code" type="string" default="" />
		
		<cfset var local=StructNew() />
		
		<cfquery name="local.qryItemData" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			select  m.key
				 , m.parent_key
				 , m.date_created
				 , m.date_updated	
				 , m.item_value				
				 , setup.set_code
				 , setup.subset_code
				 , setup.item_code
				 , setup.module
				 , IFNULL(setr.long_desc, setup.set_code) as set_long_desc
				 , IFNULL(subset.long_desc, setup.subset_code) as subset_long_desc
				 , IFNULL(item.long_desc, setup.item_code) as item_long_desc
				 , setup.is_required
				 , setup.sqllookup
				 , setup.display_type
				 , setup.data_type
				 , setr.sort_order as set_order
				 , subset.sort_order as subset_order
				 , setup.item_sort
			from r_set_subset_item setup
			left outer join #arguments.tableName# m
			  on setup.module = m.module
				and setup.set_code = m.set_code
				and setup.subset_code = m.subset_code
				and setup.item_code = m.item_code			
				and m.parent_key = <cfqueryparam value="#arguments.parent_key#" cfsqltype="cf_sql_numeric" />				
			left outer join r_reference setr
			  on setup.module = setr.module
				and setup.set_code = setr.code
				and setr.reference_type = 'SET'
			left outer join r_reference subset
			  on setup.module = subset.module
				and setup.subset_code = subset.code
				and subset.reference_type = 'SUBSET'
			left outer join r_reference item
			  on setup.module = item.module
				and setup.item_code = item.code
				and item.reference_type = 'ITEM'
			where 1=1
			and setup.module = <cfqueryparam value="#arguments.module#" cfsqltype="cf_sql_varchar" />			
			order by set_order, subset_order, item_sort
		</cfquery>
		
		<cfreturn local.qryItemData />
	</cffunction>
	
	<cffunction name="getValidateItems" access="public" output="false" returntype="query" hint="I populate the ItemData query with form values">
		<cfargument name="qryValues" type="query" required="true" />
		<cfargument name="module" type="string" required="true" />
		<cfargument name="tableName" type="string" required="true" />
		
		<cfset var local=StructNew() />
		
		<cfquery name="local.qryItemData" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
		SELECT   case
					<cfloop query="arguments.qryValues">
						when setup.item_code = '#item_code#'
							then '#item_value#'
					</cfloop>
				 end as item_value
				 , '#arguments.qryValues.parent_key#'  as parent_key
				 , m.key
				 , m.date_created
				 , m.date_updated				
				 , setup.set_code
				 , setup.subset_code
				 , setup.item_code
				 , setup.module
				 , IFNULL(setr.long_desc, setup.set_code) as set_long_desc
				 , IFNULL(subset.long_desc, setup.subset_code) as subset_long_desc
				 , IFNULL(item.long_desc, setup.item_code) as item_long_desc
				 , setup.is_required
				 , setup.sqllookup
				 , setup.display_type
				 , setup.data_type
				 , setr.sort_order as set_order
				 , subset.sort_order as subset_order
				 , setup.item_sort
			from r_set_subset_item setup
			left outer join #arguments.tableName# m
			  on setup.module = m.module
				and setup.set_code = m.set_code
				and setup.subset_code = m.subset_code
				and setup.item_code = m.item_code
				and m.parent_key = <cfqueryparam value="#arguments.qryValues.parent_key#" cfsqltype="cf_sql_numeric" />												
			left outer join r_reference setr
			  on setup.module = setr.module
				and setup.set_code = setr.code
				and setr.reference_type = 'SET'
			left outer join r_reference subset
			  on setup.module = subset.module
				and setup.subset_code = subset.code
				and subset.reference_type = 'SUBSET'
			left outer join r_reference item
			  on setup.module = item.module
				and setup.item_code = item.code
				and item.reference_type = 'ITEM'
			where 1=1
			and setup.module = <cfqueryparam value="#arguments.module#" cfsqltype="cf_sql_varchar" />		
			order by set_order, subset_order, item_sort
		</cfquery>
		
		<cfreturn local.qryItemData />	
	</cffunction>
	
	<cffunction name="getSetRuleCodes" access="public" output="false" returntype="query" hint="I return code for the set rule">
		<cfargument name="module" type="string" required="true" />
		<cfargument name="set_code" type="string" default="" />
		<cfargument name="subset_code" type="string" default="" />
		<cfargument name="item_code" type="string" default="" />
		
		<cfset var local=StructNew() />
		<cfquery name="local.qrySetRuleCodes" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			select   setup.set_code
				 , setup.subset_code
				 , setup.item_code
				 , setup.module
				 , IFNULL(setr.long_desc, setup.set_code) as set_long_desc
				 , IFNULL(subset.long_desc, setup.subset_code) as subset_long_desc
				 , IFNULL(item.long_desc, setup.item_code) as item_long_desc
				 , setup.is_required
				 , setup.sqllookup
				 , setup.display_type
				 , setup.data_type
				 , setr.sort_order as set_order
				 , subset.sort_order as subset_order
				 , setup.item_sort
			from r_set_subset_item setup
			left outer join r_reference setr
			  on setup.module = setr.module
				and setup.set_code = setr.code
				and setr.reference_type = 'SET'
			left outer join r_reference subset
			  on setup.module = subset.module
				and setup.subset_code = subset.code
				and subset.reference_type = 'SUBSET'
			left outer join r_reference item
			  on setup.module = item.module
				and setup.item_code = item.code
				and item.reference_type = 'ITEM'
			where 1=1
			and setup.module = <cfqueryparam value="#arguments.module#" cfsqltype="cf_sql_varchar" />
			<cfif StructKeyExists(arguments, 'set_code') and Len(arguments.set_code) gt 0>
				and setup.set_code = <cfqueryparam value="#arguments.set_code#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif StructKeyExists(arguments, 'subset_code') and Len(arguments.subset_code) gt 0>
				and setup.subset_code = <cfqueryparam value="#arguments.subset_code#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif StructKeyExists(arguments, 'item_code') and Len(arguments.item_code) gt 0 >
				and setup.item_code = <cfqueryparam value="#arguments.item_code#" cfsqltype="cf_sql_varchar" />
			</cfif>
			order by set_order, subset_order, item_sort	
		</cfquery>
		
		<cfreturn local.qrySetRuleCodes /> 
	</cffunction>	
	
	<cffunction name="getLookupData" access="public" returntype="struct" output="false" hint="I return a structure of queries for Set Data call have select lists">
		<cfargument name="qrySet" type="query" returntype="true" />
		<cfargument name="conditional" type="struct" default="#StructNew()#"  />
		
		<cfset var local = StructNew() />
		<cfset var ret = StructNew() />
		
		<cfquery name="local.qtemp" dbtype="query">
			SELECT item_code, sqllookup
			from arguments.qrySet
			where display_type = 'SL'
		</cfquery>
		
		<cfloop query="local.qtemp">
			<cfquery name="local.itemQuery" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
				#PreserveSingleQuotes(sqllookup)#
			</cfquery>
			<cfset ret['qry' & item_code] = local.itemQuery />
		</cfloop>
		
		<cfreturn ret /> 
	</cffunction>
</cfcomponent>
	
