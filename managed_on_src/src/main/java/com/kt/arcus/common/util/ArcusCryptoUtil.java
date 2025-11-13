package com.kt.arcus.common.util;

import java.security.InvalidKeyException;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import com.kt.arcus.common.exception.ArcusCryptoException;

import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ArcusCryptoUtil {

    private static final Logger logger = LoggerFactory.getLogger(ArcusCryptoUtil.class);

    public static String sha256Hex(String srcString) {
        return DigestUtils.sha256Hex(srcString);
    }
    
    public static String byteArrayToHex(byte[] a) {
        StringBuilder sb = new StringBuilder();
        for(final byte b: a)
            sb.append(String.format("%02x", b&0xff));
        return sb.toString();
    }

    public static byte[] hexToByteArray(String s) {
        byte[] retValue = null;
        if (s != null && s.length() != 0) {
            retValue = new byte[s.length() / 2];
            for (int i = 0; i < retValue.length; i++) {
                retValue[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);
            }
        }
        return retValue;
    }

    public static String encryptAES(String srcString, String key) {
        if (srcString == null || srcString.length() == 0) 
            return "";

        try {
            String encryptedHex = null;
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

            // Use AES in GCM mode with a 12-byte nonce
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");

            // Generate a random 12-byte nonce (recommended GCM IV size)
            byte[] nonce = new byte[12];
            SecureRandom random = new SecureRandom();
            random.nextBytes(nonce);

            GCMParameterSpec gcmSpec = new GCMParameterSpec(128, nonce); // 128-bit authentication tag
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, gcmSpec);
            byte[] encrypted = cipher.doFinal(srcString.getBytes("UTF-8"));

            // Concatenate nonce + encrypted data
            byte[] result = new byte[nonce.length + encrypted.length];
            System.arraycopy(nonce, 0, result, 0, nonce.length);
            System.arraycopy(encrypted, 0, result, nonce.length, encrypted.length);

            encryptedHex = byteArrayToHex(result);
            return encryptedHex;
            // return encrypted.trim();
        } catch (InvalidKeyException e) {
            logger.error("AES decrypt error invalid key=" + key);
        } catch (Exception e) {
            return "";
        }
        return "";
    }

    public static String decryptAES(String srcString, String key) {
        if (srcString == null || srcString.length() == 0) 
            return srcString;

        try {
            String decrypted = null;
            SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes("UTF-8"), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");

            byte[] ivBytes = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36 };

            AlgorithmParameterSpec IVspec = new IvParameterSpec(ivBytes);
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, IVspec);
            decrypted = new String(cipher.doFinal(hexToByteArray(srcString)), "UTF-8");
            return decrypted.trim();
        } catch (InvalidKeyException e) {
            logger.error("AES decrypt error invalid key=" + key);
            return srcString;
        } catch (Exception e) {
            return srcString;
        }
    }

    public static String encryptRSA(String plain) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(Cipher.ENCRYPT_MODE, ArcusConstants.RSA_PUPKEY);
        byte[] encryptedBytes = cipher.doFinal(plain.getBytes());
        return byteArrayToHex(encryptedBytes);
    }

	public static String decryptRSA(String encrypted) throws ArcusCryptoException {
        String decrypted = "";
        try {
            Cipher cipher = Cipher.getInstance("RSA");
            byte[] encryptedBytes = hexToByteArray(encrypted);
            cipher.init(Cipher.DECRYPT_MODE, ArcusConstants.RSA_PRVKEY);
            byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
            decrypted = new String(decryptedBytes, "utf-8");
        } catch (InvalidKeyException e3) {
            logger.error("RSA decrypt error");
        } catch (Exception e) {
            throw new ArcusCryptoException("RSA decrypt error " + e.getMessage());
        }
        return decrypted;
    }
}
