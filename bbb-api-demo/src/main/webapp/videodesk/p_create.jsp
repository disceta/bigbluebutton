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
<title>Создать web-презентацию.</title>
</head>
<body>

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
<h2>Создать web-презентацию.</h2>

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
                            if (request.getParameter("owner")!=null) {
                        %>
                        <td style="text-align: left; font-weight: bold; width: 5px; "/> <%=ownerName%> 
                            <input type="hidden" name="owner" value="<%=ownerName%>"/>
                        </td>
                        <%
                            } else {
                        %>
			<td style="text-align: left ">
                            <input type="text" name="owner" value="<%=ownerName%>"/></td>
                        <%
                            }
                        %>
		</tr>
		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				Пароль:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="pwd" /></td>
		</tr>
		<tr>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
			<td>
				&nbsp;</td>
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
				ПИН код модератора:</td>
			<td>
				&nbsp;</td>
			<td>
				<input type="password" name="mpwd" /></td>
		</tr>

		<tr>
			<td>
				&nbsp;</td>
			<td style="text-align: right; ">
				ПИН код web-презентации:</td>
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
				<input type="submit" value="Создать" /></td>
		</tr>	
	</tbody>
</table>
            
<INPUT TYPE=hidden NAME=action VALUE="create">
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
Ошибка создание web-презентации.
<%
        }
    }
%>
</br>
</b></font>
<br>
    <a style="color: blue; font-size: small;" href="p_smartconf.jsp?<%if (mnuVal.equals("1")) {%>&mnu=1<%}%><%if (!ownerName.equals("")) { %>&owner=<%=ownerName%><%}%>">Вход в web-презентацию</a>
</br>
<%@ include file="footer.jsp"%>

</FORM>

<%
} else if (request.getParameter("action").equals("create")) {
    String username = request.getParameter("owner");
    String password = request.getParameter("pwd");
    String joinURL="p_create.jsp";//request.getRequestURI();
    String url_db="http://localhost:8081/PresentService/presentLogin/create?cl="+username+"&pwd="+password;
    URLConnection hpCon = new URL(url_db).openConnection();
    InputStreamReader isr = new InputStreamReader(hpCon.getInputStream());
    BufferedReader br = new BufferedReader(isr);
    String s = br.readLine();
    out.print(s);
    Document doc = parseXml(s);
    Node list=doc.getElementsByTagName("Result").item(0);

	String code = list.getAttributes().getNamedItem("code").getNodeValue();

	if (code.equals("0") ) {
        joinURL=joinURL+"?errn=1";
        if (mnuVal.equals("1")) 
            joinURL=joinURL+"&mnu=1" ;
    }
    else {
        String name = request.getParameter("name");
        String welcomeMsg = "Здравствуйте!";
        String logoutURL = "";
        String viewerPW = request.getParameter( "upwd" );
        String moderatorPW = request.getParameter( "mpwd" );
        String meetingID = list.getAttributes().getNamedItem("conf_id").getNodeValue();

        String meeting_ID = createMeeting( meetingID, welcomeMsg, moderatorPW, viewerPW, 0, logoutURL, code);

        if( meeting_ID.startsWith("Error ")) {
            joinURL=joinURL+"?errn=2&mid="+meetingID;
            if (mnuVal.equals("1")) 
                joinURL=joinURL+"&mnu=1" ;
        }
        else {
            joinURL = getJoinMeetingURL(name, meetingID, moderatorPW);
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