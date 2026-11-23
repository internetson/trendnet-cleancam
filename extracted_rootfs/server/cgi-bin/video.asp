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
	
	setContent("video_audio_1",item_name[_VIDEO_N_AUDIO]);
	setContent("video_1",item_name[_VIDEO]);
	setContent("mjpeg",item_name[_MJPEG]);
	setContent("video_resol_1",item_name[_V_RESOLUTION]);
	setContent("video_qual_1",item_name[_V_QUALITY]);
	setContent("frame_rate_1",item_name[_FRAME_RATE]);
	setContent("fps_1",item_name[_FPS]);
	
	
	document.getElementById("Button").value=item_name[_APPLY];
	document.getElementById("Button1").value=item_name[_CANCEL];
}	

function disrate(){
	var obj = document.form1
	obj.framerate1.disabled = obj.framelimit1[0].checked; 

}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="video_audio_1" name="video_audio_1"></span>&nbsp;&raquo;&nbsp;<span id="video_1" name="video_1"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="video.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="mjpeg" name="mjpeg"> </span></td>
      </tr>
      <tr>
        <td width="150" valign="top" class="bgblue"><span id="video_resol_1" name="video_resol_1"></span>: </td>
        <td class="bggrey"><select name="resolution1" id="resolution1">
            <% getresolution1(); %>
          </select>                </td>
      </tr>
      <tr>
        <td width="150" valign="top" class="bgblue"><span id="video_qual_1" name="video_qual_1"></span>: </td>
        <td class="bggrey"><select name="quality1" id="select2">
            <% getquality1(); %>
        </select></td>
      </tr>
      <tr>
        <td width="150" valign="top" class="bgblue"><span id="frame_rate_1" name="frame_rate_1"></span>: </td>
        <td class="bggrey"> 
            <select name="framerate1" id="framerate1">
              <% getframerate1("30"); %>
            </select>
            <input name="framelimit1" type="hidden" value="1">
          <span class="style7" id="fps_1" name="fps_1"></span></td>
      </tr>
    </table>
    <table width="98%" border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td class="bggrey2"><input type="submit" id="Button"name="Button" value="" class="ButtonSmall">
      <input type="button" name="Button1" id="Button1" value="" class="ButtonSmall" onClick="document.location.reload('video.asp');"></td>
      </tr>
    </table>
    </form>
    <br>
  	</td>
</tr>
</table>
<script language="javascript"></script>
</body>
</html>
