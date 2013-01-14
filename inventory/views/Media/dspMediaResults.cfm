<!---
<fusedoc fuse="dspMediaResults.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display the results from the search
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="05/03/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<recordset name="resultList" />
				<string name="xfa.doEdit" />
				<string name="xfa.doView" />
				<string name="mySelf" />
			</structure>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="url">
				<string name="key" />			
				<string name="action" />
				<string name="module" />
			</structure>
		</out>
		<passthrough>
			<structure name="event" scope="MachII.framework.Event" >
				<string name="type" />
				<string name="name" />
				<string name="xfa.submit" />
				<string name="viewItems" />
				<string name="matchType" />
			</structure>		
		</passthrough>
	</io>
</fusedoc>
--->
<cfset variables.results = event.getArg("resultList") />
<cfset mySelf = event.getArg("mySelf") />
<cfset xfa.doEdit = event.getArg('xfa.doEdit') />
<cfset xfa.doView = event.getArg('xfa,doView') />
<cfset pageName = 'Media Search Results'  />
<cfset event.setArg('content.pageTitle', pageName) />
<cfoutput>
<div id="dspMediaResults">
	<hr />	
<cfif variables.results.recordcount gt 0>	
	<table width="100%" cellspacing="2" cellpadding="2" summary="I am the results list from the search">
		<colgroup>
			<col id="PictureCol" />
			<col id="NameCol" />
			<col id="GenreCol" />
			<col id="BindingCol" />
			<col id="i1Col" />
			<col id="i2Col" />
			<col id="EditCol" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col" id="PictureHead"></th>
				<th scope="col">Name</th>	
				<th scope="col">Genre</th>
				<th scope="col">Binding</th>
				<th scope="col">i1</th>
				<th scope="col">i2</th>			
				<th scope="col"></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="variables.results">
			<tr class="row#currentrow mod 2#">
				<td><cfif Len(picture) gt 0><img src="#picture#" border="0"/></cfif></td>
				<td>#name#</td>			
				<td>#genre#</td>
				<td>#binding#</td>
				<td>#i1#</td>
				<td>#i2#</td>
				<td align="center">
					<input name="action" type="submit" value="Edit" class="linkbutton" link="#mySelf##xfa.doEdit#&parent_key=#key#&parent_module=#module#" /> &nbsp;
<!--- 					<input name="action" type="submit" value="View" class="linkbutton" link="#mySelf##xfa.doView#&parent_key=#key#&parent_module=#module#" /> &nbsp; --->
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