<!---
<fusedoc fuse="dspDateFormButton.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display a date button
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="09/01/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="attributes">
				<string name="dateFieldID"  />
				<string name="dateValue" />
				<string name="formName" />
			</sturcture>
		</in>
		<out>
			<string name="#attributes.dateFieldID#" />
		</out>
	</io>
</fusedoc>
--->
<cfif thisTag.ExecutionMode is 'start'>
<cfsilent>
	<cfparam name="attributes.set_code" type="string" default="" />
	<cfparam name="attributes.parent_key" type="string" default="" />
	<cfparam name="attributes.qrySet" type="query" />
	<cfparam name="attributes.setForm" type="boolean" default="false" />
	<cfparam name="attributes.formAction" type="string" default="" />
	<cfparam name="attributes.formName" type="string" default="setForm" />
	<cfparam name="attributes.action" type="string" default="Update" />
	<cfparam name="attributes.referenceList" type="struct" default="#StructNew()#" />
	<cfparam name="attributes.setValues" type="struct" default="#StructNew()#" />

	<cfimport prefix="ui" taglib="/customtags" />	
	<cfset setCodes = arraynew(1) />
	<cfset subSetCodes = arraynew(1) />
	<cfset itemCodes = arraynew(1) />
</cfsilent>	

	<cfoutput>
	<cfif attributes.setForm>
		<form name="setForm" id="setForm" action="#attributes.formAction#" method="post">
	</cfif>
	</cfoutput>
	<cfoutput query="attributes.qrySet" group="set_code">
		<cfset ArrayAppend(setCodes, set_code) />
		<cfoutput group="subset_code">
			<cfset ArrayAppend(subSetCodes, subset_code) />
			<fieldset class="internal">
				<legend><a charset="collaspe">#subset_long_desc# +/-</a></legend>
				<div>
					<cfoutput>
						<cfset ArrayAppend(itemCodes, item_code) />
						<cfset valueID = set_code & '_' & subset_code & '_' & item_code />
						<cfif StructKeyExists(attributes.setValues, valueID)>
							<cfset thisValue = attributes.setValues[valueID] />
							<cfset selectListMatch = 'short_desc' />
						<cfelse>
							<cfset thisValue = item_value />	
							<cfset selectListMatch = 'code' />
						</cfif>
						<div class="row">
							<ui:dspItemForm 
								desc="#item_long_desc#"
								item_value="#thisValue#"
								item_id="#valueID#"
								item_code="#item_code#"
								is_required="#is_required#"
								display_type="#display_type#"
								data_type="#data_type#"
								referenceList="#attributes.referenceList#" 
								key="#key#"
								setForm="#attributes.setForm#"
								setValues="#attributes.setValues#"
								columnToMatch="#selectListMatch#" 
								formName="#attributes.formName#" />
						</div>	
					</cfoutput>
				</div>
			</fieldset>
		</cfoutput>
	</cfoutput>
	<cfoutput>
		<input type="hidden" name="set_module" value="#attributes.qrySet.module#" />
		<input type="hidden" name="listOfSetCode" value="#arraytolist( setCodes , '~' )#" />
		<input type="hidden" name="listOfSubSetCode" value="#arraytolist( subSetCodes , '~' )#" />
		<input type="hidden" name="listOfItemCode" value="#arraytolist( itemCodes , '~' )#" />
		<input type="hidden" name="set_parent_key" value="#attributes.parent_key#"  />		
	<cfif attributes.setForm>	
		<input name="action" value="#attributes.action#" type="submit" />
		<input value="Reset" type="reset" />
		</form>
	</cfif>
	</cfoutput>
</cfif>