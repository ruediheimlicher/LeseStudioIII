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

- (void)prepareAufnahmeAnURL:(NSURL*)url
{
   if ([AVAbspielplayer isPlaying])
   {
      [AVAbspielplayer stop];
   }
   AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                            error: nil];
   [AVAbspielplayer prepareToPlay];

}

- (void)playAufnahme
{
  
   {
      [AVAbspielplayer play];
      
   }
}
   - (void)openAufnahme
   {
   NSOpenPanel *playPanel = [NSOpenPanel openPanel];
   
   [playPanel beginSheetModalForWindow:[self PlayerFenster] completionHandler:^(NSInteger result)
    {
       NSError *error = nil;
       if (result == NSOKButton)
       {
          
          
          
          NSString* testpfad = [[[NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Lesebox"]stringByAppendingPathComponent:@"trimm"]stringByAppendingPathExtension:@"m4a"];
          
          [self setURL:[playPanel URL]];
          
          [AVAbspielplayer play];
       }
       else
          
       {
          [playPanel orderOut:self];
          //[self presentError:error modalForWindow:[self RecorderFenster] delegate:self didPresentSelector:@selector(didPresentErrorWithRecovery:contextInfo:) contextInfo:NULL];
       }
       
       
       
    }];
   

}

- (void)stopTempAufnahme
{
   [AVAbspielplayer stop];
}
- (void)backTempAufnahme
{
   NSLog(@"AVAbspielplayer backAVPlay");
   NSTimeInterval playbackDelay = 3.0;              // must be ≥ 0
   NSTimeInterval pos =AVAbspielplayer.currentTime;
   NSLog(@"AVAbspielplayer pos: %f",pos);
   if (pos > playbackDelay)
   {
   AVAbspielplayer.currentTime = pos - playbackDelay;
   }
   else
   {
      AVAbspielplayer.currentTime = 0;
   }
   [AVAbspielplayer play];
}
@end
