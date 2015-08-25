//
//  ViewController.h
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 14.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <objc/runtime.h>

#import "rAbspielanzeige.h"
#import "rLevelmeter.h"
#import "rEinstellungen.h"
#import "rProjektListe.h"

#import "rUtils.h"

#import "rArchivDS.h"
#import "rArchivView.h"
#import "rAVRecorder.h"
#import "rAVPlayer.h"

#import "rAdminPlayer.h"



@protocol ExportProgressWindowControllerDelegate;
@class AVAssetExportSession;




@interface ViewController : NSViewController <NSTabViewDelegate, NSWindowDelegate, NSMenuDelegate>

{
   
   // Panels
   rUtils*  Utils;
   rVolumes*                        VolumesPanel;
   rProjektStart*                   ProjektStartPanel;
   rProjektListe*                   ProjektPanel;
   rProjektNamen*                   ProjektNamenPanel;
   rEinstellungen*						EinstellungenFenster;
   rPasswortListe*						PasswortListePanel;
   rTitelListe*                     TitelListePanel;
   rAVRecorder*                     AVRecorder;
   
   rAdminPlayer*						   AdminPlayer;
   
   
   rAVPlayer*  AVAbspielplayer;
   NSString*	RPAufnahmenDirIDKey;;
   NSString *	Wert1Key;
   NSString *	Wert2Key;
   NSString *	RPModusKey;
   NSString *	RPBewertungKey;
   NSString *	RPNoteKey;
   NSString *	RPStartStatusKey;


//   NSTimer* AufnahmeTimer;
   NSTimer* WiedergabeTimer;
   int      AufnahmeZeit;
   int      WiedergabeZeit;
   NSTimer *AufnahmeTimer;
   int aufnahmetimerstatus;
   double startzeit;
}


// Menues
@property (weak)IBOutlet NSMenu*					AblaufMenu;
@property (weak)IBOutlet NSMenu*					RecorderMenu;
@property (weak)IBOutlet NSMenu*             ModusMenu;
@property (weak)IBOutlet NSMenu*					ProjektMenu;

@property (weak) IBOutlet AVPlayerView       *playerView;
@property AVPlayer *player;

@property (weak) IBOutlet AVAudioPlayer *_audioPlayer;

@property (weak) IBOutlet NSButton* StartKnopf;


@property (weak) IBOutlet rAbspielanzeige*	ArchivAbspielanzeige;
@property (weak) IBOutlet NSLevelIndicator   *LevelMeter;


@property NSMutableData*               RPDevicedaten;
@property NSMutableData*						SystemDevicedaten;

@property (weak)IBOutlet NSSlider *					Volumesteller;
@property (weak)IBOutlet rLevelmeter*				Levelmeter;
@property (weak)IBOutlet NSLevelIndicator       *audioLevelMeter;

@property (weak)IBOutlet rAbspielanzeige*			Abspielanzeige;

@property  (weak) IBOutlet NSTextField*				PWFeld;
@property  (weak) IBOutlet NSTextField*				TitelString;
@property  (weak) IBOutlet NSTextField*				ModusString;
@property  (weak) IBOutlet NSTextField *				Zeitfeld;
@property  (weak) IBOutlet NSTextField *				Levelfeld;
@property  (weak) IBOutlet NSTextField *				Leserfeld;
@property  (weak) IBOutlet NSTextField *				Abspieldauerfeld;
@property  (weak) IBOutlet NSTextField *				Kommentarfeld;
@property   IBOutlet NSTextView*					KommentarView;
@property  (weak) IBOutlet NSProgressIndicator*		Levelbalken;
@property  (weak) IBOutlet NSPopUpButton *			ArchivnamenPop;
@property  (weak) IBOutlet NSComboBox *				TitelPop;
@property  (weak) IBOutlet NSComboBox *				NeueTitelPop;

@property  (weak) IBOutlet NSWindow*					RecPlayFenster;
@property  (weak) IBOutlet NSTabView*					RecPlayTab;
@property  (weak) IBOutlet NSTextField *				Testfeld;
@property  (weak) IBOutlet NSButton*					StartRecordKnopf;
@property  (weak) IBOutlet NSButton*					StopRecordKnopf;
@property  (weak) IBOutlet NSButton*					StartPlayKnopf;
@property  (weak) IBOutlet NSButton*					StopPlayKnopf;
@property  (weak) IBOutlet NSButton*					StartStopKnopf;
@property  (weak) IBOutlet NSTextField*				StartStopString;

@property (weak)  IBOutlet NSButton*					BackKnopf;
@property  (weak) IBOutlet NSButton*					SichernKnopf;
@property  (weak) IBOutlet NSButton*					WeitereAufnahmeKnopf;
@property  (weak) IBOutlet NSButton*					LogoutKnopf;
@property  (weak) IBOutlet NSPopUpButton*				KommentarPop;


@property NSString*                     ArchivPfad;
@property NSString*                     ProjektPfad;
@property NSMutableArray*					ProjektArray;
@property NSMutableArray*					PListProjektArray;
@property NSMutableDictionary*				PListDic;
@property BOOL                          istSystemVolume;
@property BOOL                          AdminZugangOK;

@property IBOutlet NSTextField*			ProjektFeld;
@property NSMutableArray*					ProjektNamenArray;
@property NSMutableString*					KommentarOrdnerPfad;
@property BOOL                          LeseboxDa;
@property NSString*							Leser;
@property NSString*							LeserPfad;

@property FSSpec								neueAufnahmeSpec;
@property FSRef									neueAufnahmeRef;
@property short									MovieRef;
@property NSString*							neueAufnahmePfad;

@property NSURL*								LeseboxURL;
@property NSURL*								ArchivURL;

@property int                        Aufnahmedauer;
@property TimeValue							Laufzeit;
@property TimeValue							ArchivLaufzeit;
@property int									RPModus;


//@property rUtils*								Utils;

@property BOOL                         LeseboxOK;
@property NSString*                    LeseboxPfad;

@property NSMutableArray*						UserPasswortArray;
@property BOOL                            mitAdminPasswort;
@property NSMutableDictionary*				AdminPasswortDic;

@property BOOL                         mitUserPasswort;
@property BOOL                         istErsteRunde;

@property NSTimeInterval						TimeoutDelay;
@property NSData*								GrabberOutputDaten;
@property BOOL								neueSettings;
@property BOOL								istNeueAufnahme;
@property long								KnackDelay;
@property BOOL									NoteZeigen;
@property BOOL									BewertungZeigen;

@property int                       Umgebung;
@property BOOL									InputDeviceOK;

@property NSTimer *							timer;


@property NSTimer *							AbspielzeitTimer;
@property UInt32								GesamtAufnahmezeit;
@property NSTimer								*audioLevelTimer;
@property NSTimer								*playBalkenTimer;
@property NSTimer								*playArchivBalkenTimer;

@property(nonatomic, retain) NSTimer *	tempTimer;




@property UInt32								GesamtAbspielzeit;
@property float								QTKitGesamtAbspielzeit;
@property UInt32								Abspieldauer;
@property UInt32								Pause;
@property int									Durchgang;
@property  NSString*                   hiddenAufnahmePfad;

@property  (weak)  IBOutlet NSButton*					StartRecordQTKitKnopf;
@property  (weak)  IBOutlet NSButton*					StopRecordQTKitKnopf;
@property  (weak)  IBOutlet NSButton*					StartPlayQTKitKnopf;
@property  (weak)  IBOutlet NSButton*					StopPlayQTKitKnopf;
@property  (weak)  IBOutlet NSButton*					StartStopQTKitKnopf;
@property  (weak)  IBOutlet NSButton*					BackQTKitKnopf;
@property  float								QTKitGesamtAufnahmezeit;
@property  float								QTKitDauer;
@property  float								QTKitPause;




//@property (weak) IBOutlet rAdminPlayer* AdminPlayer;
@property (weak) 	IBOutlet rArchivView*			ArchivView;
@property (weak) IBOutlet NSButton*					ArchivPlayTaste;
@property (weak) IBOutlet NSButton*					ArchivStopTaste;
@property (weak) IBOutlet NSButton*					ArchivZumStartTaste;
@property (weak) IBOutlet NSButton*					ArchivInListeTaste;
@property (weak) IBOutlet NSButton*					ArchivInPlayerTaste;
@property (weak) IBOutlet NSTextField*				ArchivTitelfeld;
@property (weak) IBOutlet NSTextField*				ArchivDatumfeld;
@property (weak) IBOutlet NSTextField*				ArchivBewertungfeld;
@property (weak) IBOutlet NSTextField*				ArchivNotenfeld;
@property (weak) IBOutlet NSButton*					UserMarkCheckbox;
@property (weak) IBOutlet NSTextField*				ArchivAbspieldauerFeld;

@property (weak) IBOutlet NSTextField*				TimeoutFeld;
@property BOOL								ArchivPlayerGeladen;
@property (weak) rArchivDS*							ArchivDaten;
@property int									ArchivSelektierteZeile;
//Movie									ArchivPlayerMovie;
@property UInt32								ArchivAbspielzeit;
@property NSString*							ArchivPlayPfad;
@property NSString*							ArchivKommentarPfad;
@property NSTextView*							ArchivKommentarView;
@property BOOL									ArchivZeilenhit;
@property int									RPDevicedatenlaenge;
@property int									Wert1, Wert2, Wert3;
@property int									aktuellAnzAufnahmen;



- (IBAction)startPlay:(id)sender;

- (IBAction)stopPlay:(id)sender;
- (IBAction)goStart:(id)sender;
- (void)setLevel:(int)derLevel;
- (IBAction)showSettingsDialog:(id)sender;
- (IBAction)restoreSettings:(id)sender;
- (IBAction)saveSettings:(id)sender;
- (IBAction)setzeLeser:(id)sender;
- (IBAction)setLesebox:(id)sender;
- (IBAction)resetLesebox:(id)sender;
- (void)ListeAktualisierenAktion:(NSNotification*)note;
- (IBAction)setLeserliste:(id)sender;
- (IBAction)Logout:(id)sender;
- (IBAction)setTitel:(id)sender;
- (IBAction)showProjektStart:(id)sender;
- (IBAction)savePListAktion:(id)sender;

- (NSString*)Initialen:(NSString*)derName;

@end


// Category Lesebox

@interface ViewController (Lesebox)
- (IBAction)beginAdminPlayer:(id)sender;
- (IBAction)terminate:(id)sender;
- (IBAction)ArchivZurListe:(id)sender;
- (IBAction)anderesProjektMitTitel:(NSString*)derTitel;


- (BOOL)Leseboxvorbereiten;
- (NSString*) chooseLeseboxPfadMitUserArray:(NSArray*)derUserArray undNetworkArray:(NSArray*)derNetworkArray;

- (BOOL)NamenListeValidAnPfad:(NSString*)derProjektPfad;
- (BOOL)ProjektListeValidAnPfad:(NSString*)derArchivPfad;
- (void)checkSessionDatumFor:(NSString*)dasProjekt;
- (NSArray*)AufnahmeRetten;
- (void)updateProjektArray;
- (void)updatePasswortListe;
- (void)setProjektMenu;
- (void)setArchivNamenPop;
- (BOOL)checkAdminPW;
- (BOOL)checkAdminZugang;
- (void)resetRecPlay;
- (void)saveUserPasswortDic:(NSDictionary*)derPasswortDic;
- (void)saveNeuesProjekt:(NSDictionary*)derProjektDic;
- (void)saveNeuenProjektArray:(NSArray*)derProjektArray;
- (void)saveUserPasswortArray:(NSArray*)derPasswortArray;
- (void)SessionListeAktualisieren;

- (void)saveSessionForUser:(NSString*)derUser inProjekt:(NSString*)dasProjekt;
- (BOOL)anderesProjektEinrichtenMit:(NSString*)dasProjekt;
- (NSArray*)SessionLeserListeVonProjekt:(NSString*)dasProjekt;
@end // Lesebox

// Category AVRecorder
@interface ViewController (AVRecorder)

- (IBAction)startAVRecord:(id)sender;
- (IBAction)stopAVRecord:(id)sender;
- (IBAction)startAVStop:(id)sender;
- (BOOL)isRecording;
- (void)updateAudioLevels:(float)level;
- (void)RecordingAktion:(NSNotification*)note;
- (void)LevelmeterAktion:(NSNotification*)note;
- (IBAction)trim:(id)sender;
- (IBAction)cut:(id)sender;

- (IBAction)stop:(id)sender;

- (IBAction)startAVPlay:(id)sender;
- (IBAction)stopAVPlay:(id)sender;
- (IBAction)backAVPlay:(id)sender;
- (IBAction)saveRecord:(id)sender;
@end // AVRecorder

