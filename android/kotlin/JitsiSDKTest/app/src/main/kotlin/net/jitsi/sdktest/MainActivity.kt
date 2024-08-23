package net.jitsi.sdktest

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.view.View
import android.widget.EditText
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import org.jitsi.meet.sdk.*
import timber.log.Timber
import java.net.MalformedURLException
import java.net.URL
import java.util.ArrayList

class MainActivity : AppCompatActivity() {

    private var customToolbarButtons: ArrayList<Bundle> = getCustomToolbarButtons()

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            onBroadcastReceived(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize default options for Jitsi Meet conferences.
        val serverURL: URL
        serverURL = try {
            // When using JaaS, replace "https://meet.jit.si" with the proper serverURL
            URL("https://meet.jit.si/")
        } catch (e: MalformedURLException) {
            e.printStackTrace()
            throw RuntimeException("Invalid server URL!")
        }
        val defaultOptions = JitsiMeetConferenceOptions.Builder()
                .setServerURL(serverURL)
                // When using JaaS, set the obtained JWT here
                //.setToken("MyJWT")
                // Different features flags can be set
                //.setFeatureFlag("toolbox.enabled", false)
                //.setFeatureFlag("filmstrip.enabled", false)
                .setFeatureFlag("pip.enabled", true)
                .setFeatureFlag("welcomepage.enabled", false)
                //.setFeatureFlag("prejoinpage.enabled", false)
                .setConfigOverride("customToolbarButtons", customToolbarButtons)
                .build()
        JitsiMeet.setDefaultConferenceOptions(defaultOptions)

        registerForBroadcastMessages()
    }

    override fun onDestroy() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver)
        super.onDestroy()
    }


    fun onButtonClick(v: View?) {
        val editText = findViewById<EditText>(R.id.conferenceName)
        val text = editText.text.toString()

        if (text.isNotEmpty()) {
            // Build options object for joining the conference. The SDK will merge the default
            // one we set earlier and this one when joining.
            val options = JitsiMeetConferenceOptions.Builder()
                    .setRoom(text)
                    // Settings for audio and video
                    //.setAudioMuted(true)
                    //.setVideoMuted(true)
                    .build()
            // Launch the new activity with the given options. The launch() method takes care
            // of creating the required Intent and passing the options.
            JitsiMeetActivity.launch(this, options)
        }
    }

    @NonNull
    private fun getCustomToolbarButtons(): ArrayList<Bundle> {
        val customToolbarButtons: ArrayList<Bundle> = ArrayList<Bundle>()
        val firstCustomButton = Bundle()
        val secondCustomButton = Bundle()
        firstCustomButton.putString("text", "Button one")
        firstCustomButton.putString(
            "icon",
            "https://w7.pngwing.com/pngs/987/537/png-transparent-download-downloading-save-basic-user-interface-icon-thumbnail.png"
        )
        firstCustomButton.putString("id", "btn1")
        secondCustomButton.putString("text", "Button two")
        secondCustomButton.putString(
            "icon",
            "https://w7.pngwing.com/pngs/987/537/png-transparent-download-downloading-save-basic-user-interface-icon-thumbnail.png"
        )
        secondCustomButton.putString("id", "btn2")
        customToolbarButtons.add(firstCustomButton)
        customToolbarButtons.add(secondCustomButton)
        return customToolbarButtons
    }

    private fun registerForBroadcastMessages() {
        val intentFilter = IntentFilter()

        /* This registers for every possible event sent from JitsiMeetSDK
           If only some of the events are needed, the for loop can be replaced
           with individual statements:
           ex:  intentFilter.addAction(BroadcastEvent.Type.AUDIO_MUTED_CHANGED.action);
                intentFilter.addAction(BroadcastEvent.Type.CONFERENCE_TERMINATED.action);
                ... other events
         */
        for (type in BroadcastEvent.Type.values()) {
            intentFilter.addAction(type.action)
        }

        LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver, intentFilter)
    }

    // Example for handling different JitsiMeetSDK events
    private fun onBroadcastReceived(intent: Intent?) {
        if (intent != null) {
            val event = BroadcastEvent(intent)
            when (event.type) {
                BroadcastEvent.Type.CONFERENCE_JOINED -> Timber.i("Conference Joined with url%s", event.getData().get("url"))
                BroadcastEvent.Type.PARTICIPANT_JOINED -> Timber.i("Participant joined%s", event.getData().get("name"))
                else -> Timber.i("Received event: %s", event.type)
            }
        }
    }

    // Example for sending actions to JitsiMeetSDK
    private fun hangUp() {
        val hangupBroadcastIntent: Intent = BroadcastIntentHelper.buildHangUpIntent()
        LocalBroadcastManager.getInstance(this.applicationContext).sendBroadcast(hangupBroadcastIntent)
    }
}
