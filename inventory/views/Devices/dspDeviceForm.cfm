<!---
<fusedoc fuse="dspDeviceForm.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display all the information relating to a device
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event" >
				<structure name="TO">			
					<string name="name" />
					<string name="type" />
					<string name="manufacturer" />
					<string name="model" />
					<string name="serial" />
					<string name="picture" />
					<string name="additional_info" />
					<string name="module" />
					<string name="date_created" />
					<string name="date_updated" />
					<string name="key" />
				</structure>
				<string name="mySelf" />
				<string name="action" />
				<string name="xfa.process" />
				<string name="xfa.prev" />
				<boolean name="hasOptions" />
				<structure name="viewItems" />
			</sturcture>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="form">			
				<string name="action" />
				<string name="name" />
				<string name="type" />
				<string name="manufacturer" />
				<string name="model" />
				<string name="serial" />
				<string name="picture" />
				<string name="moreInfo" />
				<string name="key" />
				<string name="module" />
				<string name="date_created" />
				<string name="date_updated" />
				<string name="hasOptions" />				
			</structure>
		</out>
	</io>
</fusedoc>
--->

<cfset pageName = event.getArg('action', '') & ' Device' />
<cfset xfa.prev = event.getArg("xfa.prev") />
<cfset mySelf = event.getArg("mySelf") />
<cfset action = event.getArg('action') />
<cfset hasOptions = event.getArg('hasOptions') />
<cfset xfa.process = event.getArg('xfa.process') />
<cfset deviceTO = event.getArg("TO") />
<cfset viewItems = event.getArg("viewItems") />
<cfset deleteMessage = "Matt are you sure you really want to delete this device?" />
<cfset event.setArg('content.pageTitle', pageName) />
<cfimport prefix="ui" taglib="/customtags" />
<cfoutput>
<div id="dspDeviceForm">	
	<form id="deviceForm" action="#mySelf##xfa.process#" method="post">
		<fieldset class="internal">
		<legend><a class="collaspe">Device Info +/-</a></legend>
			<div>
				<div class="row">
					<label for="name"><ui:dspRequired />Name:</label>
					<input type="text" name="name" class="textField" value="#deviceTO.name#"/>
				</div>	
	 			<div class="row">
					<label for="type"><ui:dspRequired />Type:</label>
	 				<ui:dspSelectList qry="#viewItems.DEVICE_TYPE#" selectName="type" valueToMatch="#deviceTO.type#" columnToMatch="short_desc" columnToShow="long_desc"/>					
				</div> 
				<div class="row">
					<label for="manufacturer">Manufacturer:</label>
					<input type="text" name="manufacturer" class="textField" value="#deviceTO.manufacturer#" />
				</div>
				<div class="row">
					<label for="model">Model: </label>
					<input type="text" name="model" class="textField" value="#deviceTO.model#"/>
				</div>
				<div class="row">
					<label for="serial">Serial Number: </label>
					<input type="text" name="serial" class="textField" value="#deviceTO.serial#" />
				</div>
				<div class="row">
					<label for="picture">Picture Location:</label>
					<input type="text" name="picture" class="textField" value="#deviceTO.picture#" />
				</div>	
			</div>	
		</fieldset>
		<fieldset class="internal">
		<legend >Additional Info</legend>	
			<textarea name="additional_info" class="internal">#deviceTO.additional_info#</textarea>
		</fieldset>
		<input type="hidden" name="key" value="#deviceTO.key#" />
		<input type="hidden" name="module" value="#deviceTO.module#" />
		<input type="hidden" name="date_created" value="#deviceTO.date_created#" />
		<input type="hidden" name="date_updated" value="#deviceTO.date_updated#" />
		<input type="hidden" name="hasOptions" value="#hasOptions#" />

		<input name="action" type="submit" value="#action#" />
		<input type="reset" value="Reset" />
		<input name="action" type="button" value="Cancel" class="linkbutton" link='#mySelf##xfa.prev#' />
	<cfif action is 'Update'>
		<input name="action" type="submit" value="Delete"  class="deletebutton" message="#deleteMessage#"/>
	</cfif>
	</form>
</div>	
</cfoutput>