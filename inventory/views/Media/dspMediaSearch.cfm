<!---
<fusedoc fuse="dspMediaSearch.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display the media search form
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="05/03/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event" >
				<string name="mySelf" />
				<string name="type" />
				<string name="name" />
				<string name="xfa.submit" />
				<string name="viewItems" />
				<string name="matchType" />
			</structure>
		</in>
		<out>
			<structure="content">
				<string name="pageTitle" />
			</structure>
		</out>
		<passthrough>
			<structure name="event" scope="MachII.framework.Event">
				<recordset name="resultList" />
			</structure>		
		</passthroug>
	</io>
</fusedoc>
--->

<cfset event.setArg('content.pageTitle', 'Find Media') />
<cfset mySelf = event.getArg("mySelf") />
<cfset attributes.type = event.getArg("type") />
<cfset attributes.name = event.getArg("name") />
<Cfset xfa.submit = event.getArg('xfa.submit') />
<cfset viewItems = event.getArg("viewItems") />
<cfset columnToMatch = event.getArg('matchType') />
<cfimport prefix="ui" taglib="/customtags" />

<cfoutput>
<div id="dspMediaSearch"> 
 	<form action="#mySelf##xfa.submit#" method="post"> 
		<fieldset id="searchDevice">
<!--- 			<div class="row">
				<label for="type">Type:</label>
 				 <ui:dspSelectList qry="#viewItems.media_type#" 
		                           selectName="type" 
		                           valueToSend="#columnToMatch#" 
		                           valueToMatch="#attributes.type#" 
		                           columnToMatch="#columnToMatch#" 
		                           columnToShow="long_desc"
		                           class="populate" />
			</div> --->
 			<div class="row">
				<label for="type">Genre:</label>
				<select name="type" id="type" onchange="recursiveSelect_request(this,this.form.binding,'getGenreAndBinding');">
					<option value="" >-- Select option --</option>
					<option value="BOOK">Book  </option>
					<option value="VID">Video  </option>
					<option value="MUSC">Music  </option>	
				</select>
			</div>			
			<div class="row">
				<label for="binding">Binding:</label>
				<select name="binding" id="binding" ></select>								
			</div>	
			<div class="row">
				<label for="name">Name:</label>
				<input type="text" name="name" id="name" class="textField" value="#attributes.name#" />
			</div>		
			<div class="row"  align="center">
				<input name="action" type="submit" value="Find"  />			
				<input type="reset" value="Reset" />
			</div>
		</fieldset>
	</form>
</div>	
</cfoutput>	
