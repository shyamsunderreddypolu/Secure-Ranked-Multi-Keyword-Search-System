package com.dao;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * AESCrypto
 * ─────────────────────────────────────────────────────────────
 * Cryptographic utility providing AES/CBC/PKCS5Padding encryption
 * and decryption.
 *
 * Keys are derived from the 7-character alphanumeric master key (mk)
 * by taking its SHA-256 hash.
 * ─────────────────────────────────────────────────────────────
 */
public class AESCrypto {

    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/CBC/PKCS5Padding";
    private static final int IV_SIZE = 16;
    private static final SecureRandom random = new SecureRandom();

    /**
     * Encrypts the input data using AES-256 (CBC mode) derived from the master key.
     * Prepend 16-byte IV to the ciphertext.
     *
     * @param data      raw data bytes to encrypt
     * @param masterKey 7-character master key string
     * @return combined byte array (16 bytes IV + encrypted content)
     * @throws Exception if encryption fails
     */
    public static byte[] encrypt(byte[] data, String masterKey) throws Exception {
        if (data == null) return null;
        
        // Derive SecretKeySpec via SHA-256
        byte[] keyBytes = deriveKey(masterKey);
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, ALGORITHM);

        // Generate dynamic random IV
        byte[] iv = new byte[IV_SIZE];
        random.nextBytes(iv);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivParameterSpec);
        byte[] encryptedBytes = cipher.doFinal(data);

        // Combine IV and Ciphertext
        byte[] combined = new byte[IV_SIZE + encryptedBytes.length];
        System.arraycopy(iv, 0, combined, 0, IV_SIZE);
        System.arraycopy(encryptedBytes, 0, combined, IV_SIZE, encryptedBytes.length);

        return combined;
    }

    /**
     * Decrypts the combined data using AES-256 (CBC mode) derived from the master key.
     * Extracts the 16-byte IV from the front.
     *
     * @param combinedData combined byte array (IV + ciphertext)
     * @param masterKey    7-character master key string
     * @return decrypted raw data bytes
     * @throws Exception if decryption fails
     */
    public static byte[] decrypt(byte[] combinedData, String masterKey) throws Exception {
        if (combinedData == null || combinedData.length <= IV_SIZE) {
            throw new IllegalArgumentException("Invalid encrypted data length.");
        }

        // Extract IV
        byte[] iv = Arrays.copyOfRange(combinedData, 0, IV_SIZE);
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

        // Extract Ciphertext
        byte[] ciphertext = Arrays.copyOfRange(combinedData, IV_SIZE, combinedData.length);

        // Derive SecretKeySpec
        byte[] keyBytes = deriveKey(masterKey);
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, ALGORITHM);

        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivParameterSpec);
        
        return cipher.doFinal(ciphertext);
    }

    // Helper: Hashing master key to 256-bit key
    private static byte[] deriveKey(String masterKey) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        return digest.digest(masterKey.getBytes("UTF-8"));
    }

    /**
     * Hashes password using SHA-256.
     * Returns a 64-character hex string.
     */
    public static String hashPassword(String password) {
        if (password == null) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("SHA-256 hash failed", e);
        }
    }
}
