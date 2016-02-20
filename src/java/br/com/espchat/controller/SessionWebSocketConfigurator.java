package br.com.espchat.controller;

import br.com.espchat.util.Constants;
import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;

/**
 *
 * @author Edson Martins
 */
public class SessionWebSocketConfigurator extends ServerEndpointConfig.Configurator {

    public void modifyHandshake(ServerEndpointConfig config,
            HandshakeRequest request,
            HandshakeResponse response) {
        /**
         * Adiciona a sessão http como uma propriedade da configuração do usuário
         * do websocket para uso no recebimento das mensagens.
         */
        HttpSession httpSession = (HttpSession) request.getHttpSession();
        config.getUserProperties().put(Constants.HTTP_SESSION, httpSession);
    }
}
