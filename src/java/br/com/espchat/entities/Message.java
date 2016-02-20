package br.com.espchat.entities;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import br.com.espchat.util.Util;
import java.text.SimpleDateFormat;
import java.util.Base64;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Transient;
import org.json.simple.JSONObject;

@Entity
@Table(name = "MENSAGEM")
public class Message implements Serializable {

    @Transient
    private SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(name = "TEXTO", length = 3000, nullable = false)
    private String text;

    @ManyToOne
    @JoinColumn(name = "APELIDO")
    private User user;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "QUANDO")
    private Date when;

    public Message() {
        when = new Date();
        text = "nada";
    }

    public static Message of(User user, String msg, Date when) {
        Message message = new Message();
        message.setText(msg);
        message.setUser(user);
        message.setWhen(when);
        return message;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return getUser() + " em " + Util.sdf.format(getWhen()) + " disse:" + getText();
    }

    public Long getId() {
        return id;
    }

    public Date getWhen() {
        return when;
    }

    public void setWhen(Date when) {
        this.when = when;
    }

    public String getJSON() {
        JSONObject jsonMessage = new JSONObject();
        jsonMessage.put("name", this.getUser().getName());
        jsonMessage.put("nickName", this.getUser().getNickName());
        jsonMessage.put("message", this.getText());
        jsonMessage.put("when", sdf.format(this.getWhen()));
        if (user.getUrlPhoto() != null) {
            jsonMessage.put("urlPhoto", user.getUrlPhoto());
        }
        if (user.getPhoto() != null) {
            jsonMessage.put("photo", Base64.getEncoder().encodeToString(user.getPhoto()));
        }
        return jsonMessage.toJSONString();
    }

}
