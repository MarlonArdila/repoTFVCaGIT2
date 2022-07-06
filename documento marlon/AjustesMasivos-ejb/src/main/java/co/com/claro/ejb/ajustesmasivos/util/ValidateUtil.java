/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.util;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.Locale;
import javax.ejb.Stateless;
import javax.persistence.TypedQuery;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.lang3.time.DateUtils;

/**
 *
 * @author mendezaf
 */
@Stateless
public class ValidateUtil {

    public Date parseDate(final String date, final String format) {
        try {
            return DateUtils.parseDate(date, format);
        } catch (final ParseException e) {
            return null;
        }

    }

    public String[] addString(final String value, final String addValue,
            final String separator) {
        final int position = value.length();
        final StringBuilder builder = new StringBuilder(value);
        if (value.endsWith(separator)) {
            builder.insert(position, addValue);
        }
        return builder.toString().split(separator);
    }

    public <T> T getSingleResult(final TypedQuery<T> query) {
        return query.setMaxResults(NumberUtils.INTEGER_ONE).getResultList()
                .parallelStream().findFirst().orElse(null);
    }

    public LocalDate validateDateRecord(final String date, final String format) {
        try {
            final DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format, new Locale("es", "COL"));
            return LocalDate.parse(date, formatter);
        } catch (DateTimeParseException e) {
            return null;
        }

    }

}
