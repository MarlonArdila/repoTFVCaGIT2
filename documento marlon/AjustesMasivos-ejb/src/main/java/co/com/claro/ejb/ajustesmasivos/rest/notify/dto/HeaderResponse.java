package co.com.claro.ejb.ajustesmasivos.rest.notify.dto;

/**
 * Objetivo de la clase: Clase DTO del Header Response del backend
 *
 * @version 1.0
 * @since 10/08/2020
 * @author Cesar Gordillo - Hitss
 */
public class HeaderResponse {

    /**
     * traceabilityId de la operacion
     */
    private String traceabilityId;
    /**
     * responseDate de la operacion
     */
    private String responseDate;

    /**
     * Objetivo: Obtener traceabilityId Descripcion: Obtener traceabilityId
     *
     * @return traceabilityId
     */
    public String getTraceabilityId() {
        return traceabilityId;
    }

    /**
     * Objetivo: Cambiar el valor de traceabilityId Descripcion: Cambiar el
     * valor de traceabilityId
     *
     * @param traceabilityId traceabilityId de la operacion
     */
    public void setTraceabilityId(String traceabilityId) {
        this.traceabilityId = traceabilityId;
    }

    /**
     * Objetivo: Obtener responseDate Descripcion: Obtener responseDate
     *
     * @return responseDate
     */
    public String getResponseDate() {
        return responseDate;
    }

    /**
     * Objetivo: Cambiar el valor de responseDate Descripcion: Cambiar el valor
     * de responseDate
     *
     * @param responseDate responseDate de la operacion
     */
    public void setResponseDate(String responseDate) {
        this.responseDate = responseDate;
    }
}
