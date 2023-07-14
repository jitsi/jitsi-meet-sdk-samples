import React, {useState} from 'react';
import {Button, TextInput, View} from 'react-native';
import {useNavigation} from '@react-navigation/native';

const Home = () => {
    const navigation = useNavigation();
    const [roomName, onChangeRoomName] = useState('');

    return (
        <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
            <TextInput
                // @ts-ignore
                onChangeText={onChangeRoomName}
                placeholder="Enter room name here"
                style={{color: 'black', padding: 32}}
                value={roomName} />
            <Button
                disabled={!roomName}
                color="blue"
                // @ts-ignore
                onPress={() => navigation.navigate('Meeting', { roomName })}
                // @ts-ignore
                style={{height: 32, width: 32}}
                title="Join" />
        </View>
    );
};

export default Home;
