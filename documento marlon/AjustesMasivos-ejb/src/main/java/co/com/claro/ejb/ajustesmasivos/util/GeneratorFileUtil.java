/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.util;

import co.com.claro.ejb.ajustesmasivos.config.Property;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import javax.inject.Inject;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import javax.ejb.Stateful;

/**
 *
 * @author mendezaf
 */
@Stateful
public class GeneratorFileUtil implements Serializable {

    private static final Logger LOGGER = LogManager.getLogger(GeneratorFileUtil.class);

    @Inject
    @Property(key = "name.file.out")
    private String nameFileOut;

    @Inject
    @Property(key = "file.format.date")
    private String formatDate;

    @Inject
    private ValidateUtil validateUtil;

    public boolean nameFileIsValidate(final String fileName) {
        if (StringUtils.contains(fileName, this.nameFileOut)) {
            final String dateString = FilenameUtils
                    .removeExtension(fileName.split(nameFileOut)[NumberUtils.INTEGER_ONE]);
            return validateUtil.parseDate(dateString, this.formatDate) != null;
        }
        return false;
    }

    public String encodeFileToBase64Binary(final File fileLogError) {
        try {
            final byte[] encoded = Base64.encodeBase64(FileUtils
                    .readFileToByteArray(fileLogError));
            return new String(encoded, StandardCharsets.US_ASCII);
        } catch (IOException e) {
            LOGGER.error("Error al codificar el archivo {}", fileLogError.getName(), e);
        }
        return StringUtils.EMPTY;

    }

}
