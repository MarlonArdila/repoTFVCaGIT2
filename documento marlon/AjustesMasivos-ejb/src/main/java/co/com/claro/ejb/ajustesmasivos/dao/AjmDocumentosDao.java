/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.dao;

import co.com.claro.ejb.ajustesmasivos.entity.AjmDocumentos;
import co.com.claro.ejb.ajustesmasivos.entity.AbstractFacade;
import co.com.claro.ejb.ajustesmasivos.enums.StatusDocument;
import com.jcraft.jsch.ChannelSftp;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.ejb.Local;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.lang3.math.NumberUtils;

/**
 *
 * @author mendezaf
 */
@Stateless
@Local(IAjmDocumentosDao.class)
public class AjmDocumentosDao extends AbstractFacade<AjmDocumentos> implements IAjmDocumentosDao, Serializable {

    @PersistenceContext(unitName = "SalesPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AjmDocumentosDao() {
        super(AjmDocumentos.class);
    }

    @Override
    public void saveFilesWithoutProcess(final List<ChannelSftp.LsEntry> listFilesFolder) {
        for (final ChannelSftp.LsEntry file : listFilesFolder) {
            if (!this.em.createNamedQuery("AjmDocumentos.findByArchivo")
                    .setParameter("archivo", file.getFilename()).setMaxResults(NumberUtils.INTEGER_ONE)
                    .getResultList().parallelStream().findFirst().isPresent()) {
                this.em.persist(builderWithoutProcess(file.getFilename()));
            }
        }
    }

    @Override
    public List<AjmDocumentos> getListFilesByStatus(final short statusDocument) {
        return this.em.createNamedQuery("AjmDocumentos.findByEstado")
                .setParameter("estado", statusDocument).getResultList();
    }

    @Override
    public void save(final Long id) {
        final AjmDocumentos ajmDocumentos = this.find(id);
        ajmDocumentos.setEstado(StatusDocument.PROCESSED.getStatus());
        this.em.merge(ajmDocumentos);
        this.em.flush();

    }

    private AjmDocumentos builderWithoutProcess(final String fileName) {
        final AjmDocumentos ajmDocumentos = new AjmDocumentos();
        ajmDocumentos.setArchivo(fileName);
        ajmDocumentos.setEstado(StatusDocument.NOT_PROCESSED.getStatus());
        ajmDocumentos.setFechaCreacion(new Date());
        return ajmDocumentos;
    }

}
