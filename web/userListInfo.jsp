<%@page import="java.util.Date"%>
<%@page import="br.com.espchat.entities.UserList"%>
<%@page import="br.com.espchat.util.Constants"%>
<%
    /**
     * Obtém a lista de usuários conectados e envia no formato JSON.
     */
    UserList userList = (UserList) session.getServletContext().getAttribute(Constants.USER_LIST);    
    response.setContentType("application/json");
    response.setCharacterEncoding("utf-8");
    out.print(userList.getJSON());
    out.flush();
%>