<cfsetting enablecfoutputonly="true"/>
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
	</io>
</fusedoc>
--->
<cfif thisTag.ExecutionMode is 'start'>
<cfsilent>
	<cfparam name="attributes.desc" type="string" />
	<cfparam name="attributes.item_value" type="string" default="" />
	<cfparam name="attributes.item_code" type="string" />
	<cfparam name="attributes.item_id" type="string" />
	<cfparam name="attributes.is_required" type="boolean" />
	<cfparam name="attributes.display_type" type="string" />
	<cfparam name="attributes.key" type="string" />
	<cfparam name="attributes.formName" type="string" />
	<cfparam name="attributes.referenceList" type="struct" default="#structNew()#" />
	<cfparam name="attributes.setForm" type="string" default="" />
	<cfparam name="attributes.columnToMatch" type="string" default="code" />
	<cfparam name="attributes.data_type" type="string" default="TXT" />
	

	<cfimport prefix="ui" taglib="/customtags" />		
	<cfset item_id = attributes.item_id />
</cfsilent>
	<cfoutput>
	<input name="#item_id#_key" id="#item_id#_key" type="hidden" value="#attributes.key#" />
	<input name="#item_id#_dataType" id="#item_id#_dataType" type="hidden" value="#attributes.data_type#" />
	<label for="#item_id#_value"><cfif attributes.is_required><ui:dspRequired /></cfif> #attributes.desc#:</label>	
	<cfswitch expression="#attributes.display_type#">
		<cfcase value="TA">
			<textarea name="#item_id#_value" id="#item_id#_value">#attributes.item_value#</textarea>
		</cfcase>
		<cfcase value="SL">
			<ui:dspSelectList qry="#attributes.referenceList['qry' & attributes.item_code]#" 
							  selectName="#item_id#_value" 
							  valueToMatch="#attributes.item_value#" 
							  columnToMatch="#attributes.columnToMatch#" 
							  columnToShow="long_desc" />
		</cfcase>
		<cfcase value="IT">
			<input name="#item_id#_value" id="#item_id#_value" type="text" value="#attributes.item_value#" />
		</cfcase>
		<cfcase value="DA">
			<ui:dspDateFormButton dateFieldID="#item_id#_value" dateValue="#attributes.item_value#" formName="#attributes.formName#" />			
		</cfcase>
		<cfdefaultcase>
			<span class="datalabel">#attributes.item_value#</span>
			<input name="#item_id#_value" id="#item_id#_value" type="hidden" value="#attributes.item_value#" />
		</cfdefaultcase>
	</cfswitch>
	</cfoutput>	
</cfif>
<cfsetting enablecfoutputonly="false"/>