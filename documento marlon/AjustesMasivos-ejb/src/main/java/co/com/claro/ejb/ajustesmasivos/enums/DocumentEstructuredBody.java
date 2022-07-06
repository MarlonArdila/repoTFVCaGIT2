/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.enums;

import java.util.Arrays;
import lombok.Getter;

/**
 *
 * @author mendezaf
 */
public enum DocumentEstructuredBody {

    ACTION("Action", true, 0),
    TRANSACTION_ID("transactionId", false, 1),
    RESOURCE_NUMBER("resourceNumber", true, 2),
    DEDICATED_ACCOUNT("dedicatedAccount", true, 3),
    CONTRACT_ID("ContractId", false, 4),
    REASON_ID("reasonId", false, 5),
    UNITS_TYPE("unitsType", true, 6),
    AMOUNT("amount", true, 7),
    VALIDITY_TIME("validityTime", false, 8),
    NUM_PERIODS("numPeriods", false, 9),
    VALID_FROM_DATE("validFromDate", false, 10),
    PERIOD_END_DATE("periodEndDate", false, 11),
    CHARGE_SERVICE("chargeService", false, 12),
    TAX_INDICATOR("taxIndicator", false, 13),
    SEGMENT("segment", true, 14),
    SUBSCRIPTION_TYPE("subscriptionType", false, 15),
    STATUS("status", true, 16),
    ORDER_ID("orderId", true, 17),
    MESSAGE("message", true, 18),
    NOTIFY("notify", false, 19),
    NOT_FOUND("NotFound", false, 20);

    @Getter
    private final String field;
    @Getter
    private final boolean isMandatory;
    @Getter
    private final int index;

    private DocumentEstructuredBody(final String field,
            final boolean isMandatory, final int index) {
        this.field = field;
        this.isMandatory = isMandatory;
        this.index = index;
    }

    public static DocumentEstructuredBody getFieldForIndex(final int index) {
        return Arrays.stream(values()).filter(value
                -> value.getIndex() == index).findFirst().orElse(NOT_FOUND);
    }

}
