import React, {useCallback, useRef} from 'react';

import {JitsiMeeting} from '@jitsi/react-native-sdk';

import {useNavigation} from '@react-navigation/native';


interface MeetingProps {
  route: any;
}

const Meeting = ( { route }: MeetingProps ) => {
  const jitsiMeeting = useRef(null);
  const navigation = useNavigation();

  const { room } = route.params;

  const onReadyToClose = useCallback(() => {
    // @ts-ignore
    navigation.navigate('Home');
    // @ts-ignore
    jitsiMeeting.current.close();
  }, [navigation]);

  const onEndpointMessageReceived = useCallback(() => {
      console.log('You got a message!');
  }, []);

  const eventListeners = {
        onReadyToClose,
        onEndpointMessageReceived
  };

  return (
      // @ts-ignore
      <JitsiMeeting
          config = {{
            hideConferenceTimer: true,
            customToolbarButtons: [
              {
                icon: "https://w7.pngwing.com/pngs/987/537/png-transparent-download-downloading-save-basic-user-interface-icon-thumbnail.png",
                id: "btn1",
                text: "Button one"
              }, {
                icon: "https://w7.pngwing.com/pngs/987/537/png-transparent-download-downloading-save-basic-user-interface-icon-thumbnail.png",
                id: "btn2",
                text: "Button two"
              }
            ],
            toolbarButtons: [ 'microphone', 'camera', 'screensharing', 'overflowmenu', 'hangup' ],
            whiteboard: {
                enabled: true,
                collabServerBaseUrl: "https://meet.jit.si/",
            },
          }}
          eventListeners = { eventListeners as any }
          flags = {{
              "audioMute.enabled": true,
              "ios.screensharing.enabled": true,
              "fullscreen.enabled": false,
              "audioOnly.enabled": false,
              "android.screensharing.enabled": true,
              "pip.enabled": true,
              "pip-while-screen-sharing.enabled": true,
              "conference-timer.enabled": true,
              "close-captions.enabled": false,
              "toolbox.enabled": true,
          }}
          ref = { jitsiMeeting }
          style = {{ flex: 1 }}
          room = { room }
          serverURL = { "https://meet.jit.si/" } />
  );
};

export default Meeting;
