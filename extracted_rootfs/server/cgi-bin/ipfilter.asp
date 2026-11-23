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

	setContent("network_2",item_name[_NETWORK]);
	setContent("ip_filter_1",item_name[_IP_FILTER]);
	setContent("ip_filter_2",item_name[_IP_FILTER]);
	setContent("ip_range",item_name[_IP_RANGE]);
	setContent("start_ip",item_name[_START_IP]);
	setContent("end_ip",item_name[_END_IP]);
	setContent("deny_ip",item_name[_DENY_IP_LIST]);

	document.getElementById("add").value=item_name[_ADD];
	document.getElementById("delete").value=item_name[_DELETE];
}	
function dupCheck(st1,st2,st3,st4,ed1,ed2,ed3,ed4,denylist)
{
	var ip = parstIntTrimLeadZero(st1.value)+"." +
	parstIntTrimLeadZero(st2.value)+"." +
	parstIntTrimLeadZero(st3.value)+"." +
	parstIntTrimLeadZero(st4.value)+"~" +
	parstIntTrimLeadZero(ed1.value)+"." +
	parstIntTrimLeadZero(ed2.value)+"." +
	parstIntTrimLeadZero(ed3.value)+"." +
	parstIntTrimLeadZero(ed4.value);

	for(i=0;i<denylist.length;i++)
	{
		if(denylist[i].text == ip)
		{
			warnAndSelect(st1,popup_msg[popup_msg_30]);
			return false;
		}
	}
	return true;
}
function send(s){
	var o = document.form1;
	o.type.value = s;

	if(s=="add")
	{
		if(ipCheck(o.startip1,o.startip2,o.startip3,o.startip4,true)==false)	return;
		if(ipCheck(o.endip1,o.endip2,o.endip3,o.endip4,true)==false)	return;
		if(ipRangeCheck(o.startip1,o.startip2,o.startip3,o.startip4,o.endip1,o.endip2,o.endip3,o.endip4)==false) return;
		if(dupCheck(o.startip1,o.startip2,o.startip3,o.startip4,o.endip1,o.endip2,o.endip3,o.endip4,o.denylist) == false) return
	}
	else if(s=="delete")
	{
		if(confirm(popup_msg[popup_msg_31])==false)	return;
	}
	o.submit();
}
</script>
</head>
<body onLoad="start();goSetHeight();">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" class="tabBigTitle">
<tr>
	<td height="30" valign="bottom" class="headerbg2"><b><font color="#FFFFFF" size="4"><span id="network_2" name="network_2"></span>&nbsp;&raquo;&nbsp;<span id="ip_filter_1" name="ip_filter_1"></span></font></b></td>
</tr>
<tr>
  <td width="100%" height="80" align="center" valign="top">
  <form action="filter.cgi" method="post" name="form1">
  <table width="98%"  border="0" cellpadding="3" cellspacing="1" bgcolor="#333333" class="box_tn">
      <tr>
        <td colspan="2" class="greybluebg"><span id="ip_filter_2" name="ip_filter_2"> </span></td>
      </tr>
      <tr>
      	<td width="150" valign="top" class="bgblue"><span id="ip_range" name="ip_range"></span>: </td>
      	<td class="bggrey">
		<table width="100%" border="0" cellspacing="1" cellpadding="3">
		  <tr>
	        <td width="10%"><span id="start_ip" name="start_ip"></span>: </td>
	        <td width="90%"><input name="startip1" type="text" class="box_ip" id="startip1" size="3" maxlength="3">
	          .
	          <input name="startip2" type="text" class="box_ip" id="startip2" size="3" maxlength="3">
	          .
				  <input name="startip3" type="text" class="box_ip" id="startip3" size="3" maxlength="3">
	          .
				<input name="startip4" type="text" class="box_ip" id="startip4" size="3" maxlength="3"></td>
	        </tr>
	      <tr>
	        <td><span id="end_ip" name="end_ip"></span>: </td>
	        <td nowrap><input name="endip1" type="text" class="box_ip" id="endip1" size="3" maxlength="3">
	          .
	          <input name="endip2" type="text" class="box_ip" id="endip2" size="3" maxlength="3">
	          .
	          <input name="endip3" type="text" class="box_ip" id="endip3" size="3" maxlength="3">
	          .
	          <input name="endip4" type="text" class="box_ip" id="endip4" size="3" maxlength="3">
	          <input name="add" type="button" id="add" value="" size="3" maxlength="3" onClick="send('add');">
			<input name="type" type="hidden" id="type" value="add"></td>
	      </tr>
	      </table>
	      </td>
	</tr>
      <tr>
        <td width="150" valign="top" class="bgblue"><span id="deny_ip" name="deny_ip"></span>: </td>
        <td class="bggrey">
	      <table width="100%" border="0" cellspacing="1" cellpadding="3">
	        <tr>
		        <td width="16%"><select name="denylist" id="denylist">
		          <% getIpDenyList(); %>	
		          </select>
		          <input name="delete" type="button" id="delete" value="" onClick="send('delete');">
		        </td>
	        </tr>
	        </table>
	      </td>
	</tr>
    </table>
    </form>
    <br>
  	</td>
</tr>
</table>
</body>
</html>
