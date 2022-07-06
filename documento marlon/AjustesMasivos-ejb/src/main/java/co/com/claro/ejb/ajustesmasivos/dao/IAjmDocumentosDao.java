/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.dao;

import co.com.claro.ejb.ajustesmasivos.entity.AjmDocumentos;
import com.jcraft.jsch.ChannelSftp;
import java.util.List;

/**
 *
 * @author mendezaf
 */
public interface IAjmDocumentosDao {

    public void saveFilesWithoutProcess(final List<ChannelSftp.LsEntry> listFilesFolder);

    public List<AjmDocumentos> getListFilesByStatus(final short statusDocument);

    public void save(final Long id);

}
