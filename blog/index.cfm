<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
	Name         : Index
	Author       : Raymond Camden 
	Created      : February 10, 2003
	Last Updated : May 18, 2007
	History      : Reset history for version 5.0
				 : Link for more entries fixed (rkc 6/25/06)
				 : Gravatar support (rkc 7/8/06)
				 : Cleanup of area shown when no entries exist (rkc 7/15/06)
				 : Use of rb(), use of icons, other small mods (rkc 8/20/06)
				 : Change how categories are handled (rkc 9/17/06)
				 : Big change to cut down on whitespace (rkc 11/30/06)
				 : comment mod support (rkc 12/7/06)
				 : gravatar fix, thanks Pete F (rkc 12/26/06)
				 : use app.maxentries, digg link (rkc 2/28/07)
				 : fix bug where 11 items showed up, not 10 (rkc 5/18/07)
	Purpose		 : Blog home page
--->

<!--- Handle URL variables to figure out how we will get betting stuff. --->
<cfmodule template="tags/getmode.cfm" r_params="params"/>

<!--- only cache on home page --->
<cfset disabled = false>
<cfif url.mode is not "" or len(cgi.query_string) or not structIsEmpty(form)>
	<cfset disabled = true>
</cfif> 

<cfmodule template="tags/scopecache.cfm" cachename="#application.applicationname#" scope="application" disabled="#disabled#" timeout="#application.timeout#">

<!--- Try to get the articles. --->
<cftry>
	<cfset articleData = application.blog.getEntries(params)>
	<cfset articles = articleData.entries>
	<!--- if using alias, switch mode to entry --->
	<cfif url.mode is "alias">
		<cfset url.mode = "entry">
		<cfset url.entry = articles.id>
	</cfif>
	<cfcatch>
		<cfset articles = queryNew("id")>
	</cfcatch>
</cftry>

<!--- Call layout custom tag. --->
<cfmodule template="tags/layout.cfm">

	<!--- load up swfobject --->
	<cfoutput>
	<script src="#application.rooturl#/includes/swfobject_modified.js" type="text/javascript"></script>
	</cfoutput>
	
	<cfset lastDate = "">
	<cfloop query="articles">
	
		<cfset url.id = id />
		<!--- Validate Comment Form --->
		<cfif isDefined("form.addcomment")>
			
			<cfinclude template="validatecomment.cfm" />
		</cfif>	
	
		<cfoutput><div id="post-#articles.currentRow#" class="post entry<cfif articles.currentRow EQ articles.recordCount>Last</cfif>"></cfoutput>
		
		<cfif application.trackbacksallowed>
			<!--- output this rdf for auto discovery of trackback links --->
			<cfoutput>
			<!-- 
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
	             xmlns:dc="http://purl.org/dc/elements/1.1/"
	             xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/">
		    <rdf:Description
		        rdf:about="#application.blog.makeLink(id)#"
		        dc:identifier="#application.blog.makeLink(id)#"
		        dc:title="#title#"
		        trackback:ping="#application.rooturl#/trackback.cfm?#id#" />
		    </rdf:RDF>
			-->
			</cfoutput>		
		</cfif>

		<cfoutput>
		<div  class="post-heading">
			<h2><a href="#application.blog.makeLink(id)#">#title#</a></h2>
			<p><cfif len(name)> #rb("postedby")# : #name# on #application.localeUtils.dateLocaleFormat(posted)# </cfif><br />
				#rb("relatedcategories")#:
		</cfoutput>
		<cfset lastid = listLast(structKeyList(categories))>
		<cfloop item="catid" collection="#categories#">
			<cfoutput><a href="#application.blog.makeCategoryLink(catid)#">#categories[currentRow][catid]#</a><cfif catid is not lastid>, </cfif></cfoutput>
		</cfloop>
		<cfoutput>
			</p>
		<!-- end:post-heading --></div>	
		</cfoutput>

		<cfoutput>		
		<div class="post-content">
		#application.blog.renderEntry(body,false,enclosure)#
		
		<!--- STICK IN THE MP3 PLAYER --->
		<cfif enclosure contains "mp3">
			<cfset alternative=replace(getFileFromPath(enclosure),".mp3","") />
			<div class="audioPlayerParent">
				<div id="#alternative#" class="audioPlayer">
				</div>
			</div>
			<script type="text/javascript">
			// <![CDATA[
				var flashvars = {};
				// unique ID
				flashvars.playerID = "#alternative#";
				// load the file
				flashvars.soundFile= "#application.rooturl#/enclosures/#getFileFromPath(enclosure)#";
				// Load width and Height again to fix IE bug
				flashvars.width = "470";
				flashvars.height = "24";
				// Add custom variables
				var params = {};
				params.allowScriptAccess = "sameDomain";
				params.quality = "high";
				params.allowfullscreen = "true";
				params.wmode = "transparent";
				var attributes = false;
				swfobject.embedSWF("#application.rooturl#/includes/audio-player/player.swf", "#alternative#", "470", "24", "8.0.0","/includes/audio-player/expressinstall.swf", flashvars, params, attributes);
			// ]]>
			</script>
		</cfif>

		
		<cfif len(morebody) and url.mode is not "entry">
		<p align="right">
		<a href="#application.blog.makeLink(id)###more">[#rb("more")#]</a>
		</p>
		<cfelseif len(morebody)>
		<span id="more"></span>
		#application.blog.renderEntry(morebody)#
		</cfif>
		<!--  end:post-content --></div>
		</cfoutput>

		<cfoutput>
		<div class="post-footer">
			<ul>
		</cfoutput>
		
		<cfif allowcomments or commentCount neq ""><cfoutput><li class="num-comments"> <a href="#application.blog.makeLink(id)###comments">#rb("comments")# (<cfif commentCount is "">0<cfelse>#commentCount#</cfif>)</a> </li> </cfoutput></cfif>
		<cfif application.trackbacksallowed><cfoutput><li><a href="#application.blog.makeLink(id)###trackbacks">Trackbacks (<cfif trackbackCount is "">0<cfelse>#trackbackCount#</cfif>)</a> </li> </cfoutput></cfif>
		<cfif application.isColdFusionMX7><cfoutput><li class="print"><a href="#application.rooturl#/print.cfm?id=#id#" rel="nofollow">#rb("print")#</a></li></cfoutput></cfif>
		<cfoutput><li class="email"><a href="#application.rooturl#/send.cfm?id=#id#" rel="nofollow">#rb("send")#</a></li></cfoutput>
		<cfif len(enclosure)><cfoutput><li class="enclosure"><a href="#application.rooturl#/enclosures/#urlEncodedFormat(getFileFromPath(enclosure))#">#rb("download")#</a></li></cfoutput></cfif>
		<cfoutput>
    		<li><img src="#application.rooturl#/images/icon_delicious.gif" align="middle" title="del.ico.us" height="11" width="11"> <a href="http://del.icio.us/post?url=#application.blog.makeLink(id)#&title=#URLEncodedFormat("#application.blog.getProperty('blogTitle')#:#title#")#">del.icio.us</a></li>
			<li><img src="#application.rooturl#/images/digg.gif" align="middle" title="Digg It!" height="14" width="16"> <a href="http://digg.com/submit?phase=2&url=#application.blog.makeLink(id)#&title=#URLEncodedFormat("#title#")#&topic=">Digg It!</a></li>
<!--- 	    	<li><img src="#application.rooturl#/images/technorati.gif" align="middle" title="#rb("linkingblogs")#" height="16" width="16"> <a href="http://www.technorati.com/search/#application.blog.makeLink(id)#">#rb("linkingblogs")#</a> </li>
		    <li>#views# #rb("views")#</li>    --->
		   </ul>
		<!-- end:post-footer --></div>
		</cfoutput>

		<!--- Things to do if showing one entry --->						
		<cfif articles.recordCount is 1>
		
			<cfset qRelatedBlogEntries = application.blog.getRelatedBlogEntries(entryId=id,bDislayFutureLinks=true) />	

			<cfif qRelatedBlogEntries.recordCount>
				<cfoutput>
				<div id="relatedentries">
				<p>
				<div class="relatedentriesHeader">#rb("relatedblogentries")#</div>
				</p>
			
  				<ul id="relatedEntriesList">
				<cfloop query="qRelatedBlogEntries">
				<li><a href="#application.blog.makeLink(entryId=qRelatedBlogEntries.id)#">#qRelatedBlogEntries.title#</a> (#application.localeUtils.dateLocaleFormat(posted)#)</li>
				</cfloop>			
		  		</ul>
		  		<!-- end:relatedentries --></div>
		  		</cfoutput>
			</cfif>

			<cfif application.trackbacksallowed>
				<cfset trackbacks = application.blog.getTrackBacks(id)>	
				<cfoutput>	
				<div id="trackbacks">
				<div class="trackbackHeader">TrackBacks</div>
				</cfoutput>
				
				<cfif trackbacks.recordCount>
		
					<cfoutput>		
					<div class="trackbackBody addTrackbackLink">
					[<a href="javaScript:launchTrackback('#id#')">#application.resourceBundle.getResource("addtrackback")#</a>]
					</div>				
					</cfoutput>
					
					<cfoutput query="trackbacks">
						<div class="trackback<cfif currentRow mod 2>Alt</cfif>">
						<div class="trackbackBody">
						<a href="#postURL#" target="_new" rel="nofollow" class="tbLink">#title#</a><br>
						#paragraphFormat2(excerpt)#
						</div>
						<div class="trackbackByLine">#application.resourceBundle.getResource("trackedby")# #blogname# | #application.resourceBundle.getResource("trackedon")# #application.localeUtils.dateLocaleFormat(created,"short")# #application.localeUtils.timeLocaleFormat(created)#</div>
						</div>
					</cfoutput>			
				<cfelse>
					<cfoutput><div class="body">#application.resourceBundle.getResource("notrackbacks")#</div></cfoutput>
				</cfif>
				
				<cfoutput>
				<p>
				<div class="body">
				#application.resourceBundle.getResource("trackbackurl")#<br>
				#application.rooturl#/trackback.cfm?#id#
				<!-- end:body --></div>
				</p>
				<div class="trackbackBody addTrackbackLink">
					[<a href="javaScript:launchTrackback('#id#')">#application.resourceBundle.getResource("addtrackback")#</a>]
				<!-- end:trackbackBody  --></div>
				<!-- end:trackbacks--></div>
				</cfoutput>				
			</cfif>

			<cfif application.usetweetbacks>

				<cfoutput>	
				<div id="tweetbacks">
				<div class="tweetbackHeader">TweetBacks</div>
				<div id="tbContent">
				</cfoutput>

				<cfoutput>
				<!-- end:tbContent -->	</div>
				<!-- end:tweetbacks --></div>
				</cfoutput>				

			</cfif>

			<cfset comments = application.blog.getComments(id)>

			<cfoutput>
			<div id="comments">
				<div class="list">
					<h3>#comments.recordcount# Responses to &ldquo;#title#&rdquo;  <cfif application.commentmoderation>(#rb("moderation")#)</cfif></h3>
			</cfoutput>
			
			<cfset comments = application.blog.getComments(id)>
			<cfif comments.recordCount>

				<cfif allowComments>
					<cfoutput>
					<div class="trackbackBody addCommentLink">
					<!--- [<a href="javaScript:launchComment('#id#')">#rb("addcomment")#</a>] --->
					[<a href="javaScript:launchCommentSub('#id#')">#rb("addsub")#</a>]

					</div>
					</cfoutput>
				</cfif>
				<cfoutput><ol id="comment-list"></cfoutput>
				
				<cfset entryid = id>
	<!---  --->			<cfoutput query="comments">
					<li id="comment-#id#">
						<div class="list-header">
							<cfif application.gravatarsAllowed><small class="gravatar"><img src="http://www.gravatar.com/avatar/#lcase(hash(email))#?s=40&r=pg&d=#application.rooturl#/images/gravatar.gif" alt="#name#'s Gravatar" border="0"/></small></cfif>
							<p class="list-user"><strong><cfif len(comments.website)><a href="#comments.website#" rel="nofollow">#name#</a><cfelse>#name#</cfif></strong><br />
							<a href="##comment-#id#" title="">#application.localeUtils.dateLocaleFormat(posted,"LONG")# at #application.localeUtils.timeLocaleFormat(posted)#</a> </p>							
							<div class="list-comment"> #paragraphFormat2(replaceLinks(comment))#<!-- end:list-comment --></div>
						<!-- end:list-header --></div>
					</li>	
				</cfoutput>
				
				<cfoutput></ol></cfoutput>
				<cfif allowComments>
					<cfoutput>
					<div class="trackbackBody addCommentLink">
					<!--- [<a href="javaScript:launchComment('#id#')">#rb("addcomment")#</a>] --->
					<!-- end:trackbackBody addCommentLink --></div>
					</cfoutput>
				</cfif>
								
			<cfelseif not allowcomments>
				<cfoutput><div class="body">#rb("commentsnotallowed")#<!-- end:body --></div></cfoutput>
			<cfelse>
				<cfoutput>
				<div class="trackbackBody addCommentLink">
				<p style="text-align:left">#rb("nocomments")#</p>				
				<!--- [<a href="javaScript:launchComment('#id#')">#rb("addcomment")#</a>] --->
				[<a href="javaScript:launchCommentSub('#id#')">#rb("addsub")#</a>]				
				<!-- end:trackbackBody --></div>
				</cfoutput>
			</cfif>

			<cfoutput>
			<!-- end:list --></div>
			
			
			<cfinclude template="addcomment.cfm" />

			<!-- end:comments --></div>			
			</cfoutput>

		</cfif>

		<!--- this div ends the entry div --->
		<cfoutput>
		<!-- end:post --></div>
		</cfoutput>
		
	</cfloop>
	
	<cfif articles.recordCount is 0>
	
		<cfoutput><div class="body">#rb("sorry")#</div></cfoutput>
		<cfoutput>
		<div class="body">
		<cfif url.mode is "">
			#rb("noentries")#
		<cfelse>
			#rb("noentriesforcriteria")#
		</cfif>
		<!-- end:body --></div>
		</cfoutput>
		
	<cfelseif articleData.totalEntries gte url.startRow + application.maxEntries>
		
		<!--- get path if not /index.cfm --->
		<cfset path = rereplace(cgi.path_info, "(.*?)/index.cfm", "")>
		
		<!--- clean out startrow from query string --->
		<cfset qs = cgi.query_string>
		<!--- handle: http://www.coldfusionjedi.com/forums/messages.cfm?threadid=4DF1ED1F-19B9-E658-9D12DBFBCA680CC6 --->
		<cfset qs = reReplace(qs, "<.*?>", "", "all")>
		<cfset qs = reReplace(qs, "[\<\>]", "", "all")>

		<cfset qs = reReplaceNoCase(qs, "&*startrow=[0-9]+", "")>
		<cfset qs = qs & "&startRow=" & (url.startRow + application.maxEntries)>
		<cfif isDefined("form.search") and len(trim(form.search)) and not structKeyExists(url, "search")>
			<cfset qs = qs & "&search=#htmlEditFormat(form.search)#">
		</cfif>

		<cfoutput>
		<p align="right">
		<a href="#application.rooturl#/index.cfm#path#?#qs#">#rb("moreentries")#</a>
		</p>
		</cfoutput>
	</cfif>

</cfmodule>
</cfmodule>

<cfsetting enablecfoutputonly=false>	
