/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package co.com.claro.ejb.ajustesmasivos.exception;

import javax.ejb.ApplicationException;

/**
 *
 * @author mendezaf
 */
@ApplicationException(rollback = true)
public class EjbException extends Exception {

    public EjbException() {
        super();
    }

    public EjbException(String message) {
        super(message);
    }

    public EjbException(String message, Throwable cause) {
        super(message, cause);
    }

    public EjbException(Throwable cause) {
        super(cause);
    }
}
