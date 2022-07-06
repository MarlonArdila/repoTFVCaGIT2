/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.bizinteraction;

import java.util.Date;
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
public class BizInteractionRequest {

    public BizInteractionRequest() {
        super();
    }

    private String description;
    private int interactionDirectionTypeCode;
    private String subject;
    private String channelTypeCode;
    private String customerCode;
    private int categoryCode;
    private int subCategoryCode;
    private int voiceOfCustomerCode;
    private int closeInteractionCode;
    private String domainName;
    private String userSignum;
    private Date executionDate;

}
