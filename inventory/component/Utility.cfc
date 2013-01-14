<cfcomponent name="Utility" output="true" hint="I am a Utility CFC">
	
	<cffunction name="init" access="public" output="false" returntype="component.Utility">
 		<cfargument name="reactor" required="true" type="reactor.reactorFactory" />
		<cfargument name="gatewayObjects" required="true" type="string" />
		
 		<cfset setReactor(arguments.reactor) />  
 		<cfset setGateway(getReactor().createGateway(arguments.gatewayObjects)) /> 
		<cfreturn this />
	</cffunction>
	
	<cffunction name="extendedTrim" returntype="any" access="public" output="false" hint="I trim all simple values in the complex value passed to me.">
		<cfargument name="value"  type="any" required="true" hint="" />
		<cfargument name="isList" type="boolean" default="false" hint="indicates whether values passed is a list" />
		<cfargument name="delims" type="string" default="," hint="list delimiter" />
		<cfif isArray( arguments.value )>
			<cfset arguments.value = arrayTrim( arr=arguments.value ) />
		<cfelseif isStruct( arguments.value )>
			<cfset arguments.value = structTrim( s=arguments.value ) />
		<cfelseif arguments.isList>
			<cfset arguments.value = listTrim( list=arguments.value, delims=arguments.delims ) />
		<cfelseif isSimpleValue( arguments.value )>
			<cfset arguments.value = trim( arguments.value ) />
		</cfif>
		<cfreturn arguments.value />
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
	
	<!--- private methods ---->
	<cffunction name="arrayTrim" returntype="array" access="private" output="false" hint="">
		<cfargument name="arr" type="array" required="true" hint="array to trim" />
		<cfset var i =  "" />
		<cfset var len =  arraylen( arguments.arr ) />
		<cfloop from="1" to="#len#" index="i">
			<cfset arguments.arr[i] = extendedTrim( value=arguments.arr[i] ) />
		</cfloop>
		<cfreturn arguments.arr />
	</cffunction>

	<cffunction name="structTrim" returntype="struct" access="private" output="false" hint="">
		<cfargument name="s" type="struct" required="true" hint="struct to trim" />
		<cfset var i =  "" />
		<cfloop collection="#arguments.s#" item="i">
      <!--- @@Note:  Oddly enough, you need the "IF" you have an optional argument that is not passed in and
                      you call:
                            arguments = getutility().extendedTrim( value=arguments ) ;
        --->
		  <cfif structKeyExists(arguments.s, i) >
  			<cfset arguments.s[i] = extendedTrim( value=arguments.s[i] ) />
  		</cfif>
		</cfloop>
		<cfreturn arguments.s />
	</cffunction>

	<cffunction name="listTrim" returntype="string" access="private" output="false" hint="I trim a list">
		<cfargument name="list" type="string" required="true" hint="list to be trimmed" />
		<cfargument name="delims" type="string" default="," hint="list delimiter" />
		<cfreturn arraytolist( arrayTrim( arr=listtoarray( arguments.list, arguments.delims ) ), arguments.delims ) />
	</cffunction>

</cfcomponent>