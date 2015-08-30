//
//  AdminPlayerController.h
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 15.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "rAdminListe.h"
#import "rEntfernen.h"

#import "rKommentar.h"
#import "rClean.h"
#import "rMarkierung.h"
#import "rAdminDS.h"

#import "rAbspielanzeige.h"



@interface AdminPlayerController : NSViewController <NSWindowDelegate, NSTabViewDelegate>
{
   NSView						*previewView;
  
   NSLevelIndicator			*LevelMeter;
   IBOutlet rAbspielanzeige*			Abspielanzeige;
  //rAVPlayer*  AVAbspielplayer;
}

   @property  (weak)  IBOutlet NSWindow*			AdminFenster;
   @property  (weak)  IBOutlet NSTextField*		TitelString;
   @property  (weak)  IBOutlet NSTextField*		ModusString;
   @property  (weak)  IBOutlet rAdminListe*		NamenListe;
   
   @property  (weak)  IBOutlet NSTextField*		AbspieldauerFeld;
   @property    rEntfernen*                     EntfernenFenster;
   @property    rKommentar*                     KommentarFenster;
   @property    rClean*                         CleanFenster;
   @property    rMarkierung*                    MarkierungFenster;
   //	IBOutlet NSMovieView*			AdminQTPlayer;
   //	IBOutlet QTMovieView*			AdminQTKitPlayer;
   @property  (weak)  IBOutlet NSButton*			PlayTaste;
   @property  (weak)  IBOutlet NSButton*			zurListeTaste;
   @property  (weak)  IBOutlet NSButton*			ExportierenTaste;
   @property  (weak)  IBOutlet NSButton*			LoeschenTaste;
   @property  (weak)  IBOutlet NSButton*			MarkCheckbox;
   @property  (weak)  IBOutlet NSButton*			UserMarkCheckbox;
   @property  (weak)  IBOutlet NSTextField*		ProjektFeld;
   @property   IBOutlet NSTextView*             AdminKommentarView;
   @property  (weak)  IBOutlet NSTextField*		AdminTitelfeld;
   @property  (weak)  IBOutlet NSTextField*		AdminDatumfeld;
   @property  (weak)  IBOutlet NSTextField*		AdminNamenfeld;
   @property    IBOutlet NSPopUpButton*         AdminBewertungfeld;
   @property  (weak)  IBOutlet NSTextField*		AdminNotenfeld;
   
   @property  (weak)  IBOutlet NSTabView*			AufnahmenTab;
   @property  (weak)  IBOutlet NSTableView*		AufnahmenTable;
   @property  (weak)  IBOutlet NSMatrix*			MarkAuswahlOption;
   @property    NSMutableArray*                 AufnahmenDicArray;
   @property    IBOutlet NSPopUpButton*         LesernamenPop;
   @property  (weak)  IBOutlet NSButton*			DeleteTaste;
   @property  BOOL                              AufnahmeDa;
   @property  int                               selektierteAufnahmenTableZeile;
   
   //	Movie							AdminPlayerMovie;
   @property  UInt32                            AdminAbspielzeit;
   @property  NSString*                         AdminLeseboxPfad;
   @property  NSString*                         AdminArchivPfad;
   @property  NSString*                         AdminProjektPfad;
   @property  NSPopUpButton*                    ProjektPop;
   
   @property  NSString*                         AdminAktuellesProjekt;
   
   @property  NSString*                         AdminAktuellerLeser;
   @property  NSString*                         AdminAktuelleAufnahme;
   
   
   @property  NSString*                         AdminPlayPfad;
   @property  NSMutableArray *                  AdminProjektNamenArray;
   @property  NSMutableArray *                  AdminProjektArray;
   @property  BOOL                              AdminProjektAktiviert;
   
   @property  int                               AnzLeser;
   @property  int                               selektierteZeile;
   @property  (weak)  NSComboBoxCell *          comboBox;
   @property    NSPopUpButtonCell*              AufnahmenPop;
   @property  rAdminDS*                         AdminDaten;
   @property  BOOL                              Moviegeladen;
   @property  BOOL                              Textchanged;
   @property  int                               Umgebung;
   
   @property  int                               AuswahlOption;
   @property  int                               AbsatzOption;
   @property  int                               ZusatzOption;
   @property  int                               AnzahlOption;
   @property  int                               ProjektNamenOption;
   @property  int                               ProjektAuswahlOption;
   @property  int                               nurMarkierteOption;
   @property  (assign) NSString*                         OptionAString;
   @property  NSString*                         OptionBString;
   @property  NSString*                         ProjektPfadOptionString;
   @property  NSString*                         TitelOptionString;
   
   //Clean
   @property  BOOL                              nurTitelZuNamenOption;;
   @property  BOOL                              ClearBehaltenOption;
   @property  BOOL                              ExportOption;
   
   @property  NSTimer*                          CleanDelayTimer;
   
   @property  NSString*                         ExportOrdnerPfad;
   @property  NSMutableData*                    RPExportdaten;
   @property  OSType                            exportFormatFlag;
   @property  NSMutableString*                  ExportFormatString;
   @property  FSSpec                            UserExportSpec;
   @property  long                              UserExportParID;
   //NSMutableArray*				ProjektArray;


@property  (weak) IBOutlet NSButton*					StartPlayKnopf;
@property  (weak) IBOutlet NSButton*					StopPlayKnopf;
@property  (weak) IBOutlet NSButton*					StartStopKnopf;
@property  (weak) IBOutlet NSTextField*				StartStopString;
@property (weak)  IBOutlet NSButton*					BackKnopf;
@property (weak)  IBOutlet NSButton*					RewindKnopf;
@property (weak)  IBOutlet NSButton*					ForewardKnopf;

   
   //rProgressDialog * progressDialog;
   
   //UInt32      _threadModelTag;        // the threading model for this document
   //ThreadData  *_currThreadData;       // the thread data for the current export operation
   //BOOL        _onlySafeComponents;	// do we require only thread-safe components?
   //BOOL		_selectedMovie;         // has the user selected a movie for this document?
   //BOOL		_ignoreUnsafeTypes;     // do we ignore unsafe media types during export?
   
   //WorkerThreadRef	_worker;            // a worker thread handler
   
- (void) setLeseboxPfad:(NSString*)derPfad inProjekt: (NSString*)dasProjekt;
- (NSString*)AdminLeseboxPfad;
- (BOOL)setNetworkAdminLeseboxPfad:(id)sender;
- (BOOL)setHomeAdminLeseboxPfad:(id)sender;

- (void)setAdminPlayer:(NSString*)derLeseboxPfad inProjekt:(NSString*)dasProjekt;
- (void)setAdminProjektArray:(NSArray*)derProjektArray;
- (void)resetAdminPlayer;
- (void)setProjektPopMenu:(NSArray*)derProjektArray;
- (IBAction)setNeuesAdminProjekt:(id)sender;

- (IBAction)setzeLeser:(id)sender;
- (void)setLeserFuerZeile:(int)dieZeile;
- (BOOL)setPfadFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme;
- (BOOL)setKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme;
- (BOOL)saveKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme;
- (BOOL)saveAdminMarkFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
                  mitAdminMark:(int)dieAdminMark;
- (BOOL)saveMarksFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
              mitAdminMark:(int)dieAdminMark
               mitUserMark:(int)dieUserMark;


- (IBAction)startAdminPlayer:(id)sender;
- (int)selektierteZeile;

- (void)backZurListe:(id)sender;

- (void)setBackTaste:(BOOL)istDefault;
- (IBAction) AufnahmeLoeschen:(id)sender;
- (void)EntfernenNotificationAktion:(NSNotification*)note;
- (void)ex:(NSString*)dieAufnahme;
- (void)exMitPfad:(NSString*)derAufnahmePfad;
- (void)inPapierkorb:(NSString*)dieAufnahme;
- (void)inPapierkorbMitPfad:(NSString*)derAufnahmePfad;

- (void)insMagazin:(NSString*)dieAufnahme;
- (void)insMagazinMitPfad:(NSString*)derAufnahmePfad;
- (void)AufnahmeMarkieren:(id)sender;
- (BOOL)AufnahmeIstMarkiertAnPfad:(NSString*)derAufnahmePfad;
- (BOOL)AufnahmeIstMarkiertAnAnmerkungPfad:(NSString*)derAnmerkungPfad;
- (void)setMark:(BOOL)derStatus;
- (void)MarkierungEntfernenFuerZeile:(int)dieZeile;
- (void)MarkierungenEntfernen;
- (void)AlleMarkierungenEntfernen;
- (IBAction)reportAktualisieren:(id)sender;
- (void)reportUserMark:(id)sender;
- (void)reportAdminMark:(id)sender;

- (NSString*)neuerNameVonAufnahme:(NSString*)dieAufnahme mitNummer:(int)dieNummer;
- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;

- (void)AdminKeyNotifikationAktion:(NSNotification*)note;
- (void)AdminZeilenNotifikationAktion:(NSNotification*)note;
- (void)AdminEnterKeyNotifikationAktion:(NSNotification*)note;


//- (QTMovieView*)AdminQTKitPlayer;
- (NSString*)Zeitformatieren:(long) dieSekunden;
- (void)neuNummerierenVon:(NSString*) derLeser;
- (void)clearKommentarfelder;
- (OSErr)ExportMovieVonPfad:(NSString*) derAufnahmePfad;

//- (IBAction)OKSheet:(id)sender;

- (void)Leseboxordnen;
- (BOOL)FensterschliessenOK;
- (void)AdminBeenden;
- (BOOL)windowShouldClose:(id)sender;
- (IBAction)showCleanFenster:(int)tab;
- (void)setCleanTask:(int)dieTask;



@end
