/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.bizinteraction;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 *
 * @author mendezaf
 */
@Getter
@Setter
@ToString
public class BizInteractionResponse {

    public BizInteractionResponse() {
        super();
    }

    private HeaderResponse headerResponse;
    private boolean isValid;
    private String message;

    /**
     * @return the headerResponse
     */
    public HeaderResponse getHeaderResponse() {
        return headerResponse;
    }

    /**
     * @param headerResponse the headerResponse to set
     */
    public void setHeaderResponse(HeaderResponse headerResponse) {
        this.headerResponse = headerResponse;
    }

    /**
     * @return the isValid
     */
    public boolean isIsValid() {
        return isValid;
    }

    /**
     * @param isValid the isValid to set
     */
    public void setIsValid(boolean isValid) {
        this.isValid = isValid;
    }

    /**
     * @return the message
     */
    public String getMessage() {
        return message;
    }

    /**
     * @param message the message to set
     */
    public void setMessage(String message) {
        this.message = message;
    }

}
