<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title></title>
        <link rel="stylesheet" href="">
        <link href="css/chatRoom.css" rel="stylesheet" type="text/css" media="all"/>
        <script src="js/chatRoom.js" type="text/javascript"></script>
    </head>
    <body onload="onLoadChatRoom()
                    ;">
        <div class="container clearfix">
            <div class="people-list" id="people-list">
                <ul class="list" id="userList">
                </ul>
            </div>

            <div class="chat">
                <div class="chat-header clearfix">
                    <input type = "radio"
                           name = "radType"
                           id = "webSocket"                           
                           value = "Via webSocket"
                           onclick="onSelectCommunicationType();"/>
                    <label for = "radWebSocket">Via websocket</label>

                    <input type = "radio"
                           name = "radType"
                           id = "xmlRequest"
                           value = "Via xmlhttpRequest"
                           checked ="checked"
                           onclick="onSelectCommunicationType();"
                           />
                    <label for = "radXmlHttpRequest">Via xmlhttpRequest</label>
                    <button onclick="exit();" class="buttonExit">Sair</button>
                </div> 

                <div class="chat-history" id="divMessageList">
                    <ul id="messageList" style="overflow:auto">
                    </ul>
                </div> 

                <div class="chat-message clearfix">
                    <textarea name="msg" form="formMsg" id="msg" placeholder ="Digite sua mensagem aqui" rows="3" required onkeydown="pressed(event);"></textarea>

                    <i class="fa fa-file-o"></i> &nbsp;&nbsp;&nbsp;
                    <i class="fa fa-file-image-o"></i>
                    <button onclick="sendMessage();">Enviar</button>
                </div> 
            </div> 
        </div> 
    </body>
</html>