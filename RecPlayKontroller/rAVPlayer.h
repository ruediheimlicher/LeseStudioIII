//
//  rAVPlayer.h
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 23.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface rAVPlayer : NSObject
{
   AVAudioPlayer *                     AVAbspielplayer;
}
@property (assign) NSWindow *          PlayerFenster;
@property (weak) NSURL*                tempDirURL;
@property  NSString*                   hiddenAufnahmePfad;


- (void)playAufnahme;
- (void)stopTempAufnahme;
- (void)backTempAufnahme;
- (void)prepareAufnahmeAnURL:(NSURL*)url;
@end
