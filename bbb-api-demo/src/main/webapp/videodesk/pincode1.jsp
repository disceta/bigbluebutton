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
<title>Вход в конференцию по Пинкоду.</title>
</head>
<body>

<%@ include file="bbb_api.jsp"%>

<%

%>

<%
	if (request.getParameter("action")==null) {
		//
		// Assume we want to join a course
		//
%>
<%@ include file="header.jsp"%>

<h2>Веб-презентация.</h2>

<FORM NAME="form1" METHOD="GET">
<table cellpadding="5" cellspacing="5" style="width: 400px; ">
	<tbody>
		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Ваше имя:</td>
			<td style="width: 5px; ">
				&nbsp;</td>
			<td style="text-align: left ">
				<input type="text" name="meetingID" /></td>
		</tr>

		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Пинкод:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="moderatorPW" /></td>
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
	</tbody>
</table>
<INPUT TYPE=hidden NAME=action VALUE="pincode">
</FORM>

</br>
</br>
</br>


<%@ include file="footer.jsp"%>

<%
	} else if (request.getParameter("action").equals("pincode")) {
%>

<%
		String name = request.getParameter("meetingId");
		String pass = request.getParameter("moderatorPW");
    String url_db="http://localhost:8080/PresentService/loginInfo/index?name="+name+"&pass="+pass;
		URLConnection hpCon = new URL(url_db).openConnection();
		InputStreamReader isr = new InputStreamReader(hpCon.getInputStream());
		BufferedReader br = new BufferedReader(isr);
    String s = br.readLine();
    out.print(s);
    Document doc = parseXml(s);
    Node list=doc.getElementsByTagName("Result").item(0);

    if (!list.getAttributes().getNamedItem("code").getNodeValue().equals("1")) {
      out.print("Конференция не найдена.");
      return;
    }

    String username = request.getParameter("meetingID");
		String meetingID = list.getAttributes().getNamedItem("conf_id").getNodeValue();
		String welcomeMsg = list.getAttributes().getNamedItem("welcomeMSG").getNodeValue();
		String viewerPW = list.getAttributes().getNamedItem("viewerPW").getNodeValue();
		String moderatorPW = list.getAttributes().getNamedItem("moderatorPW").getNodeValue();
		String logoutURL = "/rastel/jsp/pincode.jsp";

		String meeting_ID = createMeeting( meetingID, welcomeMsg, moderatorPW, viewerPW, 0, logoutURL );

		if( meeting_ID.startsWith("Error ")) {
%>
	Ошибка создания конференции: конференция <%=meetingID%>  не создана.
	<p/> <%=meeting_ID%>
<%
			return;
		}
		String joinURL = getJoinMeetingURL(username, meetingID, pass);
%>

<script language="javascript" type="text/javascript">
	window.location.href="<%=joinURL%>";
</script>

<%
	}
%>


</body>
</html>