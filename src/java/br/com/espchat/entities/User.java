package br.com.espchat.entities;

import java.io.Serializable;
import java.util.Objects;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.Index;
import javax.persistence.Lob;
import javax.persistence.Table;

@Entity
@Table(name = "USUARIO",
       indexes = {@Index(name = "UK_USUARIO_APELIDO",  columnList = "APELIDO,TP_USUARIO", unique = true)})
public class User implements Serializable, Comparable<User> {

    @Id
    @Column(name="APELIDO", length = 500)
    private String nickName;
    
    @Column(name="NOME", length = 100)
    private String name;
    
    @Column(name="SENHA", length = 200, nullable = false)
    private String password;
    
    @Enumerated(EnumType.STRING)
    @Column(name="TP_USUARIO", length = 30, nullable = false)
    private UserType userType;
    
    @Lob
    @Column(name="FOTO")
    private byte[] photo;
    
    @Column(name="URL_FOTO", length = 5000)
    private String urlPhoto;

    public User() {
        nickName = "sem apelido";
        name = "sem nome";
        photo = new byte[]{};
    }
    
    private User (String nickName, UserType userType, String name, String password, byte[] photo, String urlPhoto){
        this.name = name;
        this.nickName = nickName;
        this.password = password;
        this.photo = photo;
        this.userType = userType;
        this.urlPhoto = urlPhoto;
    }
    
    public static User of(String nickName, UserType userType, String name,String password, byte[] photo, String urlPhoto){
        return new User(nickName,userType,name,password,photo, urlPhoto);
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        if (nickName != null) {
            this.nickName = nickName;
        }
    }

    @Override
    public String toString() {
        return getNickName();
    }

    @Override
    public int compareTo(User o) {
        return getNickName().compareTo(o.getNickName());
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 47 * hash + Objects.hashCode(this.getNickName());
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final User other = (User) obj;
        if (!Objects.equals(this.nickName, other.nickName)) {
            return false;
        }
        return true;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public byte[] getPhoto() {
        return photo;
    }

    public void setPhoto(byte[] photo) {
        this.photo = photo;
    }


    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    } 

    /**
     * @return the userType
     */
    public UserType getUserType() {
        return userType;
    }

    /**
     * @param userType the userType to set
     */
    public void setUserType(UserType userType) {
        this.userType = userType;
    }

    /**
     * @return the urlPhoto
     */
    public String getUrlPhoto() {
        return urlPhoto;
    }

    /**
     * @param urlPhoto the urlPhoto to set
     */
    public void setUrlPhoto(String urlPhoto) {
        this.urlPhoto = urlPhoto;
    }
    

}
