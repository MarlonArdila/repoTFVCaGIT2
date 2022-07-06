/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.business;

import co.com.claro.ejb.ajustesmasivos.bizinteraction.BizInteractionResponse;
import co.com.claro.ejb.ajustesmasivos.bizinteraction.RestConsumePersist;
import co.com.claro.ejb.ajustesmasivos.config.Property;
import co.com.claro.ejb.ajustesmasivos.dto.AjmDocumentosDto;
import co.com.claro.ejb.ajustesmasivos.enums.DocumentEstructuredBody;
import co.com.claro.ejb.ajustesmasivos.enums.DocumentEstructuredHeader;
import co.com.claro.ejb.ajustesmasivos.enums.StatusDocument;
import co.com.claro.ejb.ajustesmasivos.enums.TypeService;
import co.com.claro.ejb.ajustesmasivos.exception.EjbException;
import co.com.claro.ejb.ajustesmasivos.facade.AjmDocumentosFacade;
import co.com.claro.ejb.ajustesmasivos.rest.business.CustomerProfileApi;
import co.com.claro.ejb.ajustesmasivos.rest.business.NotificationApi;
import co.com.claro.ejb.ajustesmasivos.util.ConstantsUtil;
import co.com.claro.ejb.ajustesmasivos.util.GeneratorFileUtil;
import co.com.claro.ejb.ajustesmasivos.util.MessageUtil;
import co.com.claro.ejb.ajustesmasivos.util.ValidateUtil;
import co.com.claro.inspira.utilities.common.exception.dto.BackendException;
import co.com.claro.inspira.utilities.common.exception.dto.EricssonFault;
import co.com.claro.inspira.utilities.common.exception.dto.InternalException;
import co.com.claro.inspira.wsclient.customerprofile.client.config.AppConstantCustomerProfile;
import co.com.claro.inspira.wsclient.customerprofile.client.dto.GetCustomerInfoResponseType;
import com.fasterxml.jackson.core.JsonProcessingException;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import javax.ejb.Stateless;
import javax.inject.Inject;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import java.io.IOException;
import java.net.MalformedURLException;
import javax.ws.rs.WebApplicationException;
import javax.xml.ws.WebServiceException;

/**
 *
 * @author mendezaf
 */
@Stateless
public class GeneratorFile implements Serializable {

    @Inject
    private GeneratorFileUtil generatorFileUtil;

    @Inject
    private GeneratorFileConnection generatorFileConnection;

    @Inject
    private NotificationApi notificationApi;

    @Inject
    private ValidateUtil validateUtil;

    @Inject
    private MessageUtil messageUtil;

    @Inject
    private SendMailNotify sendMailNotify;

    @Inject
    private AjmDocumentosFacade ajmDocumentosFacade;

    private final CustomerProfileApi customerProfileApi = new CustomerProfileApi();

    @Inject
    @Property(key = "server.hostname")
    private String hostname;

    @Inject
    @Property(key = "server.port")
    private int port;

    @Inject
    @Property(key = "server.username")
    private String username;

    @Inject
    @Property(key = "server.pki")
    private String pki;

    @Inject
    @Property(key = "file.separator", mandatory = true)
    private String separator;

    @Inject
    @Property(key = "record.format.date", mandatory = true)
    private String recordFormatDate;

    @Inject
    @Property(key = "timeout.notify", mandatory = true)
    private long timeOutNotify;

    @Inject
    @Property(key = "getcustomerprofile.enpoint", mandatory = true)
    private String wsdlLocation;

    @Inject
    private RestConsumePersist consumePersist;

    private static final Logger LOGGER = LogManager.getLogger(GeneratorFile.class);

    public void loadFile() throws EjbException {
        Channel channel = null;
        Session session = null;
        ChannelSftp channelSftp = null;
        try {
            LOGGER.info("Conectandose al servidor... hostname -> {} "
                    + "port -> {}", this.hostname, this.port);
            final JSch jsch = new JSch();
            jsch.addIdentity(this.pki);
            session = jsch.getSession(this.username, this.hostname, this.port);
            session.setConfig("StrictHostKeyChecking", "no");
            session.connect(ConstantsUtil.TIMEOUT_SERVER);
            channel = session.openChannel("sftp");
            channel.connect(ConstantsUtil.TIMEOUT_SERVER);
            channelSftp = (ChannelSftp) channel;
            LOGGER.info("Se ha conectado correctamente al servidor hostname -> {} port -> {}",
                    this.hostname, this.port);
            if (generatorFileConnection.isValideDirectoryServer(channelSftp)) {
                final List<ChannelSftp.LsEntry> listFiles
                        = generatorFileConnection.getFiles(channelSftp);
                ajmDocumentosFacade.saveFilesWithoutProcess(listFiles);
                final List<AjmDocumentosDto> listaFiles = ajmDocumentosFacade
                        .getListFilesByStatus(StatusDocument.NOT_PROCESSED.getStatus());
                LOGGER.info("Archivos para procesar {}", listaFiles.size());
                for (final AjmDocumentosDto file : listaFiles) {
                    LOGGER.info("{} Procesando....", file.getArchivo());
                    if (generatorFileUtil.nameFileIsValidate(file.getArchivo())) {
                        final List<String> records = generatorFileConnection
                                .generateRecordsByFile(file.getArchivo(), channelSftp);
                        final List<String> messageErrors = new ArrayList<>();
                        for (int recordIndex = NumberUtils.INTEGER_ZERO; recordIndex < records.size(); recordIndex++) {
                            final String recordTrim = StringUtils.trim(records.get(recordIndex));
                            final String messageError = messageErrorRecord(recordTrim,
                                    recordIndex);
                            final String message = messageUtil.builderMessageRecord(recordIndex,
                                    recordTrim, messageError);
                            if (!StringUtils.isBlank(messageError)) {
                                messageErrors.add(message);
                            }
                            LOGGER.info(message);
                            if (!StringUtils.isBlank(messageError) && recordIndex
                                    <= NumberUtils.INTEGER_ONE) {
                                break;
                            }
                        }
                        if (!CollectionUtils.isEmpty(messageErrors)) {
                            final File fileLogError = generatorFileConnection
                                    .generatorFileEmail(channelSftp, file.getArchivo(), messageErrors);
                            sendEmailNotify(fileLogError);
                        }
                        LOGGER.info("Se han encontrado {} con errores....",
                                messageUtil.builderMessageErrorSize(messageErrors.size()));
                        ajmDocumentosFacade.save(file.getId());
                        messageErrors.clear();
                        LOGGER.info("Proceso finalizado....");
                    } else {
                        LOGGER.error(messageUtil.builderMessageErrorNameFile(file.getArchivo()));
                        ajmDocumentosFacade.save(file.getId());
                        LOGGER.info("Proceso finalizado....");
                    }
                }
            }
        } catch (final JSchException ex) {
            LOGGER.error("Oops ha ocurrido un error al conectarse "
                    + "al servidor hostname -> {} port -> {}", this.hostname, this.port, ex);
        } finally {
            generatorFileConnection.close(session, channel, channelSftp);
        }

    }

    private String messageErrorRecord(final String record,
            final int recordIndex) {
        String messageError = StringUtils.EMPTY;
        if (recordIndex <= NumberUtils.INTEGER_ONE) {
            messageError = messageErrorHeader(record, recordIndex);
        }
        if (StringUtils.isBlank(messageError) && recordIndex > NumberUtils.INTEGER_ONE) {
            final String[] recordSplit = validateUtil.addString(record,
                    ConstantsUtil.VACIO, separator);
            if (recordSplit.length == ConstantsUtil.LENGHT_RECORD) {
                for (int columnIndex = NumberUtils.INTEGER_ZERO;
                        columnIndex < recordSplit.length; columnIndex++) {
                    messageError = messageErrorColumnFile(columnIndex, recordSplit);
                    if (!StringUtils.isBlank(messageError)) {
                        break;
                    }
                }
                if (StringUtils.isBlank(messageError)) {
                    final String resourceNumber = recordSplit[DocumentEstructuredBody.RESOURCE_NUMBER.getIndex()];
                    final GetCustomerInfoResponseType response = getDocumentClient(resourceNumber);
                    messageError = sendGenerationBi(response, recordSplit);
                    if (StringUtils.isBlank(messageError)) {
                        messageError = sendSmsNotify(response, recordSplit);
                    }
                }
            } else {
                messageError = messageUtil.builderMessageLenghtRecord();
            }
        }
        return messageError;
    }

    private String messageErrorHeader(final String recordFile,
            final int recordIndex) {
        final DocumentEstructuredHeader documentEstructuredHeader
                = DocumentEstructuredHeader.getFieldForIndex(recordIndex);
        String messageError = StringUtils.EMPTY;
        switch (documentEstructuredHeader) {
            case CREATED_BY:
                if (StringUtils.isBlank(recordFile)) {
                    messageError = messageUtil.builderMessageEstructured(
                            documentEstructuredHeader.getField());
                    break;
                }
                if (!recordFile.equals(documentEstructuredHeader.getValue())) {

                    messageError = messageUtil.builderMessageEstructured(
                            documentEstructuredHeader.getField());
                }
                break;
            case DATE_HOUR:
                if (StringUtils.isBlank(recordFile)) {
                    messageError = messageUtil.builderMessageEstructured(
                            documentEstructuredHeader.getField());
                    break;
                }
                if (validateUtil.validateDateRecord(recordFile,
                        this.recordFormatDate) == null) {
                    messageError = messageUtil.builderMessageEstructured(documentEstructuredHeader.getField());
                }
                break;
        }
        return messageError;
    }

    private String messageErrorColumnFile(
            final int columnIndex, final String... line) {
        final DocumentEstructuredBody documentEstructured
                = DocumentEstructuredBody.getFieldForIndex(columnIndex);
        String messageError = StringUtils.EMPTY;
        switch (documentEstructured) {
            case ACTION:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case TRANSACTION_ID:
                break;
            case RESOURCE_NUMBER:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case DEDICATED_ACCOUNT:
                break;
            case CONTRACT_ID:
                break;
            case REASON_ID:
                break;
            case UNITS_TYPE:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case AMOUNT:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case VALIDITY_TIME:
                break;
            case NUM_PERIODS:
                break;
            case VALID_FROM_DATE:
                break;
            case PERIOD_END_DATE:
                break;
            case CHARGE_SERVICE:
                break;
            case TAX_INDICATOR:
                break;
            case SEGMENT:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case SUBSCRIPTION_TYPE:
                break;
            case STATUS:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case ORDER_ID:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case MESSAGE:
                if (StringUtils.isBlank(line[columnIndex])) {
                    messageError = messageUtil.builderMessageMandatory(
                            documentEstructured.getField());
                }
                break;
            case NOTIFY:
                break;
            default:
        }
        return messageError;
    }

    private String sendGenerationBi(final GetCustomerInfoResponseType response, final String... recordFile) {
        final String valueStatus
                = recordFile[DocumentEstructuredBody.STATUS.getIndex()].toUpperCase();
        if (valueStatus.equals(ConstantsUtil.VALUE_STATUS_COMPLETED)) {
            if (response != null
                    && !StringUtils.isBlank(response.getIndividualCustomerId())) {
                final BizInteractionResponse bizInteractionResponse
                        = consumePersist.consumePostService(response.getIndividualCustomerId());
                return bizInteractionResponse.isIsValid()
                        ? StringUtils.EMPTY : messageUtil
                                .builderMessageServices(DocumentEstructuredBody.STATUS.getField(), "GetCustomerProfile");
            }
        }
        return StringUtils.EMPTY;
    }

    private String sendSmsNotify(final GetCustomerInfoResponseType response, final String... records) {
        final String valueStatus
                = records[DocumentEstructuredBody.NOTIFY.getIndex()];
        final String amount = records[DocumentEstructuredBody.AMOUNT.getIndex()];
        final String subscriberNumber = getPhoneNumber(records[DocumentEstructuredBody.RESOURCE_NUMBER.getIndex()], response);
        String messageErrorEstructured = StringUtils.EMPTY;
        if (valueStatus.equals(ConstantsUtil.VALUE_NOTIFY_YES)) {
            if (StringUtils.isEmpty(subscriberNumber)) {
                messageErrorEstructured = sendNotification(amount, null,
                        TypeService.TYPE_EMAIL_WHITOUT_ATTACHMENT, response.getEmail());
            } else {
                messageErrorEstructured = sendNotification(amount, subscriberNumber,
                        TypeService.TYPE_SMS, null);
            }

        }
        return messageErrorEstructured;
    }

    private String sendNotification(final String amount,
            final String subscriberNumber,
            final TypeService service, final String mail) {
        String messageErrorEstructured;
        final ExecutorService executor = Executors.newSingleThreadExecutor();
        @SuppressWarnings({"unchecked", "rawtypes"})
        final Future<String> future = executor.submit(() -> {
            String messageErrorFuture = StringUtils.EMPTY;
            try {
                notificationApi.putMessage(null, amount, service, subscriberNumber, StringUtils.isNotEmpty(mail)
                        ? new String[]{mail} : null);
            } catch (final BackendException | EricssonFault | JsonProcessingException e) {
                messageErrorFuture = ConstantsUtil.FAILED;
            }
            return messageErrorFuture;
        });
        try {
            final String messageError;
            future.get(this.timeOutNotify, TimeUnit.SECONDS);
            executor.shutdownNow();
            if (future.isCancelled()) {
                messageError = messageUtil.builderMessageServices(DocumentEstructuredBody.NOTIFY.getField(),
                        "Notify");
            } else if (!future.get().isEmpty()) {
                messageError = messageUtil.builderMessageServices(DocumentEstructuredBody.NOTIFY.getField(),
                        "Notify");
            } else {
                messageError = StringUtils.EMPTY;
            }
            return messageError;
        } catch (ExecutionException | InterruptedException | TimeoutException e) {
            future.cancel(true);
            messageErrorEstructured = messageUtil.builderMessageServices(DocumentEstructuredBody.NOTIFY.getField(),
                    "Notify");
        }
        return messageErrorEstructured;

    }

    private void sendEmailNotify(final File fileLogError) {
        sendMailNotify.sendMail(fileLogError);
    }

    private String getPhoneNumber(final String resourceNumber,
            final GetCustomerInfoResponseType response) {
        return StringUtils.equals(StringUtils.left(resourceNumber, NumberUtils.INTEGER_TWO),
                ConstantsUtil.PREFIJO_MOVIL) ? resourceNumber : response.getPhoneNumber();
    }

    private GetCustomerInfoResponseType getDocumentClient(final String resourceNumber) {
        try {
            final String accion = AppConstantCustomerProfile.OPPERATION_GET_CUSTOMER_PROFILE.getValor();
            return customerProfileApi
                    .getCustomerProfile(resourceNumber, accion, wsdlLocation);
        } catch (final MalformedURLException ex) {
            LOGGER.error("Error en getDocumentClient MalformedURLException", ex);
        } catch (final WebServiceException | IOException ex) {
            LOGGER.error("Error en getDocumentClient webServiceException", ex);
        } catch (final WebApplicationException | BackendException ex) {
            LOGGER.error("Error en getDocumentClient WebApplicationException", ex);
        } catch (final EricssonFault ex) {
            LOGGER.error("Error en getDocumentClient EricssonFault", ex);
        } catch (InternalException ex) {
            LOGGER.error("Error en getDocumentClient generica", ex);
        }
        return null;
    }
}
