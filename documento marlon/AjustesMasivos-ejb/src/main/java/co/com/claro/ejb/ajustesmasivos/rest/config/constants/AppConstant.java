package co.com.claro.ejb.ajustesmasivos.rest.config.constants;

/**
 * Nombre AppConstant Objetivo constantes para mantener los valores inmutables
 * en el sistema
 *
 * @author Emmanuel Camacho Orozco - Global Hitss
 * @version 1.0.1, 2020/07/22
 *
 */
public abstract class AppConstant {

    private AppConstant() {
        super();
    }

    public static final String APP_NAME = "subscriberpackagescmws";

    public static final String STRING_BLANK = "";
    public static final String APP_NAME_GET_SUBSCRIBER_PACKAGES = "SubscriberPackages";
    public static final String LONG_DATE_FORMAT = "yyyy-MM-dd";

    public static final String TIME_OUT_CLASS = "TimeoutException";
    public static final String BUSINESS_EXCEPTION_CLASS = "BusinessException";
    public static final String APP_NAME_CUSTOMER_PROFILE = "CustomerProfile";

}
