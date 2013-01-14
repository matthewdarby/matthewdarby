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
		<out>
			<string name="#attributes.dateFieldID#" />
		</out>
	</io>
</fusedoc>
--->
<cfif thisTag.ExecutionMode is 'start'>
	<cfparam name="attributes.dateFieldID" type="string" />
	<cfparam name="attributes.dateValue" type="string" />
	<cfparam name="attributes.formName"	type="string" />
	<cfoutput>
		<input type="text" name="#attributes.dateFieldID#" id="#attributes.dateFieldID#" class="dateField" value="#DateFormat(attributes.dateValue, 'yyyy-mm-dd')#" />
		<a href="javascript:void(0)" class="noStyle" onclick="if(self.gfPop)gfPop.fPopCalendar(document.#attributes.formName#.#attributes.dateFieldID#);return false;" HIDEFOCUS><img class="PopcalTrigger" align="absmiddle" src="/views/Framework/js/Calendar/calbtn.gif" width="34" height="22" border="0" alt=""></a>
	</cfoutput>

</cfif>