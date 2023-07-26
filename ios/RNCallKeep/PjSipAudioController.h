//
//  PjSipAudioController.h
//  Copyright © 2015 Devhouse Spindle. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * __nonnull const PjSipAudioControllerAudioInterrupted;
extern NSString * __nonnull const PjSipAudioControllerAudioResumed;

/**
 *  Possible outputs the audio can have.
 */
typedef NS_ENUM(NSInteger, PjSipAudioControllerOutputs) {
    /**
     *  Audio is sent over the speaker
     */
    PjSipAudioControllerOutputSpeaker,
    /**
     *  Audio is sent to the ear speaker or mini jack
     */
    PjSipAudioControllerOutputOther,
    /**
     *  Audio is sent to bluetooth
     */
    PjSipAudioControllerOutputBluetooth,
};
#define PjSipAudioControllerOutputsString(PjSipAudioControllerOutputs) [@[@"PjSipAudioControllerOutputSpeaker", @"PjSipAudioControllerOutputOther", @"PjSipAudioControllerOutputBluetooth"] objectAtIndex:PjSipAudioControllerOutputs]


@interface PjSipAudioController : NSObject

/**
 *  If there is a Bluetooth headset connected, this will return YES.
 */
@property (readonly, nonatomic) BOOL hasBluetooth;

/**
 *  The current routing of the audio.
 *
 *  Attention: Possible values that can be set: PjSipAudioControllerSpeaker & PjSipAudioControllerOther.
 *  Setting the property to PjSipAudioControllerBluetooth won't work, if you want to activatie bluetooth
 *  you have to change the route with the mediaplayer (see example app).
 */
@property (nonatomic) PjSipAudioControllerOutputs output;

/**
 *  Configure audio.
 */
- (void)configureAudioSession;

/**
 *  Activate the audio session.
 */
- (void)activateAudioSession;

/**
 *  Deactivate the audio session.
 */
- (void)deactivateAudioSession;

- (bool)setAudioRoute: (NSString *) inputName;

- (NSArray *) getAudioInputs;

- (NSString *) getAudioInputType: (NSString *) type;

- (NSString *) getSelectedAudioRoute;

@end
