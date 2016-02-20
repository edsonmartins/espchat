package br.com.espchat.entities;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class MessageList implements Serializable {
    
    private SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    public static int MAX_OF_MESSAGES=100;
    private List<Message> messages;
    private int maxOfMessages = MAX_OF_MESSAGES;

    public MessageList(int maxOfMessages) {
        messages = new ArrayList<>();
        this.maxOfMessages = maxOfMessages;
    }

    public List<Message> getMessages() {
        return messages;
    }

    @Override
    public String toString() {
        return messages.toString();
    }
    
    public void add(Message message){
        messages.add(message);
        if (messages.size()>maxOfMessages){
            messages.remove(0);
        }
    }
    
    
    public String getJSON() {
        JSONArray list = new JSONArray();
        for (Message message : messages) {
            JSONObject jsonMessage = new JSONObject();
            jsonMessage.put("name", message.getUser().getName());
            jsonMessage.put("nickName", message.getUser().getNickName());
            jsonMessage.put("message", message.getText());
            jsonMessage.put("when", sdf.format(message.getWhen()));
            list.add(jsonMessage);
        }
        return list.toJSONString();
    }

}
