package br.com.espchat.controller;

import br.com.espchat.entities.UserList;
import br.com.espchat.entities.User;
import br.com.espchat.util.Constants;
import java.util.logging.Logger;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 * Web application lifecycle listener.
 *
 * @author Edson Martins
 */
public class EspChatSessionListener implements HttpSessionListener {
    
    static Logger LOG = Logger.getLogger(EspChatSessionListener.class.getName());

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        LOG.info("Sessão criada");
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        LOG.info("Sessão destruida");
        /**
         * Sessão destruída remove o usuário da lista de usuários conectados.
         */
        User user =(User) se.getSession().getAttribute(Constants.LOGGED_USER);
        UserList listaUsuarios = (UserList) se.getSession().getServletContext().getAttribute(Constants.USER_LIST);
        listaUsuarios.getUsers().remove(user);
    }
}
