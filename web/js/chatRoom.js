/**
 * 
 * Funções JavaScript responsávies por tratar o fluxo de solicitações da sala de bate-papo.
 */

var wsUri = "ws://" + document.location.host + "/espchat/espchatMessage";
var client = new WebSocket(wsUri);
var httpRequestMessageList = getXMLHttpRequest();
var timeoutRefreshUserList = null;
var timeoutRefreshMessageList = null;
var cacheMessage = new Array();

/**
 * Retorna um objeto para requisições http. 
 * @returns {undefined}
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
 * Evento para tratar ENTER para enviar mensagem.
 * @returns {undefined}
 */
function pressed(e) {
    e.preventDefault();
    if ((window.event ? event.keyCode : e.which) == 13) {
        sendMessage();
    }
}

/**
 * Envia uma mensagem para o servidor conforme a estratégia
 * selecionada: WEBSOCKET ou XMLHTTPREQUEST
 * @returns {undefined}
 */
function sendMessage() {
    var messageTextArea = document.getElementById("msg");
    var rbWebSocket = document.getElementById("webSocket");
    if (rbWebSocket.checked) {
        client.send(messageTextArea.value);
        messageTextArea.value = "";
    } else {
        var httpRequest = getXMLHttpRequest();
        httpRequest.onreadystatechange = function (event) {
            if (httpRequest.readyState === 4) {
                if (httpRequest.status === 200) {
                    messageTextArea.value = "";
                }
            }
        };
        // Envia a mensagem para o servlet responsável por recebê-las.
        httpRequest.open("GET", "receiveMessage.jsp?msg=" + messageTextArea.value, true);
        httpRequest.send(null);
    }
    messageTextArea.focus();
}

/**
 * Atribui as funções que irão atualizar a lista de usuários e as mensagens
 * @returns {undefined}
 */
function onLoadChatRoom() {
    timeoutRefreshUserList = setInterval(refreshUserList, 2000);
    timeoutRefreshMessageList = setInterval(refreshMessageList, 200);
}

/**
 * Cria um item contendo dados do usuário logado para adicionar na lista.
 * @param {type} user Usuário para criar o item da lista
 * @returns {item} Item criado
 */
function createUserItemHTML(user) {
    var userLi = document.createElement("li");
    userLi.className = "clearfix";
    var img = document.createElement("img");
    if (typeof user.urlPhoto !== "undefined") {
        img.src = decodeURIComponent(user.urlPhoto);
    } else if (typeof user.photo !== "undefined") {
        img.src = "data:image/png;base64," + user.photo;
    }
    img.style = "border-radius: 50%;";
    img.width = 55;
    img.height = 55;
    userLi.appendChild(img);

    var div = document.createElement("div");
    div.className = "about";
    userLi.appendChild(div);

    var divInterna = document.createElement("div");
    divInterna.className = "name";
    divInterna.appendChild(document.createTextNode(user.name));
    div.appendChild(divInterna);

    var divStatus = document.createElement("divStatus");
    divStatus.className = "status";

    var i = document.createElement("i");
    i.className = "fa fa-circle online";
    i.appendChild(document.createTextNode("online"));
    divStatus.appendChild(i);

    div.appendChild(divStatus);
    return userLi;
}

/**
 * Cria um item para representar uma mensagem.
 * @param {message} Mensagem 
 * @param {type} Tipo do item: A DIREITA ou A ESQUERDA
 * @param {id} Número da mensagem
 * @returns {item}
 */
function createMessageItemHTML(message, type, id) {
    var divMessage = document.createElement("div");
    divMessage.id = "divMsg" + id;
    var imgSrc = null;
    if (typeof message.urlPhoto !== "undefined") {
        imgSrc = decodeURIComponent(message.urlPhoto);
    } else if (typeof message.photo !== "undefined") {
        imgSrc = "data:image/png;base64," + message.photo;
    }

    if (type === 1) {
        divMessage.className = "m-b";
        divMessage.innerHTML =
                "<img class='pull-left thumb-sm avatar' src=" + imgSrc + " alt='...'></a> " +
                "<div class='m-l-sm inline'> " +
                "<div class='pos-rlt wrapper bg-primary r r-2x'> " +
                "<span class='arrow left pull-up'></span> " +
                "<p class='m-b-none'>" + message.message + "</p> " +
                "</div> " +
                "<small class='text-muted'><i class='fa fa-ok text-success'></i>" + message.when + "</small> " +
                "</div>";
    } else {
        divMessage.className = "m-b text-right";
        divMessage.innerHTML = "<img  class='pull-right thumb-sm avatar' src=" + imgSrc + " class='img-circle' alt='...'></a>" +
                "<div class='m-r-sm inline text-left'>" +
                "    <div class='pos-rlt wrapper bg-primary r r-2x'>" +
                "        <span class='arrow right pull-up arrow-primary'></span>" +
                "        <p class='m-b-none'>" + message.message + "</p>" +
                "    </div>" +
                "    <small class='text-muted'>" + message.when + "</small>" +
                "</div>";
    }
    return divMessage;
}

/**
 * Atualiza a lista de usuários conforme o intervalo agendado.
 */
function refreshUserList() {
    var httpRequest = getXMLHttpRequest();
    clearInterval(timeoutRefreshUserList);
    httpRequest.onreadystatechange = function (event) {
        if (httpRequest.readyState === 4) {
            if (httpRequest.status === 200) {
                var userList = document.getElementById("userList");
                while (userList.firstChild) {
                    userList.removeChild(userList.firstChild);
                }
                var string = httpRequest.responseText;
                var userArray = JSON.parse(string);
                userArray.forEach(function (user) {
                    var userLi = createUserItemHTML(user);
                    userList.appendChild(userLi);
                });
            }
            timeoutRefreshUserList = setInterval(refreshUserList, 2000);
        }
    };
    httpRequest.open("GET", "userListInfo.jsp", true);
    httpRequest.send(null);
}

/**
 * Objeto mensagem
 */
function Message(name, nickName, message, when, urlPhoto, photo) {
    this.name = name;
    this.nickName = nickName;
    this.message = message;
    this.when = when;
    this.urlPhoto = urlPhoto;
    this.photo = photo;
}

/**
 * Atualiza a lista de mensagens via XMLHTTPREQUEST
 */
function refreshMessageList() {
    clearInterval(timeoutRefreshMessageList);
    if (cacheMessage.length === 0) {
        httpRequestMessageList.onreadystatechange = processMessages;
        httpRequestMessageList.open("GET", "sendAllMessages.jsp", true);
        httpRequestMessageList.send(null);
    } else {
        httpRequestMessageList.onreadystatechange = processMessages;
        httpRequestMessageList.open("GET", "sendUnReadMessages.jsp", true);
        httpRequestMessageList.send(null);
    }
}

/**
 * Processa as mensagens recebidas e apresenta na tela.
 * @param {event} Evento
 */
function processMessages(event) {
    if (httpRequestMessageList.readyState === 4) {
        if (httpRequestMessageList.status === 200) {
            var messageArray = JSON.parse(httpRequestMessageList.responseText);
            var foundMessage = false;
            messageArray.forEach(function (msg) {
                cacheMessage.push(new Message(msg.name, msg.nickName, msg.message, msg.when, msg.urlPhoto, msg.photo));
                foundMessage = true;
            });
            if (foundMessage) {
                displayMessages();
            }
            timeoutRefreshMessageList = setInterval(refreshMessageList, 200);

        } else {
            console.log("ocorreu um erro atualizando lista de mensagens.");
        }

    }
}

/**
 * Apresenta as mensagens na tela.
 */
function displayMessages() {
    var messageList = document.getElementById("messageList");
    while (messageList.firstChild) {
        messageList.removeChild(messageList.firstChild);
    }

    var type = 1;
    var i = 1;
    var lastMessage = undefined;
    cacheMessage.forEach(function (msg) {
        var messageLi = createMessageItemHTML(msg, type, i);
        messageList.appendChild(messageLi);
        lastMessage = messageLi;
        if (type === 1) {
            type = 2;
        } else {
            type = 1;
        }
        i++;
    });
    lastMessage.scrollIntoView();
}

/**
 * Seleciona o tipo de comunicação: WEBSOCKET ou XMLHTTPREQUEST
 */
function onSelectCommunicationType(event) {
    var rbWebSocket = document.getElementById("webSocket");
    if (rbWebSocket.checked) {
        clearInterval(timeoutRefreshMessageList);
        client.onmessage = function (msg) {
            var msgJson = JSON.parse(msg.data);
            cacheMessage.push(new Message(msgJson.name, msgJson.nickName, msgJson.message, msgJson.when, msgJson.urlPhoto, msgJson.photo));
            displayMessages();

        };
        client.onerror = function (error) {
            console.log('WebSocket Error ' + error);
            window.location = "index.jsp";
        };

    } else {
        timeoutRefreshMessageList = setInterval(refreshMessageList, 300);
    }
}

/**
 * Invalida a sessão e redireciona para a página inicial.
 */
function exit() {
    var httpRequest = getXMLHttpRequest();
    httpRequest.onreadystatechange = function (event) {
        if (httpRequest.readyState === 4) {
            if (httpRequest.status === 200) {
                window.location = "index.jsp";
            }
        }
    };
    httpRequest.open("GET", "logout.jsp", true);
    httpRequest.send(null);
}
