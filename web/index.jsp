<%@page import="br.com.espchat.util.Constants"%>

<html>
    <head>
        <title>EspChat</title>
        <link rel="shortcut icon" href="images/icon.ico"> 
        <link href="css/espchat.css" rel="stylesheet" type="text/css" media="all"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
        <script src="js/jquery.min.js"></script>
        <script src="js/easyResponsiveTabs.js" type="text/javascript"></script>       
        <script src="js/md5.js" type="text/javascript"></script>   

        <script type="text/javascript">
            $(document).ready(function () {
                $('#horizontalTab').easyResponsiveTabs({
                    type: 'default',
                    width: 'auto',
                    fit: true
                });
            });

            function executeLogin() {
                var httpRequest = getXMLHttpRequest();
                httpRequest.onreadystatechange = function (event) {
                    if (httpRequest.readyState === 4) {
                        if (httpRequest.status === 200) {
                        }
                    }
                };
                // Envia o usuário e a senha para validar o login
                var nickName = document.getElementById("nickName").value;
                var password = CriptoJS.MD5(document.getElementById("password"));
                httpRequest.open("GET", "validateLogin.jsp?nickName=" + nickName + "&password=" + password, true);
                httpRequest.send(null);
            }

        </script>	
    </head>
    <body>
        <%
            String errorMessage = " ";
            String registerError = " ";
            String nickName = "";
            String password = "";
            String name = "";

            if (session.getAttribute(Constants.ERROR_MESSAGE) != null) {
                errorMessage = session.getAttribute(Constants.ERROR_MESSAGE) + "";
            }

            if (session.getAttribute(Constants.REGISTER_ERROR) != null) {
                registerError = session.getAttribute(Constants.REGISTER_ERROR) + "";
                nickName = (String) session.getAttribute(Constants.NICK_NAME);
                password = (String) session.getAttribute(Constants.PASSWORD);
                name = (String) session.getAttribute(Constants.NAME);
            }

            if (session.getAttribute(Constants.REGISTER_SUCCESS) != null) {
                errorMessage = session.getAttribute(Constants.REGISTER_SUCCESS) + "";
            }

        %>
        <div class="head">
            <div class="logo">
                <div class="logo-top" style="text-align: center">
                    <h1>Espchat<br>Chat especialização web 2016</h1>
                    <img id="logouem" align="middle" src="images/logo-horizontal.svg" alt="Universidade Estadual de Maringá" style="width:120px;height:61px;">
                </div>			
            </div>		
            <div class="login">
                <div class="sap_tabs">
                    <div id="horizontalTab" style="display: block; width: 100%; margin: 0px;">
                        <ul class="resp-tabs-list">
                            <li class="resp-tab-item" aria-controls="tab_item-0" role="tab"><span>Login</span></li>
                            <li class="resp-tab-item" aria-controls="tab_item-1" role="tab"><label>/</label><span>Registre-se</span></li>
                            <div class="clearfix"></div>
                        </ul>				  	 
                        <div class="resp-tabs-container">
                            <div class="tab-1 resp-tab-content" aria-labelledby="tab_item-0">
                                <div class="login-top">
                                    <div class="error-Message" id="errorMessage"><% out.print(errorMessage);%></div>
                                    <form action="validateLogin.jsp" method="post">
                                        <input type="text" class="email" placeholder="Email" required="" name="nickName" id="nickName"/>
                                        <input type="password" class="password" placeholder="Senha" required="" name="password" id="password"/>
                                        <img id="photo" height="30px" width="25px" style="display: none"></img>
                                        <div class="login-bottom login-bottom1">
                                            <div class="submit">
                                                <input type="submit" value="LOGIN"/>
                                            </div>
                                            <ul>
                                                <li><p>Ou entre com</p></li>
                                                <li><a href="#" id="loginBtn" ><span class="fb"></span></a></li>
                                                <li><a href="#"><span class="twit"></span></a></li>
                                                <li><a href="#"><span class="google"></span></a></li>
                                            </ul>
                                            <div class="clear"></div>
                                        </div>	
                                    </form>
                                </div>
                            </div>
                            <div class="tab-1 resp-tab-content" aria-labelledby="tab_item-1" id="tabRegister">
                                <div class="login-top">
                                    <div class="error-Message" id="errorMessage"><% out.print(registerError);%></div>
                                    <form action="registerUser.jsp" method="post" enctype="multipart/form-data">
                                        <input type="text" class="name active" placeholder="Seu nome" required name="name" id="name" value="<%=name%>"/>
                                        <input type="text" class="email" placeholder="Email" required name="nickName" value="<%=nickName%>"/>
                                        <input type="password" class="password" placeholder="Senha" required name="password" value="<%=password%>"/>		
                                        <input type="file" class="inputSelFile" placeholder="Foto" required name="photo" accept="image/png"/>		
                                        <div class="login-bottom">
                                            <div class="submit">
                                                <input type="submit" value="REGISTRAR"/>
                                            </div>
                                            <ul>
                                                <li><p>Ou login com</p></li>
                                                <li><a href="#"><span class="fb"></span></a></li>
                                                <li><a href="#"><span class="twit"></span></a></li>
                                                <li><a href="#"><span class="google"></span></a></li>
                                            </ul>
                                            <div class="clear"></div>
                                        </div>	
                                    </form>                                    
                                </div>

                            </div>							
                        </div>	
                    </div>
                </div>	
            </div>	
            <div class="clear"></div>
        </div>	
    </body>
    <script src="js/loginFacebook.js" type="text/javascript"></script>
</html>