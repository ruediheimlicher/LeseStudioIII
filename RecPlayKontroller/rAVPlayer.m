//
//  rAVPlayer.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 23.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "rAVPlayer.h"

@implementation rAVPlayer

- (id)init
{
   self = [super init];
   if (self)
   {
      
         }
   return self;
}

- (void)setURL:(NSURL*)playerURL
{
   AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: playerURL
                                                            error: nil];
   [AVAbspielplayer prepareToPlay];
}

@end
