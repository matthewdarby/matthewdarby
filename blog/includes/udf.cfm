<cfscript>
function titleCase(str) {
	return uCase(left(str,1)) & right(str,len(str)-1);
}

/**
* Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
* Update by David Kearns to support '
* SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
* More TLDs
* Version 4 by P Farrel, supports limits on u/h
* Added mobi
* v6 more tlds
*
* @param str      The string to check. (Required)
* @return Returns a boolean.
* @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com)
* @version 6, July 29, 2008
* Note this is different from CFLib as it has the "allow +" support
*/
function isEmail(str) {
return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*(\+['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
}

function isLoggedIn() {
	return structKeyExists(session,"loggedin");
}

/**
 * An &quot;enhanced&quot; version of ParagraphFormat.
 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
 * Rewrite and multiOS support by Nathan Dintenfas.
 * 
 * @param string 	 The string to format. (Required)
 * @return Returns a string. 
 * @author Ben Forta (ben@forta.com) 
 * @version 3, June 26, 2002 
 */
function ParagraphFormat2(str) {
	//first make Windows style into Unix style
	str = replace(str,chr(13)&chr(10),chr(10),"ALL");
	//now make Macintosh style into Unix style
	str = replace(str,chr(13),chr(10),"ALL");
	//now fix tabs
	str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
	//now return the text formatted in HTML
	return replace(str,chr(10),"<br />","ALL");
}

/**
 * A quick way to test if a string is a URL
 * 
 * @param stringToCheck 	 The string to check. 
 * @return Returns a boolean. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, November 22, 2001 
 */
function isURL(stringToCheck){
		return REFindNoCase("^(((https?:|ftp:|gopher:)\/\/))[-[:alnum:]\?%,\.\/&##!@:=\+~_]+[A-Za-z0-9\/]$",stringToCheck) NEQ 0;
}

/**
 * Converts a byte value into kb or mb if over 1,204 bytes.
 * 
 * @param bytes 	 The number of bytes. (Required)
 * @return Returns a string. 
 * @author John Bartlett (jbartlett@strangejourney.net) 
 * @version 1, July 31, 2005 
 */
function KBytes(bytes) {
	var b=0;

	if(arguments.bytes lt 1024) return trim(numberFormat(arguments.bytes,"9,999")) & " bytes";
	
	b=arguments.bytes / 1024;
	
	if (b lt 1024) {
		if(b eq int(b)) return trim(numberFormat(b,"9,999")) & " KB";
		return trim(numberFormat(b,"9,999.9")) & " KB";
	}
	b= b / 1024;
	if (b eq int(b)) return trim(numberFormat(b,"999,999,999")) & " MB";
	return trim(numberFormat(b,"999,999,999.9")) & " MB";
}


/**
* Converts text string of ISO Date to datetime object; useful for parsing RSS and RDF.
*
* @param str      ISO datetime string to parse. (Required)
* @return Returns a date.
* @author James Edmunds (jamesedmunds@jamesedmunds.com)
* @version 1, September 21, 2004
*/
function ISODateToTS(str) {
    return ParseDateTime(ReplaceNoCase(left(str,16),"T"," ","ALL"));
}

/**
 * Returns a relative path from the current template to an absolute file path.
 * 
 * @param abspath 	 Absolute path. (Required)
 * @return Returns a string. 
 * @author Isaac Dealey (info@turnkey.to) 
 * @version 1, May 2, 2003 
 */
function getRelativePath(abspath){ 
	var aHere = listtoarray(expandPath("/"),"\/"); 
	var aThere = ""; var lenThere = 0; 
	var aRel = ArrayNew(1); var x = 0; 
	var newpath = ""; 
	
	aThere = ListToArray(abspath,"\/"); lenThere = arraylen(aThere); 
	
	for (x = 1; x lte arraylen(aHere); x = x + 1) { 
		if (x GT lenThere OR comparenocase(aHere[x],aThere[x])) { 
			ArrayPrepend(aRel,".."); if (x lte lenThere) { ArrayAppend(aRel,aThere[x]); } 
		} 
	}
	
	for (; x lte arraylen(aThere); x = x + 1) { ArrayAppend(aRel,aThere[x]); }
	
	newpath = "/" & ArrayToList(aRel,"/"); 

	return newpath; 
}
Request.getRelativePath = getRelativePath;

/**
* This UDF uses a persons birthdate to output their current age in years.
* 11/30/01 - Optimize code: Sierra Bufe (sierra@brighterfusion.com)
*
* @param birthdate      Valid date object representing a person's birth date.
* @return Returns a numeric value.
* @author Eric Dobris (sierra@brighterfusion.comswooosh2@hotmail.com)
* @version 1, November 30, 2001
*/
function GetCurrentAge(birthdate){
return datediff('yyyy',birthdate,now());
}

/**
* This UDF when passed a time will calculated the numbers of
* seconds, minutes, hours, days, and years passed from the current time
* @param timPosted			DateTime String to calculate difference
* @return Returns a string stating the difference
* @author Matt Darby (matthew.darby@gmail.com)
* @version 1,  July 3, 2008
*/
function getElaspsedTime(timePosted){
	if ( datediff('yyyy',timePosted,now()) eq 1 )
		return datediff('yyyy',timePosted,now()) & ' year';	
	else if ( datediff('yyyy',timePosted,now()) gt 0 )
		return datediff('yyyy',timePosted,now()) & ' years';
	else if ( datediff('d',timePosted,now()) eq 1 )	
		return datediff('d',timePosted,now()) & ' day';					
	else if ( datediff('d',timePosted,now()) gt 0 )	
		return datediff('d',timePosted,now()) & ' days';
	else if (datediff('h',timePosted,now()) eq 1 )
		return datediff('h',timePosted,now()) & ' hour';			
	else if (datediff('h',timePosted,now()) gt 0 )
		return datediff('h',timePosted,now()) & ' hours';
	else if (datediff('n', timePosted,now()) eq 1)
		return datediff('n', timePosted,now()) & ' minute';				
	else if (datediff('n', timePosted,now()) gt 0)
		return datediff('n', timePosted,now()) & ' minutes';
	else 
		return datediff('s', timePosted,now()) & ' seconds';		
}
</cfscript>

<!---
	  This UDF from Steven Erat, http://www.talkingtree.com/blog
--->
<cffunction name="replaceLinks" access="public" output="yes" returntype="string">
    <cfargument name="input" required="Yes" type="string">
	<cfargument name="linkmax" type="numeric" required="false" default="50">
    <cfscript>
        var inputReturn = arguments.input;
        var pattern = "";
        var urlMatches = structNew();
        var inputCopy = arguments.input;
        var result = "";
        var rightStart = "";
        var rightInputCopyLen = "";
        var targetNameMax = "";
        var targetLinkName = "";
        var i = "";
        var match = "";
		
		pattern = "(((https?:|ftp:|gopher:)\/\/)|(www\.|ftp\.))[-[:alnum:]\?%,\.\/&##!;@:=\+~_]+[A-Za-z0-9\/]";
        
        while (len(inputCopy)) {
            result = refind(pattern,inputCopy,1,'true');
            if (result.pos[1]){
                match = mid(inputCopy,result.pos[1],result.len[1]);
                urlMatches[match] = "";
                rightStart = result.len[1] + result.pos[1];
                rightInputCopyLen = len(inputCopy)-rightStart;
                if (rightInputCopyLen GT 0){
                    inputCopy = right(inputCopy,rightInputCopyLen);
                } else break;
            } else break;
        }
        
        //convert back to array
        urlMatches = structKeyArray(urlMatches);

        targetNameMax = arguments.linkmax;
        for (i=1; i LTE arraylen(urlMatches);i=i+1) {
            targetLinkName = urlMatches[i];
            if (len(targetLinkName) GTE targetNameMax) {
                targetLinkName = left(targetLinkName,targetNameMax) & "...";
            }
            inputReturn = replace(inputReturn,urlMatches[i],'<a href="#urlMatches[i]#" target="_blank">#targetLinkName#</a>',"all");
        }
    </cfscript>
    <cfreturn inputReturn>
</cffunction>
