<cfsilent>
<!---
<fusedoc fuse="dspStatus.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I am display the current status information for the items in media inventory
	</responsibilities>
	<properties>
		<history author="Matt Darby" email="matthew.darby@gmail.com" date="04/16/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event">
				<recordset name="qryStatus" />
			</structure>
		</in>
	</io>
</fusedoc>
--->	
<cfset qryStatus = event.getArg('qryStatus') />	
</cfsilent>
<cfoutput>
<div class="sideBarContent">	
	<h3>Status</h3>
	<p><strong>Video:</strong> #qryStatus.video_count#<br />
	<strong>Music: </strong> #qryStatus.music_count#<br />
	<strong>Books: </strong> #qryStatus.book_count#</p>
</div>	
</cfoutput>