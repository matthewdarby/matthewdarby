<cfcomponent displayname="MediaManager" output="false" hint="I a the Media Controller" extends="component.InventoryManager" >

	<cffunction name="init" access="public" output="false" returntype="component.Media.MediaManager" 
				hint="Configures the listener as par of the Mach-II framework" >
		<cfargument name="reactor" type="reactor.reactorFactory" required="true" />
		<cfargument name="utility" type="component.Utility" required="false"> 
		<cfargument name="amazonService" type="component.AmazonWebService" required="false" />		
		<cfargument name="setSubsetItem" type="component.SetManager" required="false" />
		<cfargument name="table"  type="string" default="dv_device" />
		<cfargument name="module" type="string" default="DV" />
		<cfargument name="gateways" default="reference" type="string" hint="delimited by ~" />
		<cfargument name="childTables" type="string" default="st_store" hint="delimited by ~" />
		<cfargument name="referenceList" type="string"  />
		
		<cfreturn super.init(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="getStatus" access="public" output="false" returntype="query">
		<cfreturn getGateway().getStatus() />
	</cffunction>
	
	<cffunction name="getSearchResults" access="public" output="false" returntype="query">
		<cfargument name="type" type="string" required="true" />
		<cfargument name="name" type="string" default="" />
		<cfargument name="genre" type="string" default="" />
		<cfargument name="binding" type="string" default="" />
		
		<cfset var local=StructNew() />
		<cfswitch expression="#arguments.type#">
			<cfcase value="MUSC">
				<cfreturn getGateway().getMusicResults(type=arguments.type, name=arguments.name, genre=arguments.genre, binding=arguments.binding) />				
			</cfcase>
			<cfcase value="BOOK">
				<cfreturn getGateway().getBookResults(type=arguments.type, name=arguments.name, genre=arguments.genre, binding=arguments.binding) />			
			</cfcase>
			<cfdefaultcase>
				<cfset local.type = 'VID'>
				<cfreturn getGateway().getVideoResults(type=local.type, name=arguments.name, genre=arguments.genre, binding=arguments.binding) />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getMedium" access="public" returntype="reactor.base.abstractTO" output="false" hint="I get a single device TO object">
		<cfargument name="parent_key" type="string" required="true" />
		
		<cfscript>
			var local = StructNew();
			local.record = getReactor().createRecord(getTableName());
			local.record.setKey(arguments.parent_key);
			local.record.load();
		</cfscript> 
		
		<cfreturn local.record._getTO() /> 
	</cffunction>
	
	<cffunction name="getSimpleSearch" access="public" output="false" returntype="query">
		<cfargument name="asin" type="string" default="" />
		
		<cfreturn getGateway().getByFields(asin=arguments.asin) />
	</cffunction>	
	
	<cffunction name="assignAmazonValues" access="public" output="false" returntype="struct" hint="I assing Amazaon values to transfer object">
		<cfargument name="amazonStruct" type="struct" required="true" />
		<cfargument name="asin" type="string" required="true" />
		<cfargument name="type"   type="string" required="true" />
				
		<cfset var local = StructNew() />		
		<cfif StructKeyExists(arguments.amazonStruct, 'title')>
			<cfset local.To.name = arguments.amazonStruct.Title />
		</cfif>
		<cfif StructKeyExists(arguments.amazonStruct, 'smallimage')>
			<cfset local.To.picture = arguments.amazonStruct.smallImage /> 
		</cfif>
		<cfset local.To.asin = arguments.asin />		
		<cfset local.TO.type = arguments.type />
		
		<cfswitch expression="#Ucase(arguments.type)#">
			<cfcase value="BOOKS">
				<cfif StructKeyExists(arguments.amazonStruct, 'isbn')>
					<cfset local.set.BOOK_BI_ISBN = arguments.amazonStruct.isbn />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'author')>				
					<cfset local.set.BOOK_BI_A = arguments.amazonStruct.author />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'publisher')>				
					<cfset local.set.BOOK_BI_P = arguments.amazonStruct.Publisher>
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'publicationdate')>				
					<cfset local.set.BOOK_BI_PD = arguments.amazonStruct.PublicationDate />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'numberofpages')>				
					<cfset local.set.BOOK_BI_PG = arguments.amazonStruct.NumberOfPages />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'binding')>				
					<cfset local.set.BOOK_BI_BIND = arguments.amazonStruct.binding />
				</cfif>			
			</cfcase>
			<cfcase value="VIDEO">
				<cfif StructKeyExists(arguments.amazonStruct, 'AspectRatio')>
					<cfset local.set.VID_VID_ASR = arguments.amazonStruct.AspectRatio/>				
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'upc')>				
					<cfset local.To.upc = arguments.amazonStruct.upc />				
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'format')>					
					<cfset local.set.VID_VID_SF = arguments.amazonStruct.format />				
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'label')>									
					<cfset local.set.VID_VID_MC = arguments.amazonStruct.label />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'AudienceRating')>					
					<cfset local.set.VID_VID_R = arguments.amazonStruct.AudienceRating />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'runningtime')>					
					<cfset local.set.VID_VID_LEN = arguments.amazonStruct.runningtime />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'Binding')>					
					<cfset local.set.VID_VID_BIND = arguments.amazonStruct.Binding />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'TheatricalReleaseDate')>					
					<cfset local.set.VID_VID_RLD = arguments.amazonStruct.TheatricalReleaseDate />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'NumberOfItems')>					
					<cfset local.set.VID_VID_DSC = arguments.amazonStruct.NumberOfItems />
				</cfif>
				<cfset local.set.VID_VID_WB = "" />
			</cfcase>
			<cfcase value="MUSIC">
				<cfif StructKeyExists(arguments.amazonStruct, 'upc')>
					<cfset local.To.upc = arguments.amazonStruct.upc />				
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'Artist')>				
					<cfset local.set.MUSC_MUSC_AT = arguments.amazonStruct.Artist />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'Binding')>					
					<cfset local.set.MUSC_MUSC_BIND  = arguments.amazonStruct.Binding />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'Publisher')>					
					<cfset local.set.MUSC_MUSC_P = arguments.amazonStruct.Publisher />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'ReleaseDate')>					
					<cfset local.set.MUSC_MUSC_RLD = arguments.amazonStruct.ReleaseDate />
				</cfif>
				<cfif StructKeyExists(arguments.amazonStruct, 'NumberOfDiscs')>					
					<cfset local.set.MUSC_MUSC_DSC = arguments.amazonStruct.NumberOfDiscs />
				</cfif>	
				<cfif StructKeyExists(arguments.amazonStruct, 'Format')>				
					<cfset local.set.MUSC_MUSC_EXP = arguments.amazonStruct.Format/>
				</cfif>									
				<cfset local.set.MUSC_MUSC_CT  = ""/>
				<cfset local.set.MUSC_MUSC_T =  ""/>
				<cfset local.set.MUSC_MUSC_WB  = ""/>
				<cfset local.set.MUSC_MUSC_LEN =  ""/>							
			</cfcase>
		</cfswitch>
		<cfset local.To = getTO(local.To) />		

		<cfreturn local />
	</cffunction>			

	<cffunction name="validateAndProcess" access="public" output="false" returntype="struct" hint="I validate and process a single record">
		<cfargument name="form"  type="struct" required="true" />
		
		<cfset var throwBack = super.validateAndProcess(argumentCollection=arguments) />
		<cfif StructKeyExists(throwBack.messages, 'successText')>
			<cfset throwBack.displayData = getItemData(module=throwBack.TO.module, parent_key = throwBack.TO.key) />		
		</cfif>
		
		<cfreturn throwBack /> 
	</cffunction>

</cfcomponent>