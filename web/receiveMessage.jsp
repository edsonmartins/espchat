<%@page import="java.util.logging.Logger"%>
<%@page import="java.io.IOException"%>
<%@page import="javax.websocket.Session"%>
<%@page import="javax.websocket.EndpointConfig"%>
<%@page import="java.util.Map"%>
<%@page import="br.com.espchat.entities.UserList"%>
<%@page import="br.com.espchat.entities.MessageList"%>
<%@page import="br.com.espchat.entities.Message"%>
<%@page import="br.com.espchat.entities.User"%>
<%@page import="br.com.espchat.delegator.PersistenceDelegator"%>
<%@page import="br.com.espchat.util.EntityManagerProvider"%>
<%@page import="br.com.espchat.util.Constants"%>
<%

    /**
     * Recebe a mensagem enviado pelo usuário do bate papo e armazena na fila
     * para ser consumida pelo demais usuários do bate papo
     */
    String msg = request.getParameter(Constants.MESSAGE);

    /**
     * Obtém classe responsável por persistir os dados
     */
    PersistenceDelegator persistence = PersistenceDelegator.createInstance(EntityManagerProvider.getInstance().getEntityManager());

    /**
     * Obtém o usuário logado
     */
    User user = (User) session.getAttribute(Constants.LOGGED_USER);

    /**
     * Salva a mensagem
     */
    Message message = persistence.addMessage(user, msg);

    /**
     * Adiciona a mensagem na lista de mensagens globais no cache e na lista de
     * mensagens de cada usuário conectado.
     */
    MessageList messageList = (MessageList) session.getServletContext().getAttribute(Constants.MESSAGE_LIST);
    UserList userList = (UserList) session.getServletContext().getAttribute(Constants.USER_LIST);
    userList.add(message);
    messageList.add(message);

    /**
     * Envia a mensagem para os usuários conectados via webSocket.
     */
    Map<Session, EndpointConfig> usersWebSocket = (Map<Session, EndpointConfig>) session.getServletContext().getAttribute(Constants.USERS_WEBSOCKET);

    for (Session userSession : usersWebSocket.keySet()) {
        try {
            HttpSession userSessionHttp = (HttpSession) userSession.getUserProperties().get(Constants.HTTP_SESSION);
            /**
             * Envia para todos menos para o usuário que enviou a mensagem
             */
            if (!(userSessionHttp.equals(session))) {
                userSession.getBasicRemote().sendText(message.getJSON());
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }


%>