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

@protocol ExportProgressWindowControllerDelegate;
@class AVAssetExportSession;

@interface ViewController : NSViewController <NSTabViewDelegate, NSWindowDelegate, NSMenuDelegate>

{
   rUtils*  Utils;
   rVolumes*							VolumesPanel;
   rProjektStart*						ProjektStartPanel;
}


// Menues
@property (weak)IBOutlet NSMenu*					AblaufMenu;
@property (weak)IBOutlet NSMenu*					RecorderMenu;
@property (weak)IBOutlet NSMenu*             ModusMenu;
@property (weak)IBOutlet NSMenu*					ProjektMenu;

@property (weak) IBOutlet AVPlayerView *playerView;
@property AVPlayer *player;

@property (weak) IBOutlet AVAudioPlayer *_audioPlayer;

@property (weak) IBOutlet NSButton* StartKnopf;


@property (weak) IBOutlet rAbspielanzeige*			ArchivAbspielanzeige;
@property (weak) IBOutlet NSLevelIndicator	*audioLevelMeter;


@property NSMutableData*						RPDevicedaten;
@property NSMutableData*						SystemDevicedaten;

@property (weak)IBOutlet NSSlider *					Volumesteller;
@property (weak)IBOutlet rLevelmeter*				Levelmeter;
@property (weak)IBOutlet rAbspielanzeige*			Abspielanzeige;

@property  (weak) IBOutlet NSTextField*				PWFeld;
@property  (weak) IBOutlet NSTextField*				TitelString;
@property  (weak) IBOutlet NSTextField*				ModusString;
@property  (weak) IBOutlet NSTextField *				Zeitfeld;
@property  (weak) IBOutlet NSTextField *				Levelfeld;
@property  (weak) IBOutlet NSTextField *				Leserfeld;
@property  (weak) IBOutlet NSTextField *				Abspieldauerfeld;
@property  (weak) IBOutlet NSTextField *				Kommentarfeld;
@property  IBOutlet NSTextView*					KommentarView;
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

@property TimeValue							Dauer;
@property TimeValue							Laufzeit;
@property TimeValue							ArchivLaufzeit;
@property int									RPModus;


//@property rUtils*								Utils;

@property BOOL                         LeseboxOK;
@property NSString*                    LeseboxPfad;

@property NSMutableArray*						UserPasswortArray;
@property BOOL                            mitAdminPasswort;
@property NSMutableDictionary*				AdminPasswortDic;

@property BOOL								mitUserPasswort;
@property BOOL								istErsteRunde;

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
@property NSTimer *							AufnahmezeitTimer;
@property NSTimer *							AbspielzeitTimer;
@property UInt32								GesamtAufnahmezeit;
@property NSTimer								*audioLevelTimer;
@property NSTimer								*playBalkenTimer;
@property NSTimer								*playArchivBalkenTimer;

@property UInt32								Aufnahmedauer;
@property UInt32								GesamtAbspielzeit;
@property float									QTKitGesamtAbspielzeit;
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



// Panels
@property (nonatomic,strong) rEinstellungen*						EinstellungenFenster;
//@property (nonatomic,strong) rVolumes*							VolumesPanel;
@property (nonatomic,strong) rProjektListe*						ProjektPanel;
@property (nonatomic,strong) rProjektNamen*						ProjektNamenPanel;

@property (nonatomic,strong) rPasswortListe*						PasswortListePanel;
@property (nonatomic,strong) rTitelListe*						TitelListePanel;


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
- (IBAction)startAVRecord:(id)sender;
- (IBAction)stopPlay:(id)sender;
- (IBAction)stopAVRecord:(id)sender;
- (IBAction)startAVStop:(id)sender;
- (IBAction)goStart:(id)sender;
- (void)setLevel:(int)derLevel;
- (IBAction)showSettingsDialog:(id)sender;
- (IBAction)restoreSettings:(id)sender;
- (IBAction)saveSettings:(id)sender;
- (IBAction)setLeser:(id)sender;
- (IBAction)setLesebox:(id)sender;
- (IBAction)resetLesebox:(id)sender;
- (void)ListeAktualisierenAktion:(NSNotification*)note;
- (IBAction)setLeserliste:(id)sender;
- (IBAction)Logout:(id)sender;
- (IBAction)setTitel:(id)sender;


@end
