<%@page import="org.imgscalr.Scalr.Mode"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="org.imgscalr.Scalr"%>
<%@page import="br.com.espchat.entities.UserType"%>
<%@page import="br.com.espchat.entities.User"%>
<%@page import="br.com.espchat.util.EntityManagerProvider"%>
<%@page import="br.com.espchat.delegator.PersistenceDelegator"%>
<%@page import="br.com.espchat.util.Constants"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     * Obtém parâmetros enviados pela página de login para registrar um novo
     * usuário.
     */
    String nickName = "";
    String password = "";
    String name = "";
    byte[] photo = null;

    /**
     * Divide o conteúdo do formulário em partes obtendo os parâmetros
     * e o arquivo que contém a foto do novo usuário.
     */
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if (!isMultipart) {
        throw new RuntimeException("Formato incorreto de registro de usuário.");
    } else {
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List items = null;
        try {
            items = upload.parseRequest(request);
        } catch (FileUploadException e) {
            e.printStackTrace();
        }
        Iterator itr = items.iterator();
        while (itr.hasNext()) {
            FileItem item = (FileItem) itr.next();

            if (item.isFormField()) {
                String fieldName = item.getFieldName();
                String fieldValue = item.getString();

                if (fieldName.equals(Constants.NICK_NAME)) {
                    nickName = fieldValue;
                } else if (fieldName.equals(Constants.PASSWORD)) {
                    password = fieldValue;
                } else if (fieldName.equals(Constants.NAME)) {
                    name = fieldValue;
                }
            } else {
                if (!item.getContentType().equals(Constants.IMAGE_PNG)) {
                    session.setAttribute(Constants.REGISTER_ERROR, Constants.IMAGE_FORMAT_INVALID);
                    response.sendRedirect(Constants.LOGIN_PAGE);
                }
                /**
                 * Redimensiona a foto do usuário para 55x55
                 */
                photo = item.get();
                ByteArrayInputStream bis = new ByteArrayInputStream(photo);
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                BufferedImage image = ImageIO.read(bis);                
                BufferedImage resizedImage = Scalr.resize(image, Mode.FIT_EXACT, 55, Scalr.OP_ANTIALIAS);
                ImageIO.write(resizedImage, Constants.PNG, bos);
                photo = bos.toByteArray();
            }
        }
    }

    /**
     * Armazena os dados na sessão do usuário
     */
    session.setAttribute(Constants.NICK_NAME, nickName);
    session.setAttribute(Constants.PASSWORD, password);
    session.setAttribute(Constants.NAME, name);

    /**
     * Obtém classe responsável por persistir os dados
     */
    PersistenceDelegator persistence = PersistenceDelegator.createInstance(EntityManagerProvider.getInstance().getEntityManager());

    /**
     * Localiza usuário pelo seu nickName e tipo.
     */
    User user = persistence.findUserByNickName(nickName, UserType.ESPCHAT);

    /**
     * Verifica se o usuário já está registrado
     */
    if (user != null) {
        session.setAttribute(Constants.REGISTER_ERROR, Constants.USER_ALREADY_REGISTERED);
    } else {
        /**
         * Adiciona o novo usuário no banco de dados.
         */
        persistence.addNewUser(nickName, UserType.ESPCHAT, name, password, photo, null);
        session.setAttribute(Constants.REGISTER_SUCCESS, Constants.USER_REGISTERED_WITH_SUCCESS);
    }
    /**
     * Redireciona para a página de login.
     */
    response.sendRedirect(Constants.LOGIN_PAGE);


%>