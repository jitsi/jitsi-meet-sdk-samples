package net.jitsi.sdktest;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import org.jitsi.meet.sdk.BroadcastEvent;
import org.jitsi.meet.sdk.BroadcastIntentHelper;
import org.jitsi.meet.sdk.JitsiMeet;
import org.jitsi.meet.sdk.JitsiMeetActivity;
import org.jitsi.meet.sdk.JitsiMeetConferenceOptions;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import timber.log.Timber;

public class MainActivity extends AppCompatActivity {

    ArrayList<Bundle> customToolbarButtons = getCustomToolbarButtons();

    private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            onBroadcastReceived(intent);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize default options for Jitsi Meet conferences.
        URL serverURL;
        try {
            // When using JaaS, replace "https://meet.jit.si" with the proper serverURL
            serverURL = new URL("https://meet.jit.si");
        } catch (MalformedURLException e) {
            e.printStackTrace();
            throw new RuntimeException("Invalid server URL!");
        }
        JitsiMeetConferenceOptions defaultOptions
                = new JitsiMeetConferenceOptions.Builder()
                .setServerURL(serverURL)
                // When using JaaS, set the obtained JWT here
                //.setToken("MyJWT")
                // Different features flags can be set
                // .setFeatureFlag("toolbox.enabled", false)
                .setFeatureFlag("prejoinpage.enabled", false)
                .setFeatureFlag("welcomepage.enabled", false)
                .setConfigOverride("customToolbarButtons", customToolbarButtons)
                .build();
        JitsiMeet.setDefaultConferenceOptions(defaultOptions);

        registerForBroadcastMessages();
    }

    @Override
    protected void onDestroy() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver);

        super.onDestroy();
    }

    public void onButtonClick(View v) {
        EditText editText = findViewById(R.id.conferenceName);
        String text = editText.getText().toString();

        if (!text.isEmpty()) {
            // Build options object for joining the conference. The SDK will merge the default
            // one we set earlier and this one when joining.
            JitsiMeetConferenceOptions options
                    = new JitsiMeetConferenceOptions.Builder()
                    .setRoom(text)
                    // Settings for audio and video
                    .setAudioMuted(true)
                    .setVideoMuted(true)
                    .build();
            // Launch the new activity with the given options. The launch() method takes care
            // of creating the required Intent and passing the options.
            JitsiMeetActivity.launch(this, options);
        }
    }

    private static @NonNull ArrayList<Bundle> getCustomToolbarButtons() {
        ArrayList<Bundle> customToolbarButtons = new ArrayList<>();

        Bundle firstCustomButton = new Bundle();
        Bundle secondCustomButton = new Bundle();

        firstCustomButton.putString("text", "Button one");
        firstCustomButton.putString("icon", "https://w7.pngwing.com/pngs/987/537/png-transparent-download-downloading-save-basic-user-interface-icon-thumbnail.png");
        firstCustomButton.putString("id", "btn1");

        secondCustomButton.putString("text", "Button two");
        secondCustomButton.putString("icon", "https://w7.pngwing.com/pngs/987/537/png-transparent-download-downloading-save-basic-user-interface-icon-thumbnail.png");
        secondCustomButton.putString("id", "btn2");

        customToolbarButtons.add(firstCustomButton);
        customToolbarButtons.add(secondCustomButton);

        return customToolbarButtons;
    }

    private void registerForBroadcastMessages() {
        IntentFilter intentFilter = new IntentFilter();

        /* This registers for every possible event sent from JitsiMeetSDK
           If only some of the events are needed, the for loop can be replaced
           with individual statements:
           ex:  intentFilter.addAction(BroadcastEvent.Type.AUDIO_MUTED_CHANGED.getAction());
                intentFilter.addAction(BroadcastEvent.Type.CONFERENCE_TERMINATED.getAction());
                ... other events
         */
        for (BroadcastEvent.Type type : BroadcastEvent.Type.values()) {
            intentFilter.addAction(type.getAction());
        }

        LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver, intentFilter);
    }

    // Example for handling different JitsiMeetSDK events
    private void onBroadcastReceived(Intent intent) {
        if (intent != null) {
            BroadcastEvent event = new BroadcastEvent(intent);

            switch (event.getType()) {
                case CONFERENCE_JOINED:
                    Timber.i("Conference Joined with url%s", event.getData().get("url"));
                    break;
                case PARTICIPANT_JOINED:
                    Timber.i("Participant joined%s", event.getData().get("name"));
                    break;
            }
        }
    }

    // Example for sending actions to JitsiMeetSDK
    private void hangUp() {
        Intent hangupBroadcastIntent = BroadcastIntentHelper.buildHangUpIntent();
        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(hangupBroadcastIntent);
    }
}
