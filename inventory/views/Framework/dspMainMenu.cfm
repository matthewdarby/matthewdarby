<!---
<fusedoc fuse="dspMainMenu.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I am the Main Menu for the site
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<string name="mySelf"  />
				<string name="xfa.device" />
				<string name="xfa.media" />
			</structure>
		</in>
	</io>
</fusedoc>
--->
<cfset mySelf = event.getArg( 'mySelf' ) />
<cfset xfa.device = event.getArg('xfa.device') />
<cfset xfa.media = event.getArg('xfa.media') />

<cfoutput>
<ul>
	<li><a href="http://localhost">Public Site</a></li>
	<li><a href="#mySelf##xfa.device#">Devices</a></li>
	<li><a href="#mySelf##xfa.media#">Media</a></li>
	<li><a href="index.cfm">Home</a></li>
</ul>
</cfoutput>
