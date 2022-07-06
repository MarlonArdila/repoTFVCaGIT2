/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.conversor;

import co.com.claro.ejb.ajustesmasivos.entity.AjmDocumentos;
import co.com.claro.ejb.ajustesmasivos.dto.AjmDocumentosDto;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import org.apache.commons.collections4.CollectionUtils;

/**
 *
 * @author mendezaf
 */
@Stateless
public class AjmDocumentosConversor implements Serializable {

    public AjmDocumentosDto getAjDocumentosFromEntity(final AjmDocumentos ajmDocumentos) {
        final AjmDocumentosDto ajmDocumentosDto = new AjmDocumentosDto();
        ajmDocumentosDto.setId(ajmDocumentos.getId());
        ajmDocumentosDto.setArchivo(ajmDocumentos.getArchivo());
        ajmDocumentosDto.setEstado(ajmDocumentos.getEstado());
        ajmDocumentosDto.setFechaCreacion(ajmDocumentos.getFechaCreacion());
        return ajmDocumentosDto;
    }

    public List<AjmDocumentosDto> getListAjDocumentosFromEntity(final List<AjmDocumentos> listaEntity) {
        final List<AjmDocumentosDto> listaDto = new ArrayList<>();
        if (CollectionUtils.isNotEmpty(listaEntity)) {
            listaEntity.stream().forEach(entity -> {
                listaDto.add(getAjDocumentosFromEntity(entity));
            });
        }
        return listaDto;
    }

}
