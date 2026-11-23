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
<script language="JavaScript" type="text/javascript" src="goSetHeight.js"></script>
<script language="javascript">
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("sys_tool",item_name[_SYS_TOOLS]);
	setContent("tools_1",item_name[_TOOLS]);
	setContent("fact_reset",item_name[_FACT_RESET]);
	setContent("restore_setting",item_name[_RESTOR_SET]);
	setContent("sys_reboot",item_name[_SYS_REBOOT]);
	setContent("sys_rebooted",item_name[_SYS_REBOOTED]);
	setContent("configuration",item_name[_CONFIGURATION]);
	setContent("backup_1",item_name[_BACKUP_TIP]);
	setContent("restore_1",item_name[_RESTORE_TIP]);
	setContent("update_fw",item_name[_UPDATE_FW]);
	setContent("current_fw_ver",item_name[_CURRENT_FW_VER]);
	setContent("select_fw",item_name[_SELECT_FW]);

	document.getElementById("reset").value=item_name[_reset];
	document.getElementById("reboot").value=item_name[_REBOOT];
	document.getElementById("backup").value=item_name[_GET_BACKUP_FILE];
	document.getElementById("restore").value=item_name[_RESTORE];
	document.getElementById("update").value=item_name[_UPDATE];
}

var rf=0;
var uf=0;
function res(){
	var obj = document.formrestore;
//	if(obj.cfgfile.value == "")
	//{
		//alert("Please select a file first");		
		//return false;
//	}	

	if(rf == 0)
		obj.submit();
	rf++;	
}

function disup(){

	var obj = document.formreset;
	obj.reset.disabled = true;
	obj = document.formreboot;
	obj.reboot.disabled = true;
	obj = document.formbackup;
	obj.backup.disabled = true;

	obj = document.formrestore;	
	obj.restore.disabled = true;
	obj.cfgfile.disabled = true;
	obj = document.formup;
	obj.update.disabled = true;
	obj.file.disabled = true;	

}
function up(){
	var obj = document.formup;
	if(obj.file.value == "")
	{
		alert(popup_msg[popup_msg_49]);		
		return false;
	}
	if(uf == 0)
		obj.submit();
	disup();
	uf++;		
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="sys_tool" name="sys_tool"></span>&nbsp;&raquo;&nbsp;<span id="tools_1" name="tools_1"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="fact_reset" name="fact_reset"> </span></td>
      </tr>
      <tr>
      	<td class="bggrey">
			<table width="100%" border="0" cellspacing="1" cellpadding="3">
			<tr>
        		<td class="bggrey"><span id="restore_setting" name="restore_setting"></span></td>
      		</tr>
			  <tr><form action="reset.cgi" method="get" name="formreset">
		        <td><input type="submit" id="reset" name="reset" value="">                
		            <input type="hidden" name="type" value="0" /></td>
		      </tr></form>
			</table>
           </td>
        </tr>
    </table>
    <br>
    <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="sys_reboot" name="sys_reboot"> </span></td>
      </tr>
      <tr>
      	<td class="bggrey">
			<table width="100%" border="0" cellspacing="1" cellpadding="3">
			<tr>
        		<td class="bggrey"><span id="sys_rebooted" name="sys_rebooted"></span></td>
      		</tr>
	      	<tr><form action="reboot.cgi" method="get" name="formreboot">
	         <td><input name="reboot" type="submit" id="reboot" value="">
	          <input type="hidden" name="type" value="0" /></td>
	      </tr></form>
      	</table>
          </td>
      </tr>
    </table>
    <br>
    <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="configuration" name="configuration"> </span></td>
      </tr>
      	<tr>
      	<td class="bggrey">
			<table width="100%" border="0" cellspacing="1" cellpadding="3">
			<tr>
        		<td class="bggrey"><span id="backup_1" name="backup_1"></span></td>
      		</tr>
		      <tr>
		        <td><form action="backup.cgi" method="get" name="formbackup">
		          <input type="submit" id="backup" name="backup" value="">
		        </form>
		        </span></td>
		      </tr>
	      </table>
          </td>
      </tr>
      <tr>
      	<td class="bggrey">
			<table width="100%" border="0" cellspacing="1" cellpadding="3">
				<tr>
	        		<td class="bggrey"><span id="restore_1" name="restore_1"></span></td>
	      		</tr>
		      <tr><form action="restore.cgi" method="post"  enctype="multipart/form-data" name="formrestore">
		        <td><input name="cfgfile" type="file" id="cfgfile">
		        <input type="button" id="restore" name="restore" value="" onClick="res();">
		          </span></td>
		      </form>
		      </tr>
	      </table>
          </td>
      </tr>
    </table>
    <br>
    <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="update_fw" name="update_fw"> </span></td>
      </tr>
      <tr>
		<td class="bggrey"><b><span id="current_fw_ver" name="current_fw_ver"></span>: <span class="style7"><% getfwversion(); %> build:<% getfwbuild(); %></span></b></td>
	  </tr>
      <tr>
      	<td class="bggrey">
			<table width="100%" border="0" cellspacing="1" cellpadding="3">
			  <tr>
                <td><span id="select_fw" name="select_fw"></span>: </td>
              </tr>
		      <tr><form action="updatefree.cgi" method="post" enctype="multipart/form-data" name="formup" id="formup">
		        <td><input name="file" type="file" id="file" >
		        <input type="button" id="update" name="update" value="" onClick="up();"></td>
		        </form>
		      </tr>
	      </table>
          </td>
      </tr>
    </table>
    <br>
    </td>
</tr>
</table>
</body>
</html>
