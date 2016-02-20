package br.com.espchat.util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

/**
 *
 * @author edson
 */
public class EntityManagerProvider {

    private static final EntityManagerProvider INSTANCE = new EntityManagerProvider();

    private final EntityManagerFactory factory;

    private EntityManagerProvider() {
        this.factory = Persistence.createEntityManagerFactory("espchatPU");
    }

    public static EntityManagerProvider getInstance() {
        return INSTANCE;
    }

    public EntityManagerFactory getFactory() {
        return factory;
    }

    public EntityManager createEntityManager() {
        return factory.createEntityManager();
    }
}
