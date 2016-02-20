package br.com.espchat.util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 *
 * @author Edson Martins
 */
public class EntityManagerProvider {

    private static final EntityManagerProvider INSTANCE = new EntityManagerProvider();

    private final EntityManagerFactory factory;
    
    public ThreadLocal<EntityManager> ems = new ThreadLocal<>();

    private EntityManagerProvider() {
        this.factory = Persistence.createEntityManagerFactory("espchatPU");
    }

    public static EntityManagerProvider getInstance() {
        return INSTANCE;
    }

    public EntityManagerFactory getFactory() {
        return factory;
    }

    public EntityManager getEntityManager() {
        if (ems.get()==null){
            ems.set(factory.createEntityManager());
        }
        return ems.get();
    }
}
