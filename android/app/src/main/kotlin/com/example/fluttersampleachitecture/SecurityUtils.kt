package com.example.fluttersampleachitecture

object SecurityUtils {
    /**
     * Get secret key (32 characters for AES-256 encryption)
     * In production, this should be stored securely or generated dynamically
     */
    fun getSecretKey(): String {
        // TODO: Replace with secure key storage or generation
        // For now, returning a default key
        // In production, consider:
        // 1. Storing in Android Keystore
        // 2. Generating from device-specific properties
        // 3. Retrieving from secure server
        return "my32lengthsupersecretnooneknows!!"
    }
}
