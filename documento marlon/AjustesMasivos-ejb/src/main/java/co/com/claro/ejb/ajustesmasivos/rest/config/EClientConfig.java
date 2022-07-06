package co.com.claro.ejb.ajustesmasivos.rest.config;

import co.com.claro.inspira.utilities.common.client.ClientConfig;

/**
 * Enum con la configuracion de los clientes de los servicio utilizados en la
 * aplicacion
 *
 * @author Cesar Gordillo - Global Hitss
 *
 */
public class EClientConfig implements ClientConfig {

    public static final String SUBSCRIBER_PACKAGE = "subscriberpackage.info";
    public static final String CUSTOMER_PROFILE = "customerprofile";

    private final String endPoint;
    private String minIdle;
    private String maxIdle;
    private String maxTotal;

    /**
     * Constructor
     *
     * @param serviceName
     * @param numberService
     */
    public EClientConfig(String serviceName) {
        this.endPoint = findEndPoint(serviceName);
    }

    @Override
    public String getEndPoint() {
        return endPoint;
    }

    /**
     * Obtiene el valor del endPoint para el cliente especificado
     *
     * @param clientName
     * @return
     */
    private String findEndPoint(String serviceName) {
        return serviceName;

    }

    @Override
    public String getMinIdle() {
        return minIdle;
    }

    @Override
    public String getMaxIdle() {
        return maxIdle;
    }

    @Override
    public String getMaxTotal() {
        return maxTotal;
    }

}
