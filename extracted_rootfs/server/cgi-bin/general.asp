<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><% getWlanExist("stat"); %> Network Camera</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style1 {color: #339900}
.style2 {color: #0048c0}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	background: url("images/bg.gif");
}
.style6 {
	color: #6699ff;
	background-color: FAFAF4;
}
.style7 {font-size: 12px}
.style8 {
	background-color: E5E5e5;
}
-->
</style>
<script language="JavaScript" type="text/javascript" src="itemname.js"></script>
<script language="JavaScript" type="text/javascript" src="msg.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("event_config_1",item_name[_EVENT_CONFIGURATION]);
	setContent("gen_setting",item_name[_GEN_SETTING]);
	setContent("general_1",item_name[_GENERAL]);
	setContent("subfolder",item_name[_SUBFOLDER]);
	setContent("snap_prefix",item_name[_SNAP_PREFIX]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}	

function send(){
	var o = document.form1;
	if( (o.prefix.value!="") &&(alphanumCheck(o.prefix)==false) )	return;

	document.form1.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_config_1" name="event_config_1"></span>&nbsp;&raquo;&nbsp;<span id="gen_setting" name="gen_setting"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="general.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="general_1" name="general_1"> </span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="subfolder" name="subfolder"></span>:</td>
        <td class="bggrey"><input name="prefix" type="text" id="prefix" value="<% getEventPrefix(); %>" size="10" maxlength="10">
        <br><span id="snap_prefix" name="snap_prefix"></span></td>
      </tr>
    </table>
    <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td class="bggrey2"><input type="button" id="Button" name="Button" value="" class="ButtonSmall" onClick="send()">
    <input type="button" name="Button1" id="Button1" value="" class="ButtonSmall" onClick="reloadScreen('general.asp');"></td>
      </tr>
    </table>
	<br>
    </form>
  	</td>
</tr>
</table>
</body>
</html>
