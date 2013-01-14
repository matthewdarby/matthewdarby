<cfsetting enablecfoutputonly=true>
<cfprocessingdirective pageencoding="utf-8">
<!---
   Name : pages.cfm
   Author : William Haun (based on archives.cfm by Raymond Camden) (mods by Hatton)
   Created : August 19, 2006
   Last Updated :
   History :
--->

<cfset pages_qry = application.page.getPages() />

   
<cfmodule template="../../tags/podlayout.cfm" title="Friends">
<cfoutput>	
	<ul>
		<li><a href="http://pastorharrisblog.blogspot.com/" title="Willie Harris">Willie Harris</a></li>
		<li><a href="http://www.qasimrasheed.com/" title="Qasim Rasheed">Qasim Rasheed</a></li>
		<li><a href="http://www.briankotek.com/blog/" title="Brian Kotek">Brian Kotek</a></li>
		<li><a href="http://mikebritton.com/" title="Mike Britton">Mike Britton</a></li>
                <li><a href="http://thecrumb.com"  title="Jim Priest">Jim Priest</a></li>
                <li><a href="http://nodans.com" title="Dan Wilson">Dan Wilson</a></li>
	</ul>
</cfoutput>      
</cfmodule>
      
<cfsetting enablecfoutputonly=false />