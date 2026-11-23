<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="robots" content="noindex,nofollow"> 
<title><% getWlanExist("stat"); %> Network Camera</title>
<link href="web.css" rel="stylesheet" type="text/css">
<link href="style.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<script language="JavaScript" type="text/javascript" src="itemname.js"></script>
<script language="JavaScript" type="text/javascript" src="tree.js"></script>
<script language="JavaScript" type="text/javascript" src="warn.js"></script>
<script language="JavaScript" type="text/javascript" src="date.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var head="display:''"
function doit(header){
var head=header.style
if (head.display=="none")
head.display=""
else
head.display="none"
}
//-->

function time_go(){
	time_init(document.getElementById("datebar").innerHTML);
	start_date_show(document.getElementById("datebar"));

}

function getDocHeight(doc) {
  var docHt = 0, sh, oh;
  //if (doc.height) docHt = doc.height;
  //else 
  if (doc.body) {
    if (doc.body.scrollHeight) docHt = sh = doc.body.scrollHeight;
    if (doc.body.offsetHeight) docHt = oh = doc.body.offsetHeight;
    if (sh && oh) {docHt=0;docHt = Math.max(sh, oh);}
  }
  return docHt;
}

function getDocWidth(doc) {
  var docWd = 0, sh, oh;
  //if (doc.height) docHt = doc.height;
  //else 
  if (doc.body) {
    if (doc.body.scrollWidth) docWd = sh = doc.body.scrollWidth;
    if (doc.body.offsetWidth) docWd = oh = doc.body.offsetWidth;
    if (sh && oh) {docWd=0;docWd = Math.max(sh, oh);}
  }
  return docWd;
}

function setIframeHeight(iframeName) {
  var iframeWin = window.frames[iframeName];
  var iframeEl = document.getElementById? document.getElementById(iframeName): document.all? document.all[iframeName]: null;
  if ( iframeEl && iframeWin ) {
    iframeEl.style.height = "auto"; // helps resize (for some) if new doc shorter than previous  
    var docHt = getDocHeight(iframeWin.document);
    var docWd = getDocWidth(iframeWin.document);
    // need to add to height to be sure it will all show
    if (docHt) iframeEl.style.height = docHt + "px";
    if (docWd) iframeEl.style.width = "100%";
  }
}

function setIframeHeightMotion(iframeName) {
  var iframeWin = window.frames[iframeName];
  var iframeEl = document.getElementById? document.getElementById(iframeName): document.all? document.all[iframeName]: null;
  if ( iframeEl && iframeWin ) {
    iframeEl.style.height = "auto"; // helps resize (for some) if new doc shorter than previous  
    var docHt = getDocHeight(iframeWin.document);
    var docWd = getDocWidth(iframeWin.document);
    // need to add to height to be sure it will all show
    if (docHt) iframeEl.style.height = docHt + "px";
    if (docWd) iframeEl.style.width = "860";
  }
}

var IframePage = "<%getIframePage();%>";

function setLocation(str){
	document.getElementById("location_value").innerHTML = str;
}
function setDateTime(str){
	stop_date_show();
	document.getElementById("datebar").innerHTML = str;
	time_go();
}
function setContent(str,str1){
	document.getElementById(str).appendChild(document.createTextNode(str1));
}
function start(){
	
	setContent("location",item_name[_LOCATION]);
	setContent("systemtag",item_name[_SYSTEM]);
	setContent("datetimetag",item_name[_DATE_TIME]);
	setContent("usertag",item_name[_USER]);
	setContent("networktag",item_name[_NETWORK]);
	setContent("ipfiltertag",item_name[_IP_FILTER]);
	setContent("wirelesstag",item_name[_WIRELESS]);
	setContent("cameratag",item_name[_CAMERA]);
	setContent("videotag",item_name[_VIDEO]);
	setContent("audiotag",item_name[_AUDIO]);
	setContent("httptag",item_name[_HTTP]);
	setContent("ftptag",item_name[_FTP]);
	setContent("emailtag",item_name[_EMAIL]);
	setContent("generaltag",item_name[_GENERAL]);
	setContent("schprofiletag",item_name[_SCHEDULE_PROF]);
	setContent("motiontrigtag",item_name[_MOTION_TRIG]);
	setContent("schtrigtag",item_name[_SCHEDULE_TRIG]);
	setContent("deviceinfotag",item_name[_DEV_INFO]);
	setContent("syslogtag",item_name[_SYS_LOG]);
	
	if(IframePage=="system")
		loadIframe('ifrm','system.asp','Basic','system','system2');
	else if(IframePage=="datetime")
		loadIframe('ifrm', 'datetime.asp','Basic','date','date2');
	else if(IframePage=="user")
		loadIframe('ifrm', 'user.asp','Basic','user','user2');
	else if(IframePage=="network")
		loadIframe('ifrm', 'network.asp','Network','net','net2');
	else if(IframePage=="ipfilter")
		loadIframe('ifrm', 'ipfilter.asp','Network','ip','ip2');
	else if(IframePage=="wireless")
		loadIframe('ifrm', 'wireless.asp','Network','wire','wire2');
	else if(IframePage=="camera")
		loadIframe('ifrm', 'rdrvideo.asp', 'VideoAudio', 'camera', 'camera2');
	else if(IframePage=="video")
		loadIframe('ifrm', 'video.asp', 'VideoAudio', 'video', 'video2');
	else if(IframePage=="audio")
		loadIframe('ifrm', 'audio.asp', 'VideoAudio', 'audio', 'audio2');
	else if(IframePage=="http")
		loadIframe('ifrm', 'http.asp','Server','http','http2');
	else if(IframePage=="ftp")
		loadIframe('ifrm', 'ftp.asp','Server','ftp','ftp2');
	else if(IframePage=="email")
		loadIframe('ifrm', 'email.asp','Server','email','email2');
	else if(IframePage=="motiondetect")
		loadIframe('ifrm', 'watch.cgi?url=motion.asp','Motion','','');
	else if(IframePage=="general")
		loadIframe('ifrm', 'general.asp', 'Event', 'general', 'general2');
	else if(IframePage=="scheduleprofile")
		loadIframe('ifrm', 'scheprofile.asp', 'Event', 'sche', 'sche2');
	else if(IframePage=="motiontrigger")
		loadIframe('ifrm', 'motiontrig.asp', 'Event', 'motrig', 'motrig2');
	else if(IframePage=="scheduletrigger")
		loadIframe('ifrm', 'schetrig.asp', 'Event', 'schet', 'schet2');
	else if(IframePage=="tools")
		loadIframe('ifrm', 'tools.asp', 'Tool','','');
	else if(IframePage=="deviceinfo")
		loadIframe('ifrm', 'info.asp', 'Information', 'info', 'info2');
	else if(IframePage=="systemlog")
		loadIframe('ifrm', 'log.asp', 'Information', 'log', 'log2');
	else if(IframePage=="rebootfail")
		loadIframe('ifrm', 'reboot_fail.asp', 'Tool','','');
	else
		loadIframe('ifrm','system.asp','Basic','system','system2');
}
</script>
<body onload="MM_preloadImages('images/but_liveview_1.gif','images/but_setup_1.gif','images/but_smartwizard_1.gif','images/but_basic_1.gif');time_go();start();">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="21"><img src="images/c1_tl.gif" width="21"></td>
		<td width="758" background="images/bg1_t.gif"><img src="images/top_1.gif" width="390"></td>
		<td width="21"><img src="images/c1_tr.gif" width="21"></td>
	</tr>
	<tr>
    	<td valign="top" background="images/bg1_l.gif"><img src="images/top_2.gif" width="21" height="69"></td>
    	<td background="images/bg.gif">
    		<table width="100%" height="70" border="0" cellpadding="0" cellspacing="0">
			    <tr>
					<td width="13%" valign="top"><img src="images/logo.gif" width="300" height="69"></td>
					<td width="87%" align="right" valign="top">
						<table width="100%" border="0" cellpadding="4" cellspacing="0">
							<tr>
								<td align="right" valign="top"><img src="images/description_<% getmodelname(); %>.gif"></td>
							</tr>
							<tr>
								<td align="right" valign="top"><b><font color="#FFFFFF"><span id="location" name="location"></span>: <span id="location_value" name="location_value">
								<% getLocation(); %></span></font>&nbsp;&nbsp;&nbsp; <font color="#FFFFFF"><span class="style1">
								<span id="datebar"><% getDate(); %> <%getTime(); %></span>
								&nbsp; </span>&nbsp; </font></b></td>
							</tr>
						</table>
					</td>
			    </tr>
			  </table>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="200" valign="top" align="center">
					<table width="21%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
									  <td><img src="images/but_top.gif" width="144" height="3"></td>
									</tr>
									<tr>
									  <td><table width="100%" border="0" cellpadding="3" cellspacing="0" class="submenubg">
									      <tr>
									        <td width="100%" align="right"><img src="images/spacer.gif" width="10" height="5"></td>
									      </tr>
									      <tr>
									        <td align="center"><a href="../."><img src="images/but_liveview_0.gif" name="b_liveview" width="122" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('b_liveview','','images/but_liveview_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
									      </tr>
									      <tr>
									        <td align="center"><a href="../admin/setup.cgi?page=system"><img src="images/but_setup_1.gif" name="b_setup" width="122" height="25" border="0" id="Image2" onMouseOver="MM_swapImage('b_setup','','images/but_setup_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
									      </tr>
									      <tr>
									        <td align="right"><img src="images/spacer.gif" width="10" height="5"></td>
									      </tr>
									    </table></td>
									</tr>
									<tr>
									  <td><img src="images/but_bottom.gif" width="144" height="3"></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td width="100%"><img src="images/spacer.gif" width="8" height="8"></td>
						</tr>
					</table>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" id="tree_1">
				      <tr>
				        <td width="100%" height="80" align="center">
				          <br>
				          <table width="144" border="0" cellpadding="0" cellspacing="0">
				            <tr>
				              <td align="center"><a href="smartwizard.cgi?go=1"><img src="images/but_smartwizard_0.gif" name="b_wizard" width="144" height="28" border="0" id="Image3" onMouseOver="MM_swapImage('b_wizard','','images/but_smartwizard_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>
				          </table>
				          <table width="144" border="0" cellpadding="0" cellspacing="0">
				           <!-- Basic -->
				           <tr>
				              <td align="center"><a id = "BasCol" href="setup.cgi?page=system"><img src="images/but_basic_1.gif" name="b_basic_h" border="0" id="b_basic_h" style="display:none"><img src="images/but_basic_0.gif" name="b_basic"  border="0" id="b_basic" onMouseOver="MM_swapImage('b_basic','','images/but_basic_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				            </tr>
				            <tr>
				              <td align="center">
				               <table width="144"  border="0" cellpadding="0" cellspacing="0" id="Basic" style="display:none">
				               		<tr>
                      					<td><img src="images/but_top.gif" width="144" height="3"></td>
                    				</tr>
				                    <tr>
				                      <td id="system"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="system2"  href="setup.cgi?page=system"><span id="systemtag" name="systemtag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="date"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="date2"  href="setup.cgi?page=datetime"><span id="datetimetag" name="datetimetag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="user"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="user2" href="setup.cgi?page=user"><span id="usertag" name="usertag"></span></a></td>
				                    </tr>
				                    <tr>
                      					<td><img src="images/but_bottom.gif" width="144" height="3"></td>
                    				</tr>
				                </table>
				                </td>
				            </tr>
                    		<tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>
				  			<!-- Network -->
				            <tr>
				               <td align="center"><a id = "NetCol" href="setup.cgi?page=network"><img src="images/but_network_1.gif" name="b_network_h" border="0" id="b_network_h" style="display:none"><img src="images/but_network_0.gif" name="b_network"  border="0" id="b_network" onMouseOver="MM_swapImage('b_network','','images/but_network_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
							</tr>
				            <tr>
				              <td align="center">
				                <table width="144"  border="0" align="center" cellpadding="0" cellspacing="0" id="Network"  style="display:none">
				                	<tr>
                      					<td><img src="images/but_top.gif" width="144" height="3"></td>
                    				</tr>
				                	<tr>
				                      <td id="net"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="net2" href="setup.cgi?page=network"><span id="networktag" name="networktag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="ip"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="ip2" href="setup.cgi?page=ipfilter"><span id="ipfiltertag" name="ipfiltertag"></span></a></td>
				                    </tr>
				                    <tr >
				                      <td id="wire"><span style="display:<% getWlanExist(); %>"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="wire2" href="setup.cgi?page=wireless"><span id="wirelesstag" name="wirelesstag"></span></a></span></td>
				                    </tr>
				                    <tr>
                      					<td><img src="images/but_bottom.gif" width="144" height="3"></td>
                    				</tr>
				                </table>
				                </td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>
				            <!-- Camera -->
				     		<tr>
				              <td align="center"><a id="CamCol" href="setup.cgi?page=camera"><img src="images/but_videoaudio_1.gif" name="b_videoaudio_h" border="0" id="b_videoaudio_h" style="display:none"><img src="images/but_videoaudio_0.gif" name="b_videoaudio"  border="0" id="b_videoaudio" onMouseOver="MM_swapImage('b_videoaudio','','images/but_videoaudio_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				            </tr>
				            <tr>
				              <td align="center">
				              <table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0"  id="VideoAudio"  style="display:none">
				              		<tr>
                      					<td><img src="images/but_top.gif" width="144" height="3"></td>
                    				</tr>
				                    <tr>
				                      <td id="camera" ><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="camera2" href="setup.cgi?page=camera"><span id="cameratag" name="cameratag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="video"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="video2" href="setup.cgi?page=video"><span id="videotag" name="videotag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="audio"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="audio2" href="setup.cgi?page=audio"><span id="audiotag" name="audiotag"></span></a></td>
				                    </tr>
				                    <tr>
                      					<td><img src="images/but_bottom.gif" width="144" height="3"></td>
                    				</tr>
				                </table>
				              </td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>
				            <!-- Server -->  
				            <tr>
				             <td align="center"><a id="SerCol" href="setup.cgi?page=http"><img src="images/but_eventserver_1.gif" name="b_eventserver_h" border="0" id="b_eventserver_h" style="display:none"><img src="images/but_eventserver_0.gif" name="b_eventserver"  border="0" id="b_eventserver" onMouseOver="MM_swapImage('b_eventserver','','images/but_eventserver_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				            </tr>
				            <tr>
				              <td align="center">
				                  <table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" id="Server"  style="display:none">
				                  	<tr>
                      					<td><img src="images/but_top.gif" width="144" height="3"></td>
                    				</tr>
                    				<tr>
				                      <td id="http"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="http2" href="setup.cgi?page=http"><span id="httptag" name="httptag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="ftp"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="ftp2" href="setup.cgi?page=ftp"><span id="ftptag" name="ftptag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="email"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="email2" href="setup.cgi?page=email"><span id="emailtag" name="emailtag"></span></a></td>
				                    </tr>
				                    <tr>
                      					<td><img src="images/but_bottom.gif" width="144" height="3"></td>
                    				</tr>
				                </table></td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>
				           <!-- Motion -->  
				            <tr>
				               <td align="center"><a id="MotCol" href="setup.cgi?page=motiondetect"><img src="images/but_motiondetect_1.gif" name="b_motiondetect_h" border="0" id="b_motiondetect_h" style="display:none"><img src="images/but_motiondetect_0.gif" name="b_motiondetect"  border="0" id="b_motiondetect" onMouseOver="MM_swapImage('b_motiondetect','','images/but_motiondetect_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>  
				          <!-- Event Config -->
				             <tr>
				             	<td align="center"><a id="EvnCol" href="setup.cgi?page=general"><img src="images/but_eventconfig_1.gif" name="b_eventconfig_h" border="0" id="b_eventconfig_h" style="display:none"><img src="images/but_eventconfig_0.gif" name="b_eventconfig"  border="0" id="b_eventconfig" onMouseOver="MM_swapImage('b_eventconfig','','images/but_eventconfig_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				             </tr>
				             <tr>
				               <td align="center">
				                <table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" id="Event"  style="display:none">
				                  <tr>
                      				<td><img src="images/but_top.gif" width="144" height="3"></td>
                    			  </tr>
				                  <tr>
				                    <td id = "general" ><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id = "general2" href="setup.cgi?page=general"><span id="generaltag" name="generaltag"></span></a></td>
				                  </tr>
				                  <tr>
				                    <td id = "sche" ><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id = "sche2" href="setup.cgi?page=scheduleprofile"><span id="schprofiletag" name="schprofiletag"></span></a></td>
				                  </tr>
				                  <tr>
				                    <td id = "motrig" ><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id = "motrig2" href="setup.cgi?page=motiontrigger"><span id="motiontrigtag" name="motiontrigtag"></span></a></td>
				                  </tr>
				                  <tr>
				                    <td id = "schet" ><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id = "schet2" href="setup.cgi?page=scheduletrigger"><span id="schtrigtag" name="schtrigtag"></span></a></td>
				                  </tr>
				                  <tr>
                      				<td><img src="images/but_bottom.gif" width="144" height="3"></td>
								  </tr>
				                </table>
				                </td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>  
				            <!-- Tool -->  
				            <tr>
				              <td align="center"><a id = "ToolCol" href="setup.cgi?page=tools"><img src="images/but_tools_1.gif" name="b_tools_h" border="0" id="b_tools_h" style="display:none"><img src="images/but_tools_0.gif" name="b_tools"  border="0" id="b_tools" onMouseOver="MM_swapImage('b_tools','','images/but_tools_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
				            </tr>
				            <tr>
                      			<td><img src="images/spacer.gif" width="8" height="8"></td>
                    		</tr>
				            <!-- Information -->
				      		<tr>
				               <td align="center"><a id="InfCol" href="setup.cgi?page=deviceinfo"><img src="images/but_information_1.gif" name="b_information_h" border="0" id="b_information_h" style="display:none"><img src="images/but_information_0.gif" name="b_information"  border="0" id="b_information" onMouseOver="MM_swapImage('b_information','','images/but_information_1.gif',1)" onMouseOut="MM_swapImgRestore()"></a></td>
							</tr>
							<tr>
								<td align="center">
				                  <table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" id="Information"  style="display:none">
				                  	<tr>
									  <td><img src="images/but_top.gif" width="144" height="3"></td>
									</tr>
				                    <tr>
				                      <td id="info"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="info2" href="setup.cgi?page=deviceinfo"><span id="deviceinfotag" name="deviceinfotag"></span></a></td>
				                    </tr>
				                    <tr>
				                      <td id="log"><img src="images/spacer.gif" width="15" height="15"><font color="#FFFFFF">&bull;</font> <a id="log2" href="setup.cgi?page=systemlog"><span id="syslogtag" name="syslogtag"></span></a></td>
				                    </tr>
				                    <tr>
									  <td><img src="images/but_bottom.gif" width="144" height="3"></td>
								  	</tr>
				                </table>
				                </td>
				            </tr>
				          </table>
				         </td>
				      </tr>
				    </table>
					</td>
					<td width="10"><img src="images/spacer.gif" width="10" height="15"></td>
					<td valign="top" width="100%">
				    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
				    		<tr>
				    			<td align="left">
				    			<iframe name="ifrm" id="ifrm" src="" frameborder="0" scrolling="no" width="100%" height="0">Sorry, your browser doesn't support iframes.</iframe>
								</td>
				    		</tr>		
				    	</table>    
				    </td>
				</tr>
			</table>
		</td>
  <td width="21" background="images/bg1_r.gif"></td>
  </tr>
  <tr>
    <td><img src="images/c1_bl.gif" width="21"></td>
    <td align="right" background="images/bg1_b.gif"><img src="images/copyright.gif" width="264"></td>
    <td><img src="images/c1_br.gif" width="21"></td>
  </tr>
</table>
</body>
</html>
