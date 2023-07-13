import React, {useCallback, useRef} from 'react';

import {JitsiMeeting} from '@jitsi/react-native-sdk/index';
import {useNavigation} from '@react-navigation/native';

interface MeetingProps {
  text: string;
}

const Meeting = ({text}: MeetingProps) => {
  const jitsiMeeting = useRef(null);
  const navigation = useNavigation();

  const onClose = useCallback(() => {
    // @ts-ignore
    navigation.navigate('Home');
    // @ts-ignore
    jitsiMeeting.current.close();
  }, [navigation]);

  const meetingOptions = {
    domain: 'https://meet.jit.si',
    onReadyToClose: onClose,
    roomName: text,
    settings: {
      startWithAudioMuted: true,
      startWithVideoMuted: true,
      startAudioOnly: false,
    },
  };

  return (
    <>
      <JitsiMeeting
        // @ts-ignore
        flags={{'call-integration.enabled': false}}
        meetingOptions={meetingOptions}
        ref={jitsiMeeting}
        style={{flex: 1}}
      />
    </>
  );
};

export default Meeting;
