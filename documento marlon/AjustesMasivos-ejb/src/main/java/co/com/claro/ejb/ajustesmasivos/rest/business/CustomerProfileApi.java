package co.com.claro.ejb.ajustesmasivos.rest.business;

import co.com.claro.ejb.ajustesmasivos.rest.config.EClientConfig;
import co.com.claro.ejb.ajustesmasivos.rest.config.constants.AppConstant;
import java.io.IOException;
import java.net.MalformedURLException;

import javax.ws.rs.WebApplicationException;
import javax.xml.ws.WebServiceException;

import co.com.claro.inspira.utilities.common.client.ClientConfig;
import co.com.claro.inspira.utilities.common.exception.dto.BackendException;
import co.com.claro.inspira.utilities.common.exception.dto.EricssonFault;
import co.com.claro.inspira.utilities.common.exception.dto.EricssonFaultMessageType;
import co.com.claro.inspira.utilities.common.exception.dto.InternalException;
import co.com.claro.inspira.wsclient.customerprofile.client.CustomerProfileClientPool;
import co.com.claro.inspira.wsclient.customerprofile.client.dto.GetCustomerInfoRequestType;
import co.com.claro.inspira.wsclient.customerprofile.client.dto.GetCustomerInfoResponseType;
import co.com.claro.inspira.utilities.common.header.dto.HeaderRequestType;

/**
 * Objetivo consumo backEnd CustomerProfileApi Descripción consumo backEnd
 * CustomerProfileApi, encargada de obtener la instancia de su conexión y mapeo
 * de datos
 *
 * @author HITSS Cesar Gordillo
 * @version 1.0.1, 2020/07/22
 */
public class CustomerProfileApi {

    /**
     * Objetivo getCustomerProfile Descripcion: Encargada de la conexion al pool
     * de conexiones Fecha Creacion: 27/09/2019 Autor: HITSS Cesar Gordillo
     *
     * @param msisdn
     * @param accion
     * @param wsdlLocation
     * @return devuelve la conexión con la instancia {Customer}
     * @throws MalformedURLException
     * @throws IOException
     * @throws EricssonFault
     * @throws BackendException
     * @throws InternalException
     */
    public GetCustomerInfoResponseType getCustomerProfile(String msisdn, String accion, String wsdlLocation)
            throws EricssonFault, BackendException, InternalException,
            MalformedURLException, WebServiceException, IOException {
        ClientConfig clientConfig
                = new EClientConfig(wsdlLocation);
        GetCustomerInfoResponseType response;
        try {
            CustomerProfileClientPool client;
            HeaderRequestType headerRequestType = new HeaderRequestType();
            GetCustomerInfoRequestType request = new GetCustomerInfoRequestType();
            request.setMsisdn(msisdn);

            client = CustomerProfileClientPool.getInstance(clientConfig);

            response = client.getCustomerProfile(request,
                    headerRequestType, accion);
            return response;
        } catch (MalformedURLException e) {
            throw e;
        } catch (WebServiceException | IOException
                | WebApplicationException | BackendException e) {
            throw e;
        } catch (EricssonFault e) {
            EricssonFaultMessageType faultInfo = new EricssonFaultMessageType();
            faultInfo.setErrorLocation(AppConstant.APP_NAME_CUSTOMER_PROFILE);
            faultInfo.setFaultSource(e.getClass().getSimpleName());
            throw new EricssonFault(null, faultInfo);
        } catch (Exception e) {
            throw new InternalException(null, null,
                    AppConstant.APP_NAME_CUSTOMER_PROFILE,
                    e.getClass().getSimpleName());
        }
    }

}
