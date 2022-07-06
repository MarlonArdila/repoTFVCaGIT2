/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.enums;

import java.util.Arrays;
import lombok.Getter;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author mendezaf
 */
public enum DocumentEstructuredHeader {

    CREATED_BY("createdBy", "EOC", true, 0),
    DATE_HOUR("FechaCreacion", StringUtils.EMPTY, true, 1),
    NOT_FOUND("NotFound", StringUtils.EMPTY, false, 2);

    @Getter
    private final String field;
    @Getter
    private final boolean isMandatory;
    @Getter
    private final int index;
    @Getter
    private final String value;

    private DocumentEstructuredHeader(final String field,
            final String value,
            final boolean isMandatory, final int index) {
        this.field = field;
        this.value = value;
        this.isMandatory = isMandatory;
        this.index = index;
    }

    public static DocumentEstructuredHeader getFieldForIndex(final int index) {
        return Arrays.stream(values()).filter(value
                -> value.getIndex() == index).findFirst().orElse(NOT_FOUND);
    }

}
