import {type StackNavigationProp} from '@react-navigation/stack';

export type RootStackType = {
  Home: undefined;
  Meeting: {
    room: string;
  }
}

export type UseNavigationProp<
  T extends keyof RootStackType = keyof {}
> = StackNavigationProp<RootStackType, T>

export type JitsiMeetingRef = {
  close: () => void;
  setVideoMuted: () => void;
  setAudioMuted: () => void;
}

export interface IEventListeners {
  onConferenceBlurred?: Function;
  onConferenceFocused?: Function;
  onConferenceJoined?: Function;
  onConferenceLeft?: Function;
  onConferenceWillJoin?: Function;
  onEnterPictureInPicture?: Function;
  onParticipantJoined?: Function;
  onReadyToClose?: Function;
}