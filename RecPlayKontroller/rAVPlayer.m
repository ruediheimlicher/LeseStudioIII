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

- (NSURL*)AufnahmeURL
{
   return AVAbspielplayer.url;
}

- (void)prepareAufnahmeAnURL:(NSURL*)url
{
   if (url)
   {
      NSLog(@"prepareAufnahmeAnURL: %@",url.path);
      self.hiddenAufnahmePfad = [url path];
      if ([AVAbspielplayer isPlaying])
      {
         [AVAbspielplayer stop];
      }
   }
   return;
   // an url muss schon ein lokales file sein, nicht nur eine adresse
   NSError* err;
   AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                            error: &err];
   
   [AVAbspielplayer prepareToPlay];
   double dur = AVAbspielplayer.duration;
   
   NSLog(@"prepareAufnahmeAnURL err: %@ dur: %f",err, dur);
   
}

- (void)prepareAdminAufnahmeAnURL:(NSURL*)url
{
   NSLog(@"prepareAdminAufnahmeAnURL: %@",url.path);
   if ([AVAbspielplayer isPlaying])
   {
      [AVAbspielplayer stop];
   }
   // an url muss schon ein lokales file sein, nicht nur eine adresse
   NSError* err;
   AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                            error: &err];
   
   [AVAbspielplayer prepareToPlay];
   double dur = AVAbspielplayer.duration;
   
   NSLog(@"prepareAdminAufnahmeAnURL err: %@ dur: %f",err, dur);
   
}

- (void)playAdminAufnahme
{
   
   if (haltzeit)
   {
      NSLog(@"playAufnahme nach halt: %2.2f",haltzeit);
      AVAbspielplayer.currentTime = haltzeit;
      [AVAbspielplayer play];
   }
   else
      
   {
      NSLog(@"playAdminAufnahme: %@", AVAbspielplayer.url.path);
      // http://stackoverflow.com/questions/1605846/avaudioplayer-with-external-url-to-m4p
      double dur = AVAbspielplayer.duration;
      haltzeit = 0;
      [AVAbspielplayer play];
      
      if ( [posTimer isValid])
      {
         [posTimer invalidate];
      }
      posTimer=[NSTimer scheduledTimerWithTimeInterval:0.1
                                                target:self
                                              selector:@selector(posAnzeigeFunktion:)
                                              userInfo:NULL
                                               repeats:YES];
      
      
   }
}


- (void)playAufnahme
{
 
   if (haltzeit)
   {
      NSLog(@"playAufnahme nach halt: %2.2f",haltzeit);
      AVAbspielplayer.currentTime = haltzeit;
      [AVAbspielplayer play];
   }
   else
  
   {
      NSLog(@"playAufnahme: %@", AVAbspielplayer.url.path);
      // http://stackoverflow.com/questions/1605846/avaudioplayer-with-external-url-to-m4p
      NSError* err;
      AVAbspielplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:  self.hiddenAufnahmePfad]
                                                               error: &err];
      NSLog(@"playAufnahme err: %@",err);
      [AVAbspielplayer prepareToPlay];
      double dur = AVAbspielplayer.duration;
      haltzeit = 0;
      [AVAbspielplayer play];
      
      if ( [posTimer isValid])
      {
         [posTimer invalidate];
      }
      posTimer=[NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(posAnzeigeFunktion:)
                                                        userInfo:NULL
                                                         repeats:YES];

      
   }
}

- (void)invalTimer
{
   if ( [posTimer isValid])
   {
      [posTimer invalidate];
   }
}

- (void)posAnzeigeFunktion:(NSTimer*)timer
{
   NSTimeInterval pos =AVAbspielplayer.currentTime;
   NSTimeInterval dur =AVAbspielplayer.duration;
   
   
   if (pos)
   {
  //    NSLog(@"pos: %f dur: %f",pos,dur);
      NSNotificationCenter * nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"abspielpos" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [NSNumber numberWithDouble:pos] ,@"pos",
                                                                   [NSNumber numberWithDouble:dur] ,@"dur",nil]];

      
      if (pos == dur)
      {
         [posTimer invalidate];
      }
   }
}
- (void)resetTimer
{
   if ([posTimer isValid])
   {
      [posTimer invalidate];
   }
}

- (BOOL)isPlaying
{
   return [AVAbspielplayer isPlaying];
}

- (double)duration
{
   return AVAbspielplayer.duration;
}

- (double)position
{
   return AVAbspielplayer.currentTime;
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
   haltzeit = [AVAbspielplayer currentTime];
   [AVAbspielplayer pause];
}

- (void)toStartTempAufnahme
{
   NSLog(@"AVAbspielplayer toBeginTempAufnahme");
   {
      AVAbspielplayer.currentTime = 0;
   }
   [AVAbspielplayer play];
}


- (void)rewindTempAufnahme
{
   NSLog(@"AVAbspielplayer rewindTempAufnahme");
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

- (void)forewardTempAufnahme
{
   NSLog(@"AVAbspielplayer forewardTempAufnahme");
   NSTimeInterval playbackDelay = 3.0;              // must be ≥ 0
   NSTimeInterval pos =AVAbspielplayer.currentTime;
    NSTimeInterval end =AVAbspielplayer.duration;
   NSLog(@"AVAbspielplayer pos: %f",pos);
   if (pos < end - playbackDelay)
   {
      AVAbspielplayer.currentTime = pos + playbackDelay;
   }
   [AVAbspielplayer play];
}

@end
