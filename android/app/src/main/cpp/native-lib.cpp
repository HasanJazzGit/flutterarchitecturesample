#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_fluttersampleachitecture_SecurityUtils_getSecretKey(JNIEnv* env, jobject /* this */) {
    std::string key = "my32lengthsupersecretnooneknows!!";
    return env->NewStringUTF(key.c_str());
}
