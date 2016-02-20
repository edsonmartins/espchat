<%@page import="br.com.espchat.entities.UserList"%>
<%@page import="br.com.espchat.util.Constants"%>
<%@page import="br.com.espchat.entities.UserType"%>
<%@page import="br.com.espchat.delegator.PersistenceDelegator"%>
<%@page import="java.util.List"%>
<%@page import="javax.persistence.TypedQuery"%>
<%@page import="javax.persistence.criteria.Root"%>
<%@page import="javax.persistence.criteria.CriteriaQuery"%>
<%@page import="javax.persistence.criteria.CriteriaBuilder"%>
<%@page import="javax.persistence.EntityManager"%>
<%@page import="br.com.espchat.util.EntityManagerProvider"%>
<%@page import="br.com.espchat.entities.User"%>
<%

    /**
     * Obtém parâmetros enviados pela página de login para validar ser o usuário
     * possuí um cadastro. Esta validação aplica-se apenas a usuários do tipo:
     * ESPCHAT. Demais usuários serão válidados pelas respectivas APIS.
     * (Facebook,Twitter,Google Plus). Serão cadastrados apenas a título de
     * histórico de participação na salda de bate-papo.
     *
     */
    String nickName = request.getParameter(Constants.NICK_NAME);
    String password = request.getParameter(Constants.PASSWORD);

    /**
     * Obtém classe responsável por persistir os dados
     */
    PersistenceDelegator persistence = PersistenceDelegator.createInstance(EntityManagerProvider.getInstance().createEntityManager());

    /**
     * Localiza usuário pelo seu nickName e tipo.
     */
    User user = persistence.findUserByNickName(nickName, UserType.ESPCHAT);

    /**
     * Se não encontrar o usuário redireciona para o login novamente.
     */
    if (user == null) {
        session.setAttribute(Constants.ERROR_MESSAGE, Constants.USER_OR_PASSWORD_INVALID);
        response.sendRedirect(Constants.LOGIN_PAGE);
    } else if (!(password.equals(user.getPassword()))) {
        /**
         * Valida a senha
         */
        session.setAttribute(Constants.ERROR_MESSAGE, Constants.USER_OR_PASSWORD_INVALID);
        response.sendRedirect(Constants.LOGIN_PAGE);
    } else {
        /**
         * Armazena o usuário na sessão http para uso posterior
         */
        session.setAttribute(Constants.LOGGED_USER, user);
        /**
         * Adiciona o usuário na lista de usuários logados
         */
        UserList userList = (UserList) session.getServletContext().getAttribute(Constants.USER_LIST);
        userList.add(user);
        /**
         * Redireciona para sala de bate papo
         */
        response.sendRedirect(Constants.ROOM_PAGE);
    }
%>