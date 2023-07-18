package com.example.echo_transmitter_app

//import android.R
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.media.MediaPlayer
import android.os.Bundle
import android.view.View
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity


class MainActivity : AppCompatActivity() {

    lateinit var messageIdInput: EditText
    lateinit var deviceIdInput: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        messageIdInput = findViewById(R.id.MessageIDField)
        deviceIdInput = findViewById(R.id.deviceIDField)
    }

    fun beginTransmission(view: View?){
        val messageId = messageIdInput.text.toString().toShort()
        val deviceId = deviceIdInput.text.toString().toShort()

        val audioData = echoTransmit(messageId, deviceId)

        val track = AudioTrack.Builder()
            .setAudioAttributes(AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_UNKNOWN)
                .build())
            .setAudioFormat(AudioFormat.Builder()
                .setSampleRate(44100)
                .setEncoding(AudioFormat.ENCODING_PCM_FLOAT)
                .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                .build())
            .setTransferMode(AudioTrack.MODE_STATIC)
            .setBufferSizeInBytes(4 * 94960)
            .build()

        track.write(audioData, 0, 94960, AudioTrack.WRITE_BLOCKING)
        track.play()
//
//        println(messageId)
//        println(deviceId)
    }

    private external fun echoTransmit(messageId: Short, deviceId: Short): FloatArray

    companion object{
        init{
            System.loadLibrary("echo_transmitter_app")
        }
    }
}