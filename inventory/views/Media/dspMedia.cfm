<!---
<fusedoc fuse="dspDevice.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display all the information relating to a media
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="05/19/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event" >
				<structure name="event">
					<structure name="mediaTO">			
						<string name="name" />
						<string name="type" />
						<string name="ASIN" />
						<string name="UPC" />
						<string name="picture" />
						<string name="is_loaned" />
						<string name="loaned_to" />
						<string name="date_loaned" />
						<string name="date_created" />
						<string name="date_updated" />
						<string name="module" />						
						<string name="key" />
					</structure>
					<structure name="storeTO">
						<string name="is_gift" />
						<string name="has_receipt" />
						<string name="date_purchased" />
						<string name="store_purchased" />
						<string name="price" />
						<string name="unit_price" />
						<string name="warranty_price" />
						<string name="coupon_amt" />
						<string name="gift_card" />
						<string name="date_warranty" />
						<string name="warranty_info" />
						<string name="parent_key" />
						<string name="key" />
						<string name="parent_key" />
						<string name="parent_module" />						
					</structure>
				</structure>
			</sturcture>
		</in>
		<out>
			<structure="content">
				<string name="pageTitle" />
			</structure>
		</out>
	</io>
</fusedoc>
--->
<cfset variables.data = event.getArg("mediaTO") />
<cfset store = event.getArg("storeTO") />
<cfset pageName = data.name />
<cfset event.setArg('content.pageTitle', pageName) />
<cfoutput>
<div id="dspMedia">
	<table border="0" width="100%" summary="Device Information">
		<tr>
			<td >
			     <img src="#data.picture#"  height="50%" width="50%" border="0"/>
			</td>
			<td>
				<div class="row">
				   <span class="datalabel">Name:</span> 
				   <span class="data">#data.name#</span>
				</div>
				<div class="row">
				   <span class="datalabel">Type:</span>
				   <span class="data">#data.type#</span>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfif data.is_loaned eq 1>	
				   <span class="datalabel">This has been loaned out to #data.loaned_to# on #DateForamt(data.date_loaned, "short")#</span>
				<cfelse>
				   <span class="datalabel">This is not loaned out.</span>
				</cfif>					
			</td>
		</tr>
	</table>
	<cfif IsStruct(store)>
	<table border="0" width="100%" summary="Price Information">
		<tr>
			<td><strong>Store Purchased From:</strong>
				<span class="data">#store.store_purchased#</span>
			</td>
			<td></td>
		</tr>
		<tr>
			<td><strong>Purchase Date:</strong>
				<span class="data">#DateFormat(store.date_purchased, "full")#</span>
			</td>
			<td><strong>Purchased By:</strong>
				<span class="data">#store.purchased_by#</span>
			</td>
		</tr>
		<tr>
			<td><strong>Have the Receipt?</strong>
				<span class="data"><cfif store.has_receipt>Yes<cfelse>No</cfif></span>
			</td>
			<td><strong>Was This a Gift?</strong>
				<span class="data"><cfif store.is_gift>Yes<cfelse>No</cfif></span>
			</td>
		</tr>		
		<tr>
			<td><strong>Price Paid:</strong>
				<span class="data">$#store.price#</span>
			</td>
			<td><strong>Unit Price:</strong>
				<span class="data">$#store.unit_price#</span>
			</td>
		</tr>
		<tr>
			<td><strong>Gift Card Amount:</strong>
				<span class="data">$#store.gift_card#</span>
			</td>
			<td><strong>Coupon Amount:</strong>
				<span class="data">$#store.coupon_amt#</span>
			</td>
		</tr>		
		<tr>
			<td><strong>Warranty Price:</strong>
				<span class="data">$#store.warranty_price#</span>
			</td>
			<td><strong>Warranty Date</strong>
				<span  class="data">#DateFormat(store.date_warranty, "full")#</span>
			</td>
		</tr>
		<tr>
			<td colspan="2"><strong>Warranty Information:</strong>
							<span class="data">#store.warranty_info#</span>
			</td>
		</tr>
	</table>
	</cfif>
</div>	
</cfoutput>
