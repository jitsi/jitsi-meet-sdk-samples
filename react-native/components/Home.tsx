import React from 'react';
import {UseNavigationProp} from '../types';
import {useNavigation} from '@react-navigation/native';
import {TouchableOpacity, TextInput, View, StyleSheet, Text, Platform} from 'react-native';

const Home: React.FC = () => {
    const navigation = useNavigation<UseNavigationProp>();

    const [room, onChangeRoom] = React.useState<string>('');

    const onJoinPress = React.useCallback(() => {
      navigation.navigate('Meeting', {room});
    }, [navigation, room]);

    return (
        <View style={style.container}>
          <TextInput
            value={room} 
            style={style.input}
            onChangeText={onChangeRoom}
            placeholder="Enter room name here"
          />
          <TouchableOpacity
            disabled={!room}
            style={[
              style.button, 
              !room 
                ? style.disabledButton 
                : style.activeButton
              ]}
            onPress={onJoinPress}
            activeOpacity={0.6}>
            <Text style={style.buttonText}>
              Join
            </Text>
          </TouchableOpacity>
        </View>
    );
};

export default Home;

const style = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  input: {
    borderRadius: 5,
    marginBottom: 16,
    color: '#000000',
    paddingHorizontal: 32,
    backgroundColor: '#f7f9f9',
    ...(Platform.OS === 'ios' && {
      paddingVertical: 16,
    })
  },
  button: {
    width: 60,
    height: 40,
    borderRadius: 5,
    alignItems: 'center',
    justifyContent: 'center',
  },
  activeButton: {
    backgroundColor: 'blue',
  },
  disabledButton: {
    backgroundColor: 'gray'
  },
  buttonText: {
    color: "#ffffff",
  }
})