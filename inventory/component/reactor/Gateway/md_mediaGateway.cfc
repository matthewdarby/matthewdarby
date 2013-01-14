
<cfcomponent hint="I am the database agnostic custom Gateway object for the md_media object.  I am generated, but not overwritten if I exist.  You are safe to edit me."
	extends="reactor.project.Matt.Gateway.md_mediaGateway" >
	<!--- Place custom code here, it will not be overwritten --->
	
	<cffunction name="getVideoResults" access="public" output="false" returntype="query">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="name" required="false" type="string" />
		<cfargument name="binding" required="false" type="string" />
		<cfargument name="genre" required="false" type="string" />
				
		<cfset var local = StructNew() />	

		<cfquery name="local.qryVideoSearch" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			SELECT m.key
			  , m.module 
				, m.name
				, m.picture
				, type.long_desc as type
				, genre.long_desc as genre
				, binding.long_desc as binding				
				, screen.long_desc as i2
				, mc.item_value as i1
			FROM md_media m
			left outer join md_media_item sf
			  on sf.parent_key = m.key
				and sf.set_code = 'VID'
				and sf.subset_code = 'VID'
				and sf.item_code = 'SF'
			left outer join md_media_item bind
			  on bind.parent_key = m.key
				and bind.set_code = 'VID'
				and bind.subset_code = 'VID'
				and bind.item_code = 'BIND'
			left outer join md_media_item mc
			  on mc.parent_key = m.key
				and mc.set_code = 'VID'
				and mc.subset_code = 'VID'
				and mc.item_code = 'MC'
			left outer join md_media_item gen
			  on gen.parent_key = m.key
				and gen.set_code = 'VID'
				and gen.subset_code = 'VID'
				and gen.item_code = 'GEN'
			left outer join r_reference type
			  on type.module = m.module
				and type.code = m.type
				and type.reference_type = 'MEDIA_TYPE'
			left outer join r_reference screen
			  on screen.module = sf.module
				and screen.code = sf.item_value
				and screen.reference_type = 'SCREEN_FORMAT'
			left outer join r_reference binding
			  on binding.module = bind.module
				and binding.code = bind.item_value
				and binding.reference_type = 'BINDING'
			left outer join r_reference genre
			  on genre.module = gen.module
				and genre.code = gen.item_value
				and genre.reference_type = 'GENRE'
			WHERE 1=1
			<cfif Len(arguments.type) gt 0>
				and m.type = <cfqueryparam value='#arguments.type#' cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.name) gt 0>	 
				and m.name like <cfqueryparam value='%#arguments.name#%' cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.genre) gt 0>
				AND gen.item_value = <cfqueryparam value="#arguments.genre#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.binding) gt 0>
				AND bind.item_value = <cfqueryparam value="#arguments.binding#" cfsqltype="cf_sql_varchar" />
			</cfif>			
			ORDER BY m.name, genre
		</cfquery>	

		<cfreturn local.qryVideoSearch />
	</cffunction>
	
	<cffunction name="getBookResults" access="public" output="false" returntype="query">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="name" required="false" type="string" />
		<cfargument name="binding" required="false" type="string" />
		<cfargument name="genre" required="false" type="string" />
		
		<cfset var local = StructNew() />	

		<cfquery name="local.qryBookSearch" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			SELECT m.key
			    , m.module 
				, m.name
				, m.picture
				, type.long_desc as type
				, genre.long_desc as genre
				, binding.long_desc as binding				
				, p.item_value as i2
				, a.item_value as i1
			FROM md_media m	
			left outer join md_media_item p
			  on p.parent_key = m.key
				and p.set_code = 'BOOK'
				and p.subset_code = 'BI'
				and p.item_code = 'P'
			left outer join md_media_item bind
			  on bind.parent_key = m.key
				and bind.set_code = 'BOOK'
				and bind.subset_code = 'BI'
				and bind.item_code = 'BIND'
			left outer join md_media_item gen
			  on gen.parent_key = m.key
				and gen.set_code = 'BOOK'
				and gen.subset_code = 'BI'
				and gen.item_code = 'GEN'
			left outer join md_media_item A
			  on a.parent_key = m.key
			    and a.set_code = 'BOOK'
				and a.subset_code = 'BI'
				and a.item_code = 'A'
			left outer join r_reference type
			  on type.module = m.module
				and type.code = m.type
				and type.reference_type = 'MEDIA_TYPE'
			left outer join r_reference binding
			  on binding.module = bind.module
				and binding.code = bind.item_value
				and binding.reference_type = 'BINDING'
			left outer join r_reference genre
			  on genre.module = gen.module
				and genre.code = gen.item_value
				and genre.reference_type = 'GENRE'
			WHERE 1=1
			<cfif Len(arguments.type) gt 0>
				AND m.type = <cfqueryparam value='#arguments.type#' cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.name) gt 0>	 
				AND m.name like <cfqueryparam value='%#arguments.name#%' cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.genre) gt 0>
				AND gen.item_value = <cfqueryparam value="#arguments.genre#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.binding) gt 0>
				AND bind.item_value = <cfqueryparam value="#arguments.binding#" cfsqltype="cf_sql_varchar" />
			</cfif>
			ORDER BY m.name, genre
		</cfquery>	

		<cfreturn local.qryBookSearch />
	</cffunction>	
	
	<cffunction name="getMusicResults" access="public" output="false" returntype="query">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="name" required="false" type="string" />
		<cfargument name="binding" required="false" type="string" />
		<cfargument name="genre" required="false" type="string" />
				
		<cfset var local = StructNew() />	

		<cfquery name="local.qryMusicSearch" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			SELECT m.key
			    , m.module 
				, m.name
				, m.picture
				, type.long_desc as type
				, genre.long_desc as genre
				, binding.long_desc as binding				
				, at.item_value as i1
				, p.item_value as  i2
			FROM md_media m	
			left outer join md_media_item p
			  on p.parent_key = m.key
				and p.set_code = 'MUSC'
				and p.subset_code = 'MUSC'
				and p.item_code = 'P'
			left outer join md_media_item bind
			  on bind.parent_key = m.key
				and bind.set_code = 'MUSC'
				and bind.subset_code = 'MUSC'
				and bind.item_code = 'BIND'
			left outer join md_media_item at
			  on at.parent_key = m.key
				and at.set_code = 'MUSC'
				and at.subset_code = 'MUSC'
				and at.item_code = 'AT'
			left outer join md_media_item gen
			  on gen.parent_key = m.key
				and gen.set_code = 'MUSC'
				and gen.subset_code = 'MUSC'
				and gen.item_code = 'GEN'
			left outer join r_reference type
			  on type.module = m.module
				and type.code = m.type
				and type.reference_type = 'MEDIA_TYPE'	
			left outer join r_reference binding
			  on binding.module = bind.module
				and binding.code = bind.item_value
				and binding.reference_type = 'BINDING'
			left outer join r_reference genre
			  on genre.module = gen.module
				and genre.code = gen.item_value
				and genre.reference_type = 'GENRE'
			WHERE 1=1
			<cfif Len(arguments.type) gt 0>
				and m.type = <cfqueryparam value='#arguments.type#' cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.name) gt 0>	 
				and m.name like <cfqueryparam value='%#arguments.name#%' cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.genre) gt 0>
				AND gen.item_value = <cfqueryparam value="#arguments.genre#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif Len(arguments.binding) gt 0>
				AND bind.item_value = <cfqueryparam value="#arguments.binding#" cfsqltype="cf_sql_varchar" />
			</cfif>			
			ORDER BY m.name, genre
		</cfquery>	

		<cfreturn local.qryMusicSearch />
	</cffunction>	

	<cffunction name="getStatus" access="public" output="false" returntype="query">
		<cfset var = StructNew() />
		
		<cfquery name="local.qryStatus" datasource="#_getConfig().getDsn()#" username="#_getConfig().getUsername()#" password="#_getConfig().getPassword()#">
			SELECT (
			SELECT count(*)
			FROM md_media
			WHERE type = 'VID' ) as video_count
			, ( 
			SELECT count(*)
			FROM md_media
			WHERE type = 'BOOK') as book_count
			, (
			SELECT count(*)
			FROM md_media
			WHERE type = 'MUSC') as music_count 
			FROM md_media		
		</cfquery>
		
		<cfreturn local.qryStatus />
	</cffunction>	
</cfcomponent>
	
