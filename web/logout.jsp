<%@page import="br.com.espchat.util.Constants"%>
<%
   /**
    * Invalida a sess�o do usu�rio e redireciona para a p�gina de login.
    */
   session.invalidate();
   response.sendRedirect(Constants.LOGIN_PAGE);
%>