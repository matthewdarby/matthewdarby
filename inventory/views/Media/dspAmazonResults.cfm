<!---
<fusedoc fuse="dspAmazonResults.cfm" specification="2.0" language="ColdFusion">
	<responsibilities>
		I display all the information relating to a media
	</responsibilities>
	<properties>
		<history author="Matt Darby"  date="09/02/2006" comments="Initial Version" />
	</properties>
	<io>
		<in>
			<structure name="event" scope="MachII.framework.Event" >		
				<structure name="productInfo" />
				<string name="xfa.process" />
				<string name="category" />
				<string name="mySelf" />
			</structure>
		</in>
		<out>
			<structure name="content">
				<string name="pageTitle" />
			</structure>
			<structure name="url">
				<string name="Asin" />
				<string name="type" />
			</structure>		
		</out>
	</io>
</fusedoc>
--->
<cfset pageName = "Amazon.com Search Results">
<cfset event.setArg('content.pageTitle', pageName) />
<cfset productInfo =  event.getArg('productInfo') />
<cfset xfa.process = event.getArg('xfa.process') />
<cfset category = event.getArg('category') />
<cfset mySelf = event.getArg("mySelf") />
<cfoutput>
<div id="dspAmazonResults">
	<hr />	
<cfif IsObject(productInfo)>
	<table width="100%" cellspacing="2" cellpadding="2" summary="I am the results list from the Amazon search">
		<thead>
			<tr>
				<th></th>
				<th >Title</th>	
				<cfif category is not 'video'>			
				<th >
					<cfswitch expression="#category#">
						<cfcase value="books">
							Author
						</cfcase>
						<cfdefaultcase>
							Artist
						</cfdefaultcase>
					</cfswitch>
				</th>
				</cfif>
				<th ></th>
			</tr>
		</thead>
		<tbody>
			<cfloop index="i" from="1" to="#arraylen(productInfo.details)#" step="1" >				
			<tr class="row#i mod 2#">
				<td><img src="#productInfo.details[i].ImageUrlSmall#"></td>
				<td>#productInfo.details[i].ProductName#</td>
				<cfif category is not 'video'>			
				<td>
					<cfswitch expression="#category#">
						<cfcase value="books">
							<cftry>
								<cfloop from="1" to="#arraylen(productInfo.details[i].authors)#" index="z">
									#productInfo.details[i].authors[z]#<br>
								</cfloop>
							<cfcatch>&nbsp;</cfcatch>
							</cftry>
						</cfcase>
						<cfdefaultcase>
							<cftry>#productInfo.details[i].artists[1]#
							<cfcatch >&nbsp;</cfcatch>
							</cftry>
						</cfdefaultcase>
					</cfswitch>					
				</td>
				</cfif>
				<td align="center">
					<input name="action" type="submit" value="Add" class="linkbutton" link="#mySelf##xfa.process#&Asin=#productInfo.details[i].Asin#&type=#category#" />
				</td>
			</tr>	
			</cfloop>
		</tbody>
	</table>
</cfif>
</div>  
</cfoutput>