<%@ page import="java.util.List" %>
<%@ page import="models.Pointage" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Pointage> pointages = (List<Pointage>) request.getAttribute("pointages");
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
    java.util.TimeZone tz = java.util.TimeZone.getTimeZone("UTC");
    sdf.setTimeZone(tz);
%>


 

