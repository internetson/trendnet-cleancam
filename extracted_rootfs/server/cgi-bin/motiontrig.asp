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
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("event_config_1",item_name[_EVENT_CONFIGURATION]);
	setContent("motion_trig_1",item_name[_MOTION_DET_TRIG]);
	setContent("motion_trig_2",item_name[_MOTION_DET_TRIG]);
	setContent("please_set",item_name[_PLEASE_SET]);
	setContent("enable_1",item_name[_ENABLE]);
	setContent("sch_profile_1",item_name[_SCHEDULE_PROF]);
	setContent("action",item_name[_ACTION]);
	setContent("http_notify",item_name[_HTTP_NOTIFY]);
	setContent("send_email",item_name[_SEND_EMAIL]);
	setContent("ftp_upload",item_name[_FTP_UPLOAD]);

	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="event_config_1" name="event_config_1"></span>&nbsp;&raquo;&nbsp;<span id="motion_trig_1" name="motion_trig_1"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="motiontrig.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="motion_trig_2" name="motion_trig_2"> </span><br><span id="please_set" name="please_set"></span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="enable_1" name="enable_1"></span></td>
        <td class="bggrey"><input name="enable" type="checkbox" id="enable" value="1" <% getMotionEnable("1"); %> ></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="sch_profile_1" name="sch_profile_1"></span>:</td>
        <td class="bggrey"><select name="profile" id="profile">
          <% getMotionSche(); %>
        </select></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="action" name="action"></span>:</td>
        <td class="bggrey" width="80%">
			<table width="100%" border="0" cellspacing="1" cellpadding="2">
					<tr>
		        <td><input name="http" type="checkbox" id="http" value="1" <% getMotionHttp("1"); %>>
                <span id="http_notify" name="http_notify"></span></td>
		      </tr>
		      <tr>
		        <td><input name="email" type="checkbox" id="email" value="1" <% getMotionEmail("1"); %>>
                <span id="send_email" name="send_mail"></span></td>
		      </tr>
		      <tr>
		        <td><input name="ftp" type="checkbox" id="ftp" value="1"  <% getMotionFtp("1"); %>>
                <span id="ftp_upload" name="ftp_upload"></span></td>
		      </tr>
		    </table>
		   </td>
		</tr>
    </table>
    <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td class="bggrey2"><input type="submit" id="Button" name="Button" value="" class="ButtonSmall">
    <input type="button" name="Button1" id="Button1" value="" class="ButtonSmall" onClick="reloadScreen('motiontrig.asp');"></td>
      </tr>
    </table>
	<br>
    </form>
  	</td>
</tr>
</table>
</body>
</html>
