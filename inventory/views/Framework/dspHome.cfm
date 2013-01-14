<!---
<fusedoc fuse="dspHome.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I am the Home page for my private site
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<out>
			<structure name="event" scope="MachII.framework.Event">
				<string name="content.pageTitle"  />
			</structure>
		</out>
	</io>
</fusedoc>
--->

<cfset event.setArg("content.pagetitle", "Matt's Internal Site") />
<cfoutput>
<div id="dspHome">
	<p>Choose an option from the Right Menu.  Later this will display some status info
	and other relevant information for Matt.</p>
</div>
</cfoutput>
