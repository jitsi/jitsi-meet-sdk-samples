import React, {useCallback, useRef} from 'react';
import {
  useRoute,
  RouteProp,
  useNavigation,
} from '@react-navigation/native';
import type {
  RootStackType, 
  IEventListeners, 
  JitsiMeetingRef, 
  UseNavigationProp
} from '../types';
import {StyleSheet} from 'react-native';
import {JitsiMeeting} from '@jitsi/react-native-sdk/index';

const CONFIG = {};
const SERVICE_URL = 'https://meet.jit.si/';

const Meeting: React.FC = () => {
  const jitsiMeeting = useRef<JitsiMeetingRef>(null);

  const navigation = useNavigation<UseNavigationProp>();

  const {
    params: {room},
  } = useRoute<RouteProp<RootStackType, 'Meeting'>>();

  const onReadyToClose = useCallback(() => {
    navigation.navigate('Home');
    jitsiMeeting.current?.close();
  }, [navigation]);

  const eventListeners = React.useMemo((): IEventListeners => {
    return {onReadyToClose}
  }, []);

  return (
    <JitsiMeeting
      room={room}
      config={CONFIG}    
      ref={jitsiMeeting}
      style={style.jitsi}
      serverURL={SERVICE_URL}
      eventListeners={eventListeners} 
    />
  );
};

export default Meeting;

const style = StyleSheet.create({
  jitsi: {
    flex: 1,
  }
})