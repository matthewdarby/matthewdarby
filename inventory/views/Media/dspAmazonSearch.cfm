<!---
<fusedoc fuse="dspAmazonSearch.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display all the information relating to a media
	</responsibilities>
	<properties>
		<history author="Matt Darby"  date="09/02/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event">
				<string name="mySelf" />
				<string name="viewItems" />
				<string name="matchType" />
				<string name="xfa.submit" />
				<string name="category" />
				<string name="keyword" />
			</structure>			
		</in>
		<out>
			<structure name="form">
				<string name="category" />
				<string name="keyword" />
				<string name="action" />
			</structure>
			<structure name="event">
				<string name="pageTitle" />
			</structure>
		</out>
	</io>
</fusedoc>
--->
<cfset event.setArg('content.pageTitle', 'Amazon Search') />
<cfset mySelf = event.getArg("mySelf") />
<cfset viewItems = event.getArg("viewItems") />
<cfset columnToMatch = event.getArg('matchType') />
<cfset xfa.submit = event.getArg('xfa.submit') />
<cfset category = event.getArg('category') />
<cfset keyword = event.getArg('keyword') />
<cfimport prefix="ui" taglib="/customtags" />
<cfoutput>
<div id="dspMediaSearch">	
	<form action="#mySelf##xfa.submit#" method="post">
		<fieldset id="searchDevice">
			<div class="row">
				<label for="category">Category:</label>
 				 <ui:dspSelectList qry="#viewItems.media_type#" selectName="category" valueToMatch="#category#" valueToSend="#columnToMatch#" columnToMatch="#columnToMatch#" columnToShow="long_desc"/>
			</div>
			<div class="row">
				<label for="keyword">Keyword:</label>
				<input type="text" name="keyword" id="keyword" class="textField" value="#keyword#" />
			</div>		
			<div class="row"  align="center">
				<input name="action" type="submit" value="Find" />			
				<input type="reset" value="Reset" />
			</div>
		</fieldset>
	</form>
</div>
</cfoutput>	
