package com.example.fluttersampleachitecture

object NativeKeyProvider {
    init {
        System.loadLibrary("native-lib") // must match CMake target
    }

    external fun getSecretKey(): String
}
