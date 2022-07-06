package co.com.claro.ejb.ajustesmasivos.bizinteraction;

import co.com.claro.ejb.ajustesmasivos.config.Property;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.Serializable;
import java.util.Date;
import javax.ejb.Stateless;
import javax.inject.Inject;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import static javax.ws.rs.core.MediaType.APPLICATION_JSON;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

/**
 * Clase encargada del consumo de servicios Rest - InfoLaft
 *
 * @version 1.0
 * @since 04/06/2020
 * @author Cesar Gordillo - Hitss
 */
@Stateless
public class RestConsumePersist implements Serializable {

    private static final Logger LOGGER = LogManager.getLogger(RestConsumePersist.class);

    @Inject
    @Property(key = "bizinteractions.endpoint", mandatory = true)
    private String enpointBizInteractions;

    @Inject
    @Property(key = "bi.description", mandatory = true)
    private String description;

    @Inject
    @Property(key = "bi.interaction.direction.type.code", mandatory = true)
    private Integer interactionDirectionTypeCode;

    @Inject
    @Property(key = "bi.subject", mandatory = true)
    private String subject;

    @Inject
    @Property(key = "bi.channel.type.code", mandatory = true)
    private String channelTypeCode;

    @Inject
    @Property(key = "bi.category.code", mandatory = true)
    private Integer categoryCode;

    @Inject
    @Property(key = "bi.subcategory.code", mandatory = true)
    private Integer subcategoryCode;

    @Inject
    @Property(key = "bi.voice.of.customer.code", mandatory = true)
    private Integer voiceOfCustomerCode;

    @Inject
    @Property(key = "bi.close.interaction.code", mandatory = true)
    private Integer closeInteractionCode;

    @Inject
    @Property(key = "bi.domain.name", mandatory = true)
    private String domainName;

    /**
     * Realiza el llamado al metodo PutMessage del servicio Rest Notification
     *
     * @param customerCode
     * @return
     */
    public BizInteractionResponse consumePostService(final String customerCode) {
        try {
            final ObjectMapper obj = new ObjectMapper();
            final Client client = ClientBuilder.newClient();
            final BizInteractionRequest request = getBizInteractionRequest(customerCode);
            final String json = obj.writeValueAsString(request);
            return client.target(enpointBizInteractions)
                    .resolveTemplate("getOperation", "setPresencialBizInteraction")
                    .resolveTemplate("message", json)
                    .queryParam("transactionId", "transactionId45")
                    .queryParam("system", "system46")
                    .queryParam("user", "user47")
                    .queryParam("password", "password4")
                    .queryParam("requestDate", "2018-05-21T16:39:28.781")
                    .queryParam("ipApplication", "ipApplication49")
                    .queryParam("traceabilityId", "traceabilityId50")
                    .request(APPLICATION_JSON).put(Entity.json(""), BizInteractionResponse.class);
        } catch (RuntimeException e) {
            LOGGER.error("ERROR", e);
        } catch (Exception ex) {
            LOGGER.error("ERROR", ex);
        }
        return new BizInteractionResponse();
    }

    private BizInteractionRequest getBizInteractionRequest(final String customerCode) {
        final BizInteractionRequest request = new BizInteractionRequest();
        request.setDescription(this.description);
        request.setInteractionDirectionTypeCode(this.interactionDirectionTypeCode);
        request.setSubject(this.subject);
        request.setChannelTypeCode(this.channelTypeCode);
        request.setCustomerCode(customerCode);
        request.setCategoryCode(this.categoryCode);
        request.setSubCategoryCode(this.subcategoryCode);
        request.setVoiceOfCustomerCode(this.voiceOfCustomerCode);
        request.setCloseInteractionCode(this.closeInteractionCode);
        request.setDomainName(this.domainName);
        request.setUserSignum(StringUtils.EMPTY);
        request.setExecutionDate(new Date());
        return request;
    }

}
