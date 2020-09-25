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
<title>Создать конференцию.</title>
</head>
<body>

<%@ include file="bbb_api.jsp"%>

<%@ page 
  import="java.util.*"
%> 

<% 

%>

<% 
	if (request.getParameter("action")==null) {
		//
		// Assume we want to join a course
		//
%> 
<%@ include file="header.jsp"%>

<h2>Создайте конференцию.</h2>

<FORM NAME="form1" METHOD="GET">
<table cellpadding="5" cellspacing="5" style="width: 400px; ">
	<tbody>
		<tr>
			<td>&nbsp;
				</td>
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
				Пароль модератора:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="moderatorPW" /></td>
		</tr>

		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Пароль участника:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="viewerPW" /></td>
		</tr>

		<tr>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="submit" value="Создать" /></td>
		</tr>	
	</tbody>
</table>
<INPUT TYPE=hidden NAME=action VALUE="create">
</FORM>

</br>
</br>
</br>


<%@ include file="footer.jsp"%>

<%
	} else if (request.getParameter("action").equals("create")) {
		
		String meetingID = request.getParameter("meetingID");
		String password = request.getParameter("moderatorPW");
		String welcomeMsg = "Вас приветствует программа Растел.Презентация";//request.getParameter( "welcomeMsg" );
		String logoutURL = "/rastel/jsp/connect.jsp";//request.getParameter( "logoutURL" );
		String viewerPW = request.getParameter( "viewerPW" );
		String moderatorPW = request.getParameter( "moderatorPW" );
		
		//out.write(endMeeting(meetingID, moderatorPW));
		meetingID=meetingID+new Random().nextInt(999);

		String meeting_ID = createMeeting( meetingID, welcomeMsg, moderatorPW, viewerPW, 0, logoutURL );
		String username = meeting_ID;

		if( meeting_ID.startsWith("Error ")) {
%>
	Ошибка создания конференции: конференция <%=meetingID%>  не создана.
	<p/> <%=meeting_ID%>
<%
			return;
		}
		String joinURL = getJoinMeetingURL(username, meetingID, password);			
		out.write(joinURL);
%>

<h> OK </h>

<script language="javascript" type="text/javascript">
	window.location.href="<%=joinURL%>"; 
</script>


<%
	} 
%>


</body>
</html>