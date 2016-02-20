/**
 * 
 * Utilização do SDK do Facebook para realização do login social.
 */

var
  nameFacebook = null;
  idFacebook = null;
  urlPhoto = null;
  
/**
 * Busca os dados do usuário no facebook. Inclusive a url para sua foto.
 * @returns {undefined}
 */
        
function getUserData() {
    FB.api('/me', function (response) {
        console.log(response);
        nameFacebook = response.name;
        idFacebook = response.id;
        FB.api('/me/picture?type=normal', function (response) {
            urlPhoto = encodeURIComponent(response.data.url);
            console.log(response.data.url);
            console.log(urlPhoto);
            connectRoomChatWithFacebookLogin();
        });
    });
}

window.fbAsyncInit = function () {
    /**
     * Inicializa o SDK do facebook
     * appId: É referente o ID da sua aplicação que deve ser criada na pagina do facebook developers.
     */
    FB.init({
        appId: '1756157087938772',
        xfbml: true,
        version: 'v2.5'
    });

    /*
     * Atualiza sessão do usuário caso ele solicitado para manter conectado
     */
    FB.getLoginStatus(function (response) {
        if (response.status === 'connected') {
            // usuário autorizado
        } else {
            // usuário não autorizado
        }
    });
};

/*
 * Carrega o JavaScript SDK
 */
(function (d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {
        return;
    }
    js = d.createElement(s);
    js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

/*
 * Adiciona o evento onClick ao botão de login do Facebook.
 */
var btnLogin = document.getElementById('loginBtn');
btnLogin.addEventListener('click', function () {
    //Executa o login
    FB.login(function (response) {
        if (response.authResponse) {
            //usuário autorizou sua aplicação
            btnLogin.style.display = 'none';
            getUserData();
        }
    }, {scope: 'email,public_profile', return_scopes: true});
}, false);


/**
 * Cria uma conexão XMLHttpRequest para validação do login social
 * no EspChat.
 * @returns {XMLHttpRequest}
 */
function getXMLHttpRequest() {
    var xmlHttpReq = false;
    if (window.XMLHttpRequest) {
        xmlHttpReq = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        try {
            xmlHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (exp1) {
            try {
                xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (exp2) {
                xmlHttpReq = false;
            }
        }
    }
    return xmlHttpReq;
}

/**
 * Valida o login social no EspChat e redireciona para a sala de bate-papo.
 * @returns {undefined}
 */
function connectRoomChatWithFacebookLogin() {
    var request = getXMLHttpRequest();
    request.open("GET", "validateLoginSocial.jsp?"+"loginSocialType=facebook&name="+nameFacebook+"&id="+idFacebook+"&urlPhoto="+urlPhoto, false);
    request.send(null);

    if (request.status === 200) {
        window.location = "chatRoom.jsp";
    } else {
        console.log("erro");
    }
}