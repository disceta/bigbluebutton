<%@page import="javax.xml.transform.dom.DOMSource"%>
<%@page import="javax.xml.transform.stream.StreamResult"%>
<%@page import="javax.xml.transform.OutputKeys"%>
<%@page import="javax.xml.transform.TransformerFactory"%>
<%@page import="javax.xml.transform.Transformer"%>
<%@page import="org.w3c.dom.Element"%>
<%@page import="com.sun.org.apache.xerces.internal.dom.ChildNode"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="org.w3c.dom.NodeList"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>web-презентация</title>
</head>
<body>

	<!--
		<div id="rtLogo" class="logo">
		  <img src="/images/rt.jpg" alt="Rastel" border="0" />
		  <span class="help">
			<script type="text/javascript">
			  write_help_ref("/help/ru/help.htm", "Помощь");
			</script>
			<noscript>
			  <a href="/help/ru/help.htm"  target="help" >Помощь</a>
			</noscript>
		  </span>

		</div>
	-->

<%@ include file="bbb_api.jsp"%>

<%

%>

<%
String mnuVal="";
if (request.getParameter("mnu")!=null && request.getParameter("mnu").equals("1"))
	mnuVal="1";
if (request.getParameter("action")==null) {
	String ownerName="";
	if (request.getParameter("owner")!=null)
		ownerName=request.getParameter("owner");
%>

<%if (mnuVal.equals("1"))  { %>
<%@ include file="header.jsp"%>
<%} %>

<br>
<%@ include file="p_header.jsp"%>
<br>

<table BORDER="0" style="width: 800px;" >
<td>

<h2>Вход в web-презентацию.</h2>

<FORM NAME="form1" METHOD="GET">
<table cellpadding="5" cellspacing="5" style="width: 450px; ">
	<tbody>
		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Номер web-кабинета:</td>
			<td style="width: 5px; ">
				&nbsp;</td>
						<%
							if (!ownerName.equals("")) {
						%>
						<td style="text-align: left; font-weight: bold; width: 5px; "/> <%=ownerName%> </td>
						<%
							} else {
						%>
			<td style="text-align: left ">
							<input type="text" name="owner" /></td>
						<%
							}
						%>
		</tr>
		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Имя:</td>
			<td style="width: 5px; ">
				&nbsp;</td>
			<td style="text-align: left ">
				<input type="text" name="name" /></td>
		</tr>

		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				ПИН код:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="upwd" /></td>
		</tr>

		<tr>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="submit" value="Вход" /></td>
		</tr>
				
				<tr>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
		</tr>
				
	</tbody>
</table>
	
	<INPUT TYPE=hidden NAME=action VALUE="pincode">
	<INPUT TYPE=hidden NAME=mnu VALUE="<%=mnuVal%>">

<%
	if (request.getParameter("errn")!=null) {
%> 
<font style="font-size:15px" color="brown"><b></br>
*   
<%
		if (request.getParameter("errn").equals("1")) {
%>
Вы ошиблись при вводе пинкода.
<%
		}
		else if (request.getParameter("errn").equals("2")) {
%>
Ошибка создание презентации.
<%
		}
	}
%>
</br>
</b></font>
<br>
</br>
	 <a style="color: blue; font-size: small;" href="p_create.jsp?<%if (mnuVal.equals("1")) {%>&mnu=1<%}%><%if (!ownerName.equals("")) { %>&owner=<%=ownerName%><%}%>">Создать web-презентацию</a>
</br>
</FORM>
</td>
<td>
<%@ include file="about.htm"%>
<a href="about_long.htm"  target="help" style="align: right;" >подробнее</a>
</td>
</table>
<%@ include file="footer.jsp"%>


<%
	} else if (request.getParameter("action").equals("pincode")) {
%>

<%
	String cl = request.getParameter("owner");
	String username = request.getParameter("name");
	String pass = request.getParameter("upwd");
	String joinURL="";request.getRequestURI();
	String url_db="http://localhost:8081/PresentService/presentLogin/login?cl="+cl+"&name="+username+"&upwd="+pass;
	URLConnection hpCon = new URL(url_db).openConnection();
	InputStreamReader isr = new InputStreamReader(hpCon.getInputStream());
	BufferedReader br = new BufferedReader(isr);
	String s = br.readLine();
	out.print(s);
	Document doc = parseXml(s);
	Node list=doc.getElementsByTagName("Result").item(0);
	String code = list.getAttributes().getNamedItem("code").getNodeValue();

	if (code.equals("0") ) {
		joinURL=joinURL+"?errn=1&em=db_status_not_ok";
		if (mnuVal.equals("1")) 
			joinURL=joinURL+"&mnu=1" ;
	}
	else {
		String meetingID = list.getAttributes().getNamedItem("conf_id").getNodeValue();
		String logoutURL = joinURL;
		
		if (isMeetingRunning(meetingID).equals("false") ) {
			joinURL=joinURL+"?errn=1&em=not_running&i="+meetingID;
			if (mnuVal.equals("1")) 
				joinURL=joinURL+"&mnu=1" ;
		}
		else {
			joinURL = getJoinMeetingURL(username, meetingID, pass);
		}
	}
%>

<script language="javascript" type="text/javascript">
	window.location.href="<%=joinURL%>";
</script>

<%
	}
%>


</body>
</html>
