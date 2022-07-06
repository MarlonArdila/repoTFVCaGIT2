/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.util;

import java.io.Serializable;
import javax.ejb.Stateless;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author mendezaf
 */
@Stateless
public class MessageUtil implements Serializable {

    private static final Logger LOGGER = LogManager.getLogger(MessageUtil.class);

    public String builderMessageMandatory(final String field) {
        final StringBuilder builder = new StringBuilder();
        builder.append(field).append(StringUtils.SPACE).append("es mandatorio");
        return builder.toString();
    }

    public String builderMessageEstructured(final String field) {
        final StringBuilder builder = new StringBuilder();
        builder.append(field).append(StringUtils.SPACE).append("Estructura de archivo errada");
        return builder.toString();
    }

    public String builderMessageServices(final String field, final String service) {
        final StringBuilder builder = new StringBuilder();
        builder.append(field).append(StringUtils.SPACE)
                .append("Error en el legado").append(StringUtils.SPACE);
        builder.append(service);
        return builder.toString();
    }

    public String builderMessageRecord(final int indexRecord, final String record, final String messageError) {
        try {
            final StringBuilder builder = new StringBuilder();
            builder.append("Linea").append(StringUtils.SPACE);
            builder.append(indexRecord + NumberUtils.INTEGER_ONE)
                    .append(ConstantsUtil.SUSPENSION_POINTS);
            if (StringUtils.isBlank(messageError)) {
                builder.append(ConstantsUtil.OK);
            } else {
                builder.append(ConstantsUtil.FAILED)
                        .append(ConstantsUtil.TWO_POINT).append(StringUtils.SPACE);
                builder.append(record).append(StringUtils.SPACE);
                builder.append("(").append(messageError).append(")");
            }
            return builder.toString();
        } catch (Exception e) {
            LOGGER.info("Error al crear el mensaje", e);
        }
        return null;

    }

    public String builderMessageLenghtRecord() {
        final StringBuilder builder = new StringBuilder();
        builder.append("La longitud del registro no es valida");
        return builder.toString();
    }

    public String builderMessageErrorNameFile(final String nameFile) {
        final StringBuilder builder = new StringBuilder();
        builder.append(ConstantsUtil.FAILED)
                .append(ConstantsUtil.TWO_POINT).append(StringUtils.SPACE);
        builder.append(nameFile).append(StringUtils.SPACE);
        builder.append("(").append("nombre de archivo no valido").append(")");
        return builder.toString();
    }

    public String builderMessageErrorSize(final int errorSize) {
        final StringBuilder builder = new StringBuilder();
        if (errorSize == NumberUtils.INTEGER_ONE) {
            builder.append(errorSize).append(StringUtils.SPACE).append("registro");
        } else {
            builder.append(errorSize).append(StringUtils.SPACE).append("registros");
        }
        return builder.toString();
    }

}
