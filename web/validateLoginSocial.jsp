<%@page import="java.net.URLDecoder"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="org.imgscalr.Scalr.Mode"%>
<%@page import="org.imgscalr.Scalr.Mode"%>
<%@page import="org.imgscalr.Scalr"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.net.URL"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="br.com.espchat.entities.UserList"%>
<%@page import="br.com.espchat.entities.User"%>
<%@page import="br.com.espchat.util.EntityManagerProvider"%>
<%@page import="br.com.espchat.delegator.PersistenceDelegator"%>
<%@page import="br.com.espchat.entities.UserType"%>
<%@page import="br.com.espchat.util.Constants"%>
<%
    /**
     * Obtém os dados do login social
     */
    String loginSocialType = request.getParameter(Constants.LOGIN_SOCIAL_TYPE);
    String name = request.getParameter(Constants.NAME);
    String id = request.getParameter(Constants.ID);
    String nickName = id + "@" + loginSocialType;
    String urlPhoto = request.getParameter(Constants.URL_PHOTO);

    /**
     * Registra o usuário do login social
     */
    UserType userType = UserType.getUserType(loginSocialType);

    /**
     * Obtém classe responsável por persistir os dados
     */
    PersistenceDelegator persistence = PersistenceDelegator.createInstance(EntityManagerProvider.getInstance().getEntityManager());

    /**
     * Localiza usuário pelo seu nickName e tipo.
     */
    User user = persistence.findUserByNickName(nickName, userType);

    /**
     * Se não encontrar o usuário do login social, registra o mesmo.
     */
    if (user == null) {
        user = persistence.addNewUser(nickName, userType, name, "", null, urlPhoto);
    }

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
%>