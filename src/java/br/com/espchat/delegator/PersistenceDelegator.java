package br.com.espchat.delegator;

import br.com.espchat.entities.Message;
import br.com.espchat.entities.User;
import br.com.espchat.entities.UserType;
import br.com.espchat.entities.User_;
import java.util.Date;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

/**
 *
 * @author Edson Martins
 */
public class PersistenceDelegator {

    static Logger LOG = Logger.getLogger(PersistenceDelegator.class.getName());

    private EntityManager em;

    public static PersistenceDelegator createInstance(EntityManager em) {
        return new PersistenceDelegator(em);
    }

    private PersistenceDelegator(EntityManager em) {
        this.em = em;
    }

    /**
     * Busca um usuário pelo seu apelido e tipo
     *
     * @param nickName
     * @return
     */
    public User findUserByNickName(String nickName, UserType userType) {
        /**
         * Busca o usuário usando critéria e o metamodel gerado para a classe
         * User = User_
         */
        LOG.info("Buscando usuário "+nickName+" : "+userType);
        
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<User> cq = cb.createQuery(User.class);
        Root<User> root = cq.from(User.class);
        cq.select(root).where(cb.and(cb.equal(root.get(User_.nickName), nickName)), cb.equal(root.get(User_.userType), userType));
        
        TypedQuery<User> query = em.createQuery(cq);
        User userFound = null;
        try {
            userFound = query.getSingleResult();
            LOG.info("Usuário "+nickName+" encontrado.");
        } catch (NoResultException e) {
            LOG.info("Usuário "+nickName+" NÃO encontrado.");
        }

        return userFound;
    }

    /**
     * Adiciona um novo usuário
     *
     * @param nickName Apelido
     * @param userType Tipo de usuário: ESPCHAT, FACEBOOK, TWITTER E GOOGLE_PLUS
     * @param name Nome do usuário
     * @param password Senha
     * @param photo Foto
     * @return Novo usuário
     */ 
    public User addNewUser(String nickName, UserType userType, String name, String password, byte[] photo, String urlPhoto) {
        /**
         * Registrando novo usuário
         */
        LOG.info("Registrando usuário "+nickName+" : "+userType);
        User user = User.of(nickName, userType, name, password, photo, urlPhoto);
        em.getTransaction().begin();
        em.persist(user);
        em.getTransaction().commit();
        return user;
    }
    
    public Message addMessage(User user, String msg){
        /**
         * Adicionando mensagem
         */
        LOG.info("Adicionando mensagem "+msg+" do usuário "+user.getNickName());
        Message message = Message.of(user, msg, new Date());
        em.getTransaction().begin();
        em.persist(message);
        em.getTransaction().commit();
        return message;
    }
}
