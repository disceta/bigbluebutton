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


<html>
    <head>
        <title>Вход</title>
        <link rel="stylesheet" href="/css/main.css" />
        <link rel="shortcut icon" href="/images/favicon.ico" type="image/x-icon" />
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="login"/>
        
    
        <script type="text/javascript" src="/js/application.js"></script>

        <script type="text/javascript" src="/js/helpsel.js"></script>

    </head>
    <body>
        <div id="spinner" class="spinner" style="display:none;">
            <img src="/images/spinner.gif" alt="Spinner" />
        </div>
        <div id="rtLogo"  class="logo">
          <img src="/images/rt.jpg" alt="Rostelecom" border="0" />

        <span class="audio_conf">
             <a href="http://95.167.167.81" title="Конференция"  target="help">
               <img src="/images/3d_chart.png" style="border-style: none"/>
             </a>
        </span>
        </div>
        
        <div class="body">
            <h1>Вход</h1>

<%@ include file="bbb_api.jsp"%>

<%

%>

<%
	if (request.getParameter("action")==null) {
		//
		// Assume we want to join a course
		//
%>

            <form name="form1" method="GET" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="login">Имя</label>
                                </td>
                                <td valign="top" class="value ">
                                    <input type="text" name="login" value="" id="login" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password">Пароль</label>
                                </td>
                                <td valign="top" class="value ">
                                    <input type="password" name="password" value="" id="password" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input type="submit" name="create" class="save" value="Войти" id="create" /></span>
                </div>
            </form>
        </div>
    


<%
	if (request.getParameter("errn")!=null) {
%> 
<font style="font-size:15px" color="brown"><b>*   
<%
            if (request.getParameter("errn").equals("1")) {
%>
Вы ошиблись при вводе пинкода.
<%
            }
            else if (request.getParameter("errn").equals("2")) {
%>
Ошибка создание конференции.
<%
            }
%>
</b></font>
<%      }%>
</br>
</br>
</br>


<%
	} else if (request.getParameter("action").equals("pincode")) {
%>

<%
    String name = request.getParameter("meetingId");
    String pass = request.getParameter("moderatorPW");
    String joinURL="";//request.getRequestURI();
    String url_db="http://localhost:8081/PresentService/loginInfo/index?name="+urlEncode(name)+"&pass="+urlEncode(pass);
    URLConnection hpCon = new URL(url_db).openConnection();
    InputStreamReader isr = new InputStreamReader(hpCon.getInputStream());
    BufferedReader br = new BufferedReader(isr);
    String s = br.readLine();
    out.print(s);
    Document doc = parseXml(s);
    Node list=doc.getElementsByTagName("Result").item(0);

    if (!list.getAttributes().getNamedItem("code").getNodeValue().equals("1")) {
      joinURL=joinURL+"?errn=1";
    }
    else {
        String username = request.getParameter("meetingID");
        String meetingID = list.getAttributes().getNamedItem("conf_id").getNodeValue();
        String welcomeMsg = list.getAttributes().getNamedItem("welcomeMSG").getNodeValue();
        String viewerPW = list.getAttributes().getNamedItem("viewerPW").getNodeValue();
        String moderatorPW = list.getAttributes().getNamedItem("moderatorPW").getNodeValue();
        String logoutURL = joinURL;

        String meeting_ID = createMeeting( meetingID, welcomeMsg, moderatorPW, viewerPW, 0, logoutURL );

        if( meeting_ID.startsWith("Error ")) {
            joinURL=joinURL+"?errn=2&mid="+meetingID;
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
