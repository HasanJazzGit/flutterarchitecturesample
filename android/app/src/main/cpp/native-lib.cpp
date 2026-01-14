#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_fluttersampleachitecture_NativeKeyProvider_getSecretKey(JNIEnv *env, jobject /* this */) {
    std::string key = "abcdefhijklmnopqrstuvwxyzabcdefghijklmnop";
    return env->NewStringUTF(key.c_str());
}
