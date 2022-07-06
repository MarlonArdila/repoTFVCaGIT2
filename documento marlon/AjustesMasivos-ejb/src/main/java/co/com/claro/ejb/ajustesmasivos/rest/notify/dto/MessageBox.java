/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.rest.notify.dto;

/**
 *
 * @author mendezaf
 */
public class MessageBox {

    private String customerId;

    private String customerBox;

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getCustomerBox() {
        return customerBox;
    }

    public void setCustomerBox(String customerBox) {
        this.customerBox = customerBox;
    }

    @Override
    public String toString() {
        return "ClassPojo [customerId = " + customerId + ", customerBox = " + customerBox + "]";
    }
}
