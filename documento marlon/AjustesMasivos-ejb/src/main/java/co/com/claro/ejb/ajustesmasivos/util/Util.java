/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.util;

import co.com.claro.inspira.utilities.common.header.dto.HeaderRequestType;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

/**
 *
 * @author mendezaf
 */
public class Util {

    /**
     * Convierte un objeto de tipo <tt>HeaderRequest</tt> a uno
     * <tt>HeaderRequestType</tt>
     *
     * @return
     */
    public static HeaderRequestType convertToHeaderRequestType() {
        HeaderRequestType objResponse = new HeaderRequestType();
        objResponse.setIdESBTransaction("1234567890");
        objResponse.setIdApplication("app12345");
        objResponse.setTarget("");
        objResponse.setUserApplication("usuario1");
        objResponse.setPassword("");
        GregorianCalendar c = new GregorianCalendar();
        try {
            c.setTime(new Date());
            XMLGregorianCalendar date2 = DatatypeFactory.newInstance().newXMLGregorianCalendar(c);
            objResponse.setStartDate(date2);
        } catch (DatatypeConfigurationException e) {
        }
        objResponse.setIpApplication("");
        objResponse.setIdBusinessTransaction("111234567890");
        objResponse.setChannel("USSD");
        return objResponse;
    }

}
