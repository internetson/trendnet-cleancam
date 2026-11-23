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
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("sys_info",item_name[_SYS_INFO]);
	setContent("device_information",item_name[_DEV_INFORMATION]);
	setContent("basic_1",item_name[_BASIC]);
	setContent("cam_name",item_name[_CAM_NAME]);
	setContent("location_1",item_name[_LOCATION]);
	setContent("fw_ver",item_name[_FW_VER]);
	setContent("video_n_audio",item_name[_VIDEO]);
	setContent("mjpeg_resol",item_name[_MJP_RESOL]);
	setContent("network_1",item_name[_NETWORK]);
	setContent("ip_mode",item_name[_IP_MODE]);
	setContent("ip_addr",item_name[_IP_ADDR]);
	setContent("subnet_mask",item_name[_SUBNET_MASK]);
	setContent("default_gw",item_name[_DEFAULT_GW]);
	setContent("mac_addr",item_name[_MAC_ADDR]);
	setContent("pri_dns",item_name[_PRI_DNS_ADDR]);
	setContent("sec_dns",item_name[_SEC_DNS_ADDR]);
	setContent("upnp_enable",item_name[_UPNP_ENABLE]);
	setContent("http_port",item_name[_HTTP_PORT]);
	setContent("wireless",item_name[_WIRELESS]);
	setContent("essid",item_name[_ESSID]);
	setContent("connection",item_name[_CONNECTION]);
	setContent("channel",item_name[_CHANNEL]);
	setContent("auth",item_name[_AUTH]);
	setContent("encry",item_name[_ENCRYPTION]);
}

function init(){
	if(document.form1.enable.value != "checked")
	{
			document.getElementById("wlantbl").style.display = "none";
			return;
	}
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="sys_info" name="sys_info"></span>&nbsp;&raquo;&nbsp;<span id="device_information" name="device_information"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="system.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="basic_1" name="basic_1"> </span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="cam_name" name="cam_name"></span>:</td>
        <td class="bggrey"><% getCamName(); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="location_1" name="location_1"></span>: </td>
        <td class="bggrey"><% getLocation(); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="fw_ver" name="fw_ver"></span>: </td>
        <td class="bggrey"><% getfwversion(); %> build: <% getfwbuild(); %></td>
      </tr>
      <tr>
        <td colspan="2" class="greybluebg"><span id="video_n_audio" name="video_n_audio"> </span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="mjpeg_resol" name="mjpeg_resol"></span>:</td>
        <td class="bggrey"><% getresolution1("stat"); %></td>
      </tr>
      <tr>
        <td colspan="2" class="greybluebg"><span id="network_1" name="network_1"> </span></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="ip_mode" name="ip_mode"></span>: </td>
        <td class="bggrey"><% getIpType("stat"); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="ip_addr" name="ip_addr"></span>: </td>
        <td class="bggrey"><% getdevip(); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="subnet_mask" name="subnet_mask"></span>: </td>
        <td class="bggrey"><% getdevmask(); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="default_gw" name="default_gw"></span>: </td>
        <td class="bggrey"><% getdevgw(); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="mac_addr" name="mac_addr"></span>: </td>
        <td class="bggrey"><% getdevmac(); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="pri_dns" name="pri_dns"></span>: </td>
        <td class="bggrey"><% getDns1("stat"); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="sec_dns" name="sec_dns"></span>: </td>
        <td class="bggrey"><% getDns2("stat"); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="upnp_enable" name="upnp_enable"></span> : </td>
        <td class="bggrey"><% getUpnpEnable("stat"); %></td>
      </tr>
      <tr>
        <td class="bgblue"><span id="http_port" name="http_port"></span>: </td>
        <td class="bggrey"><% getWebPort(); %></td>
      </tr>
      </table>
    <div id="wlantbl">
    <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr style="display:<% getWlanExist(); %>">
        <td colspan="2" class="greybluebg"><span id="wireless" name="wireless"> </span></td>
      </tr>
      <tr style="display:<% getWlanExist(); %>">
        <td class="bgblue"><span id="essid" name="essid"></span>: </td>
        <td class="bggrey"><% getWlanEssid("1"); %></td>
      </tr>
      <tr style="display:<% getWlanExist(); %>">
        <td class="bgblue"><span id="connection" name="connection"></span>: </td>
        <td class="bggrey"><% getWlanConnmode("stat"); %></td>
      </tr>
      <tr style="display:<% getWlanExist(); %>">
        <td class="bgblue"><span id="channel" name="channel"></span>: </td>
        <td class="bggrey"><% getWlanConnChannel(); %></td>
      </tr>
      <tr style="display:<% getWlanExist(); %>">
        <td class="bgblue"><span id="auth" name="auth"></span>: </td>
        <td class="bggrey"><% getWlanAuth("stat"); %></td>
      </tr>
      <tr style="display:<% getWlanExist(); %>">
        <td class="bgblue"><span id="encry" name="encry"></span>: </td>
        <td class="bggrey"><% getWlanSecurity("stat"); %></td>
      </tr>
    </table>
    </div>
    <input name="enable" type="hidden" id="enable" value="<% getWlanEnable("1"); %>">
  </form>
  <br>
  </td>
</tr>
</table>
<script language="javascript" type="text/javascript">init();</script>
</body>
</html>
