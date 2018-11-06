package co.yperea.application;

import co.yperea.application.EntityManager;

public class ManagerFactory<T> {

    public static EntityManager getManager(Class entityType) {
        return new EntityManager(entityType);
    }
}
