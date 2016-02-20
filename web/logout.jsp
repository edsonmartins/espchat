<%@page import="br.com.espchat.util.Constants"%>
<%
   /**
    * Invalida a sessão do usuário e redireciona para a página de login.
    */
   session.invalidate();
   response.sendRedirect(Constants.LOGIN_PAGE);
%>