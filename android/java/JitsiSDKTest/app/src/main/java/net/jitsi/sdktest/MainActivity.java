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
import java.util.List;
import java.util.Map;

import timber.log.Timber;

public class MainActivity extends AppCompatActivity {


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
                .setFeatureFlag("pip.enabled", false)
                .setConfigOverride("customToolbarButtons", getCustomToolbarButtons())
                .setConfigOverride("toolbarButtons", getToolbarButtons())
                .setConfigOverride("recordingService", getRecordingService())
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
                    // When using JaaS, set the obtained JWT here
                    //.setToken("MyJWT")
                    // Different features flags can be set
                    //.setFeatureFlag("toolbox.enabled", false)
                    //.setFeatureFlag("prejoinpage.enabled", false)
                    .setFeatureFlag("pip.enabled", true)
                    .setFeatureFlag("welcomepage.enabled", false)
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
        Bundle thirdCustomButton = new Bundle();
        Bundle fourthCustomButton = new Bundle();
        Bundle fifthCustomButton = new Bundle();

        firstCustomButton.putString("icon", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFISURBVHgBxVWBcYMwDJQ7QbuBu4FHcDfoBvEGZQOSicgGdIPQCWADRnClQ76qYFE7Vy5/J3yRXpKlCAFwMEwJKcbo8CCxrJpQBmPMAPcCgz6jtChz1DGifBC3NrhnZ0KPElCsrIh1nUjkS4OfapwosbjM6S+yZ+Ktpmxu5419/R5pZKnraYk/Khu+gYU7ITpwTjojjCMeXzh675ozLKNKuCJvUng98dD+IpWOMwfFqY1btAo3sN3tK39sNurwO/xAv59Yb+mhvJnZljE2FxKtszLBYUgJJnooE7S3b65rhWjzJBOkIH7tgCV/4nGBLS7KJDkZU47pDMuGfMs4perS/zFw4hyvg2VMX9eGszYZpRAT1OSMx64KJh237AQ5vXRjLNhL8fe3I0AJVk4dJ3XCblnXi8t4qAGX3YhEOcw8HGo7H/fR/y98AzFrGjU3gjYAAAAAAElFTkSuQmCC");
        firstCustomButton.putString("id", "record");

        secondCustomButton.putString("icon", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAFRSURBVHgB1VTRcYMwDBWdgBG8QTMCGzQbNBuUDWCDsgHZICPQDdINSCcgncCV7p5bVXHADpePvDsdRBbvyX5yiO6MIqXIe+/4UXE4pD4liqI40RowccUx+OsYIH4TeQOSiaPVRPy+4dhxjKhpKAeKfM9RztSVqBHUlALpFB8cKBFSi29cSvEeW3dGdMBxSfRmvUR+uSl00hvyEQSdamDUx4e1ae5Ig3mCF/Ohj+xI0KrcDrmN5nwyGkH9W+WeOT70zONd7oImOxmOqMAZT6dyX4bINmN/n+kalFmdylVh1nE0UvOO3KuqE28mWgJGbjIGtv4SrVoPg9CnCETvAfJviCrS1L9BWBKpw7Ek1DZ2R6kiYTy3MzVb1HSUC5h5hB8usu6wdqRbocwbjek672gN/N/tHlTuELu1a0R+TVempv09Z4h06g7km5ooUmeP48PjBzBGLGGSG2WSAAAAAElFTkSuQmCC");
        secondCustomButton.putString("id", "location");
        
        thirdCustomButton.putString("icon", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAErSURBVHgBvZWNEYIwDIWD5yCOwAiwAW6AG7gBMAmM4AawAW6gGzhCTc7Ahf6dbdF3J7208X1tWgrAj5XJQClVYFNAmu5Zlt2MXjTv1X7qdfOKB1pIFHmwV2F0QqDIhP9baf3rZI8QKS5DLeIBa3/R8w4QZ16xeYemdFA6ijdlSQGgcnqgdytbsJzAWMBED5xxI1vUbM12bTJ25eAQ1Vw7moMYWzf54DGgWc1idhthWWpszvCpf8kxfLUCMuVZjNw2ECC5AgMgzFs5JiGc88DfKQigmzvGl5yXC+IDGOauHDJmgAHxAazmWt5VxFaIdw9CZYNIQOyLtgqP5xObksNRL1cywAbZHWCBGICJHirwhXJAls/l9l5S5t2SomGFahC653NI04QrmeBfegPEpC4OSSpfkQAAAABJRU5ErkJggg==");
        thirdCustomButton.putString("id", "screenshot");
        
        fourthCustomButton.putString("icon", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAADSSURBVHgB7VTRCcJADE3BAeoGHcFNdAPdwG7QbqBO0G7gCHaD4gR1BJ0gvsOAIl5jAkd/+uDRwr33cuTuQjQjFZi5BStKBSnAkxdZKAEFPmtwGZHcwDtYQ/vIsuxIht3t2YazJXwnptCCfES3FV0/pvtlvICDovGFi3kAG0XTu8LFHFq0UjS5KzwWpqwXYEnO8CY0WtGUch4FecKBWtG12qVwhcs5HP7ZxLexYhuiLzg2Kq4f/yd6jYMYOoyIjqzg92v23XVrEUoFhG/YMshmWPEEwndJv9jtUaIAAAAASUVORK5CYII=");
        fourthCustomButton.putString("id", "swap-camera");
        
        fifthCustomButton.putString("backgroundColor", "red");
        fifthCustomButton.putString("icon", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAACESURBVHgB7ZRLDoAgDESL8b7iCfQIXtUTjDSyYMGnhe7gJSTGTOcl2kC0mBMARziXMu+leR7w+GlKOBOzN2nggZaku1wiGS6vSczKcxLz8oxEVb6RHBSex0k/CwTb1V2evLOR1H7osASCbemWQLGKiSR7F+2FuTec0zn3UIOQYQEtJuYDedv/MgzzIYUAAAAASUVORK5CYII=");
        fifthCustomButton.putString("id", "close");

        customToolbarButtons.add(firstCustomButton);
        customToolbarButtons.add(secondCustomButton);
        customToolbarButtons.add(thirdCustomButton);
        customToolbarButtons.add(fourthCustomButton);
        customToolbarButtons.add(fifthCustomButton);

        return customToolbarButtons;
    }

    private static Bundle getRecordingService() {
        Bundle recordingService = new Bundle();
        recordingService.putBoolean("enabled", true);
        recordingService.putBoolean("sharingEnabled", true);

        return recordingService;
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

    private String[] getToolbarButtons() {
        return new String[]{"record", "location", "screenshot", "swap-camera", "close"};
    }
}
