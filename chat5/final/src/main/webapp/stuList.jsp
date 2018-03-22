
<%@page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.appengine.api.datastore.Transaction"%>
<%@page import="com.google.appengine.api.datastore.Query"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
    <meta charset="utf-8">
</head>

<body>

<%
	String userID = (String) request.getParameter("UserID");
	DatastoreService dataStore = DatastoreServiceFactory.getDatastoreService();
	Transaction txn = dataStore.beginTransaction();
	String userName = null;
	String check = null;
	
%>


<div style="float:left;">
<div style="float:left;width:30%;height:100%;background:#FFFFCC">




</div>
<div style="float:right;width:70%;background:#FFFFFF">
<%=userID %>
<%
	if(userID == null){
		%>	
		<a href="./addUser.jsp">Sign in</a>
		<%
	}
	else{
		Query query = new Query("Chat");
		query.addFilter("ProfID", Query.FilterOperator.EQUAL, userID);
		query.addFilter("Check", Query.FilterOperator.EQUAL, "true");
		PreparedQuery pq = dataStore.prepare(query);
		%>
		<table border="1">
		<tr>
		<th>Name</th>
		<th>Chat</th>
		</tr>
		<%
		for(Entity result:pq.asIterable()){
			Key personKey = KeyFactory.createKey("Person", (String)result.getProperty("UserID"));
			Entity person = dataStore.get(personKey);
			
			userName = (String) person.getProperty("Name");
			
			%>
			
			<tr>
			<td><%=userName%></td>
			<td>
			<form action="./profChat.jsp">
			<input type="image" src="./stButton.jpg" />
			<input type="hidden" name="UserID" value="<%=(String)result.getProperty("UserID") %>" />
			<input type="hidden" name="guestbookName" value="<%=userID+(String)result.getProperty("UserID") %>" />
			<input type="hidden" name="ProfID" value="<%=userID %>"/>
			</form>
			</td>			
			<tr>

			<%
		}
		%>
		</table>
		<%
	}
%>


</div>
</div>

</body>
</html>
<%-- //[END all]--%>
