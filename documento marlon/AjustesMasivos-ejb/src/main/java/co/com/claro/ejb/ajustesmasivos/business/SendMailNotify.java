/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.business;

import co.com.claro.ejb.ajustesmasivos.config.Property;
import co.com.claro.ejb.ajustesmasivos.enums.TypeService;
import co.com.claro.ejb.ajustesmasivos.rest.business.NotificationApi;
import co.com.claro.ejb.ajustesmasivos.util.ConstantsUtil;
import co.com.claro.inspira.utilities.common.exception.dto.BackendException;
import co.com.claro.inspira.utilities.common.exception.dto.EricssonFault;
import com.fasterxml.jackson.core.JsonProcessingException;
import java.io.File;
import java.io.Serializable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import javax.ejb.Asynchronous;
import javax.ejb.Stateless;
import javax.inject.Inject;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author mendezaf
 */
@Stateless
public class SendMailNotify implements Serializable {

    @Inject
    private NotificationApi notificationApi;

    @Inject
    @Property(key = "timeout.notify", mandatory = true)
    private long timeOutNotify;

    @Inject
    @Property(key = "mail.customer.box", mandatory = true)
    private String[] mailCustomerBox;

    @Asynchronous
    public void sendMail(final File fileLogError) {
        Long timeout = this.timeOutNotify;
        final ExecutorService executor = Executors.newSingleThreadExecutor();
        @SuppressWarnings({"unchecked", "rawtypes"})
        final Future<String> future = executor.submit(() -> {
            String messageErrorFuture = StringUtils.EMPTY;
            try {
                notificationApi.putMessage(fileLogError, null,
                        TypeService.TYPE_EMAIL_ATTACHMENT, null, mailCustomerBox);
            } catch (final BackendException | EricssonFault | JsonProcessingException e) {
                messageErrorFuture = ConstantsUtil.FAILED;
            }
            return messageErrorFuture;
        });
        try {
            future.get(timeout, TimeUnit.SECONDS);
            executor.shutdownNow();
        } catch (ExecutionException | InterruptedException | TimeoutException e) {
            future.cancel(true);
        } finally {
            if (fileLogError.exists()) {
                FileUtils.deleteQuietly(fileLogError);
            }
        }
    }
}
