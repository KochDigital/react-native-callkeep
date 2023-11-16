//
//  PjSipAudioController.m
//  Copyright © 2015 Devhouse Spindle. All rights reserved.
//

@import AVFoundation;

#import "PjSipAudioController.h"
#import "../VialerPJSIP.framework/Versions/A/Headers/pjsua.h"

NSString * const PjSipAudioControllerAudioInterrupted = @"PjSipAudioControllerAudioInterrupted";
NSString * const PjSipAudioControllerAudioResumed = @"PjSipAudioControllerAudioResumed";

@implementation PjSipAudioController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:nil];
}

- (BOOL)hasBluetooth {
    NSArray *availableInputs = [[AVAudioSession sharedInstance] availableInputs];

    for (AVAudioSessionPortDescription *input in availableInputs) {
        if ([input.portType isEqualToString:AVAudioSessionPortBluetoothHFP]) {
            return YES;
        }
    }
    return NO;
}

- (PjSipAudioControllerOutputs)output {
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *output in route.outputs) {
        if ([output.portType isEqualToString:AVAudioSessionPortBluetoothHFP]) {
            return PjSipAudioControllerOutputBluetooth;
        } else if ([output.portType isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
            return PjSipAudioControllerOutputSpeaker;
        }
    }
    return PjSipAudioControllerOutputOther;
}

- (void)setOutput:(PjSipAudioControllerOutputs)output {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (output == PjSipAudioControllerOutputSpeaker) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    } else if (output == PjSipAudioControllerOutputOther) {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
    NSLog(output == PjSipAudioControllerOutputSpeaker ? @"Speaker modus activated": @"Speaker modus deactivated");
}

- (void)configureAudioSession {
    NSError *audioSessionCategoryError;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&audioSessionCategoryError];
    NSLog(@"Setting AVAudioSessionCategory to \"Play and Record\"");

    if (audioSessionCategoryError) {
        NSLog(@"Error setting the correct AVAudioSession category");
    }

    // set the mode to voice chat
    NSError *audioSessionModeError;
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeVoiceChat error:&audioSessionModeError];
    NSLog(@"Setting AVAudioSessionCategory to \"Mode Voice Chat\"");

    if (audioSessionModeError) {
        NSLog(@"Error setting the correct AVAudioSession mode");
    }
}

- (void)checkCurrentThreadIsRegisteredWithPJSUA {
    static pj_thread_desc a_thread_desc;
    static pj_thread_t *a_thread;
    if (!pj_thread_is_registered()) {
        pj_thread_register("VialerPJSIP", a_thread_desc, &a_thread);
    }
}

- (BOOL)activateSoundDevice {
    NSLog(@"Activating audiosession");
    [self checkCurrentThreadIsRegisteredWithPJSUA];
    pjsua_set_no_snd_dev();
    pj_status_t status;
    status = pjsua_set_snd_dev(PJMEDIA_AUD_DEFAULT_CAPTURE_DEV, PJMEDIA_AUD_DEFAULT_PLAYBACK_DEV);
    if (status == PJ_SUCCESS) {
        return YES;
    } else {
        char statusmsg[PJ_ERR_MSG_SIZE];
        pj_strerror(status, statusmsg, sizeof(statusmsg));
        NSLog(@"Failure in enabling sound device, status: %s", statusmsg);
        
        return NO;
    }
}

- (void)activateAudioSession {
    if ([self activateSoundDevice]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
    }
}

- (void)deactivateSoundDevice {
    NSLog(@"Deactivating audiosession");
    [self checkCurrentThreadIsRegisteredWithPJSUA];
    pjsua_set_no_snd_dev();

}

- (void)deactivateAudioSession {
    [self deactivateSoundDevice];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:nil];
}

- (bool)setAudioRoute: (NSString *) inputName {
    @try {
        NSError* err = nil;\
        if ([inputName isEqualToString:@"Speaker"]) {
            [self setOutput:PjSipAudioControllerOutputSpeaker];
            return true;
        }

        AVAudioSession* myAudioSession = [AVAudioSession sharedInstance];
        NSArray *ports = [self getAudioInputs];
        for (AVAudioSessionPortDescription *port in ports) {
            if ([port.portName isEqualToString:inputName]) {
                BOOL isSetted = [myAudioSession setPreferredInput:(AVAudioSessionPortDescription *)port error:&err];
                if(!isSetted){
                    [NSException raise:@"setPreferredInput failed" format:@"error: %@", err];
                }
                return true;
            }
        }
        return false;
    }
    @catch ( NSException *e ){
        NSLog(@"[PjSipAudioController][setAudioRoute] exception: %@",e);
        return false;
    }
}

- (NSArray *) getAudioInputs
{
    NSError* err = nil;
    NSString *str = nil;

    AVAudioSession* myAudioSession = [AVAudioSession sharedInstance];
    NSString *category = [myAudioSession category];
    NSUInteger options = [myAudioSession categoryOptions];


    if(![category isEqualToString:AVAudioSessionCategoryPlayAndRecord] && (options != AVAudioSessionCategoryOptionAllowBluetooth) && (options !=AVAudioSessionCategoryOptionAllowBluetoothA2DP))
    {
        BOOL isCategorySetted = [myAudioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&err];
        if (!isCategorySetted)
        {
            NSLog(@"setCategory failed");
            [NSException raise:@"setCategory failed" format:@"error: %@", err];
        }
    }

    BOOL isCategoryActivated = [myAudioSession setActive:YES error:&err];
    if (!isCategoryActivated)
    {
        NSLog(@"[RNCallKeep][getAudioInputs] setActive failed");
        [NSException raise:@"setActive failed" format:@"error: %@", err];
    }

    NSArray *inputs = [myAudioSession availableInputs];
    return inputs;
}

- (NSString *) getAudioInputType: (NSString *) type
{
    if ([type isEqualToString:AVAudioSessionPortBuiltInMic]){
        return @"Phone";
    }
    else if ([type isEqualToString:AVAudioSessionPortHeadsetMic]){
        return @"Headset";
    }
    else if ([type isEqualToString:AVAudioSessionPortHeadphones]){
        return @"Headset";
    }
    else if ([type isEqualToString:AVAudioSessionPortBluetoothHFP]){
        return @"Bluetooth";
    }
    else if ([type isEqualToString:AVAudioSessionPortBluetoothA2DP]){
        return @"Bluetooth";
    }
    else if ([type isEqualToString:AVAudioSessionPortBuiltInSpeaker]){
        return @"Speaker";
    }
    else if ([type isEqualToString:AVAudioSessionPortCarAudio]) {
        return @"CarAudio";
    }
    else{
        return nil;
    }
}

- (NSString *) getSelectedAudioRoute
{
    AVAudioSession* myAudioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *currentRoute = [myAudioSession currentRoute];
    NSArray *selectedOutputs = currentRoute.outputs;
    
    AVAudioSessionPortDescription *selectedOutput = selectedOutputs[0];
    
    if(selectedOutput && [selectedOutput.portType isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
        return @"Phone";
    }
    
    return [self getAudioInputType: selectedOutput.portType];
}


/**
 *  Function called on AVAudioSessionInterruptionNotification
 *
 *  The class registers for AVAudioSessionInterruptionNotification to be able to regain
 *  audio after it has been interrupted by another call or other audio event.
 *
 *  @param notification The notification which lead to this function being invoked over GCD.
 */
- (void)audioInterruption:(NSNotification *)notification {
    NSInteger avInteruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    if (avInteruptionType == AVAudioSessionInterruptionTypeBegan) {
        [self deactivateSoundDevice];
        [[NSNotificationCenter defaultCenter] postNotificationName:PjSipAudioControllerAudioInterrupted
                                                            object:self
                                                          userInfo:nil];

    } else if (avInteruptionType == AVAudioSessionInterruptionTypeEnded) {
        [self activateSoundDevice];
        [[NSNotificationCenter defaultCenter] postNotificationName:PjSipAudioControllerAudioResumed
                                                            object:self
                                                          userInfo:nil];
    }
}

@end
