<!---
<fusedoc fuse="dspDeviceResults.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display the results from the search
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<string name="mySelf" />
				<string name="xfa.doEdit" />
				<string name="xfa.doView" />
				<recordset name="listedDevices" />
			</structure>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="form">
				<string name="parent_key" />			
				<string name="action" />
				<string name="parent_module" />
			</structure>
		</out>
	</io>
</fusedoc>
--->
<cfset variables.results = event.getArg("listedDevices") />
<cfset mySelf = event.getArg( 'mySelf' ) />
<cfset pageName = 'Device Search Results' />
<cfset xfa.doEdit = event.getArg('xfa.doEdit') />
<cfset xfa.doView = event.getArg('xfa.doview') />
<cfset event.setArg('content.pageTitle', pageName) />
<cfoutput>
<div id="dspDeviceResults">
<hr />	
<cfif variables.results.recordcount gt 0>	
	<table width="100%" cellspacing="2" cellpadding="2" summary="I am the results list from the search">
		<thead>
			<tr>
				<th width="15%">Type</th>
				<th width="50%">Name</th>
				<th width="15%">Manufacturer</th>
				<th width="20%"></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="variables.results">
			<tr class="row#currentrow mod 2#">
				<td>#type#</td>
				<td>#name#</td>
				<td>#manufacturer#</td>
				<td align="center">
					<input name="action" type="submit" value="Edit" class="linkbutton" link="#mySelf##xfa.doEdit#&parent_key=#key#&parent_module=#module#&action=Edit" /> &nbsp;
					<input name="action" type="submit" value="View" class="linkbutton" link="#mySelf##xfa.doView#&parent_key=#key#&parent_module=#module#&action=View" /> &nbsp;										
				</td>
			</tr>	
			</cfloop>
		</tbody>
	</table>
<cfelse>
	<p>There were no results based on your search</p>
</cfif>
</div>
</cfoutput>