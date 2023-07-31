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

  const { room } = route.params;

  const onReadyToClose = useCallback(() => {
    // @ts-ignore
    navigation.navigate('Home');
    // @ts-ignore
    jitsiMeeting.current.close();
  }, [navigation]);

  const eventListeners = {
    onReadyToClose
  };

  return (
      // @ts-ignore
      <JitsiMeeting
          eventListeners={eventListeners as any}
          flags={{'call-integration.enabled': !isSimulator}}
          ref={jitsiMeeting}
          style={{flex: 1}}
          room={room}
          serverURL={'https://meet.jit.si/'} />
  );
};

export default Meeting;
