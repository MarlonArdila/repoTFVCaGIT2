package co.com.claro.ejb.ajustesmasivos.rest.notify.dto;

/**
 * Objetivo de la clase: Clase DTO del response del backend
 *
 * @version 1.0
 * @since 10/08/2020
 * @author Cesar Gordillo - Hitss
 */
public class MessageNotificationResponse {

    /**
     * isValid de la operacion
     */
    private String isValid;
    /**
     * headerResponse de la operacion
     */
    private HeaderResponse headerResponse;
    /**
     * message de la operacion
     */
    private String message;
    /**
     * messageResponse de la operacion
     */
    private MessageResponse messageResponse;

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
     * Objetivo: Obtener headerResponse Descripcion: Obtener headerResponse
     *
     * @return headerResponse
     */
    public HeaderResponse getHeaderResponse() {
        return headerResponse;
    }

    /**
     * Objetivo: Cambiar el valor de headerResponse Descripcion: Cambiar el
     * valor de headerResponse
     *
     * @param headerResponse headerResponse de la operacion
     */
    public void setHeaderResponse(HeaderResponse headerResponse) {
        this.headerResponse = headerResponse;
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

    /**
     * Objetivo: Obtener messageResponse Descripcion: Obtener messageResponse
     *
     * @return messageResponse
     */
    public MessageResponse getMessageResponse() {
        return messageResponse;
    }

    /**
     * Objetivo: Cambiar el valor de messageResponse Descripcion: Cambiar el
     * valor de messageResponse
     *
     * @param messageResponse messageResponse de la operacion
     */
    public void setMessageResponse(MessageResponse messageResponse) {
        this.messageResponse = messageResponse;
    }
}
