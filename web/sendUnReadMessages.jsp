<%@page import="br.com.espchat.entities.User"%>
<%@page import="br.com.espchat.entities.UserList"%>
<%@page import="br.com.espchat.entities.MessageList"%>
<%@page import="br.com.espchat.util.Constants"%>
<%

    /**
     * Obtém a lista de usuários
     */
    UserList userList = (UserList) session.getServletContext().getAttribute(Constants.USER_LIST);
    /**
     * Obtém o usuário logado
     */
    User user = (User) session.getAttribute(Constants.LOGGED_USER);

    /**
     * Envia as mensagens para o usuário
     */
    response.setContentType("application/json");
    response.setCharacterEncoding("utf-8");
    String _response = userList.getMessagesByUserJSON(user, Constants.UNREAD_MESSAGES);
    System.out.println(_response);
    out.print(_response);
    out.flush();

%>