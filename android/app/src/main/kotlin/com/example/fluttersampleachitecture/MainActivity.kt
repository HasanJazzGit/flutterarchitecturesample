package com.example.fluttersampleachitecture

import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "security_channel"



    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Secret key channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.fluttersampleachitecture/security")
            .setMethodCallHandler { call, result ->
                android.util.Log.d("Security", "Method called: ${call.method}")
                when (call.method) {
                    "getSecretKey" -> {
                        try {
                            val key = SecurityUtils.getSecretKey()
                            android.util.Log.d("Security", "Secret key retrieved: ${key.take(5)}...")
                            result.success(key)
                        } catch (e: Exception) {
                            android.util.Log.e("Security", "Error getting secret key: ${e.message}")
                            result.error("ERROR", "Failed to get secret key: ${e.message}", null)
                        }
                    }
                    else -> {
                        android.util.Log.w("Security", "Unknown method: ${call.method}")
                        result.notImplemented()
                    }
                }
            }
        // Security channel for iOS-style checks
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkRoot" -> {
                        val isRoot = isRooted
                        android.util.Log.d("Security", "Root check: $isRoot")
                        result.success(isRoot)
                    }
                    "checkEmulator" -> {
                        val isEmu = isEmulator
                        android.util.Log.d("Security", "Emulator check: $isEmu")
                        android.util.Log.d("Security", "FINGERPRINT: ${Build.FINGERPRINT}")
                        android.util.Log.d("Security", "MODEL: ${Build.MODEL}")
                        android.util.Log.d("Security", "MANUFACTURER: ${Build.MANUFACTURER}")
                        android.util.Log.d("Security", "PRODUCT: ${Build.PRODUCT}")
                        android.util.Log.d("Security", "HARDWARE: ${Build.HARDWARE}")
                        result.success(isEmu)
                    }
                    "checkDeveloperMode" -> {
                        val isDev = isDeveloperModeEnabled
                        android.util.Log.d("Security", "Developer mode check: $isDev")
                        result.success(isDev)
                    }
                    else -> result.notImplemented()
                }
            }

        // Additional security channel (optional, for obfuscated checks)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "qwe_rty_123")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "a1" -> result.success(checkRootAdvanced())
                    "b1" -> result.success(isEmulatorAdvanced)
                    "c1" -> result.success(isDeveloperModeEnabled)
                    else -> result.notImplemented()
                }
            }
    }

    // ==================== Root Detection ====================
    private val isRooted: Boolean
        /**
         * Comprehensive root detection using multiple methods
         */
        get() = checkRootBinaries() ||
                checkRootPackages() ||
                checkBuildTags() ||
                checkSystemMount() ||
                checkBusybox() ||
                checkXposed() ||
                checkMagisk() ||
                checkFridaFiles()

    /**
     * Check for common root binary locations
     */
    private fun checkRootBinaries(): Boolean {
        val rootPaths = arrayOf(
            "/system/bin/su",
            "/system/xbin/su",
            "/sbin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/data/local/su",
            "/su/bin/su",
            "/vendor/bin/su"
        )

        for (path in rootPaths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    /**
     * Check for root management apps
     */
    private fun checkRootPackages(): Boolean {
        val rootPackages = arrayOf(
            "com.noshufou.android.su",
            "com.noshufou.android.su.elite",
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "com.thirdparty.superuser",
            "com.yellowes.su",
            "com.topjohnwu.magisk",
            "com.kingroot.kinguser",
            "com.kingo.root",
            "com.smedialink.oneclickroot",
            "com.zhiqupk.root.global",
            "com.alephzain.framaroot"
        )

        for (packageName in rootPackages) {
            try {
                packageManager.getPackageInfo(packageName, 0)
                return true
            } catch (ignored: Exception) {
                // Package not found, continue
            }
        }
        return false
    }

    /**
     * Check build tags for test-keys (indicates custom ROM)
     */
    private fun checkBuildTags(): Boolean {
        return Build.TAGS != null && Build.TAGS.contains("test-keys")
    }

    /**
     * Check if /system is mounted as read-write
     */
    private fun checkSystemMount(): Boolean {
        try {
            val process: Process = Runtime.getRuntime().exec("mount")
            val reader: BufferedReader = BufferedReader(
                InputStreamReader(process.getInputStream())
            )
            var line: String?
            while ((reader.readLine().also { line = it }) != null) {
                if (line!!.contains("/system") && line.contains("rw")) {
                    return true
                }
            }
        } catch (ignored: Exception) {
            // Error reading mount info
        }
        return false
    }

    /**
     * Check for Busybox (common in rooted devices)
     */
    private fun checkBusybox(): Boolean {
        val busyboxPaths = arrayOf(
            "/system/bin/busybox",
            "/system/xbin/busybox"
        )

        for (path in busyboxPaths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    /**
     * Check for Xposed Framework
     */
    private fun checkXposed(): Boolean {
        val xposedPaths = arrayOf(
            "/system/framework/XposedBridge.jar",
            "/system/bin/app_process32_xposed",
            "/system/lib/libxposed_art.so"
        )

        for (path in xposedPaths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    /**
     * Check for Magisk (popular root solution)
     */
    private fun checkMagisk(): Boolean {
        val magiskPaths = arrayOf(
            "/data/adb/magisk",
            "/sbin/.magisk",
            "/cache/.magisk",
            "/dev/.magisk",
            "/cache/magisk.log",
            "/data/adb/magisk.img",
            "/data/adb/magisk.db"
        )

        for (path in magiskPaths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    /**
     * Check for Frida files
     */
    private fun checkFridaFiles(): Boolean {
        val fridaPaths = arrayOf(
            "/data/local/tmp/frida-server",
            "/system/lib/libfrida.so",
            "/system/lib64/libfrida.so"
        )

        for (path in fridaPaths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    // ==================== Emulator Detection ====================
    private val isEmulator: Boolean
        /**
         * Comprehensive emulator detection - More specific to avoid false positives
         * Uses multiple reliable indicators
         */
        get() {
            // Most reliable checks first (QEMU files, system properties, hardware)
            val hasQemuFiles = checkQemuFiles()
            val hasEmulatorProperties = checkEmulatorProperties()
            val hasEmulatorHardware = checkBuildHardware()
            val hasEmulatorNetwork = checkEmulatorNetwork()
            
            // If any of the most reliable checks pass, it's definitely an emulator
            if (hasQemuFiles || hasEmulatorProperties || hasEmulatorHardware || hasEmulatorNetwork) {
                return true
            }
            
            // Secondary checks - require multiple indicators to avoid false positives
            val hasEmulatorFingerprint = checkBuildFingerprint()
            val hasEmulatorModel = checkBuildModel()
            val hasEmulatorProduct = checkBuildProduct()
            val hasEmulatorBrandDevice = checkBuildBrandDevice()
            
            // Require at least 2 secondary indicators to be safe
            val secondaryIndicators = listOf(
                hasEmulatorFingerprint,
                hasEmulatorModel,
                hasEmulatorProduct,
                hasEmulatorBrandDevice
            ).count { it }
            
            // If 2+ secondary indicators, likely emulator
            return secondaryIndicators >= 2
        }
    
    /**
     * Check Build.FINGERPRINT for emulator indicators (more specific)
     */
    private fun checkBuildFingerprint(): Boolean {
        val fingerprint = Build.FINGERPRINT ?: return false
        // Very specific emulator patterns
        return fingerprint.startsWith("generic") ||
               fingerprint.lowercase().contains("vbox") ||
               fingerprint.contains("google/sdk") ||
               fingerprint.contains("/sdk_") ||
               fingerprint.contains("/emu")
    }
    
    /**
     * Check Build.MODEL for emulator indicators (more specific)
     */
    private fun checkBuildModel(): Boolean {
        val model = Build.MODEL ?: return false
        // Very specific emulator patterns - avoid generic "sdk" check
        return model.equals("Emulator", ignoreCase = true) ||
               model.contains("Android SDK built for x86", ignoreCase = true) ||
               model.startsWith("sdk_", ignoreCase = true) ||
               model.contains("google_sdk", ignoreCase = true) ||
               model == "sdk" ||
               model.contains("Simulator", ignoreCase = true) ||
               (model.contains("sdk", ignoreCase = true) && 
                Build.PRODUCT?.contains("sdk", ignoreCase = true) == true)
    }
    
    /**
     * Check Build.MANUFACTURER for emulator indicators (more specific)
     */
    private fun checkBuildManufacturer(): Boolean {
        val manufacturer = Build.MANUFACTURER ?: return false
        // Only check for known emulator manufacturers
        return manufacturer.contains("Genymotion", ignoreCase = true) ||
               (manufacturer.contains("Google", ignoreCase = true) && 
                Build.MODEL?.startsWith("sdk_", ignoreCase = true) == true)
    }
    
    /**
     * Check Build.BRAND and Build.DEVICE for emulator indicators (more specific)
     */
    private fun checkBuildBrandDevice(): Boolean {
        val brand = Build.BRAND ?: return false
        val device = Build.DEVICE ?: return false
        // Only check for exact "generic" match, not contains
        return (brand.equals("generic", ignoreCase = true) &&
                device.equals("generic", ignoreCase = true))
    }
    
    /**
     * Check Build.PRODUCT for emulator indicators (more specific)
     */
    private fun checkBuildProduct(): Boolean {
        val product = Build.PRODUCT ?: return false
        // Very specific emulator patterns
        return product.equals("sdk", ignoreCase = true) ||
               product.equals("google_sdk", ignoreCase = true) ||
               product.startsWith("sdk_", ignoreCase = true) ||
               product.contains("emulator", ignoreCase = true) ||
               product.contains("simulator", ignoreCase = true) ||
               product.contains("vbox", ignoreCase = true) ||
               (product.contains("generic", ignoreCase = true) &&
                Build.BRAND?.equals("generic", ignoreCase = true) == true)
    }
    
    /**
     * Check Build.HARDWARE for emulator indicators (very reliable)
     */
    private fun checkBuildHardware(): Boolean {
        val hardware = Build.HARDWARE ?: return false
        // goldfish and ranchu are definitive emulator hardware
        return hardware.equals("goldfish", ignoreCase = true) ||
               hardware.equals("ranchu", ignoreCase = true) ||
               hardware.contains("vbox", ignoreCase = true)
    }
    
    /**
     * Check system properties for emulator indicators (very reliable)
     */
    private fun checkEmulatorProperties(): Boolean {
        return try {
            // Check ro.kernel.qemu property (set to 1 on emulators) - MOST RELIABLE
            val qemuProcess = Runtime.getRuntime().exec("getprop ro.kernel.qemu")
            val qemuReader = BufferedReader(InputStreamReader(qemuProcess.inputStream))
            val qemuResult = qemuReader.readLine()
            qemuReader.close()
            if (qemuResult != null && qemuResult.trim() == "1") {
                android.util.Log.d("Security", "ro.kernel.qemu = 1 (emulator)")
                return true
            }
            
            // Check ro.hardware property (goldfish/ranchu indicates emulator) - VERY RELIABLE
            val hardwareProcess = Runtime.getRuntime().exec("getprop ro.hardware")
            val hardwareReader = BufferedReader(InputStreamReader(hardwareProcess.inputStream))
            val hardwareResult = hardwareReader.readLine()
            hardwareReader.close()
            if (hardwareResult != null) {
                val hw = hardwareResult.trim().lowercase()
                if (hw == "goldfish" || hw == "ranchu") {
                    android.util.Log.d("Security", "ro.hardware = $hardwareResult (emulator)")
                    return true
                }
            }
            
            false
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Check for QEMU files (emulator indicators)
     */
    private fun checkQemuFiles(): Boolean {
        val qemuPaths = arrayOf(
            "/dev/socket/qemud",
            "/dev/qemu_pipe",
            "/system/lib/libc_malloc_debug_qemu.so",
            "/sys/qemu_trace",
            "/system/bin/qemu-props"
        )

        for (path in qemuPaths) {
            if (File(path).exists()) {
                return true
            }
        }
        return false
    }

    /**
     * Check for emulator network (10.0.2.15 is default emulator IP)
     */
    private fun checkEmulatorNetwork(): Boolean {
        try {
            val process: Process = Runtime.getRuntime().exec("ip addr show")
            val reader: BufferedReader = BufferedReader(
                InputStreamReader(process.getInputStream())
            )
            var line: String?
            while ((reader.readLine().also { line = it }) != null) {
                if (line!!.contains("10.0.2.15")) {
                    return true
                }
            }
        } catch (ignored: Exception) {
            // Error reading network info
        }
        return false
    }

    // ==================== Developer Mode Detection ====================
    private val isDeveloperModeEnabled: Boolean
        /**
         * Check if USB debugging/Developer mode is enabled
         */
        get() {
            try {
                val adbEnabled: Int = Settings.Secure.getInt(
                    getContentResolver(),
                    Settings.Global.ADB_ENABLED,
                    0
                )
                return adbEnabled != 0
            } catch (ignored: Exception) {
                return false
            }
        }

    // ==================== Advanced/Obfuscated Checks ====================
    /**
     * Advanced root check (obfuscated method names)
     */
    private fun checkRootAdvanced(): Boolean {
        return checkRootBinaries() ||
                checkRootPackages() ||
                checkBuildTags() ||
                checkSystemMount() ||
                checkBusybox() ||
                checkXposed() ||
                checkMagisk() ||
                checkFridaProcesses() ||
                checkFridaPorts() ||
                checkFridaFiles()
    }

    /**
     * Check for running Frida processes
     */
    private fun checkFridaProcesses(): Boolean {
        try {
            val process: Process = Runtime.getRuntime().exec("ps")
            val reader: BufferedReader = BufferedReader(
                InputStreamReader(process.getInputStream())
            )
            var line: String?
            while ((reader.readLine().also { line = it }) != null) {
                if (line!!.contains("frida") || line.contains("gadget")) {
                    return true
                }
            }
        } catch (ignored: Exception) {
            // Error reading process list
        }
        return false
    }

    /**
     * Check for Frida listening ports
     */
    private fun checkFridaPorts(): Boolean {
        try {
            val process: Process = Runtime.getRuntime().exec("netstat -an")
            val reader: BufferedReader = BufferedReader(
                InputStreamReader(process.getInputStream())
            )
            var line: String?
            while ((reader.readLine().also { line = it }) != null) {
                if (line!!.contains(":27042") || line.contains(":27043")) {
                    return true
                }
            }
        } catch (ignored: Exception) {
            // Error reading network stats
        }
        return false
    }

    /**
     * Advanced emulator check
     */
    private val isEmulatorAdvanced: Boolean
        get() = isEmulator
}