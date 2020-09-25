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
<title>Монитор конференций</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Конференции Растел.</title>


</head>
<body>

<%@ include file="bbb_api.jsp"%>

<%@ include file="header.jsp"%>

<script type="text/javascript">
function loadXMLDoc()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
xmlhttp.onreadystatechange=function()
  {
	  if (xmlhttp.readyState==4 && xmlhttp.status==200) {
	    txt="<table border='1'><tr>"
	    	+"<th>&nbsp;&nbsp;ID&nbsp;&nbsp;</th>"
	    	+"<th>Start Time</th>"
	    	+"<th>End Time</th>"
	    	+"<th>Running?</th>"
	    	+"<th>Participant Count</th>"
	    	+"</tr>"
	    	;
	    x=xmlhttp.responseXML.documentElement.getElementsByTagName("meeting");
	    for (i=0;i<x.length;i++) {
		    txt=txt + "<tr>" 
		    	+ tag(x, "meetingID") 
		    	+ tag(x, "startTime") 
		    	+ tag(x, "endTime") 
		    	+ tag(x, "running")
		    	+ tag(x, "participantCount")
		    	+ "</tr>";
	    }
	    txt=txt + "</table>";
	    document.getElementById('myDiv').innerHTML=txt;
	  }
  }
var newDate = new Date;
xmlhttp.open("GET","meetings.jsp?getxml=true&="+newDate.getTime(),false);
xmlhttp.send();
setTimeout("loadXMLDoc();", 20000);
}
function tag(ax, atxt) {
    ax=x[i].getElementsByTagName(atxt);
    txt="<td>";
	try {txt=txt + ax[0].firstChild.nodeValue;}
	catch (er){}
    txt=txt+"</td>";
	return txt;
}
</script>

<h2>Посмотреть активные конференции.</h2>

<!-- 
<button type="button" onclick="loadXMLDoc()">Refresh</button>
 -->
 
<br>
<br>

<div id="myDiv"></div>

<script type="text/javascript">
loadXMLDoc();
</script>

<br>
<br>

<%@ include file="footer.jsp"%>

</body>
</html>