package com.kt.arcus.common.util;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPublicKeySpec;
import java.util.Collections;

public class ArcusConstants {
    public static final String YES = "Y";    
    public static final String NO = "N";    

    public static final String WRIGHT = "W";
    public static final String READ = "R";

    public static final int NO_MENU_ID = 0;
    public static final int ALL_AllOW_MENU_ID = -1;

    public static final String DEFAULT_MENU_ICON = "ti-layout-grid3";

    public static final int EMPTY_USER_ID = -1;
    public static final String EMPTY_COMPANY_ID = "";
    public static final String EMPTY_MERAKI_ORG_ID = "ARCUS:UNKNOWN";

    public static final String UNKNOWN = "UNKNOWN";

    public static final String SEARCH_ALL = "All";
    public static final int SEARCH_ALL_INT = -1;

    public static final String SUPER_ADMIN_COMPANY_ID = "system";

    public static final String MASK_STRING = "******";

    public static final int GF_DASHBOARD_DEFAULT_HEIGHT_PIXEL = 1000;

    public static final String ARCUS_DB_URL = System.getenv("ARCUS_DB_URL");
    public static final String ARCUS_SITE = System.getenv("ARCUS_SITE");      // "", "admin", "user"
    // public static final String ARCUS_SITE = "";      // "", "admin", "user"
    public static final String ARCUS_BASE_URL = System.getenv("ARCUS_BASE_URL");
    public static final String ARCUS_SPLASH_BASE_URL = System.getenv("ARCUS_SPLASH_BASE_URL");
    public static final String ARCUS_GRAFANA_URL = System.getenv("ARCUS_GRAFANA_URL");
    public static final String ARCUS_GRAFANA_USER = System.getenv("ARCUS_GRAFANA_USER");
    public static final String ARCUS_GRAFANA_PASS = System.getenv("ARCUS_GRAFANA_PASS");
    public static final String ARCUS_ES_URL = System.getenv("ARCUS_ES_URL");
    public static final String ARCUS_MERAKI_API_BASE_URL = System.getenv("ARCUS_MERAKI_API_BASE_URL");
    public static final String ARCUS_ALLINHOME_API_URL = System.getenv("ARCUS_ALLINHOME_API_URL");
    public static final String ARCUS_UPLOAD_PATH = System.getenv("ARCUS_UPLOAD_PATH");
    public static final String ARCUS_TMP_PATH = System.getenv("ARCUS_TMP_PATH");
    public static final String IPC_SERVICE_ID = System.getenv("ARCUS_IPC_SERVICE_ID");
    public static final String ARCUS_HOST_IP = System.getenv("ARCUS_HOST_IP");
    public static final long   ARCUS_USER_PASSWORD_EXPIRE_SEC  = System.getenv("ARCUS_USER_PASSWORD_EXPIRE_SEC") != null
                                                               ? Long.parseLong(System.getenv("ARCUS_USER_PASSWORD_EXPIRE_SEC"))
                                                               : 60 * 60 * 24 * 30;
    public static final long   ARCUS_ADMIN_PASSWORD_EXPIRE_SEC = System.getenv("ARCUS_ADMIN_PASSWORD_EXPIRE_SEC") != null 
                                                               ? Long.parseLong(System.getenv("ARCUS_ADMIN_PASSWORD_EXPIRE_SEC"))
                                                               : 60 * 60 * 24 * 30;
    public static final String ARCUS_CUSTOMER_CONTACT = System.getenv("ARCUS_CUSTOMER_CONTACT");
    public static final String ARCUS_CAPTIVE_API_URL = System.getenv("ARCUS_CAPTIVE_API_URL");

    public static final String ARCUS_DEFAULT_PASSWORD = "abcd1234!";

    public static final String ARCUS_ALARM_EMAIL_RECEIVERS = System.getenv("ARCUS_ALARM_EMAIL_RECEIVERS");
    public static final String ARCUS_ALARM_SMS_SENDER = System.getenv("ARCUS_ALARM_SMS_SENDER");
    public static final String ARCUS_ALARM_SMS_RECEIVERS = System.getenv("ARCUS_ALARM_SMS_RECEIVERS");

    public static PublicKey RSA_PUPKEY;
    public static PrivateKey RSA_PRVKEY;
    public static String RSA_PUBKEY_MODULUS;
    public static String RSA_PUBKEY_EXPONENT;
    static {
        try {
            KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
            generator.initialize(2048);
            KeyPair keyPair = generator.genKeyPair();
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();
            RSA_PUPKEY = publicKey;
            RSA_PRVKEY = privateKey;

            System.out.println(keyPair.getPublic());
            System.out.println(ArcusConstants.RSA_PUPKEY);

            RSAPublicKeySpec publicSpec = (RSAPublicKeySpec) keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
            RSA_PUBKEY_MODULUS = publicSpec.getModulus().toString(16);
            RSA_PUBKEY_EXPONENT = publicSpec.getPublicExponent().toString(16);
        } catch (NoSuchAlgorithmException e) {
          e.printStackTrace();
        } catch (InvalidKeySpecException e) {
          // TODO Auto-generated catch block
          e.printStackTrace();
        }
    }
}