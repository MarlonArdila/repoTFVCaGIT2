package co.com.claro.ejb.ajustesmasivos.rest.notify.dto;

/**
 * Objetivo de la clase: Clase DTO del response message anidado del backend
 *
 * @version 1.0
 * @since 10/08/2020
 * @author Cesar Gordillo - Hitss
 */
public class MessageResponse {

    /**
     * isValid de la operacion
     */
    private String isValid;
    /**
     * message de la operacion
     */
    private String message;

    /**
     * Objetivo: Obtener isValid Descripcion: Obtener isValid
     *
     * @return isValid
     */
    public String getIsValid() {
        return isValid;
    }

    /**
     * Objetivo: Cambiar el valor de isValid Descripcion: Cambiar el valor de
     * isValid
     *
     * @param isValid isValid de la operacion
     */
    public void setIsValid(String isValid) {
        this.isValid = isValid;
    }

    /**
     * Objetivo: Obtener message Descripcion: Obtener message
     *
     * @return message
     */
    public String getMessage() {
        return message;
    }

    /**
     * Objetivo: Cambiar el valor de message Descripcion: Cambiar el valor de
     * message
     *
     * @param message message de la operacion
     */
    public void setMessage(String message) {
        this.message = message;
    }
}
