<!---
<fusedoc fuse="dspDeviceSearch.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display the device search form
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<string name="xfa.submit" />
				<string name="mySelf" />
				<string name="searchTxt" />
			</structure>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="form">
				<string name="searchTxt" />
				<string name="action" />
			</structure>
		</out>
		<passthrough>
			<structure name="event" scope="MachII.framework.Event">
				<string name="xfa.process" />
			</structure>
		</passthrough>
	</io>
</fusedoc>
--->

<cfset event.setArg('content.pageTitle', 'Find Devices') />
<cfset mySelf = event.getArg("mySelf") />
<cfset searchTxt = event.getArg('searchTxt') />
<cfset xfa.submit = event.getArg('xfa.submit') />
<cfoutput>
<div id="dspDeviceSearch">	
	<form action="#mySelf##xfa.submit#" method="post">
		<fieldset id="searchDevice">
			<label for="searchTxt">Enter Device Info:</label>
			<input type="text" name="searchTxt" id="searchTxt" class="textField" value="#searchTxt#"/>
			<input name="action" type="submit" value="Find" />			
		</fieldset>
	</form>
</div>
</cfoutput>
