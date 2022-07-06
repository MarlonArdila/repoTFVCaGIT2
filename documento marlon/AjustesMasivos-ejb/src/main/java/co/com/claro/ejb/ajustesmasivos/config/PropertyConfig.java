/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.config;

import co.com.claro.ejb.ajustesmasivos.util.ConstantsUtil;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.util.MissingResourceException;
import java.util.Properties;
import javax.annotation.PostConstruct;
import javax.enterprise.context.Dependent;
import javax.enterprise.inject.Produces;
import javax.enterprise.inject.spi.InjectionPoint;
import lombok.Getter;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Dependent
public class PropertyConfig implements Serializable {

    private static final Logger LOGGER = LogManager.getLogger(PropertyConfig.class);

    private static final String MANDATORY_PARAM = "El parametro de configuracion con nombre -> {} es obligatorio";

    @Getter
    private Properties properties;

    @PostConstruct
    public void init() {
        loadProperties();
    }

    @Produces
    @Property
    public String injectConfigurationString(final InjectionPoint ip) throws IllegalStateException {
        final Property param = ip.getAnnotated().getAnnotation(Property.class);
        if (StringUtils.isBlank(param.key())) {
            return param.defaultValue();
        }
        String value;
        try {
            value = properties.getProperty(param.key());
            if (StringUtils.isBlank(value)) {
                if (param.mandatory()) {
                    LOGGER.error(MANDATORY_PARAM, param.key());
                    throw new IllegalStateException();
                } else {
                    return param.defaultValue();
                }
            }
            return value;
        } catch (final MissingResourceException e) {
            if (param.mandatory()) {
                LOGGER.error(MANDATORY_PARAM, param.key(), e);
                throw new IllegalStateException();
            }
            return StringUtils.EMPTY;
        }
    }

    @Produces
    @Property
    public int injectConfigurationInt(final InjectionPoint ip) throws IllegalStateException {
        final Property param = ip.getAnnotated().getAnnotation(Property.class);
        if (StringUtils.isBlank(param.key())) {
            return Integer.parseInt(param.defaultValue());
        }
        String value;
        try {
            value = properties.getProperty(param.key());
            if (StringUtils.isBlank(value)) {
                if (param.mandatory()) {
                    LOGGER.error(MANDATORY_PARAM, param.key());
                    throw new IllegalStateException();
                } else {
                    return Integer.parseInt(param.defaultValue());
                }
            }
            return Integer.parseInt(value);
        } catch (final MissingResourceException e) {
            if (param.mandatory()) {
                LOGGER.error(MANDATORY_PARAM, param.key(), e);
                throw new IllegalStateException();
            }
            return NumberUtils.INTEGER_ZERO;
        }
    }

    @Produces
    @Property
    public long injectConfigurationLong(final InjectionPoint ip) throws IllegalStateException {
        final Property param = ip.getAnnotated().getAnnotation(Property.class);
        if (StringUtils.isBlank(param.key())) {
            return Long.parseLong(param.defaultValue());
        }
        String value;
        try {
            value = properties.getProperty(param.key());
            if (StringUtils.isBlank(value)) {
                if (param.mandatory()) {
                    LOGGER.error(MANDATORY_PARAM, param.key());
                    throw new IllegalStateException();
                } else {
                    return Long.parseLong(param.defaultValue());
                }
            }
            return Long.parseLong(value);
        } catch (final MissingResourceException e) {
            if (param.mandatory()) {
                LOGGER.error(MANDATORY_PARAM, param.key(), e);
                throw new IllegalStateException();
            }
            return NumberUtils.INTEGER_ZERO;
        }
    }

    @Produces
    @Property
    public String[] injectConfigurationArray(final InjectionPoint ip) throws IllegalStateException {
        final Property param = ip.getAnnotated().getAnnotation(Property.class);
        if (StringUtils.isBlank(param.key())) {
            return getArrayFromString(param.defaultValue());
        }
        String value;
        try {
            value = properties.getProperty(param.key());
            if (StringUtils.isBlank(value)) {
                if (param.mandatory()) {
                    LOGGER.error(MANDATORY_PARAM, param.key());
                    throw new IllegalStateException();
                } else {
                    return getArrayFromString(param.defaultValue());
                }
            }
            return getArrayFromString(value);
        } catch (final MissingResourceException e) {
            if (param.mandatory()) {
                LOGGER.error(MANDATORY_PARAM, param.key(), e);
                throw new IllegalStateException();
            }
            return ArrayUtils.EMPTY_STRING_ARRAY;
        }
    }

    private String[] getArrayFromString(final String value) {
        if (StringUtils.contains(value, ConstantsUtil.POINT_COMMA)) {
            return StringUtils.split(value, ConstantsUtil.POINT_COMMA);
        } else {
            return new String[]{value};
        }
    }

    private void loadProperties() {
        this.properties = new Properties();
        try (InputStreamReader inputStreamReader
                = new InputStreamReader(new FileInputStream(ConstantsUtil.PATH_PROPERTIES),
                        StandardCharsets.UTF_8)) {
            properties.load(inputStreamReader);
        } catch (final IOException ex) {
            LOGGER.error("Error al cargar las propiedades", ex);
        }
    }
}
