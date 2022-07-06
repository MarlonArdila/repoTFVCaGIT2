/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.util;

import java.util.List;

/**
 *
 * @author mendezaf
 */
public class MessageBox {

    private String messageChannel;

    private List<co.com.claro.ejb.ajustesmasivos.rest.notify.dto.MessageBox> messageBox;

    public void setMessageChannel(String messageChannel) {
        this.messageChannel = messageChannel;
    }

    public String getMessageChannel() {
        return this.messageChannel;
    }

    public void setMessageBox(List<co.com.claro.ejb.ajustesmasivos.rest.notify.dto.MessageBox> messageBox) {
        this.messageBox = messageBox;
    }

    public List<co.com.claro.ejb.ajustesmasivos.rest.notify.dto.MessageBox> getMessageBox() {
        return this.messageBox;
    }
}
