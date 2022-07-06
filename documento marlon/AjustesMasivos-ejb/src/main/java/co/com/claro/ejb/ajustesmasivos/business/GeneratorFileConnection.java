/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.business;

import co.com.claro.ejb.ajustesmasivos.config.Property;
import co.com.claro.ejb.ajustesmasivos.exception.EjbException;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import javax.inject.Inject;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import javax.ejb.Stateless;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author mendezaf
 */
@Stateless
public class GeneratorFileConnection implements Serializable {

    private static final Logger LOGGER = LogManager.getLogger(GeneratorFileConnection.class);

    @Inject
    @Property(key = "name.folder.out")
    private String folderOut;

    @Inject
    @Property(key = "name.folder.log")
    private String folderLog;

    @Inject
    @Property(key = "name.file.out")
    private String nameFileOut;

    @Inject
    @Property(key = "name.file.log")
    private String nameFileLog;

    @Inject
    @Property(key = "server.hostname")
    private String hostname;

    public boolean isValideDirectoryServer(final ChannelSftp channelSftp) {
        LOGGER.info("Verificando si existe el directorio... -> {}", this.folderOut);
        boolean isValidate = true;
        try {
            channelSftp.cd(this.folderOut);
            LOGGER.info("Se ha encontrado el directorio");
        } catch (SftpException e) {
            switch (e.id) {
                case ChannelSftp.SSH_FX_NO_SUCH_FILE:
                    isValidate = false;
                    LOGGER.error("Error no se ha encontrado el directorio -> {}", this.folderOut);
                    break;
                case ChannelSftp.SSH_FX_FAILURE:
                    isValidate = false;
                    LOGGER.error("Error el obtener el directorio -> {} en el servidor -> {}",
                            this.folderOut,
                            this.hostname);
                    break;
                default:
                    isValidate = false;
                    LOGGER.error("Error el obtener el directorio -> {} en el servidor -> {}",
                            this.folderOut,
                            this.hostname);
                    break;
            }
        }
        return isValidate;
    }

    public List<ChannelSftp.LsEntry> getFiles(final ChannelSftp channelSftp) {
        try {
            return channelSftp.ls("*.txt");
        } catch (final SftpException ex) {
            LOGGER.error("Error al obtener los archivos en el directorio -> {}", this.folderOut, ex);
        }
        return null;
    }

    public List<String> generateRecordsByFile(final String fileName, final ChannelSftp channelSftp) throws EjbException {
        try {
            final InputStream inputStream = channelSftp.get(fileName);
            return readFile(inputStream);
        } catch (final SftpException sfEx) {
            LOGGER.error("Error al leer el archivo servidor externo {} ", fileName, sfEx);
        } catch (final RuntimeException | IOException e) {
            LOGGER.error("Ha ocurrido un error al procesamiento de archivos", e);
            throw new EjbException(e);
        }
        return new ArrayList<>();
    }

    private List<String> readFile(final InputStream inputStream) throws IOException {
        final List<String> listRecords = new ArrayList<>();
        listRecords.addAll(IOUtils.readLines(inputStream, StandardCharsets.UTF_8));
        return listRecords;
    }

    public File generatorFileEmail(final ChannelSftp channelSftp, final String nameFileError,
            final List<String> messageErrors) {
        try {
            final File fileTemp = createFileLogError(generatorNameFileError(nameFileError));
            FileUtils.writeLines(fileTemp, messageErrors);
            createFileServerLogError(channelSftp, fileTemp);
            return fileTemp;
        } catch (final IOException e) {
            LOGGER.error("Error al crear archivo de error en log {} ", nameFileError, e);
        }
        return null;
    }

    private void createFileServerLogError(final ChannelSftp channelSftp, final File fileTemp) {
        final File file = new File(fileTemp.getAbsolutePath());
        try {
            channelSftp.put(file.getAbsolutePath(), this.folderLog.concat(file.getName()));
        } catch (final SftpException ex) {
            switch (ex.id) {
                case ChannelSftp.SSH_FX_PERMISSION_DENIED:
                    LOGGER.error("Permiso denegado al crear "
                            + "el archivo -> {} en la ruta -> {}", fileTemp.getName(), this.folderLog);
                    break;
                case ChannelSftp.SSH_FX_NO_SUCH_FILE:
                    LOGGER.error("No se ha encontrado la ruta de destino "
                            + "-> {} ", this.folderLog);
                    break;
                default:
                    LOGGER.error("Error al crear el archivo -> {} en la ruta -> {} ",
                            fileTemp.getName(), this.folderLog);
                    break;
            }
        }
    }

    private File createFileLogError(final String fileName) {
        final File fileTemp = getFileLogErrorByName(fileName);
        try {
            FileUtils.touch(fileTemp);
        } catch (final IOException e) {
            LOGGER.error("Error al crear archivo temporal {} ", nameFileLog, e);
        }
        return fileTemp;
    }

    public File getFileLogErrorByName(final String fileName) {
        return new File(System
                .getProperty("java.io.tmpdir"), fileName);
    }

    private String generatorNameFileError(final String fileName) {
        return StringUtils.replace(fileName, this.nameFileOut, this.nameFileLog);
    }

    public void close(final Session session,
            final Channel channel, final ChannelSftp sftpChannel) {
        if (session != null && session.isConnected()) {
            session.disconnect();
        }
        if (channel != null && channel.isConnected()) {
            channel.disconnect();
        }
        if (sftpChannel != null && sftpChannel.isConnected()) {
            sftpChannel.disconnect();
        }
        LOGGER.info("Se ha cerrado la conexion del servidor correctamente");
    }
}
