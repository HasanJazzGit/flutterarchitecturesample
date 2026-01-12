#include "SecurityUtils.h"
#include <string>

const char* getSecretKey() {
    // Same secret key as Android for consistency
    // In production, this should be stored securely or generated dynamically
    static std::string key = "my32lengthsupersecretnooneknows!!";
    return key.c_str();
}
