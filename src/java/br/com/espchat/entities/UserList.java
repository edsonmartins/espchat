package br.com.espchat.entities;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class UserList implements Serializable {

    private SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    private Set<User> users;
    private Map<User, List<MessageControl>> messagesByUser;

    public UserList() {
        users = new TreeSet<>();
        messagesByUser = Collections.synchronizedMap(new LinkedHashMap<>());
    }

    public Set<User> getUsers() {
        return users;
    }

    @Override
    public String toString() {
        return users.toString();
    }

    public void add(User user) {
        users.add(user);
    }

    public void add(Message message) {
        for (User user : users) {
            if (!(messagesByUser.containsKey(user))) {
                messagesByUser.put(user, new ArrayList<>());
            }
            messagesByUser.get(user).add(MessageControl.of(message));
        }
    }

    public void add(Message message, User excludeUser) {
        for (User user : users) {
            if (!(user.equals(excludeUser))) {
                if (!(messagesByUser.containsKey(user))) {
                    messagesByUser.put(user, new ArrayList<>());
                }
                MessageControl mc = MessageControl.of(message);
                messagesByUser.get(user).add(mc);
            }
        }
    }

    public String getJSON() {
        JSONArray list = new JSONArray();
        for (User user : users) {
            JSONObject jsonUser = new JSONObject();
            jsonUser.put("name", user.getName());
            jsonUser.put("nickName", user.getNickName());
            if (user.getUrlPhoto() != null) {
                jsonUser.put("urlPhoto", user.getUrlPhoto());
            }
            if (user.getPhoto() != null) {
                jsonUser.put("photo", Base64.getEncoder().encodeToString(user.getPhoto()));
            }
            list.add(jsonUser);
        }
        return list.toJSONString();
    }

    public String getMessagesByUserJSON(User user, boolean allMessages) {
        JSONArray list = new JSONArray();
        if (messagesByUser.containsKey(user)) {

            for (MessageControl messageControl : messagesByUser.get(user)) {
                if ((!(messageControl.isRead()) || (allMessages))) {
                    JSONObject jsonUser = new JSONObject();
                    jsonUser.put("name", messageControl.getMessage().getUser().getName());
                    jsonUser.put("nickName", messageControl.getMessage().getUser().getNickName());
                    jsonUser.put("message", messageControl.getMessage().getText());
                    jsonUser.put("when", sdf.format(messageControl.getMessage().getWhen()));
                    if (messageControl.getMessage().getUser().getUrlPhoto() != null) {
                        jsonUser.put("urlPhoto", messageControl.getMessage().getUser().getUrlPhoto());
                    }
                    if (messageControl.getMessage().getUser().getPhoto() != null) {
                        jsonUser.put("photo", Base64.getEncoder().encodeToString(messageControl.getMessage().getUser().getPhoto()));
                    }
                    list.add(jsonUser);
                }
                messageControl.read();
            }
        }
        return list.toJSONString();
    }

}
