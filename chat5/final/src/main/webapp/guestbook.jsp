
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.appengine.api.datastore.Transaction"%>
<%@page import="com.google.appengine.api.datastore.Query"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
    <meta charset="utf-8">
</head>

<body>

<%
	String userID = (String) request.getAttribute("UserID");
	DatastoreService dataStore = DatastoreServiceFactory.getDatastoreService();
	Transaction txn = dataStore.beginTransaction();
	String userName = null;
	String check = null;
	
%>


<div style="float:left;">
<div style="float:left;width:30%;height:100%;background:#FFFFCC">




</div>
<div style="float:right;width:70%;background:#FFFFFF">

<%
	if(userID == null){
		%>
		<a href="./login.jsp">Sign in</a> <a href="./addUser.jsp">join</a>
		<%
	}
	else{
		Key personKey = KeyFactory.createKey("Person", userID);
		Entity person = dataStore.get(personKey);
		
		userName = (String) person.getProperty("Name");
		check = (String) person.getProperty("Check");		
		%>
				Hello! <%=userName %>.<br/>
				
		<%
		if(check.compareTo("Student") == 0){
			%>
			<form action="./profList.jsp" method="post">
			<input TYPE="IMAGE" src="./stButton.jpg"/>
			<input type="hidden" name="UserID" value="<%=userID%>" />
			</form>	
			<%
		}
		else if(check.compareTo("Professor") == 0){
			%>
			교수입니다.
			<form action="./stuList.jsp" method="post">
			<input TYPE="IMAGE" src="./stButton.jpg"/>
			<input type="hidden" name="UserID" value="<%=userID%>" />
			</form>	
			
			<%
		}
	}
%>


</div>
</div>

</body>
</html>
<%-- //[END all]--%>
