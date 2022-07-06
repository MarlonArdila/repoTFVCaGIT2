/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.config;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.enterprise.util.Nonbinding;
import javax.inject.Qualifier;

@Qualifier
@Target({ElementType.TYPE, ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface Property {

    /**
     * Bundle key
     *
     * @return a valid bundle key or ""
     */
    @Nonbinding
    String key() default "";

    /**
     * Is it a mandatory property
     *
     * @return true if mandator
     */
    @Nonbinding
    boolean mandatory() default false;

    /**
     * Default value if not provided
     *
     * @return default value or ""
     */
    @Nonbinding
    String defaultValue() default "";
}
