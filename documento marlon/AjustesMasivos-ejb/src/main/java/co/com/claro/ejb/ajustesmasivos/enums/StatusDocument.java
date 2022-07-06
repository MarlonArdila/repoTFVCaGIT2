/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.enums;

import lombok.Getter;
import org.apache.commons.lang3.math.NumberUtils;

/**
 *
 * @author mendezaf
 */
public enum StatusDocument {

    PROCESSED(NumberUtils.SHORT_ONE),
    NOT_PROCESSED(NumberUtils.SHORT_ZERO);

    @Getter
    private final short status;

    private StatusDocument(final short status) {
        this.status = status;
    }

}
