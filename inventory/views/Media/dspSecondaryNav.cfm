<cfsilent>
<!---
<fusedoc fuse="dspSecondaryNav.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display secondary menu for the media layout
	</responsibilities>
	<properties>
		<history author="Matt Darby" date="09/02/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<structure name="xfa">
					<string name="add" />
					<string name="addAmazon" />
					<string name="find" />
					<string name="all" />				
					<string name="edit" />
					<string name="view" />
					<string name="store" />
				</structure>
				<string name="objectSingular" />
				<string name="objectPlural" />
				<string name="hasOptions" />
				<string name="mySelf" />
				<string name="parent_key" />
				<string name="parent_module" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfset mySelf = event.getArg( 'mySelf' ) />
<cfset xfa.find = event.getArg('xfa.find') />
<cfset xfa.add = event.getArg('xfa.add') />
<cfset xfa.edit = event.getArg('xfa.edit') />
<cfset xfa.addAmazon = event.getArg('xfa.addAmazon') />
<cfset xfa.all = event.getArg('xfa.all') />
<cfset xfa.view = event.getArg('xfa.view') />
<cfset xfa.store = event.getArg('xfa.store') />
<cfset hasOptions = event.getArg('hasOptions') />
<cfset parent_module = event.getArg('parent_module') />
<cfset parent_key = event.getArg('parent_key') />
<cfset objectPlural = event.getArg('objectPlural') />
<cfset objectSingular = event.getArg('objectSingular') />
</cfsilent>

<cfoutput>
<div class="sideBarContent">	
	<h3>#objectSingular#</h3>	
	<ul>
		<li><a href="#mySelf##xfa.find#">Find</a></li>	
		<li><a href="#mySelf##xfa.add#">Add Manually</a></li>		
		<li><a href="#mySelf##xfa.addAmazon#">Add through Amazon</a></li>
		<li><a href="#mySelf##xfa.all#">#objectPlural# List</a></li>	
		<cfif hasOptions>
		<ul>	
			<li><a href="#mySelf##xfa.edit#&parent_key=#parent_key#&parent_module=#parent_module#">Edit</a></li>
<!--- 			<li><a href="#mySelf##xfa.view#&parent_key=#parent_key#&parent_module=#parent_module#">View</a></li> --->
			<li><a href="#mySelf##xfa.store#&parent_key=#parent_key#&parent_module=#parent_module#">Store</a></li>
		</ul>
		</cfif> 
	</ul>
</div>
</cfoutput>
