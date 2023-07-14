//
//  PjSipRingback.m
//  Copyright © 2016 Devhouse Spindle. All rights reserved.
//

#import "PjSipRingback.h"

#import "Constants.h"
#import "NSString+PJString.h"
#import <VialerPJSIP/pjsua.h>
#import "PjSipEndpoint.h"

static int const PjSipRingbackChannelCount = 1;
static int const PjSipRingbackRingbackCount = 1;
static int const PjSipRingbackFrequency1 = 440;
static int const PjSipRingbackFrequency2 = 440;
static int const PjSipRingbackOnDuration = 2000;
static int const PjSipRingbackOffDuration = 4000;
static int const PjSipRingbackInterval = 4000;

@interface PjSipRingback()
@property (readonly, nonatomic) NSInteger ringbackSlot;
@property (readonly, nonatomic) pjmedia_port *ringbackPort;
@end

@implementation PjSipRingback

-(instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }

    PjSipEndpoint *endpoint = [PjSipEndpoint instance];

    pj_status_t status;
    pjmedia_tone_desc tone[PjSipRingbackRingbackCount];
    pj_str_t name = pj_str("tone");

    //TODO make ptime and channel count not constant?

    NSUInteger samplesPerFrame = (PJSUA_DEFAULT_AUDIO_FRAME_PTIME * 16000 * PjSipRingbackChannelCount) / 1000;

    status = pjmedia_tonegen_create2(endpoint.pjPool, &name, (unsigned int)16000, PjSipRingbackChannelCount, (unsigned int)samplesPerFrame, 16, PJMEDIA_TONEGEN_LOOP, &_ringbackPort);

    if (status != PJ_SUCCESS) {
        char statusmsg[PJ_ERR_MSG_SIZE];
        pj_strerror(status, statusmsg, sizeof(statusmsg));
        NSLog(@"Error creating ringback tones, status: %s", statusmsg);
        return nil;
    }

    pj_bzero(&tone, sizeof(tone));

    for (int i = 0; i < PjSipRingbackRingbackCount; ++i) {
        tone[i].freq1 = PjSipRingbackFrequency1;
        tone[i].freq2 = PjSipRingbackFrequency2;
        tone[i].on_msec = PjSipRingbackOnDuration;
        tone[i].off_msec = PjSipRingbackOffDuration;
    }

    tone[PjSipRingbackRingbackCount - 1].off_msec = PjSipRingbackInterval;

    pjmedia_tonegen_play(self.ringbackPort, PjSipRingbackRingbackCount, tone, PJMEDIA_TONEGEN_LOOP);

    status = pjsua_conf_add_port(endpoint.pjPool, [self ringbackPort], (int *)&_ringbackSlot);

    if (status != PJ_SUCCESS) {
        char statusmsg[PJ_ERR_MSG_SIZE];
        pj_strerror(status, statusmsg, sizeof(statusmsg));
        NSLog(@"Error adding media port for ringback tones, status: %s", statusmsg);
        return nil;
    }
    return self;
}

-(void)dealloc {
    [self checkCurrentThreadIsRegisteredWithPJSUA];
    // Destory the conference port otherwise the maximum number of ports will reached and pjsip will crash.
    pj_status_t status = pjsua_conf_remove_port((int)self.ringbackSlot);
    if (status != PJ_SUCCESS) {
        char statusmsg[PJ_ERR_MSG_SIZE];
        pj_strerror(status, statusmsg, sizeof(statusmsg));
        NSLog(@"Error removing the port, status: %s", statusmsg);
        return;
    }
    
    pjmedia_port_destroy(self.ringbackPort);
}

-(void)start {
    PjSipLogInfo(@"Start ringback, isPlaying: %@", self.isPlaying ? @"YES" : @"NO");
    if (!self.isPlaying) {
        pjsua_conf_connect((int)self.ringbackSlot, 0);
        self.isPlaying = YES;
    }
}

-(void)stop {
    PjSipLogInfo(@"Stop ringback, isPlaying: %@", self.isPlaying ? @"YES" : @"NO");
    if (self.isPlaying) {
        pjsua_conf_disconnect((int)self.ringbackSlot, 0);
        self.isPlaying = NO;

        // Destory the conference port otherwise the maximum number of ports will reached and pjsip will crash.
        pj_status_t status = pjsua_conf_remove_port((int)self.ringbackSlot);
        if (status != PJ_SUCCESS) {
            char statusmsg[PJ_ERR_MSG_SIZE];
            pj_strerror(status, statusmsg, sizeof(statusmsg));
            NSLog(@"Error removing the port, status: %s", statusmsg);
        }
    }
}

- (void)checkCurrentThreadIsRegisteredWithPJSUA {
    static pj_thread_desc a_thread_desc;
    static pj_thread_t *a_thread;
    if (!pj_thread_is_registered()) {
        pj_thread_register("VialerPJSIP", a_thread_desc, &a_thread);
    }
}
@end