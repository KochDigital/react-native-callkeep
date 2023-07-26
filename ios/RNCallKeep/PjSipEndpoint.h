#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#import "PjSipAccount.h"
#import "PjSipCall.h"
#import "PjSipModule.h"
#import "PjSipRingback.h"
#import "PjSipAudioController.h"
#import "PjSipCustomStringArray.h"


@interface PjSipEndpoint : NSObject

@property NSMutableDictionary* accounts;
@property NSMutableDictionary* calls;
@property PjSipCustomStringArray* endedCallIds;
@property(nonatomic, strong) PjSipModule *bridge;
@property (strong, nonatomic) PjSipRingback *ringback;
@property (strong, nonatomic) PjSipAudioController * audioController;


@property pjsua_transport_id tcpTransportId;
@property pjsua_transport_id udpTransportId;
@property pjsua_transport_id tlsTransportId;

@property bool isSpeaker;
  
@property pj_pool_t * _Nullable pjPool;

+(instancetype)instance;

-(NSDictionary *)start: (NSDictionary *) config;

-(void) updateStunServers: (int) accountId stunServerList:(NSArray *)stunServerList;

-(PjSipAccount *)createAccount:(NSDictionary*) config;
-(void) deleteAccount:(int) accountId;
-(PjSipAccount *)findAccount:(int)accountId;
-(PjSipCall *)makeCall:(PjSipAccount *) account destination:(NSString *)destination callSettings: (NSDictionary *)callSettings msgData: (NSDictionary *)msgData;
-(void)pauseParallelCalls:(PjSipCall*) call; // TODO: Remove this feature.
-(PjSipCall *)findCall:(int)callId;
-(PjSipCall *)findCallWithUuid:(NSString *)callUuid;
-(void)useSpeaker;
-(void)useEarpiece;

-(void)changeOrientation: (NSString*) orientation;
-(void)changeCodecSettings: (NSDictionary*) codecSettings;
-(void)assignCall:(PjSipCall*) call callId:(int)callId;

-(void)emmitRegistrationChanged:(PjSipAccount*) account;
-(void)emmitCallReceived:(PjSipCall*) call;
-(void)emmitCallUpdated:(PjSipCall*) call;
-(void)emmitCallChanged:(PjSipCall*) call;
-(void)emmitCallTerminated:(PjSipCall*) call;

@end
