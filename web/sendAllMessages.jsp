<%@page import="br.com.espchat.entities.User"%>
<%@page import="br.com.espchat.entities.MessageList"%>
<%@page import="br.com.espchat.entities.UserList"%>
<%@page import="br.com.espchat.util.Constants"%>
<%

    /**
     * Obtém a lista de usuários conectados.
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
    out.print(userList.getMessagesByUserJSON(user, Constants.ALL_MESSAGES));
    out.flush();    


%>