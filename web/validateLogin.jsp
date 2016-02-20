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
     * Obt�m par�metros enviados pela p�gina de login para validar ser o usu�rio
     * possu� um cadastro. Esta valida��o aplica-se apenas a usu�rios do tipo:
     * ESPCHAT. Demais usu�rios ser�o v�lidados pelas respectivas APIS.
     * (Facebook,Twitter,Google Plus). Ser�o cadastrados apenas a t�tulo de
     * hist�rico de participa��o na salda de bate-papo.
     *
     */
    String nickName = request.getParameter(Constants.NICK_NAME);
    String password = request.getParameter(Constants.PASSWORD);

    /**
     * Obt�m classe respons�vel por persistir os dados
     */
    PersistenceDelegator persistence = PersistenceDelegator.createInstance(EntityManagerProvider.getInstance().createEntityManager());

    /**
     * Localiza usu�rio pelo seu nickName e tipo.
     */
    User user = persistence.findUserByNickName(nickName, UserType.ESPCHAT);

    /**
     * Se n�o encontrar o usu�rio redireciona para o login novamente.
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
         * Armazena o usu�rio na sess�o http para uso posterior
         */
        session.setAttribute(Constants.LOGGED_USER, user);
        /**
         * Adiciona o usu�rio na lista de usu�rios logados
         */
        UserList userList = (UserList) session.getServletContext().getAttribute(Constants.USER_LIST);
        userList.add(user);
        /**
         * Redireciona para sala de bate papo
         */
        response.sendRedirect(Constants.ROOM_PAGE);
    }
%>