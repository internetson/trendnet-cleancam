<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<title>
<% getWlanExist("stat"); %> Network Camera</title>
</title>
</head>
<body onLoad="">
<table width="100%" border="0" cellspacing="1" cellpadding="10">
<tr>
<td align="center">
<object
    classid = "clsid:CAFEEFAC-0015-0000-0012-ABCDEFFEDCBA"
    codebase = "http://java.sun.com/update/1.5.0/jinstall-1_5_0_12-windows-i586.cab#Version=5,0,120,4"
    WIDTH = "<% getwidth(); %>" HEIGHT = "<% getheight(); %>" NAME = "ucx" >
    <PARAM NAME = CODE VALUE = "ultracam.class" >
    <PARAM NAME = ARCHIVE VALUE = "ultracam.jar" >
    <PARAM NAME = NAME VALUE = "ucx" >
    <param name = "type" value = "application/x-java-applet;jpi-version=1.5.0_12">
    <param name = "scriptable" value = "false">
    <PARAM NAME = "accountcode" VALUE="<% getserial(); %>" />
    <PARAM NAME = "codebase" VALUE="http://<% getip(); %>:<% getport() %>/<% getgroup(); %>" />
    <PARAM NAME = "mode" VALUE="0" />

    <comment>
	<embed
            type = "application/x-java-applet" \
            CODE = "ultracam.class" \
            ARCHIVE = "ultracam.jar" \
            NAME = "ucx" \
            WIDTH = "<% getwidth(); %>" \
            HEIGHT = "<% getheight(); %>" \
            accountcode ="<% getserial(); %>" / \
            codebase ="http://<% getip(); %>:<% getport() %>/<% getgroup(); %>" / \
            mode ="0" / \
	    scriptable = false
	    pluginspage = "http://java.sun.com/products/plugin/index.html#download">
	    <noembed>
            
            </noembed>
	</embed>
    </comment>
</object></td>
</tr>
</table>
</body>
</html>
