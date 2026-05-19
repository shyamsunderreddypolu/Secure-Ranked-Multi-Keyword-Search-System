package com.dao;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.ECGenParameterSpec;
import java.util.Random;

/**
 * RandomeString
 * ─────────────────────────────────────────────────────────────
 * Cryptographic utility for SecureRank project (MJDM04).
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Provides:
 *   getPublicKey()    → generates a random 5-char salt string
 *                       used as encryption key for GM simulation
 *   setUpTrapdoor()   → sets up EC (Elliptic Curve) key pair
 *                       used for trapdoor generation (PKG module)
 *
 * The class name "RandomeString" (original typo preserved to match
 * existing project imports and servlet references).
 *
 * Algorithms used:
 *   - EC (Elliptic Curve) KeyPairGenerator — secp256r1 curve
 *   - PrivateKey / PublicKey — Java Security API
 * ─────────────────────────────────────────────────────────────
 */
public class RandomeString {

    // Shared EC key pair — generated once, reused across calls
    private static KeyPair   keyPair    = null;
    private static PublicKey  publicKey  = null;
    private static PrivateKey privateKey = null;

    // Salt characters for getPublicKey() random string
    private static final String SALTCHARS = "1234567890abcdefghi"
            + "jklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // ─────────────────────────────────────────────────────────
    // getPublicKey()
    // Generates a random 5-character alphanumeric salt string.
    // Used by UploadFile.java and GenerateTrapdoor.java as the
    // encryption key for XOR-based GM content encryption.
    //
    // In full system: returns the actual EC public key string.
    // Here: returns a salt for demonstration purposes.
    // ─────────────────────────────────────────────────────────
    public static String getPublicKey() {
        StringBuilder salt = new StringBuilder();
        Random        rnd  = new Random();
        while (salt.length() < 5) {
            int index = (int)(rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        String saltStr = salt.toString();
        return saltStr;
    }

    // ─────────────────────────────────────────────────────────
    // setUpTrapdoor()
    // Initialises an Elliptic Curve (EC) key pair using the
    // secp256r1 (NIST P-256) curve via Java KeyPairGenerator.
    //
    // Called by PKG module before trapdoor generation.
    // The private key is used to sign/encrypt the trapdoor.
    // The public key is distributed to the Cloud Server for
    // index matching during Boolean keyword search.
    //
    // Generated keys are stored in static fields for reuse.
    // ─────────────────────────────────────────────────────────
    public void setUpTrapdoor() {
        KeyPairGenerator kpg;
        try {
            kpg = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecsp = new ECGenParameterSpec("secp256r1");
            kpg.initialize(ecsp);

            KeyPair    kp      = kpg.genKeyPair();
            PrivateKey privKey = kp.getPrivate();
            PublicKey  pubKey  = kp.getPublic();

            // Store for use by other methods
            keyPair    = kp;
            privateKey = privKey;
            publicKey  = pubKey;

            System.out.println("[RandomeString] EC KeyPair generated successfully.");
            System.out.println("[RandomeString] Algorithm: " + pubKey.getAlgorithm());

        } catch (Exception e) {
            System.err.println("[RandomeString] setUpTrapdoor() error: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ─────────────────────────────────────────────────────────
    // getKeyPair() — returns the EC KeyPair after setUpTrapdoor()
    // ─────────────────────────────────────────────────────────
    public static KeyPair getKeyPair() {
        return keyPair;
    }

    // ─────────────────────────────────────────────────────────
    // getPrivateKey() — returns EC private key
    // Used by DC to sign trapdoor values
    // ─────────────────────────────────────────────────────────
    public static PrivateKey getStoredPrivateKey() {
        return privateKey;
    }

    // ─────────────────────────────────────────────────────────
    // getStoredPublicKey() — returns EC public key object
    // Use getPublicKey() for the salt string version
    // ─────────────────────────────────────────────────────────
    public static PublicKey getStoredPublicKey() {
        return publicKey;
    }
}
