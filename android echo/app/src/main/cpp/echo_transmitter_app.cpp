#include <jni.h>
#include <memory>
#include <android/log.h>
//#include "echo_transmitter.h"
//#include "echo_transmitter_terminate.h"
//#include "rt_nonfinite.h"
#include "include/echo_transmitter.h"

#define OUTPUT_SIZE 94960

extern "C" {

    JNIEXPORT jfloatArray JNICALL
    Java_com_example_echo_1transmitter_1app_MainActivity_echoTransmit(JNIEnv *env, jobject thiz,
                                                                      jshort messageId,
                                                                      jshort deviceId) {
        __android_log_print(ANDROID_LOG_DEBUG, "EchoTest", "Hello world! %d %d", messageId, deviceId);

        double input[32];
        for (int i = 0; i < 16; ++i) {
            input[i + 16] = (double) ((messageId >> (15 - i)) & 1);
            input[i] = (double) ((deviceId >> (15 - i)) & 1);
        }

        double output_signal[OUTPUT_SIZE] = { 0 };
        double cw_sig[24576] = { 0 };
        double sync_sig[16384] = { 0 };
        double data_sig[54000] = { 0 };
        double encoded_bits_coder[108] = { 0 };
        echo_transmitter(input, output_signal, cw_sig, sync_sig, data_sig, encoded_bits_coder);

        __android_log_print(ANDROID_LOG_DEBUG, "EchoTest", "Generated : %f", output_signal[14]);

        jfloatArray jOutput = env->NewFloatArray(OUTPUT_SIZE);
        jfloat jOutputArray[OUTPUT_SIZE];
        for (int i = 0; i < OUTPUT_SIZE; ++i) {
            jOutputArray[i] = (jfloat) output_signal[i];
        }
        env->SetFloatArrayRegion(jOutput, 0, OUTPUT_SIZE, jOutputArray);
        return jOutput;
    }
}


