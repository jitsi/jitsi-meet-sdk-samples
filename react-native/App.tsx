import React from 'react';

import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';

import Home from './components/Home';
import Meeting from './components/Meeting';

import {type RootStackType} from './types'

const RootStack = createStackNavigator<RootStackType>();

const screenOptions = {
  headerShown: false,
};

const App: React.FC = () => (
    <NavigationContainer>
      <RootStack.Navigator initialRouteName="Home">
        <RootStack.Screen
          name="Home"
          component={Home}
          options={screenOptions}
        />
        <RootStack.Screen
          name="Meeting"
          component={Meeting}
          options={screenOptions}
        />
      </RootStack.Navigator>
    </NavigationContainer>
);

export default App;
