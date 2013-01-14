<!---
<fusedoc fuse="AmazonWebService" specification="2.0" language="ColdFusion">
	<responsibilities>
		I communicate with the Amazaon Web Service
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="09/02/2006" comments="Initial Version" />
	</properties>
</fusedoc>
--->
<cfcomponent name="AmazonWebService" output="false" hint="I search the Amazon E-Commerce Service">

	<cffunction name="init" access="public" returntype="component.AmazonWebService" output="false">
		<cfargument name="developerKey" type="string" required="true" hint="I am the developer key given with the AWS account" />
		<cfargument name="soapURL" type="string" required="true" hint="I am the web address to the AWS" />
		<cfargument name="awsURL" type="string" required="true" hint="I am the web address to the new AWS">
		
		<cfset setAWSKey(arguments.developerKey) />
		<cfset setAWSSoapUrl(arguments.soapURL) />
		<cfset setAWSURL(arguments.awsURL) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProductsByCategory" access="public" returntype="any" hint="">
		<cfargument name="category" required="true" type="string" />
		<cfargument name="keyword" required="true" type="string" />
		<cfargument name="pageReturned" default="1" type="string" />
		
		<cfscript>
			var local  = structnew();
			local.keyWordSearch.devtag  = getAWSKey();
			local.keyWordSearch.keyword = arguments.keyword;
			local.keyWordSearch.mode = arguments.category;
			local.keyWordSearch.page = arguments.pageReturned;
			local.keyWordSearch.tag = "webservices-20";
			local.keyWordSearch.type = "lite";
		</cfscript>
		
		<cfinvoke webservice="#getAWSSoapUrl()#"
				  method="KeywordSearchRequest"
				  returnvariable="local.aProductInfo">
			<cfinvokeargument name="KeywordSearchRequest" value="#local.keyWordSearch#"/>
		</cfinvoke>	
		
		<cfreturn local.aProductInfo />
	</cffunction>
	
	<cffunction name="getProductByASIN" access="public" returntype="any" hint="">
		<cfargument name="asin" type="string" required="true" />
		<cfscript>
			var local = StructNew();
			local.aAsinRequest.asin = arguments.asin;
			local.aAsinRequest.devtag = getAWSKey();
			local.aAsinRequest.tag = "webservices-20";
			local.aAsinRequest.type = 'lite';
		</cfscript>
		
		<cfinvoke webservice="#getAWSSoapUrl()#"
  		     	  method="asinSearchRequest"
				  returnvariable="local.aProductInfo">
			<cfinvokeargument name="asinSearchRequest" value="#local.aAsinRequest#"/>
		</cfinvoke>	
		
		<cfreturn local.aAsinRequest /> 
	</cffunction>
	
	<cffunction name="getItemInformation" access="public" returntype="any">
		<cfargument name="itemid" type="string" required="true" />
		<cfargument name="type"   type="string" required="true" />
		
		<cfset var local = StructNew() />
		<cfhttp url="#getAWSURL()#" method="get" timeout="60" >
			<cfhttpparam name="SubscriptionId" value="#getAWSKey()#" type="url"/>
			<cfhttpparam name="Service" value="AWSECommerceService" type="url" />
			<cfhttpparam name="Operation" value="ItemLookup" type="url" />
			<cfhttpparam name="ItemId" value="#arguments.itemid#" type="url" />
			<cfhttpparam name="ResponseGroup" value="Medium" type="url" />
		</cfhttp>
		
		<cfscript>
			local.myXMLfoo = XMLParse(cfhttp.fileContent);
			local.xmlHead = local.myXMLfoo.XmlRoot.xmlChildren[2].xmlChildren[2].xmlChildren[8];
			local.mySize = arraylen(local.xmlHead.xmlChildren);
			local.myStruct = structNew();
			
			for ( local.i=1;  local.i lte local.mySize; local.i=local.i+1) {
				local.myStruct[local.xmlHead.xmlChildren[local.i].xmlName] = local.xmlHead.xmlChildren[local.i].xmltext;
				if ( arraylen(local.xmlHead.xmlChildren[local.i].xmlChildren) gt 1) {
					local.thisChild = local.xmlHead.xmlChildren[local.i];
					for ( local.k=1;  local.k lte arraylen(local.thisChild.xmlChildren); local.k=local.k+1) {
						local.myTemp[local.thisChild.xmlChildren[local.k].xmlName] = local.thisChild.xmlChildren[local.k].xmltext;
					}
					local.myStruct[local.xmlHead.xmlChildren[local.i].xmlName] = local.myTemp;
				}
			}	
			local.goop = XMLSearch(local.myXMLFoo, '/:ItemLookupResponse/:Items/:Item/:SmallImage/:URL');
			local.myStruct.smallImage = local.goop[1].xmlText;
		</cfscript> 

		<cfreturn local.myStruct />
	</cffunction>
	
	<!--- GETTERS AND SETTERS --->
	<cffunction name="getAWSKey" access="public"  output="false" returntype="string">
		<cfreturn variables.instance.awsKey />
	</cffunction>
	<cffunction name="setAWSKey" access="public" output="false" returntype="void">
		<cfargument name="awsKey" type="string" required="true" />
		<cfset variables.instance.awsKey = arguments.awsKey />
	</cffunction>
	
	<cffunction name="getAWSSoapUrl" access="public"  output="false" returntype="string">
		<cfreturn variables.instance.awsSoapUrl />
	</cffunction>
	<cffunction name="setAWSSoapUrl" access="public" output="false" returntype="void">
		<cfargument name="awsSoapUrl" type="string" required="true" />
		<cfset variables.instance.awsSoapUrl = arguments.awsSoapUrl />
	</cffunction>

	<cffunction name="getAWSURL" access="public"  output="false" returntype="string">
		<cfreturn variables.instance.awsURL />
	</cffunction>
	<cffunction name="setAWSURL" access="public" output="false" returntype="void">
		<cfargument name="awsURL" type="string" required="true" />
		<cfset variables.instance.awsURL = arguments.awsURL />
	</cffunction>
</cfcomponent>