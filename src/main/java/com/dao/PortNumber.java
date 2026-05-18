package com.dao;

import java.security.SecureRandom;

/**
 * PortNumber
 * ─────────────────────────────────────────────────────────────
 * Utility class for the PKG (Private Key Generator) module.
 * Project: SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
 *
 * Generates random cryptographic keys for:
 *   getSk()  → Secret Key  — issued to Data Owner / Data Consumer
 *   getMk()  → Master Key  — kept by PKG, used to derive secret keys
 *
 * Keys are alphanumeric random strings (7 characters).
 * In a real deployment these would use Paillier/GM key generation.
 * ─────────────────────────────────────────────────────────────
 */
public class PortNumber {

    // Characters used for key generation
    private static final String CHARS =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    private static final int KEY_LENGTH = 7;

    private static final SecureRandom random = new SecureRandom();

    /**
     * getSk() — Generates a random Secret Key (sk)
     * Issued to Data Owner or Data Consumer by PKG.
     * Used by the user to generate trapdoors for search.
     *
     * @return random 7-character alphanumeric string
     */
    public static String getSk() {
        return generateKey(KEY_LENGTH);
    }

    /**
     * getMk() — Generates a random Master Key (mk)
     * Held by PKG. Used internally to derive secret keys.
     * Never shared with Data Owner or Data Consumer directly.
     *
     * @return random 7-character alphanumeric string
     */
    public static String getMk() {
        return generateKey(KEY_LENGTH);
    }

    // ── Internal key generator ────────────────────────────────
    private static String generateKey(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARS.charAt(random.nextInt(CHARS.length())));
        }
        return sb.toString();
    }
}
