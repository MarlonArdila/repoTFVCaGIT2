package co.com.claro.ejb.ajustesmasivos.rest.operation;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

/**
 * <p>
 * Java class for ClaroFault complex type.
 *
 * <p>
 * The following schema fragment specifies the expected content contained within
 * this class.
 *
 * <pre>
 * &lt;complexType name="ClaroFault">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="traceabilityId" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="categoryCode">
 *           &lt;simpleType>
 *             &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *               &lt;length value="2"/>
 *               &lt;enumeration value="01"/>
 *               &lt;enumeration value="02"/>
 *               &lt;enumeration value="03"/>
 *               &lt;enumeration value="04"/>
 *               &lt;enumeration value="05"/>
 *             &lt;/restriction>
 *           &lt;/simpleType>
 *         &lt;/element>
 *         &lt;element name="categoryDescription" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="location" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="message" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="technicalDescription" type="{http://www.w3.org/2001/XMLSchema}anyType"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 *
 *
 */
@SuppressWarnings("serial")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ClaroFault", propOrder = {
    "traceabilityId",
    "categoryCode",
    "categoryDescription",
    "location",
    "message",
    "technicalDescription"
})
public class ClaroFault extends Exception {

    @XmlElement(required = true)
    protected String traceabilityId;
    @XmlElement(required = true)
    protected String categoryCode;
    @XmlElement(required = true)
    protected String categoryDescription;
    @XmlElement(required = true)
    protected String location;
    @XmlElement(required = true)
    protected String message;
    @XmlElement(required = true)
    protected String technicalDescription;

    /**
     * Gets the value of the traceabilityId property.
     *
     * @return possible object is {@link String }
     *
     */
    public String getTraceabilityId() {
        return traceabilityId;
    }

    /**
     * Sets the value of the traceabilityId property.
     *
     * @param value allowed object is {@link String }
     *
     */
    public void setTraceabilityId(String value) {
        this.traceabilityId = value;
    }

    /**
     * Gets the value of the categoryCode property.
     *
     * @return possible object is {@link String }
     *
     */
    public String getCategoryCode() {
        return categoryCode;
    }

    /**
     * Sets the value of the categoryCode property.
     *
     * @param value allowed object is {@link String }
     *
     */
    public void setCategoryCode(String value) {
        this.categoryCode = value;
    }

    /**
     * Gets the value of the categoryDescription property.
     *
     * @return possible object is {@link String }
     *
     */
    public String getCategoryDescription() {
        return categoryDescription;
    }

    /**
     * Sets the value of the categoryDescription property.
     *
     * @param value allowed object is {@link String }
     *
     */
    public void setCategoryDescription(String value) {
        this.categoryDescription = value;
    }

    /**
     * Gets the value of the location property.
     *
     * @return possible object is {@link String }
     *
     */
    public String getLocation() {
        return location;
    }

    /**
     * Sets the value of the location property.
     *
     * @param value allowed object is {@link String }
     *
     */
    public void setLocation(String value) {
        this.location = value;
    }

    /**
     * Gets the value of the message property.
     *
     * @return possible object is {@link String }
     *
     */
    public String getMessage() {
        return message;
    }

    /**
     * Sets the value of the message property.
     *
     * @param value allowed object is {@link String }
     *
     */
    public void setMessage(String value) {
        this.message = value;
    }

    /**
     * Gets the value of the technicalDescription property.
     *
     * @return possible object is {@link Object }
     *
     */
    public String getTechnicalDescription() {
        return technicalDescription;
    }

    /**
     * Sets the value of the technicalDescription property.
     *
     * @param value allowed object is {@link Object }
     *
     */
    public void setTechnicalDescription(String value) {
        this.technicalDescription = value;
    }

}
