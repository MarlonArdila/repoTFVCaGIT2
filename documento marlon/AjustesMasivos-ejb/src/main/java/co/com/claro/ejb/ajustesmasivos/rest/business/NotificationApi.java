package co.com.claro.ejb.ajustesmasivos.rest.business;

import co.com.claro.ejb.ajustesmasivos.config.Property;
import co.com.claro.ejb.ajustesmasivos.enums.TypeService;
import co.com.claro.ejb.ajustesmasivos.rest.config.EClientConfig;
import co.com.claro.ejb.ajustesmasivos.rest.notify.dto.MessageContentRequest;

import co.com.claro.inspira.utilities.common.client.ClientConfig;
import co.com.claro.inspira.utilities.common.exception.dto.BackendException;
import co.com.claro.inspira.utilities.common.exception.dto.EricssonFault;
import co.com.claro.inspira.wsclient.notification.client.NotificationClientPool;
import co.com.claro.inspira.wsclient.notification.client.dto.PutMessageRequest;
import com.fasterxml.jackson.core.JsonProcessingException;
import java.io.File;
import java.io.Serializable;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import org.json.JSONObject;

/**
 * Objetivo trabajo de operacion para la operacion putMessage y Convierte un
 * objeto HaderRequest de termsAgreement en HeaderRequest del servicio
 * Notification
 *
 * @author mendezaf
 * @version 1.0.1, 2020/07/08
 */
@Stateless
public class NotificationApi implements Serializable {

    @Inject
    @Property(key = "notify.endpoint", mandatory = true)
    private String notifyEndpoint;

    @Inject
    private SerializeDto serializeDto;

    private NotificationClientPool client;
    /**
     * Instancia de la clase
     */
    private static NotificationApi instance;

    /**
     * Objetivo: Obtener la instancia Singleton de la clase Descripcion: Obtiene
     * la instancia Singleton de la clase
     *
     * @return instance Instancia de la clase
     */
    public static NotificationApi getInstance() {
        if (instance == null) {
            instance = new NotificationApi();
        }
        return instance;
    }

    /**
     * Objetivo Realiza el llamado a la operacion putMessage extrayendo la
     * informacion del request recibido por termsAgreement Descripción Realiza
     * el llamado a la operacion putMessage extrayendo la informacion del
     * request recibido por termsAgreement
     *
     * @param fileLogError
     * @param amount
     * @param notificationType
     * @param suscriberNumber
     * @param mails
     * @throws
     * co.com.claro.inspira.utilities.common.exception.dto.BackendException
     * @throws co.com.claro.inspira.utilities.common.exception.dto.EricssonFault
     * @throws com.fasterxml.jackson.core.JsonProcessingException
     */
    public void putMessage(final File fileLogError,
            final String amount,
            final TypeService notificationType,
            final String suscriberNumber,
            final String[] mails) throws BackendException, EricssonFault, JsonProcessingException, JsonProcessingException, JsonProcessingException {
        final ClientConfig clientConfig = new EClientConfig(this.notifyEndpoint);
        client = NotificationClientPool.getInstance(clientConfig);
        MessageContentRequest requestNotification;
        requestNotification = serializeDto.generarDtoNotification(fileLogError, amount, notificationType, suscriberNumber);
        if (TypeService.TYPE_EMAIL_ATTACHMENT == notificationType 
                || TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT == notificationType) {
            for (final String mail : mails) {
                requestNotification.getMessageBox().stream()
                        .findAny().get().getMessageBox()
                        .stream().findAny().get().setCustomerBox(mail);
                final JSONObject requestJson = new JSONObject(requestNotification);
                final PutMessageRequest request = new PutMessageRequest();
                request.setHeaderRequest(convertToHeaderRequestRest());
                request.setMessage(requestJson.toString());
                client.putMessage(request);
            }
        } else {
            final JSONObject requestJson = new JSONObject(requestNotification);
            final PutMessageRequest request = new PutMessageRequest();
            request.setHeaderRequest(convertToHeaderRequestRest());
            request.setMessage(requestJson.toString());
            client.putMessage(request);
        }

    }

    /**
     * Objetivo Convierte un objeto HaderRequest de termsAgreement en
     * HeaderRequest del servicio Notification Descripción Convierte un objeto
     * HaderRequest de termsAgreement en HeaderRequest del servicio Notification
     *
     * @return devuelve mapeo de tipo HeaderRequest
     */
    protected static co.com.claro.inspira.wsclient.notification.client.dto.HeaderRequest convertToHeaderRequestRest() {
        co.com.claro.inspira.wsclient.notification.client.dto.HeaderRequest objResponse = new co.com.claro.inspira.wsclient.notification.client.dto.HeaderRequest();

        objResponse.setTransactionId("");
        objResponse.setSystem("String");
        objResponse.setUser("");
        objResponse.setTarget("");
        objResponse.setPassword("");
        GregorianCalendar c = new GregorianCalendar();
        try {
            c.setTime(new Date());
            XMLGregorianCalendar date2 = DatatypeFactory.newInstance().newXMLGregorianCalendar(c);
            objResponse.setRequestDate(date2.toString());
        } catch (DatatypeConfigurationException e) {
        }

        objResponse.setIpApplication("");
        objResponse.setTraceabilityId("");
        return objResponse;
    }
}
