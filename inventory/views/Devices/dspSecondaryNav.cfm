<!---
<fusedoc fuse="dspSecondaryNav.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display secondary menu for the layout
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="05/03/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<structure name="xfa">
					<string name="add" />
					<string name="find" />
					<string name="all" />				
					<string name="edit" />
					<string name="view" />
					<string name="store" />
				</structure>
				<structure name="viewItems">
					<string name="objectSingular" />
					<string name="objectPlural" />
					<string name="hasOptions" />
				</structure>
				<string name="mySelf" />
				<string name="parent_key" />
				<string name="parent_module" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfset mySelf = event.getArg( 'mySelf' ) />
<cfset parent_key = event.getArg('parent_key') />
<cfset parent_module = event.getArg('parent_module') />
<cfset xfa.add = event.getArg('xfa.add') />
<cfset xfa.find = event.getArg('xfa.find') />
<cfset xfa.all = event.getArg('xfa.all') />
<cfset xfa.edit = event.getArg('xfa.edit') />
<cfset xfa.view = event.getArg('xfa.view') />
<cfset xfa.store = event.getArg('xfa.store') />
<cfset objectSingular = event.getArg('objectSingular') />
<cfset hasOptions = event.getArg('hasOptions') />
<cfoutput>
<div class="sideBarContent">	
	<h3>#objectSingular#</h3>	
	<ul>
		<li><a href="#mySelf##xfa.add#">Add</a></li>
		<li><a href="#mySelf##xfa.find#">Find</a></li>	
		<li><a href="#mySelf##xfa.all#">#objectSingular# List</a></li>	
		<cfif hasOptions>
			<li><a href="#mySelf##xfa.edit#&parent_key=#parent_key#&parent_module=#parent_key#">Edit</a></li>
			<li><a href="#mySelf##xfa.view#&parent_key=#parent_key#&parent_module=#parent_key#">View</a></li>
			<li><a href="#mySelf##xfa.store#&parent_key=#parent_key#&parent_module=#parent_key#">Store</a></li>
		</cfif>
	</ul>
</div>
</cfoutput>