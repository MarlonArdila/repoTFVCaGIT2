/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.rest.notify.dto;

import java.util.List;

/**
 *
 * @author mendezaf
 */
public class MessageContentRequest {

    private String communicationOrigin;

    private String deliveryReceipts;

    private List<String> profileId;

    private List<String> communicationType;

    private List<Attach> attach;

    private String typeCostumer;

    private List<co.com.claro.ejb.ajustesmasivos.util.MessageBox> messageBox;

    private String contentType;

    private String pushType;

    private String messageContent;

    private String type;
    private String subject;
    private String idMessage;

    public String getCommunicationOrigin() {
        return communicationOrigin;
    }

    public void setCommunicationOrigin(String communicationOrigin) {
        this.communicationOrigin = communicationOrigin;
    }

    public String getDeliveryReceipts() {
        return deliveryReceipts;
    }

    public void setDeliveryReceipts(String deliveryReceipts) {
        this.deliveryReceipts = deliveryReceipts;
    }

    public List<String> getProfileId() {
        return profileId;
    }

    public void setProfileId(List<String> profileId) {
        this.profileId = profileId;
    }

    public List<String> getCommunicationType() {
        return communicationType;
    }

    public void setCommunicationType(List<String> communicationType) {
        this.communicationType = communicationType;
    }

    public List<Attach> getAttach() {
        return attach;
    }

    public void setAttach(List<Attach> attach) {
        this.attach = attach;
    }

    public String getTypeCostumer() {
        return typeCostumer;
    }

    public void setTypeCostumer(String typeCostumer) {
        this.typeCostumer = typeCostumer;
    }

    public List<co.com.claro.ejb.ajustesmasivos.util.MessageBox> getMessageBox() {
        return messageBox;
    }

    public void setMessageBox(List<co.com.claro.ejb.ajustesmasivos.util.MessageBox> messageBox) {
        this.messageBox = messageBox;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getPushType() {
        return pushType;
    }

    public void setPushType(String pushType) {
        this.pushType = pushType;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * @return the subject
     */
    public String getSubject() {
        return subject;
    }

    /**
     * @param subject the subject to set
     */
    public void setSubject(String subject) {
        this.subject = subject;
    }

    /**
     * @return the idMessage
     */
    public String getIdMessage() {
        return idMessage;
    }

    /**
     * @param idMessage the idMessage to set
     */
    public void setIdMessage(String idMessage) {
        this.idMessage = idMessage;
    }

    @Override
    public String toString() {
        return "ClassPojo [communicationOrigin = " + communicationOrigin + ", deliveryReceipts = " + deliveryReceipts + ", profileId = " + profileId + ", communicationType = " + communicationType + ", attach = " + attach + ", typeCostumer = " + typeCostumer + ", messageBox = " + messageBox + ", contentType = " + contentType + ", pushType = " + pushType + ", messageContent = " + messageContent + "]";
    }
}
