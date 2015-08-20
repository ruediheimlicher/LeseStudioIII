//
//  ViewController+AVRecorder.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 19.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "ViewController+AVRecorder.h"

@implementation ViewController (AVRecorder)

- (void)AufnahmeTimerFunktion:(NSTimer*)derTimer
{
  // NSLog(@"AufnahmeTimerFunktion");
   if (aufnahmetimerstatus)
   {
      AufnahmeZeit++;
      
      int Minuten = AufnahmeZeit/60;
      int Sekunden =AufnahmeZeit%60;
      
      NSString* MinutenString;
      
      NSString* SekundenString;
      if (Sekunden<10)
      {
         SekundenString=[NSString stringWithFormat:@"0%d",Sekunden];
      }
      else
      {
         SekundenString=[NSString stringWithFormat:@"%d",Sekunden];
      }
      if (Minuten<10)
      {
         MinutenString=[NSString stringWithFormat:@"0%d",Minuten];
      }
      else
      {
         MinutenString=[NSString stringWithFormat:@"%d",Minuten];
      }
      [self.Zeitfeld setStringValue:[NSString stringWithFormat:@"%@:%@",MinutenString, SekundenString]];
   }
   
}


- (IBAction)startAVRecord:(id)sender
{
   NSLog(@"recording 1 %@",[NSDate date]);
   NSDate *now = [[NSDate alloc] init];
   startzeit = (int)now.timeIntervalSince1970;
   NSLog(@"setRecording startzeit: %ld",startzeit);
   if ([AufnahmeTimer isValid])
   {
      
   }
   else
   {
      AufnahmeTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(AufnahmeTimerFunktion:)
                                                   userInfo:nil
                                                    repeats:YES];
   }
   aufnahmetimerstatus=0;
   
   if ([AVRecorder isRecording])
   {
      NSLog(@"Aufnahme in Gang");
      return;
   }
   
   if ([self.playBalkenTimer isValid])
   {
      [self.playBalkenTimer invalidate];
   }
   
   //[playBalkenTimer invalidate];
   self.istNeueAufnahme=1;
   OSErr err=0;
   
   if (!(AVRecorder))
   {
      AVRecorder = [[rAVRecorder alloc]init];
   }
   if (AVRecorder)
   {
      AVRecorder.RecorderFenster = [self.view window];
      [AVRecorder setRecording:YES];
      // if AVRecorder
      AufnahmeZeit=0;
      [AVRecorder setstartzeit:startzeit];
   }
   
   [self.Zeitfeld setStringValue:@"00:00"];
   
   [self.Abspieldauerfeld setStringValue:@"0"];
   [self.Abspielanzeige setLevel:0];
   [self.Abspielanzeige setNeedsDisplay:YES];
   return;
   self.Pause=0;
   
   //int erfolg=[[self RecPlayFenster]makeFirstResponder:[self RecPlayFenster]];
   [[self.TitelPop cell] addItemWithObjectValue:[[self.TitelPop cell]stringValue]];
   [[self.TitelPop cell] setEnabled:NO];
   self. Aufnahmedauer=0;
   
   
   self.Leser=[self.ArchivnamenPop titleOfSelectedItem];
   long n=[self.ArchivnamenPop indexOfSelectedItem];
   NSLog(@"Selected Item: %ld",n);
   NSLog(@"startRecord:Selected Item: %ld		Leser: %@",n,self.Leser);
   if ([self.ArchivnamenPop indexOfSelectedItem]==0)
   {
      NSAlert *NamenWarnung = [[NSAlert alloc] init];
      [NamenWarnung addButtonWithTitle:NSLocalizedString(@"I Will",@"Aufforderung Namen angeben")];
      //[RecorderWarnung addButtonWithTitle:@"Cancel"];
      [NamenWarnung setMessageText:NSLocalizedString(@"Who are You?",@"Frage nach Namen")];
      [NamenWarnung setInformativeText:NSLocalizedString(@"You must choose your name before recording.",@"Gib Namen ein")];
      [NamenWarnung setAlertStyle:NSWarningAlertStyle];
      
      /*
       [NamenWarnung beginSheetModalForWindow:RecPlayFenster
       modalDelegate:nil
       didEndSelector:nil
       contextInfo:nil];
       
       */
      NSImage* StartRecordImg=[NSImage imageNamed:@"StartRecordImg.tif"];
      [[self.StartStopKnopf cell]setImage:StartRecordImg];
      [self.StartStopString setStringValue:@"START"];
      return;
   }
   
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL sauberOK=0;
   //NSLog(@"startAVRecord neueAufnahmePfad: %@",neueAufnahmePfad);
   NSError* startErr;
     [self.StartPlayQTKitKnopf setEnabled:NO];
   
   
   [self.StopPlayQTKitKnopf setEnabled:NO];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   [self.StopRecordQTKitKnopf setEnabled:YES];
   [self.BackKnopf setEnabled:NO];
   
}



- (IBAction)stopAVRecord:(id)sender
{
   NSLog(@"stopAVRecord");
   
   [AVRecorder setRecording:NO];
   return;
   /*
    [mCaptureMovieFileOutput recordToOutputFileURL:nil];
    //NSLog(@"recordedDuration: %f",(float)[mCaptureMovieFileOutput  recordedDuration].timeValue);
    //	NSString* TimeString=QTStringFromTime([mCaptureMovieFileOutput  recordedDuration]);
    QTTime duration =[mCaptureMovieFileOutput  recordedDuration];
    //NSLog(@"stopAVRecord 1");
    //GesamtAufnahmezeit= duration.timeValue/duration.timeScale;
    //NSLog(@"stopAVRecord 2");
    QTKitGesamtAufnahmezeit= (float)duration.timeValue/duration.timeScale;
    //NSLog(@"QTKitGesamtAufnahmezeit: %2.1f",QTKitGesamtAufnahmezeit);
    [audioLevelMeter setFloatValue:0];
    
    //NSLog(@"stop: GesamtAufnahmezeit: %2.2f",GesamtAufnahmezeit);
    //NSLog(@"TimeString: %@",TimeString);
    */
   if (self.audioLevelTimer)
   {
      [self.audioLevelTimer invalidate];
   }
   [self.StartPlayQTKitKnopf setEnabled:YES];
   [self.TitelPop  setEnabled:YES];
   [self.TitelPop  setSelectable:YES];
   [[self.TitelPop cell] setEnabled:YES];
   [[self.TitelPop cell] setEnabled:YES];
   
   //[self MovieFertigmachen];
   [self.StartPlayKnopf setEnabled:YES];
   [self.SichernKnopf setEnabled:YES];
   [self.WeitereAufnahmeKnopf setEnabled:YES];
   
   //[RecordQTKitPlayer setMovie:[mCaptureMovieFileOutput movie]];
   
   
}

- (BOOL)isRecording
{
   return [AVRecorder isRecording];//([mCaptureMovieFileOutput outputFileURL] != nil);
}

#pragma mark startAVStop
- (IBAction)startAVStop:(id)sender
{
   
   NSLog(@"startAVStop");
   
   
   if ([self isRecording])
	  {
        NSImage* StartRecordImg=[NSImage imageNamed:@"StartRecordImg.tif"];
        [[self.StartStopKnopf cell]setImage:StartRecordImg];
        [self.StartStopString setStringValue:@"START"];
        [self stopAVRecord:(NULL)];
        
     }
	  
	  else
     {
        NSImage* StopRecordImg=[NSImage imageNamed:@"StopRecordImg.tif"];
        [[self.StartStopKnopf cell]setImage:StopRecordImg];
        [self.StartStopString setStringValue:@"STOP"];
        [self startAVRecord:(NULL)];
        
     }
   
}

- (void)updateAudioLevels:(float)level
{
   // Get the mean audio level from the movie file output's audio connections
   
   
   //NSLog(@"Level: %2.2f",level);


   if (level > 0)
   {
      [self.audioLevelMeter setFloatValue:level];
   }
   else
   {
      [self.audioLevelMeter setFloatValue:0];
   }
   
   float l=0;
   
   
   
   
}

- (void)RecordingAktion:(NSNotification*)note{
   //NSLog(@"RecordingAktion note: %@",note);
   if ([[note userInfo ]objectForKey:@"record"])
   {
      switch([[[note userInfo ] objectForKey:@"record"]intValue])
      {
         case 0:
         {
            NSLog(@"RecordingAktion Aufnahme stop");
            aufnahmetimerstatus=0;
            if ([AufnahmeTimer isValid])
            {
               NSLog(@"RecordingAktion Timer valid");
           //    [AufnahmeTimer invalidate];
            }
         }break;
            
         case 1:
         {
            NSLog(@"RecordingAktion Aufnahme start");
            aufnahmetimerstatus=1;
            AufnahmeZeit = 0;
/*
            AufnahmeTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(AufnahmeTimerFunktion:)
                                                         userInfo:nil
                                                         repeats:YES];
  */
         }break;
      }// switch
   }
   
}
-(void)onTick:(NSTimer *)timer {
   NSLog(@"AufnahmeTimerFunktion");
}
@end
