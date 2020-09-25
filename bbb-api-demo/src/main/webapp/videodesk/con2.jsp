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
<title>Присоединиться к конференции.</title>
</head>
<body>

<%@ include file="bbb_api.jsp"%>

<% 
	if (request.getParameterMap().isEmpty()) {
		//
		// Assume we want to join a course
		//
%> 

<h2>Подключитесь к конференции.</h2>

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
				<input type="text" name="username" /></td>
		</tr>
		
	
		
		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Пароль:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="password" /></td>
		</tr>
		<tr>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="submit" value="Подключить" /></td>
		</tr>	
	</tbody>
</table>
<INPUT TYPE=hidden NAME=action VALUE="join">
</FORM>

</br>

</br>


<%@ include file="footer.jsp"%>

<%
	} else if (request.getParameter("action").equals("join")) {
		String username = request.getParameter("username");
		String meetingID = request.getParameter("password");
		String password = request.getParameter("password");
		if (isMeetingRunning(meetingID).equals("false") ) {
%>
	Ошибка подключения к конференции: конференция не существует.
<%
			return;
		}
		String joinURL = getJoinMeetingURL(username, meetingID, password);			
		//out.write(joinURL);
%>

<h> OK ... </h>


<script language="javascript" type="text/javascript">
	window.location.href="<%=joinURL%>";
</script>


<%
	} 
%>

</body>
</html>