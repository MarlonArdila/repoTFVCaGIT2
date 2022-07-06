/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.enums;

import lombok.Getter;

/**
 *
 * @author mendezaf
 */
public enum TypeService {

    TYPE_SMS("Envio de sms"),
    TYPE_EMAIL_WHITOUT_ATTACHMENT("Envio de email sin adjunto"),
    TYPE_SUBSCRIBER_PACKAGES("Servicio subscriberPackages"),
    TYPE_CUSTOMER_INTERACTION("Servicio customerInteraction"),
    TYPE_EMAIL_ATTACHMENT("Envio de email con adjunto"),
    TYPE_NOTIFY("Servicio Notify");

    @Getter
    private final String description;

    private TypeService(final String description) {
        this.description = description;
    }

}
