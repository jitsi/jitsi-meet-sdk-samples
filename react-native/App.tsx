import React, {useState} from 'react';

import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';

import Home from './components/Home';
import Meeting from './components/Meeting';

const RootStack = createStackNavigator();

const App = () => {
  const [text, onChangeText] = useState('ThisRoomNameIsATestForYouToTest');

  return (
    <NavigationContainer>
      <RootStack.Navigator initialRouteName="Home">
        <RootStack.Screen
          children={() => {
            return <Home onChangeText={onChangeText} text={text} />;
          }}
          name="Home"
          options={{
            headerShown: false,
          }}
        />
        <RootStack.Screen
          children={() => {
            return <Meeting text={text} />;
          }}
          name="Meeting"
          options={{
            headerShown: false,
          }}
        />
      </RootStack.Navigator>
    </NavigationContainer>
  );
};

export default App;
