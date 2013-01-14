<cfcomponent>
<cfscript>	
   This.name=rereplace( getdirectoryfrompath( getcurrenttemplatepath() ), "[^\d\w]", "", "All" );
   This.clientmanagement="True";
   This.loginstorage="Session" ;
   This.sessionmanagement="True" ;
   This.sessiontimeout=CreateTimeSpan(0,0,1,0);
</cfscript>
 <cfsetting showdebugoutput="No" enablecfoutputonly="No"> 
</cfcomponent>