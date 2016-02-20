package br.com.espchat.entities;

/**
 *
 * @author Edson Martins
 */
public class MessageControl {

    private Message message;
    private boolean read;

    public static MessageControl of(Message message) {
        MessageControl messageControl = new MessageControl(message);
        return messageControl;
    }

    private MessageControl(Message message) {
        this.message = message;
        this.read = false;
    }

    public Message getMessage() {
        return message;
    }

    public void read() {
        this.read = true;
    }
    
    public boolean isRead(){
        return read;
    }

}
