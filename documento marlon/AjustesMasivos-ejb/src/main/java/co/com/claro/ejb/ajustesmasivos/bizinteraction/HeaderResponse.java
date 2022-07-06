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
@ToString
@Getter
@Setter
public class HeaderResponse {

    public HeaderResponse() {
        super();
    }

    private String responseDate;
    private String traceabilityId;

}
