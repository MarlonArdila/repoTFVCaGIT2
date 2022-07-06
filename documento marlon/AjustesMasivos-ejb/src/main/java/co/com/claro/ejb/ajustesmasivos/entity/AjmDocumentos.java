/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.entity;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author mendezaf
 */
@Entity
@Table(name = "AJM_DOCUMENTOS")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "AjmDocumentos.findAll", query = "SELECT a FROM AjmDocumentos a")
    , @NamedQuery(name = "AjmDocumentos.findById", query = "SELECT a FROM AjmDocumentos a WHERE a.id = :id")
    , @NamedQuery(name = "AjmDocumentos.findByArchivo", query = "SELECT a.archivo FROM AjmDocumentos a WHERE a.archivo = :archivo")
    , @NamedQuery(name = "AjmDocumentos.findByFechaCreacion", query = "SELECT a FROM AjmDocumentos a WHERE a.fechaCreacion = :fechaCreacion")
    , @NamedQuery(name = "AjmDocumentos.findByEstado", query = "SELECT a FROM AjmDocumentos a WHERE a.estado = :estado")})

public class AjmDocumentos implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "ID_AJM_DOCUMENTOS_SEQ")
    private Long id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 150)
    @Column(name = "ARCHIVO")
    private String archivo;
    @Basic(optional = false)
    @NotNull
    @Column(name = "FECHA_CREACION")
    @Temporal(TemporalType.TIMESTAMP)
    private Date fechaCreacion;
    @Basic(optional = false)
    @NotNull
    @Column(name = "ESTADO")
    private short estado;

    public AjmDocumentos() {
        super();
    }

    public AjmDocumentos(Long id) {
        this.id = id;
    }

    public AjmDocumentos(Long id, String archivo, Date fechaCreacion, short estado) {
        this.id = id;
        this.archivo = archivo;
        this.fechaCreacion = fechaCreacion;
        this.estado = estado;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getArchivo() {
        return archivo;
    }

    public void setArchivo(String archivo) {
        this.archivo = archivo;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public short getEstado() {
        return estado;
    }

    public void setEstado(short estado) {
        this.estado = estado;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AjmDocumentos)) {
            return false;
        }
        AjmDocumentos other = (AjmDocumentos) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "co.com.claro.ejb.ajustesmasivos.entity.AjmDocumentos[ id=" + id + " ]";
    }

}
