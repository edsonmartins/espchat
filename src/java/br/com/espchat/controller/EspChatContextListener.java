package br.com.espchat.controller;

import br.com.espchat.delegator.PersistenceDelegator;
import br.com.espchat.entities.Message;
import br.com.espchat.entities.MessageList;
import br.com.espchat.entities.User;
import br.com.espchat.entities.UserList;
import br.com.espchat.util.Constants;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import br.com.espchat.util.EntityManagerProvider;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

/**
 * Web application lifecycle listener.
 *
 * @author Edson Martins
 */
@ServerEndpoint(value = "/espchatMessage", configurator = SessionWebSocketConfigurator.class)
public class EspChatContextListener implements ServletContextListener {

    private UserList userList = new UserList();
    private MessageList messageList = new MessageList(MessageList.MAX_OF_MESSAGES);
    private static final Map<Session, EndpointConfig> usersWebSocket = Collections.synchronizedMap(new HashMap<>());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        EntityManagerProvider.getInstance().getEntityManager();
        /**
         * Inicializa objetos de controle de usuários e de mensagens
         */
        sce.getServletContext().setAttribute(Constants.USER_LIST, userList);
        sce.getServletContext().setAttribute(Constants.MESSAGE_LIST, messageList);
        sce.getServletContext().setAttribute(Constants.USERS_WEBSOCKET, usersWebSocket);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }

    @OnOpen
    public void open(Session session, EndpointConfig config) {
        usersWebSocket.put(session, config);
    }

    @OnClose
    public void onClose(Session userSession) {

    }

    @OnError
    public void onError(Throwable t) {
        t.printStackTrace();
    }

    @OnMessage
    public void onMessage(String msg, Session userSession) {
        EndpointConfig config = usersWebSocket.get(userSession);
        HttpSession userSessionHttp = (HttpSession) config.getUserProperties().get(Constants.HTTP_SESSION);
        /**
         * Obtém classe responsável por persistir os dados
         */
        PersistenceDelegator persistence = PersistenceDelegator.createInstance(EntityManagerProvider.getInstance().getEntityManager());

        /**
         * Obtém o usuário logado
         */
        User user = (User) userSessionHttp.getAttribute(Constants.LOGGED_USER);

        /**
         * Salva a mensagem
         */
        Message message = persistence.addMessage(user, msg);

        /**
         * Adiciona a mensagem na lista de mensagens globais no cache e na lista
         * de mensagens de cada usuário conectado
         */
        MessageList messageList = (MessageList) userSessionHttp.getServletContext().getAttribute(Constants.MESSAGE_LIST);
        UserList userList = (UserList) userSessionHttp.getServletContext().getAttribute(Constants.USER_LIST);
        userList.add(message, user);
        messageList.add(message);

        /**
         * Envia a mensagem para todos os usuários conectados via WEBSOCKET
         */
        for (Session session : usersWebSocket.keySet()) {
            try {
                session.getBasicRemote().sendText(message.getJSON());
            } catch (IOException ex) {
                Logger.getLogger(EspChatContextListener.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
