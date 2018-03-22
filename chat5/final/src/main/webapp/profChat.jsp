<%-- //[START all]--%>
<%@page import="com.google.appengine.api.datastore.Entity"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.guestbook.Greeting" %>
<%@ page import="com.example.guestbook.Guestbook" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>

<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    String userID = request.getParameter("UserID");
    String profID = request.getParameter("ProfID");
    if (profID == null) {
        response.sendRedirect("./login.jsp");
    }
    DatastoreService dataStore = DatastoreServiceFactory.getDatastoreService();
    com.google.appengine.api.datastore.Key personKey = KeyFactory.createKey("Person", profID);
	Entity person = dataStore.get(personKey);
	
	String userName = (String) person.getProperty("Name");
%>


<%-- //[START datastore]--%>
<%
    // Create the correct Ancestor key
      Key<Guestbook> theBook = Key.create(Guestbook.class, guestbookName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
      List<Greeting> greetings = ObjectifyService.ofy()
          .load()
          .type(Greeting.class) // We want only Greetings
          .ancestor(theBook)    // Anyone in this book
          .order("-date")       // Most recent first - date is indexed.
          .limit(5)             // Only show 5 of them.
          .list();

    if (greetings.isEmpty()) {
%>
<p>No messages.</p>
<%
    } else {
%>
<p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>
<%
      // Look at all of our greetings
        for (Greeting greeting : greetings) {
            pageContext.setAttribute("greeting_content", greeting.content);
            String author;
            if (greeting.author_id == null) {
                author = "An anonymous person";
            } else {
                author = greeting.author_id;
                String author_id = greeting.author_id;
                if (profID != null && profID.equals(author_id)) {
                    author += userName +" (You)";
                }
            }
            pageContext.setAttribute("greeting_user", author);
%>
<p><b>${fn:escapeXml(greeting_user)}</b> wrote:</p>
<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
<%
        }
    }
%>

<form action="/sign2" method="post">
    <div><textarea name="content" rows="3" cols="60"></textarea></div>
    <div><input type="submit" value="Post Greeting"/></div>
    <input type="hidden" name="UserID" value="<%=userID%>"/>
    <input type="hidden" name="ProfID" value="<%=profID%>"/>
    <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
</form>

</body>
</html>
<%-- //[END all]--%>
