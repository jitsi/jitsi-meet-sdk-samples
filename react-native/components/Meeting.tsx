import React, {useCallback, useRef} from 'react';
import DeviceInfo from 'react-native-device-info';

import {JitsiMeeting} from '@jitsi/react-native-sdk/index';
import {useNavigation} from '@react-navigation/native';

const isSimulator = DeviceInfo.isEmulatorSync();

interface MeetingProps {
  route: any;
}

const Meeting = ({route}: MeetingProps) => {
  const jitsiMeeting = useRef(null);
  const navigation = useNavigation();
  const { roomName } = route.params;

  const onReadyToClose = useCallback(() => {
    // @ts-ignore
    navigation.navigate('Home');
    // @ts-ignore
    jitsiMeeting.current.close();
  }, [navigation]);

  const meetingOptions = {
    domain: 'https://meet.jit.si',
    onReadyToClose,
    roomName,
    settings: {
      startWithAudioMuted: true,
      startWithVideoMuted: true,
      startAudioOnly: false,
    },
  };

  return (
      <JitsiMeeting
          // @ts-ignore
          flags={{'call-integration.enabled': !isSimulator}}
          meetingOptions={meetingOptions}
          ref={jitsiMeeting}
          style={{flex: 1}} />
  );
};

export default Meeting;
