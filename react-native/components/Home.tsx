import React from 'react';
import {Button, TextInput, View} from 'react-native';
import {useNavigation} from '@react-navigation/native';

interface HomeProps {
  onChangeText: Function;
  text: string;
}

const Home = ({onChangeText, text}: HomeProps) => {
  const navigation = useNavigation();

  return (
    <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
      <TextInput
        style={{color: 'black'}}
        // @ts-ignore
        onChangeText={onChangeText}
        value={text}
        placeholder="Enter room name here"
      />
      <Button
        title="Join"
        color="red"
        // @ts-ignore
        onPress={() => navigation.navigate('Meeting')}
      />
    </View>
  );
};

export default Home;
