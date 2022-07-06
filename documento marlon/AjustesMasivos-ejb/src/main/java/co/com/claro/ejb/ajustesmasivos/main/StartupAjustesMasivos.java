/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.main;

import co.com.claro.ejb.ajustesmasivos.business.GeneratorFile;
import co.com.claro.ejb.ajustesmasivos.config.Property;
import co.com.claro.ejb.ajustesmasivos.exception.EjbException;
import java.io.Serializable;
import java.util.concurrent.TimeUnit;
import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.annotation.Resource;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.enterprise.concurrent.ManagedScheduledExecutorService;
import javax.inject.Inject;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author martin
 */
@Startup
@Singleton
public class StartupAjustesMasivos implements Serializable {

    @Resource
    private ManagedScheduledExecutorService scheduledExecutorService;

    @Inject
    private GeneratorFile generatorFile;

    @Inject
    @Property(key = "schedule.period.hour")
    private long schedulePeriod;

    private static final Logger LOGGER = LogManager.getLogger(StartupAjustesMasivos.class);

    @PostConstruct
    public void initialize() {
        scheduledExecutorService.scheduleAtFixedRate(this::run,
                NumberUtils.LONG_ZERO, schedulePeriod, TimeUnit.HOURS);
        LOGGER.info("Se ha iniciado el sistema.... ");
        LOGGER.info("Tiempo de ejecucion en horas.... {}", schedulePeriod);
    } 

    public void run() {
        try {
            generatorFile.loadFile();
        } catch (final EjbException exception) {
            LOGGER.error("Oops ha ocurrido un error al procesar los archivos", exception);
        }
    }

    @PreDestroy
    public void terminate() {
        LOGGER.info("Se ha detenido el sistema.... ");
    }

}
