package co.com.claro.ejb.ajustesmasivos.rest.business;

import co.com.claro.ejb.ajustesmasivos.config.Property;
import co.com.claro.ejb.ajustesmasivos.enums.TypeService;
import co.com.claro.ejb.ajustesmasivos.rest.notify.dto.Attach;
import co.com.claro.ejb.ajustesmasivos.rest.notify.dto.MessageBox;
import co.com.claro.ejb.ajustesmasivos.rest.notify.dto.MessageContentRequest;
import co.com.claro.ejb.ajustesmasivos.util.ConstantsUtil;
import co.com.claro.ejb.ajustesmasivos.util.GeneratorFileUtil;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.ejb.Stateless;
import javax.inject.Inject;
import org.apache.commons.lang3.StringUtils;

/**
 * Clase de serializacion entre backend y EAP
 *
 * @version 1.0
 * @since 10/08/2020
 * @author Cesar Gordillo - Hitss
 */
@Stateless
public class SerializeDto implements Serializable {

    /**
     * Properties Mail*
     */
    @Inject
    @Property(key = "mail.push.type", mandatory = true)
    private String mailPushType;

    @Inject
    @Property(key = "mail.typeCustomer", mandatory = true)
    private String mailTypeCustomer;

    @Inject
    @Property(key = "mail.message.channel", mandatory = true)
    private String mailMessageChannel;

    @Inject
    @Property(key = "mail.customer.id", mandatory = true)
    private String mailCustomerId;

    @Inject
    @Property(key = "mail.profiles", mandatory = true)
    private String mailProfiles;

    @Inject
    @Property(key = "mail.communication.type", mandatory = true)
    private String mailCommunicationType;

    @Inject
    @Property(key = "mail.communication.origen", mandatory = true)
    private String mailCommunicationOrigen;

    @Inject
    @Property(key = "mail.delivery.receipts", mandatory = true)
    private String mailDeliveryReceipts;

    @Inject
    @Property(key = "mail.content.type", mandatory = true)
    private String mailContentType;

    @Inject
    @Property(key = "mail.message.content", mandatory = true)
    private String mailMessageContent;

    @Inject
    @Property(key = "mail.attach.type", mandatory = true)
    private String mailAttachType;

    @Inject
    @Property(key = "mail.attach.encode", mandatory = true)
    private String mailAttachEncode;

    /**
     * Properties Sms*
     */
    @Inject
    @Property(key = "sms.push.type", mandatory = true)
    private String smsPushType;

    @Inject
    @Property(key = "sms.type.costumer", mandatory = true)
    private String smsTypeCostumer;

    @Inject
    @Property(key = "sms.message.channel", mandatory = true)
    private String smsMessageChannel;

    @Inject
    @Property(key = "sms.customer.id", mandatory = true)
    private String smsCustomerId;

    @Inject
    @Property(key = "sms.profiles", mandatory = true)
    private String smsProfiles;

    @Inject
    @Property(key = "sms.communication.type", mandatory = true)
    private String smsCommunicationType;

    @Inject
    @Property(key = "sms.communication.origen", mandatory = true)
    private String smsCommunicationOrigen;

    @Inject
    @Property(key = "sms.delivery.receipts", mandatory = true)
    private String smsDeliveryReceipts;

    @Inject
    @Property(key = "sms.content.type", mandatory = true)
    private String smsContentType;

    @Inject
    @Property(key = "sms.message.content", mandatory = true)
    private String smsMessageContent;

    @Inject
    @Property(key = "sms.subject", mandatory = true)
    private String smsSubject;

    @Inject
    @Property(key = "mail.subject", mandatory = true)
    private String mailSubject;

    @Inject
    @Property(key = "sms.id.message", mandatory = true)
    private String smsIdMessage;
    @Inject
    @Property(key = "mail.subject.wihout.attachment", mandatory = true)
    private String mailSubjectWithoutAttachment;
    @Inject
    @Property(key = "mail.message.wihout.attachment", mandatory = true)
    private String mailMessageWithoutAttachment;

    @Inject
    private GeneratorFileUtil generatorFileUtil;

    public SerializeDto() {
        super();
    }

    /**
     * Objetivo: Serializar el request de NotificationV2.0 para su consumo
     * Descripcion: Serializar el request de NotificationV2.0 para su consumo
     *
     * @param fileLogError
     * @param amount
     * @param notificationType
     * @param subscriberNumber
     * @return MessageNotificationRequest Request de Backend en DTO
     */
    public MessageContentRequest generarDtoNotification(final File fileLogError,
            final String amount,
            final TypeService notificationType,
            final String subscriberNumber) {
        final MessageContentRequest requestNotification
                = new MessageContentRequest();
        requestNotification.setPushType(notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT
                        ? this.mailPushType : this.smsPushType);
        if (notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT) {
            requestNotification.setTypeCostumer(this.mailTypeCustomer);
        } else {
            requestNotification.setTypeCostumer(this.smsTypeCostumer);
        }
        requestNotification.setMessageBox(getMessageBox(notificationType, subscriberNumber));
        requestNotification.setProfileId(getProfilesId(notificationType));
        requestNotification.setCommunicationType(getCommunicationType(notificationType));
        if (notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT) {
            requestNotification.setCommunicationOrigin(this.mailCommunicationOrigen);
            requestNotification.setDeliveryReceipts(this.mailDeliveryReceipts);
            requestNotification.setContentType(this.mailContentType);
        } else {
            requestNotification.setCommunicationOrigin(this.smsCommunicationOrigen);
            requestNotification.setDeliveryReceipts(this.smsDeliveryReceipts);
            requestNotification.setContentType(this.smsContentType);
        }
        if (notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT) {
            requestNotification.setMessageContent(builderMessageContent(amount, notificationType));
            requestNotification.setSubject(notificationType == TypeService.TYPE_EMAIL_ATTACHMENT 
                    ? this.mailSubject : this.mailSubjectWithoutAttachment);
            if (notificationType == TypeService.TYPE_EMAIL_ATTACHMENT) {
                requestNotification.setAttach(getAttach(fileLogError));
            }
        } else {
            requestNotification.setMessageContent(builderMessageContent(amount, notificationType));
            requestNotification.setSubject(this.smsSubject);
            requestNotification.setIdMessage(this.smsIdMessage);
        }
        return requestNotification;
    }

    private List<co.com.claro.ejb.ajustesmasivos.util.MessageBox> getMessageBox(final TypeService notificationType, final String subscriberNumber) {
        final List<co.com.claro.ejb.ajustesmasivos.util.MessageBox> listaMessageBox = new ArrayList<>();
        final co.com.claro.ejb.ajustesmasivos.util.MessageBox boxDto = new co.com.claro.ejb.ajustesmasivos.util.MessageBox();
        final List<MessageBox> listaMessage = new ArrayList<>();
        final MessageBox messageBox = new MessageBox();
        if (notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT) {
            boxDto.setMessageChannel(this.mailMessageChannel);
            messageBox.setCustomerId(this.mailCustomerId);
            listaMessage.add(messageBox);
            boxDto.setMessageBox(listaMessage);
            listaMessageBox.add(boxDto);
        } else {
            boxDto.setMessageChannel(this.smsMessageChannel);
            messageBox.setCustomerBox(subscriberNumber);
            messageBox.setCustomerId(this.smsCustomerId);
            listaMessage.add(messageBox);
            boxDto.setMessageBox(listaMessage);
            listaMessageBox.add(boxDto);
        }
        return listaMessageBox;
    }

    private List<String> getCommunicationType(final TypeService notificationType) {
        final List<String> communicationsType = new ArrayList<>();
        final String communicationsTypeBundle = notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT
                        ? this.mailCommunicationType : this.smsCommunicationType;
        if (!StringUtils.isBlank(communicationsTypeBundle)) {
            if (StringUtils.contains(communicationsTypeBundle, ConstantsUtil.COMMA)) {
                final String[] profiles = StringUtils.split(communicationsTypeBundle, ConstantsUtil.COMMA);
                communicationsType.addAll(Arrays.asList(profiles));
            } else {
                communicationsType.add(communicationsTypeBundle);
            }
        }
        return communicationsType;
    }

    private List<String> getProfilesId(final TypeService notificationType) {
        final List<String> profilesId = new ArrayList<>();
        final String profileBundle = notificationType == TypeService.TYPE_EMAIL_ATTACHMENT
                || notificationType == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT
                        ? this.mailProfiles : this.smsProfiles;
        if (!StringUtils.isBlank(profileBundle)) {
            if (StringUtils.contains(profileBundle, ConstantsUtil.COMMA)) {
                final String[] profiles = StringUtils.split(profileBundle, ConstantsUtil.COMMA);
                profilesId.addAll(Arrays.asList(profiles));
            } else {
                profilesId.add(profileBundle);
            }
        }
        return profilesId;
    }

    private String builderMessageContent(final String amount, final TypeService typeService) {
        final StringBuilder builder = new StringBuilder();
        if (typeService == TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT
                || typeService == TypeService.TYPE_SMS) {
            builder.append(typeService == TypeService.TYPE_SMS
                    ? this.smsMessageContent 
                    : this.mailMessageWithoutAttachment).append(" $").append(amount);
        } else {
            builder.append(this.mailMessageContent);

        }
        return builder.toString();
    }

    private List<Attach> getAttach(final File fileLogError) {
        final List<Attach> listAttach = new ArrayList<>();
        final Attach attach = new Attach();
        attach.setName(fileLogError.getName());
        attach.setType(this.mailAttachType);
        attach.setEncode(this.mailAttachEncode);
        attach.setContent(generatorFileUtil.encodeFileToBase64Binary(fileLogError));
        listAttach.add(attach);
        return listAttach;
    }

    public static boolean validarTarget(String target, String separator, String valueTarget) {
        String targetArray[] = target.split("\\" + separator);
        for (String targetPos : targetArray) {
            if (StringUtils.containsIgnoreCase(valueTarget, targetPos)) {
                return true;
            }
        }
        return false;
    }
}
