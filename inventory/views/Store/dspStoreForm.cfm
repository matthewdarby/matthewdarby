<!---
<fusedoc fuse="dspDevice.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display all the information relating to price information
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="04/26/2006" comments="Initial Version" />
		<history author="Matt Darby" date="05/03/2006" comments="Added Calendar object" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event" >
				<structure name="TO" />
				<structure name="inventoryTO" />
				<string name="action" />
				<string name="parent_key" />
				<string name="parent_module" />
				<string name="xfa.process" />
				<string name="xfa.prev" />
				<string name="xfa.form" />
				<string name="mySelf" />
				<boolean name="hasOptions" />
			</sturcture>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="form">			
				<string name="store_purchased" />
				<string name="purchased_by" />
				<string name="purchase_date" />
				<boolean name="has_receipt" />
				<boolean name="is_gift" />
				<string name="price" />
				<string name="unit_price" />
				<string name="coupon_amt" />
				<string name="gift_card" />
				<string name="warranty_price" />
				<string name="warranty_date" />
				<string name="warranty_info" />
				<string name="parent_key" />
				<string name="parent_module" />
				<string name="module" />				
				<string name="key" />
			</structure>
		</out>
	</io>
</fusedoc>
--->
<cfset storeTO = event.getArg("TO") />
<cfset inventoryTO = event.getArg('inventoryTO') />
<cfset parent_key = event.getArg('parent_key') />
<cfset parent_module = event.getArg('parent_module') />
<cfset action = event.getArg('action') />
<cfset deleteMessage = "Matt are you sure you really want to delete the store info?">
<cfset pageName = action & ' Store Information for ' & inventoryTO.name /> 
<cfset event.setArg('content.pageTitle', pageName) /> 
<cfset xfa.process = event.getArg('xfa.process') />
<cfset xfa.prev = event.getArg('xfa.prev') />
<cfset xfa.form = event.getArg('xfa.form') />
<cfset mySelf = event.getArg('mySelf') />
<cfset hasOptions = event.getArg('hasOptions') />
<cfimport prefix="ui" taglib="/customtags" />

<cfoutput>
<div id="dspStoreForm">	
	<form name="storeForm" id="storeForm" action="#mySelf##xfa.process#" method="post">
		<fieldset class="internal">
		<legend >Object Info</legend>	
			<div class="row">
				<label for="storePurchased"><ui:dspRequired /> Store Purchased From:</label>
				<input type="text" name="store_purchased" value="#storeTO.store_purchased#" class="textField" />
			</div>
			<div class="row">
				<label for="purchased_by"><ui:dspRequired /> Purchased By:</label>
				<input type="text" name="purchased_by" value="#storeTO.purchased_by#" class="textField" />
			</div>
			<div class="row">
				<label for="purchase_date"><ui:dspRequired /> Date Purchased:</label>
				<ui:dspDateFormButton dateFieldID="date_purchased" dateValue="#storeTO.date_purchased#" formName="storeForm" />				
			</div>
			<div class="row">
				<label for="hasReceipt"><ui:dspRequired /> Have Receipt?:</label>
				Yes <input type="radio" name="has_receipt" value="1" <cfif storeTO.has_receipt is "1"> checked</cfif> /> &nbsp;
				No <input type="radio" name="has_receipt" value="0" <cfif storeTO.has_receipt is "0"> checked</cfif>/>
			</div>
			<div class="row">
				<label for="isGift"><ui:dspRequired /> Was this a Gift?:</label>
				Yes <input type="radio" name="is_gift" value="1" <cfif storeTO.is_gift is "1"> checked</cfif>/> &nbsp;
				No <input type="radio" name="is_gift" value="0" <cfif storeTO.is_gift is "0"> checked</cfif>/>
			</div>
		</fieldset>
		<fieldset class="internal">
		<legend>Price Info</legend>
			<div class="row">
				<label for="price">Price:</label>
				<input type="text" name="price" value="#storeTO.price#" class="textField" />
			</div>
			<div class="row">
				<label for="unit_price">Unit Price:</label>
				<input type="text" name="unit_price" value="#storeTO.unit_price#" class="textField" />
			</div>
			<div class="row">
				<label for="coupon_amt">Coupon Amount:</label>
				<input type="text" name="coupon_amt" value="#storeTO.coupon_amt#" class="textField" />
			</div>
			<div class="row">
				<label for="gift_card">Gift Card Amount:</label>
				<input type="text" name="gift_card" value="#storeTO.gift_card#" class="textField" />
			</div>
			<div class="row">
				<label for="warranty_price">Warranty Price:</label>
				<input type="text" name="warranty_price" value="#storeTO.warranty_price#" class="textField" />
			</div>
			<div class="row">
				<label for="date_warranty">End of Warranty Date:</label>
				<ui:dspDateFormButton dateFieldID="date_warrant" dateValue="#storeTO.date_warranty#" formName="storeForm" />				
			</div>
		</fieldset>
		<fieldset class="internal">
		<legend >Warranty Information</legend>
			<textarea name="warranty_info" class="internal">#storeTO.warranty_info#</textarea>
		</fieldset>
		
		<input type="hidden" name="key" value="#storeTO.key#" />
		<input type="hidden" name="parent_key" value="#inventoryTO.key#" />
		<input type="hidden" name="parent_module" value="#inventoryTO.module#" />
		<input type="hidden" name="module" value="#storeTO.module#" />
		<input type="hidden" name="hasOptions" value="#hasOptions#">
		<input type="hidden" name="date_created" value="#storeTO.date_created#" />
		<input type="hidden" name="date_updated" value="#storeTO.date_updated#" />
		<input type="hidden" name="xfa.form" value="#xfa.form#" />
		<input type="hidden" name="xfa.prev" value="#xfa.prev#" />
	
		<input name="action" type="submit" value="#action#" />

		<input type="reset" value="Reset" />
		<input name="action" type="button" value="Cancel" class="linkbutton" link="#mySelf##xfa.prev#" />
	<cfif CompareNoCase(action,'Update') eq 0>
		<input name="action" type="submit" value="Delete"  class="deletebutton" message="#deleteMessage#"/>
	</cfif>		
	</form>
</div>
</cfoutput>
