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
<script language="JavaScript" type="text/javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("basic_1",item_name[_BASIC]);
	setContent("system_1",item_name[_SYSTEM]);
	setContent("basic_2",item_name[_BASIC]);
	setContent("cam_name",item_name[_CAM_NAME]);
	setContent("location_1",item_name[_LOCATION]);
	setContent("led",item_name[_INDI_LED]);
	setContent("led_ctl",item_name[_INDI_LED_CTL]);
	setContent("normal",item_name[_NORMAL]);
	setContent("off",item_name[_OFF]);
	setContent("irled",item_name[_IR_LED]);
	setContent("irled_ctl",item_name[_IR_LED_CTL]);
	setContent("irnormal",item_name[_NORMAL]);
	setContent("iroff",item_name[_OFF]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}

function send(){
	var obj = document.form1;
	if(isAscii(obj.camname.value) == false && obj.camname.value.length>16)
	{
		warnAndSelect(obj.camname,popup_msg[popup_msg_68]);
		return;
	}
	if(isAscii(obj.location.value) == false && obj.location.value.length>16)
	{
		warnAndSelect(obj.location,popup_msg[popup_msg_69]);
		return;
	}
	obj.submit();
}

function goSetHeight() {
	if (parent == window) return;
	else{
		parent.setIframeHeight('ifrm');
		parent.setLocation("<% getLocation(); %>");
	}
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="basic_1" name="basic_1"></span>&nbsp;&raquo;&nbsp;</span><span id="system_1" name="system_1"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="system.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="basic_2" name="basic_2"> </span></td>
      </tr>
      <tr>
        <td width="150" class="bgblue"><span id="cam_name" name="cam_name"></span>: </td>
        <td class="bggrey"> <input name="camname" type="text" id="camname" value="<% getCamNameS(); %>" size="32" maxlength="32"></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="location_1" name="location_1"></span>: </td>
        <td class="bggrey"> <input name="location" type="text" id="location" value="<% getLocationS(); %>" size="32" maxlength="32"></td>
      </tr>
      <tr>
        <td colspan="2" class="greybluebg"><span id="led" name="led"> </span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="led_ctl" name="led_ctl"></span>:</td>
        <td class="bggrey"> 
          <input name="led" type="radio" value="2" <% getLed("2"); %>>
          <span id="normal" name="normal"></span>
          <input name="led" type="radio" value="0"  <% getLed("0"); %>>
          <span id="off" name="off"></span></td>
      </tr>
      <tr>
        <td colspan="2" class="greybluebg"><span id="irled" name="irled"> </span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="irled_ctl" name="irled_ctl"></span>:</td>
        <td class="bggrey"> 
          <input name="irled" type="radio" value="1" <% getIRLed("1"); %>>
          <span id="irnormal" name="irnormal"></span>
          <input name="irled" type="radio" value="0"  <% getIRLed("0"); %>>
          <span id="iroff" name="iroff"></span></td>
      </tr>

    </table>
    <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td class="bggrey2"><input type="button" id="Button" name="Button" class="ButtonSmall" value="" onClick="send();">
    	<input type="button" name="Button1" id="Button1" value="" class="ButtonSmall" onClick="reloadScreen('system.asp');"></td>
      </tr>
    </table>
	<br>
    </form>
	</td>
</tr>
</table>
</body>
</html>
