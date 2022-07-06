/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.facade;

import co.com.claro.ejb.ajustesmasivos.conversor.AjmDocumentosConversor;
import co.com.claro.ejb.ajustesmasivos.dto.AjmDocumentosDto;
import javax.ejb.Stateless;
import javax.inject.Inject;
import co.com.claro.ejb.ajustesmasivos.dao.IAjmDocumentosDao;
import co.com.claro.ejb.ajustesmasivos.entity.AjmDocumentos;
import com.jcraft.jsch.ChannelSftp;
import java.io.Serializable;
import java.util.List;

/**
 *
 * @author mendezaf
 */
@Stateless
public class AjmDocumentosFacade implements Serializable {

    @Inject
    private IAjmDocumentosDao ajmDocumentosView;

    @Inject
    private AjmDocumentosConversor documentosConversor;

    public void saveFilesWithoutProcess(final List<ChannelSftp.LsEntry> listFilesFolder) {
        ajmDocumentosView.saveFilesWithoutProcess(listFilesFolder);
    }

    public List<AjmDocumentosDto> getListFilesByStatus(final short statusDocument) {
        final List<AjmDocumentos> listaFiles = ajmDocumentosView
                .getListFilesByStatus(statusDocument);
        return documentosConversor.getListAjDocumentosFromEntity(listaFiles);
    }

    public void save(final Long id) {
        ajmDocumentosView.save(id);
    }

}
