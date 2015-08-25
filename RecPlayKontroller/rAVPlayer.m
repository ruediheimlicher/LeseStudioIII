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
   //NSLog(@"prepareAufnahmeAnURL: %@",url);
   self.hiddenAufnahmePfad = [url path];
   if ([AVAbspielplayer isPlaying])
   {
      [AVAbspielplayer stop];
   }
   return;
   // an url muss schon ein lokales file sein, nicht nur eine adresse
   NSError* err;
   AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                            error: &err];
   NSLog(@"prepareAufnahmeAnURL err: %@",err);
   [AVAbspielplayer prepareToPlay];

}

- (void)playAufnahme
{
  //NSLog(@"playAufnahme: %@", AVAbspielplayer.url);
   {
      // http://stackoverflow.com/questions/1605846/avaudioplayer-with-external-url-to-m4p
      NSError* err;
      AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:  self.hiddenAufnahmePfad]
                                                               error: &err];
      NSLog(@"playAufnahme err: %@",err);
      [AVAbspielplayer prepareToPlay];

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
