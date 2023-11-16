//
//  PjSipConference.h
//  Pods
//
//  Created by Andre on 09/06/23.
//
#import <React/RCTUtils.h>

#import "../VialerPJSIP.framework/Versions/A/Headers/pjsua.h"

#import "PjSipCall.h"

@interface PjSipConference : NSObject

@property int id;
@property NSMutableDictionary* calls;


+(instancetype)instance;

-(void)addCall:(PjSipCall*) call;
-(void)removeCall:(PjSipCall*) call;
-(void)start;
-(void)stop;


@end
