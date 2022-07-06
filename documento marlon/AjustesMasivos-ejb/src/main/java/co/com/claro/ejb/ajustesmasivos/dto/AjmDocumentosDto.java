/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.dto;

import java.io.Serializable;
import java.util.Date;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author mendezaf
 */
@Getter
@Setter
public class AjmDocumentosDto implements Serializable {

    private Long id;
    private String archivo;
    private Date fechaCreacion;
    private short estado;

    public AjmDocumentosDto() {
        super();
    }

    public AjmDocumentosDto(Long id, String archivo, Date fechaCreacion, short estado) {
        this.id = id;
        this.archivo = archivo;
        this.fechaCreacion = fechaCreacion;
        this.estado = estado;
    }

}
