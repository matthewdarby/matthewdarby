<cfsilent>
<!---
<fusedoc fuse="dspMediaForm.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display all the information relating to a media
	</responsibilities>
	<properties>
		<history author="Matt Darby"  date="05/03/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event" >
				<structure name="TO" />
				<string name="message" />
				<string name="action" />
				<string name="hasOptions" />
				<string name="mySelf" />
				<string name="xfa.process" />
				<string name="xfa.prev" />
				<structure name="appConstants" />
				<structure name="set" />
				<recordset name="displayData" />
				<structure name="viewItems" />
				<string name="type">
			</sturcture>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="form">			
				<string name="name" />
				<string name="type" />
				<string name="manufacturer" />
				<string name="model" />
				<string name="serial" />
				<string name="picture" />
				<string name="moreInfo" />
				<string name="key" />
				<string name="action" />
			</structure>
		</out>
	</io>
</fusedoc>
--->
<cfset mySelf = event.getArg("mySelf") />
<cfset data = event.getArg("TO") />
<cfset constants = event.getArg('appConstants') />
<cfset viewItems = event.getArg("viewItems") />
<cfset displayData = event.getArg('displayData') />
<cfset action = event.getArg('action') />
<cfset hasOptions = event.getArg('hasOptions') />
<cfset xfa.process = event.getArg('xfa.process') />
<cfset xfa.prev = event.getArg('xfa.prev') />
<cfset columnToMatch = event.getArg('matchType') />
<cfset amazonValues = event.getArg('set') />
<cfset isAmazonCommunication = IsStruct(amazonValues) />
<cfset deleteMessage = "Matt are you sure you really want to delete this medium?" />
<cfset pageName = action & ' Medium'>
<cfset event.setArg('content.pageTitle', pageName) />
<cfset event.removeArg('type') />

<cfimport prefix="ui" taglib="/customtags" />
</cfsilent>
<cfoutput>	
<div id="dspMediaForm">		
	<form id="mediaForm" name="mediaForm" action="#mySelf##xfa.process#" method="post">
		<fieldset class="internal">
		<legend>General Media Info</legend>
			<div class="row">
				<label for="type"><ui:dspRequired />Type:</label>
				<cfif hasOptions or isAmazonCommunication>
	  				<ui:dspGetTranslatedValue qryValue="#viewItems.media_type#" valueToMatch="#data.type#" valueToShow="long_desc" columnToMatch="#columnToMatch#" inputName="type" isFormElement="true" />
	  			<cfelse>	  				
	  				<ui:dspSelectList qry="#viewItems.media_type#" selectName="type" valueToMatch="#data.type#" columnToMatch="#columnToMatch#" columnToShow="long_desc"/>				 	  				
	  			</cfif>
			</div>			
			<div class="row">
				<label for="title"><ui:dspRequired /> Name:</label>
				<input type="text" name="name" class="textField" value="#data.name#"/>
			</div>			
			<div class="row">
				<label for="picture">Picture: </label>
				<input type="text" name="picture" class="textField" value="#data.picture#" />
			</div>	
			<div class="row">
				<label for="asin">ASIN: </label>
 				<input type="text" name="asin" class="textField" value="#data.asin#" /> 
			</div>
			<div class="row">
				<label for="upc">UPC: </label>
				<input type="text" name="upc" class="textField" value="#data.upc#" />
			</div>		
			<div class="row">
				<label for="is_loaned"><ui:dspRequired /> Was this Purchased?</label>
				Yes <input type="radio" name="is_legal" class="radio" value="1" <cfif data.is_legal >checked</cfif> />
				No <input type="radio" name="is_legal" class="radio" value="0" <cfif not data.is_legal >checked</cfif> />
			</div>								
		</fieldset>
		
		<fieldset class="internal">
		<legend>Check-Out Info</legend>	
			<div class="row">
				<label for="is_loaned"><ui:dspRequired /> Has this been Loaned?</label>
				Yes <input type="radio" name="is_loaned" class="radio" value="1" <cfif data.is_loaned  >checked</cfif> />
				No <input type="radio" name="is_loaned" class="radio" value="0" <cfif not data.is_loaned  >checked</cfif> />
			</div>
			<div class="row">
				<label for="loaned_to">Who was this loaned to?</label>
				<input type="text" name="loaned_to" class="textField" value="#data.loaned_to#" />
			</div>
			<div class="row">
				<label for="date_loaned">Date Loaned</label>
				<ui:dspDateFormButton dateFieldID="date_loaned" dateValue="#data.date_loaned#" formName="mediaForm" />
			</div>
		</fieldset>
		<cfif IsStruct(displayData) and isAmazonCommunication>
 		<ui:dspSetForm parent_key="#data.key#"
					   qrySet="#displayData.qrySetItems#" 
					   action="#action#"
					   referenceList="#displayData.lookup#"	
					   setValues="#amazonValues#"
					   formName="mediaForm"/>
		<cfelseif IsStruct(displayData) and not isAmazonCommunication>
 		<ui:dspSetForm parent_key="#data.key#"
					   qrySet="#displayData.qrySetItems#" 
					   action="#action#"
					   referenceList="#displayData.lookup#"
					   formName="mediaForm"/>		
		</cfif>
		
	
		<input type="hidden" name="key" value="#data.key#" />
		<input type="hidden" name="module" value="#data.module#" />
		<input type="hidden" name="date_created" value="#data.date_created#" />
		<input type="hidden" name="date_updated" value="#data.date_updated#" />
		<input type="hidden" name="hasOptions" value="#hasOptions#" />
		<input type="hidden" name="matchType" value="#columnToMatch#" />
		
		<input name="action" type="submit" value="#action#" />
		<input type="reset" value="Reset" />
		<input name="action" type="button" value="Cancel" class="linkbutton" link='#mySelf##xfa.prev#' />		
		<cfif CompareNoCase(action, 'Update') eq 0><input name="action" type="submit" value="Delete"  class="deletebutton" message="#deleteMessage#" /></cfif>
	</form>
</div>	
</cfoutput>
