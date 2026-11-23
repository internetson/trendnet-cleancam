function errorRedirect(code){
	window.status="error code="+code;
	window.location="/error.htm";
}

function alertAndSelect(obj,str){
	alert(str);
	obj.select();
}


function isNUM(obj){
	if(isNaN(obj.value)==true)
	  {  alertAndSelect(obj,"IP check - not a legal number: "+ obj.value)
             return false;
	  }
	return true;
	
}
function inRange(obj){
	if (range(obj.value,0,255)==false)
	{   alertAndSelect(obj,"IP check - ip exceeds range: " + obj.value);
	     return false;
	}
	return true;
}

function isFilled(obj){
	if(trimHTblank(obj.value)=="")
	{	alertAndSelect(obj,"IP check - ip field can't be blank");
		return false;
	}
	return true
}

function isPosInt(num){
	re = /^\d+$/;
	if (!re.test(num)) 
		return false;
	return true;
}

function trimHTblank(s){
 // Remove leading spaces 

  while (s.substring(0,1) == ' ') 
  {
    s = s.substring(1,s.length);
  }

  // Remove trailing spaces

  while (s.substring(s.length-1,s.length) == ' ') 
  {
    s = s.substring(0,s.length-1);
  }
  return s;

}



function ipCheck(a,b,c,d){
	if(!isNUM(a))	return -1;
	if(!isNUM(b))	return -1;
	if(!isNUM(c))   return -1;
	if(!isNUM(d)) 	return -1;
	if(!inRange(a))	return -2;
	if(!inRange(b))	return -2;
	if(!inRange(c))	return -2;
	if(!inRange(d))	return -2;
	if(((trimHTblank(a.value)=="")&&(trimHTblank(b.value)=="")&&(trimHTblank(c.value)=="")&&(trimHTblank(d.value)==""))==false)
	{
	 
	 if(!isFilled(a))return -3;	
	 if(!isFilled(b))return -3;
	 if(!isFilled(c))return -3;
	 if(!isFilled(d))return -3;
	}
	return true;
}

function dateCheck(obj){

	obj.value=trimHTblank(obj.value);
	a=obj.value.split("-");
	if(( isPosInt(a[0]) && isPosInt(a[1]) && isPosInt(a[2]) ) == false)
	{	alertAndSelect(obj,"illegal date input");
		return false;
	}
	if(range(a[0],1970,2037)==false)
	{	alertAndSelect(obj,"year exceeds range (1970-2037)");
		return false;
	}
	
	if(isValidDate(a[2],a[1],a[0])==false)
	{	alertAndSelect(obj, "\'" +obj.value+ "\' is not a correct date");
		return false;
	}	
	obj.value=a[0]+"-"+addzero(trimzero(a[1]))+"-"+addzero(trimzero(a[2]));
	return true;
}

function isValidDate(day,month,year){
var dteDate;
dteDate=new Date(year,month-1,day);
 return(	(day==dteDate.getDate()) && ((month-1)==dteDate.getMonth()) && (year==dteDate.getFullYear()))
  
}

function addzero(num){
	if(num<=9)
	  return "0"+num 
	else
	  return num
}



function timeCheck(obj){

	obj.value=trimHTblank(obj.value);
	a=obj.value.split(":");
	if(( isPosInt(a[0]) && isPosInt(a[1]) && isPosInt(a[2]) ) == false)
	{	
		alertAndSelect(obj,"illegal time input");
		return false;
	}

	if(range(a[0],0,23)==false)
	{	alertAndSelect(obj,"hour exceeds range");
		return false;
	}
	if(range(a[1],0,59)==false)
	{	alertAndSelect(obj,"minute exceeds range");
		return false;
	}
	if(range(a[2],0,59)==false)
	{	alertAndSelect(obj,"second exceeds range");
		return false;
	}
	obj.value=addzero(trimzero(a[0]))+":"+addzero(trimzero(a[1]))+":"+addzero(trimzero(a[2]));


	return true;
}

function timeCheck2(obj1,obj2,obj3){

	if((isPosInt(obj1.value)&&range(obj1.value,0,23))==false)
	{	alertAndSelect(obj1,"hour not valid");
		return false;
	}
	if((isPosInt(obj2.value)&&range(obj2.value,0,59))==false)
	{	alertAndSelect(obj2,"minute not valid");
		return false;
	}
	if((isPosInt(obj3.value)&&range(obj3.value,0,59))==false)
	{	alertAndSelect(obj3,"second not valid");
		return false;
	}
	return true;
}
function emailCheck(obj){
	//var filter="^[\\w-_\.]*[\\w-_\.]\@[\\w]\.+[\\w]+[\\w]$";
	var filter=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
	if ((filter.test(obj.value)==false) && (obj.value!=""))
	{
		alertAndSelect(obj,"email not valid");
		return false;
	}
	return true;
	
}

function domainCheck(obj){
	
	var filter=/((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
	//var filterip=/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ 
	if ((filter.test(obj.value)==false) && (obj.value!="") && (isValidIP(obj.value)==false))
	{
		alertAndSelect(obj,"domain not valid");
		return false;
	}
	return true;

}

function hostnameCheck(obj){
	if(isValidString(obj.value,"\\~!@#$%^&*()=+/|{}[]<>,:;`\'\"?.")==false)
	{
		alertAndSelect(obj,"camera name can only contains '-','_',[a-z],[A-Z],[0-9]");
		return false;
	}
	if(isValidString(obj.value," ")==false)
	{
		alertAndSelect(obj,"camera name cannot contains space");
		return false;
	}

	if(isPosInt(obj.value))
	{
		alertAndSelect(obj,"camera name cannot be a number");
		return false;
	}
	return true;

}

//obj:  the obj to be checked
//bit:  64bit ==0 , 128bit ==1
//enc:  Ascii ==0 ,   Hex == 1
function wepCheck(obj,bit,enc){
	var filter ;
	var validLength;
	if((bit == 0)&&(enc == 0))
		validLength = 5
	else if((bit == 0)&&(enc == 1))
		validLength = 10
	else if((bit == 1)&&(enc == 0))
		validLength = 13
	else if((bit == 1)&&(enc == 1))
		validLength = 26

	if(enc==0)
		filter = /^[a-zA-Z0-9]+$/;
	else if(enc==1)
		filter = /^[a-fA-F0-9]+$/;

	if(obj.value.length != validLength)
	{
		alertAndSelect(obj,"this key should be " + validLength+" characters long");
		return false;
	}

	if(enc==1)
	{	if(filter.test(obj.value)==false)
		{
			alertAndSelect(obj,"hex key should only contain [a-f],[A-f],[0-9]");
			return false;
		}
	}
	else if(enc==0)
	{
		if(asciiCheck(obj.value)==false)
		{
			alertAndSelect(obj,"ascii key should not contain double-byte character");
			return false;
		}
	}
	
	return true;
	
}

function asciiCheck(value){
     var i;
     for (i=0; i<value.length; i++) {
        if (value.charCodeAt(i)>127) 
            return false;
     }
     return true;
}
function hexCheck(value){
}

function essidCheck(obj){
	if(asciiCheck(obj.value)==false)
	{
		alertAndSelect(obj,"essid cannot contain double-byte character");
		return false;
	}
	return true;
	
}

function textCheck(obj){
	if(isValidString(obj.value,"\"") == false)
	{
		alertAndSelect(obj,"can't contain symbol \" ");
		return false;
	}
	return true

}

function pathCheck(obj){
	if(isValidString(obj.value,"\\")==false)
	{
		alertAndSelect(obj,"path should use slash \'/\'");
		return false;
	}
	return true;
}

function userCheck(obj){
	if(isValidString(obj.value," ")==false)
	{
		alertAndSelect(obj,"user should not contain space");
		return false;
	}
	return true;

}

function isValidIP(str) {
   var re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
   if (re.test(str)) {
      var parts = str.split(".");
      if (parseInt(parseFloat(parts[0])) == 0) { return false; }
      for (var i=0; i<parts.length; i++) {
         if (parseInt(parseFloat(parts[i])) > 255) { return false; }
      }
      return true;
   } else {
      return false;
   }
}


function intervalCheck(obj,minint,maxint){
	re = /^\d+$/;
	if (isPosInt(obj.value)==false) {
		alertAndSelect(obj,"\'"+ obj.value + '\' is NOT an positive integer!');
		return false;
	}
	if(range(obj.value,minint,maxint)==false){
	alertAndSelect(obj, "\'" + obj.value + '\' exceeds range  [ '+ minint + '-' + maxint + ']');
		return false;
	}
	return true;
	
}


function filenameCheck(obj){
	if((isValidString(obj.value,"\\/:*?\"<>|") )==false)
	{
		alertAndSelect(obj,"\'"+ obj.value + '\' is NOT a valid name!' +"(contains   \\:/*?\"<>|)");
		return false;
	}
	return true;
}


function isContainsInvalid(oriStr,InvalidChars)
{

   var IsValid=false;
   var Char;

 
   for (i = 0; i < oriStr.length && IsValid == true; i++) 
      { 
      Char = oriStr.charAt(i); 
      if (InvalidChars.indexOf(Char) != -1) 
         {
         IsValid = true;
         }
      }
   return IsValid;
   
}


function isValidString(oriStr,InvalidChars)
{

   var IsValid=true;
   var Char;

 
   for (i = 0; i < oriStr.length && IsValid == true; i++) 
      { 
      Char = oriStr.charAt(i); 
      if (InvalidChars.indexOf(Char) != -1) 
         {
         IsValid = false;
         }
      }
   return IsValid;
   
}





function parstIntTrimZero(strobj){
	i=0;
	var str = new String(strobj);
	while ((str.substring(i,i+1)=="0")&&(i<str.length-1))
	     i++;
	return parseInt(str.substring(i,str.length))
	
}

function range(value,min,max){
	return ((value<min)||(value>max))?false:true;
}

function addzero(num){
	if(num<=9)
	  return "0"+num 
	else
	  return num
}

function trimzero(strobj){
	i=0;
	var str = new String(strobj);
	while ((str.substring(i,i+1)=="0")&&(i<str.length-1))
	     i++;
	return str.substring(i,str.length)
}

function addTrailSlash(s){
	if(s.substring(s.length-1,s.length) != "\\")
		s=s+"\\";
	return s
}

function getRadioCheckedIndex(radioObject){
	var value=0;
	for (i=0;i<radioObject.length;i++){
		if (radioObject[i].checked)
		   return i
	}
}

function setRadioByArray(radioObject,inputArray,inputString){
	for(i=0;i<inputArray.length;i++)
	  if(inputString==inputArray[i])
	  	{radioObject[i].checked=true
	  	break
	  	}
}


function getArrayIndex(radioObject,inputArray,inputString){
	for(i=0;i<inputArray.length;i++)
	  if(inputString==inputArray[i])
		return i;
	return 0;
}

function parstIntTrimZero(strobj){
        i=0;
        var str = new String(strobj);
        while ((str.substring(i,i+1)=="0")&&(i<str.length-1))
             i++;
        return parseInt(str.substring(i,str.length))

}

