import React, {useState} from 'react';
import {Button, TextInput, View} from 'react-native';

import {useNavigation} from '@react-navigation/native';

const Home = () => {
    const navigation = useNavigation();
    const [room, onChangeRoom] = useState('');

    return (
        <View style={{
            alignItems: 'center',
            flex: 1,
            justifyContent: 'center'
        }}>
            <TextInput
                // @ts-ignore
                onChangeText={onChangeRoom}
                placeholder="Enter room name here"
                style={{color: 'black', padding: 32}}
                value={room} />
            <Button
                color="blue"
                disabled={!room}
                // @ts-ignore
                onPress={() => navigation.navigate('Meeting', { room })}
                // @ts-ignore
                style={{height: 32, width: 32}}
                title="Join" />
        </View>
    );
};

export default Home;
