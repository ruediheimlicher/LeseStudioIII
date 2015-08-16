//
//  ViewController.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 14.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//
enum
{
   Datum=2,
   Bewertung,
   Noten,
   UserMark,
   AdminMark,
   Kommentar
};
enum
{
   kModusMenuTag=30000,
   kRecPlayTag,
   kAdminTag,
   kKommentarTag,
   kEinstellungenTag
};

enum
{
   kAblaufMenuTag=40000,
   kProjektWahlenTag,
   kProjektlisteBearbeitenTag,
   kMarkierungenLoschenTag,
   kAlleMarkierungenLoschenTag,
   kListeAktualisierenTag,
   kAufnahmenLoschenTag,
   kAufnahmenExportierenTag,
   kLeseboxNeuOrdnenTag,
   kAndereLeseboxTag,
   kSettingsTag
};

enum
{
   kNamenListeBearbeitenTag=50001,
   kPasswortAndernTag,
   kPasswortListeBearbeitenTag,
   kTitelListeBearbeitenTag
};
enum
{
   kRecorderMenuTag=80000,
   kRecorderProjektWahlenTag,
   kRecorderPasswortAndernTag,
   kRecorderSettingsTag,
   kNeueSessionTag,
   kSessionAktualisierenTag
};



#import "ViewController.h"
#import "rUtils.h"

NSString*	RPAufnahmenDirIDKey		=	@"RPAufnahmenDirID";
NSString *	Wert1Key=@"Wert1";
NSString *	Wert2Key=@"Wert2";
NSString *	RPModusKey=@"RPModus";
NSString *	RPBewertungKey=@"RPBewertung";
NSString *	RPNoteKey=@"RPNote";
NSString *	RPStartStatusKey=@"StartStatus";

NSString* projekt=@"projekt";
NSString* projektpfad=@"projektpfad";
NSString* archivpfad=@"archivpfad";
NSString* leseboxpfad=@"leseboxpfad";
NSString* projektarray=@"projektarray";
NSString* OK=@"ok";
NSString* fix=@"fix";
NSString* mituserpw=@"mituserpw";

const short kAdminUmgebung=1;
const short kRecPlayUmgebung=0;


const short DatumReturn=2;
const short BewertungReturn= 3;
const short NotenReturn= 4;
const short UserMarkReturn= 5;
const short AdminMarkReturn= 6;
const short KommentarReturn=7;
NSString*	RPDevicedatenKey=	@"RPDevicedaten";

/*NSMenu*                      ModusMenu;
extern  NSMenu*                      AblaufMenu;
extern  NSMenu*                      RecorderMenu;
extern  NSMenu*                      ProjektMenu;
 */
@implementation ViewController

- (void)viewDidLoad //awakeFromNib
{
   [super viewDidLoad];
   
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(KeyNotifikationAktion:)
              name:@"Pfeiltaste"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ZeilenNotifikationAktion:)
              name:@"selektierteZeile"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(EnterKeyNotifikationAktion:)
              name:@"EnterKey"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(BewertungNotifikationAktion:)
              name:@"mitBewertung"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(NotenNotifikationAktion:)
              name:@"mitNote"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(StartStatusNotifikationAktion:)
              name:@"StartStatus"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(UmgebungAktion:)
              name:@"Umgebung"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(VolumesAktion:)
              name:@"VolumeWahl"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(SettingsAktion:)
              name:@"Settings"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ProjektListeAktion:)
              name:@"ProjektWahl"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(neuesProjektAktion:)
              name:@"neuesProjekt"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(anderesProjektAktion:)
              name:@"anderesProjekt"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(ProjektStartAktion:)
              name:@"ProjektStart"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ProjektEntfernenAktion:)
              name:@"ProjektEntfernen"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ProjektMenuAktion:)
              name:@"ProjektMenu"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(savePListAktion:)
              name:@"savePList"
            object:nil];
   
   
   
   
   [nc addObserver:self
          selector:@selector(BeendenAktion:)
              name:@"externbeenden"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(TitelListeAktion:)
              name:@"titelliste"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(TimeoutAktion:)
              name:@"timeout"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(SaveKommentarAktion:)
              name:@"SaveKommentar"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(LevelmeterAktion:)
              name:@"levelmeter"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(ListeAktualisierenAktion:)
              name:@"ListeAktualisieren"
            object:nil];
   
   
   
   


   BOOL success = NO;
   NSError *error;
   Utils = [[rUtils alloc ]init];
   
    self.ProjektArray = [[NSMutableArray alloc]initWithCapacity:0];
   self.PListProjektArray = [[NSMutableArray alloc]initWithCapacity:0];
   self.ProjektNamenArray = [[NSMutableArray alloc]initWithCapacity:0];
   self.UserPasswortArray = [[NSMutableArray alloc]initWithCapacity:0];
   self.AdminPasswortDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   
   
   NSString* lb=NSLocalizedString(@"Lesebox",@"Lesebox");
   NSString* cb=NSLocalizedString(@"Comments",@"Anmerkungen");
   NSString*HomeLeseboxPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents/",lb];
   //NSLog(@"cb: %@  Lesebox: %@ HomeLeseboxPfad: %@",cb,lb,HomeLeseboxPfad);
   NSString* locBeenden=NSLocalizedString(@"Quit",@"Beenden");
   
   NSColor* HintergrundFarbe=[NSColor colorWithDeviceRed:80.0/255.0 green:230.0/255.0 blue:140.0/255.0 alpha:1.0];
   NSColor * TitelFarbe=[NSColor purpleColor];
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 36];
   [[self TitelString]setFont:TitelFont];
   [[self TitelString] setTextColor:TitelFarbe];
   [[self ModusString] setFont:TitelFont];
   [[self ModusString] setTextColor:TitelFarbe];
   HomeLeseboxPfad = @"/Users/ruediheimlicher/Documents/Lesebox";
   NSLog(@"Lesebox: %@ HomeLeseboxPfad: %@",cb,lb,HomeLeseboxPfad);
   
   //BOOL istOrdner;
//   [self.RecPlayFenster setDelegate:self];
//   [self.RecPlayFenster setBackgroundColor:HintergrundFarbe];
   
   //	NSColor * TitelFarbe=[NSColor whiteColor];
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 36];
   [self.TitelString setFont:TitelFont];
   [self.TitelString setTextColor:TitelFarbe];
   [self.ModusString setFont:TitelFont];
   [self.ModusString setTextColor:TitelFarbe];
   
   
   NSImage* myImage = [NSImage imageNamed: @"MicroIcon"];
   [NSApp setApplicationIconImage: myImage];
   
   [self.AblaufMenu setDelegate:self];
   [self.ModusMenu setDelegate:self];
   [self.RecorderMenu setDelegate:self];
   
   [[self.ModusMenu itemWithTag:kRecPlayTag] setTarget:self];//Recorder
   [[self.ModusMenu itemWithTag:kAdminTag] setTarget:self];//Admin
   [[self.ModusMenu itemWithTag:kKommentarTag] setTarget:self];//Kommentar
   [[self.ModusMenu itemWithTag:kEinstellungenTag] setTarget:self];//Kommentar
   //NSLog(@"Menu: %@ setAutoenablesItems: %d",[[ModusMenu itemWithTag:30002] title],[ModusMenu autoenablesItems]);
   //[AblaufMenu setDelegate:self];
   [[self.AblaufMenu itemWithTag:kAndereLeseboxTag] setTarget:self];//neue Lesebox
   [[self.AblaufMenu itemWithTag:kListeAktualisierenTag] setTarget:self];//Lesebox aktualisieren
   [[self.AblaufMenu itemWithTag:kLeseboxNeuOrdnenTag] setTarget:self];//Lesebox neu ordnen
   [[self.AblaufMenu itemWithTag:kAufnahmenLoschenTag] setTarget:self];//Aufnahmen loeschen
   [[self.AblaufMenu itemWithTag:kAufnahmenExportierenTag] setTarget:self];//Aufnahmen exportieren
   [[self.AblaufMenu itemWithTag:kSettingsTag] setTarget:self];//Settings
   [[self.AblaufMenu itemWithTag:kMarkierungenLoschenTag] setTarget:self];//
   [[self.AblaufMenu itemWithTag:kAlleMarkierungenLoschenTag] setTarget:self];//
   [[self.AblaufMenu itemWithTag:kTitelListeBearbeitenTag] setTarget:self];//
   
   // NSLog(@"Menu: %@ tag: %d",[[AblaufMenu itemWithTag:kProjektWahlenTag]description],kProjektWahlenTag);
   //[[AblaufMenu itemWithTag:kProjektWahlenTag] setTarget:self];//
   
   [[self.RecorderMenu itemWithTag:kRecorderProjektWahlenTag] setTarget:self];//
   [[self.RecorderMenu itemWithTag:kRecorderPasswortAndernTag] setTarget:self];//
   [[self.RecorderMenu itemWithTag:kRecorderSettingsTag] setTarget:self];//

   
   NSFileManager *Filemanager = [NSFileManager defaultManager];

   
   BOOL PListBusy=YES;
   int runde=0;
   while (PListBusy)
   {
      runde++;
      BOOL PListOK=[self Leseboxvorbereiten];
      
      
      PListBusy=!PListOK;
      if (runde==20)
      {
         PListBusy=NO;
      }
   }//while
   
   [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
   
   
   NSURL* URLPfad=[[NSURL alloc]initFileURLWithPath:self.LeseboxPfad];

   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:self.LeseboxPfad forKey:leseboxpfad];
   [NotificationDic setObject:self.ArchivPfad forKey:archivpfad];
   
   [NotificationDic setObject:self.ProjektPfad forKey:projektpfad];
   [NotificationDic setObject:self.ProjektArray forKey:projektarray];
   [nc postNotificationName:@"Utils" object:self userInfo:NotificationDic];
   [self.ProjektFeld setStringValue:[self.ProjektPfad lastPathComponent]];
   [self.RecorderMenu setSubmenu:self.ProjektMenu forItem:[self.RecorderMenu itemWithTag:kRecorderProjektWahlenTag]];
   
   self.neueSettings=NO;
   switch (self.Umgebung)
   {
      case kAdminUmgebung:
      {
         //NSLog(@"vor beginAdminPlayer:      ProjektArray: \n%@",[ProjektArray description]);
         
         if(!self.AdminZugangOK)
         {
            self.AdminZugangOK=[self checkAdminZugang];
         }
         if (self.AdminZugangOK)
            
         {
            self.Umgebung=kAdminUmgebung;
            //NSLog(@"PListDic nach checkAdminZugang: %@",[PListDic description]);
            [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
            
            [self beginAdminPlayer:nil];
            //NSLog(@"PListDic nach beginAdminPlayer: %@",[PListDic description]);
            
            
            return;
         }
         else
         {
            NSLog(@"case kAdminUmgebung: Zugang nicht OK");
            
            self.Umgebung=kRecPlayUmgebung;
            //Kein gültiges PW für Admin, also Recorder öffnen
            if (![self NamenListeValidAnPfad:self.ProjektPfad]||([self AdminPW]==NO))//Im Projektordner sind keine Namen
            {
               NSAlert *Warnung = [[NSAlert alloc] init];
               
               [Warnung addButtonWithTitle:locBeenden];
               [Warnung setMessageText:NSLocalizedString(@"No valid password for Admin",@"Kein gültiges Admin-Passwort")];
               
               NSString* s1=NSLocalizedString(@"The folder for project %@ is empty",@"Ordner für  Projekt xx ist leer");
               NSString* s2=[NSString stringWithFormat:s1,[self.ProjektPfad lastPathComponent]];
               
               NSString* s3=NSLocalizedString(@"The applicatin will terminate",@"Das Programm wird beendet");
               NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s2,s3];
               [Warnung setInformativeText:InformationString];
               [Warnung setAlertStyle:NSWarningAlertStyle];
               
               //[Warnung setIcon:RPImage];
               int antwort=[Warnung runModal];
               if ([self AdminPW]==NO)//Neue LB, noch kein AdminPW gesetzt, aufräumen
               {
                  
                  if ([Filemanager fileExistsAtPath:self.LeseboxPfad])
                  {
                     NSLog(@"awake LB entfernen: %@",self.LeseboxPfad);
                     [Filemanager removeItemAtURL:[NSURL fileURLWithPath:self.LeseboxPfad] error:NULL];
                  }
                  [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
                  [NSApp terminate:self];
                  
               }
               else
               {
                  [self terminate:NULL];//ordentlich aussteigen
               }
            }
            
            
         }
         
         
      }break;
      case kRecPlayUmgebung:
      {
         
      }break;
      default:
      {
         NSLog(@"switch RPModus: terminate");
         [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
         [self terminate:NULL]; 
         
      }
         
   }//Switch Umgebung
   
   [self Aufnahmevorbereiten];
   NSFont* Lesernamenfont;
   Lesernamenfont=[NSFont fontWithName:@"Helvetica" size: 20];
   NSColor * LesernamenFarbe=[NSColor whiteColor];
   [self.Leserfeld setFont: Lesernamenfont];
   [self.Leserfeld setTextColor: LesernamenFarbe];
   
   [self.RecPlayFenster setIsVisible:YES];
   
   //[Leserfeld setBackgroundColor:[NSColor lightGrayColor]];
   //NSImage* StartRecordImg=[[NSImage alloc]initWithContentsOfFile:@"StartPlayImg.tif"];
   NSImage* StartRecordImg=[NSImage imageNamed:@"StartRecordImg.tif"];
   [[self.StartRecordKnopf cell]setImage:StartRecordImg];
   
   [[self.StartStopKnopf cell]setImage:StartRecordImg];
   
   NSImage* StopRecordImg=[NSImage imageNamed:@"StopRecordImg.tif"];
   [[self.StopRecordKnopf cell]setImage:StopRecordImg];
   
   NSImage* StartPlayImg=[NSImage imageNamed:@"StartPlayImg.tif"];
   [[self.StartPlayKnopf cell]setImage:StartPlayImg];
   
   [[self.ArchivPlayTaste cell]setImage:StartPlayImg];
   NSImage* StopPlayImg=[NSImage imageNamed:@"StopPlayImg.tif"];
   [[self.StopPlayKnopf cell]setImage:StopPlayImg];
   [[self.ArchivStopTaste cell]setImage:StopPlayImg];
   NSImage* BackImg=[NSImage imageNamed:@"Back.tif"];
   [[self.BackKnopf cell]setImage:BackImg];
   [[self.ArchivZumStartTaste cell]setImage:BackImg];
   
   
   
   [self.RecPlayTab setDelegate:self];
   [self.RecPlayTab selectFirstTabViewItem:nil];
   self.ArchivDaten=[[rArchivDS alloc]initWithRowCount:0];
   [self.ArchivView setDelegate: self.ArchivDaten];
   [self.ArchivView setDataSource: self.ArchivDaten];
   //NSLog(@"setRecPlay:	mitUserPasswort: %d",mitUserPasswort);
   if (self.mitUserPasswort)
   {
      [self.PWFeld setStringValue:NSLocalizedString(@"With Password",@"Mit Passwort")];
   }
   else
   {
      [self.PWFeld setStringValue:NSLocalizedString(@"Without Password",@"Ohne Passwort")];
   }
   
   //Tooltips
   
   [self.StartRecordKnopf setToolTip:NSLocalizedString(@"Start Record.\nAn existing unsaved Record is overridden.",@"Aufnahme beginnen\nEine schon vorhandene ungesicherte Aufnahme wird überschrieben")];
   [self.StopRecordKnopf setToolTip:NSLocalizedString(@"Stop Record",@"Aufnahme beenden")];
   [self.StartPlayKnopf setToolTip:NSLocalizedString(@"Start Play",@"Wiedergabe beginnen")];
   [self.BackKnopf setToolTip:NSLocalizedString(@"Back to Start",@"Zurück an den Anfang")];
   [self.StopPlayKnopf setToolTip:NSLocalizedString(@"Stop Play",@"Wiedergabe anhalten")];
   [self.SichernKnopf setToolTip:NSLocalizedString(@"Save Record.\nThe record is saved in the Lecturebox",@"Aufnahme sichern.\nDie Aufnahme wird in der Lesebox gesichert.")];
   [self.LogoutKnopf setToolTip:NSLocalizedString(@"Logout current user.",@"Abmelden des aktuellen Lesers.")];
   //[[RecPlayTab tabViewItemAtIndex:1]setToolTip:NSLocalizedString(@"Achiv of recent records.",@"Archiv von bisherigen Aufnahmen.")];
   [self.ArchivInListeTaste setToolTip:NSLocalizedString(@"Move current record back to the List.",@"Aktuelle Aufnahme in die Liste zurücklegen")];
   [self.ArchivInPlayerTaste setToolTip:NSLocalizedString(@"Move selected record into player.",@"Ausgewählte Aufnahme in den Player verschieben.")];
   [self.UserMarkCheckbox setToolTip:NSLocalizedString(@"Mark current Record.",@"Diese Aufnahme markieren.")];
   [self.ArchivPlayTaste setToolTip:NSLocalizedString(@"Start Play",@"Wiedergabe beginnen")];
   [self.ArchivZumStartTaste setToolTip:NSLocalizedString(@"Back to Start",@"Zurück an den Anfang")];
   [self.ArchivStopTaste setToolTip:NSLocalizedString(@"Stop Play",@"Wiedergabe anhalten")];
   [self.TitelPop setToolTip:NSLocalizedString(@"After Login:\nTitle of last Record.\nBelow: List of available titles",@"Nach dem Login:\n˙Titel der letzten Aufnahme.\nDarunter: Liste der vorhandenen Titel")];
   [self.ArchivnamenPop setToolTip:NSLocalizedString(@"List of names in the current project.",@"Liste der Namen im aktuellen Projekt.")];
   [self.Leserfeld setToolTip:NSLocalizedString(@"After Login:\nCurrent Reader.",@"Nach dem Login:\nAktueller Leser")];
   [self.ProjektFeld setToolTip:NSLocalizedString(@"Current Project.\nOther projects can be choosen in the Recorder Menu if available.",@"Aktuelles Projekt")];
   [[self.ModusMenu itemWithTag:kAdminTag]setToolTip:@"Hallo"];
   [[self.ModusMenu itemWithTag:kRecPlayTag]setToolTip:@"Hallo"];
   [[self.ModusMenu itemWithTag:kKommentarTag]setToolTip:@"Hallo"];
   [[self.ModusMenu itemWithTag:kEinstellungenTag]setToolTip:@"Hallo"];
   int i=[[[NSUserDefaults standardUserDefaults]objectForKey:@"Wert1"]intValue];
   //NSLog(@"Test Wert1: %d",i);
   //i--;
   
   NSTimer* KontrollTimer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                            target:self 
                                                          selector:@selector(KontrollTimerfunktion:) 
                                                          userInfo:nil 
                                                           repeats:YES];
   

  
   
}

- (void)KontrollTimerfunktion:(NSTimer*)derTimer
{
   if ([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0)
   {
      [derTimer invalidate];
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung setMessageText:@"PList  Kein PList-Eintrag mehr fuer 'pw'"];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      //int antwort=[Warnung runModal];
      
   }
}
   
- (IBAction)Titelsetzen:(NSButton *)sender
{
   _TitelString.stringValue = @"Lesestudio";
}



- (BOOL)Leseboxvorbereiten
{
   
   
   NSArray* NetworkCompArray=[Utils checkNetzwerkVolumes];
   
   NSLog(@"Leseboxvorbereiten	NetworkCompArray: %@",[NetworkCompArray description]);
   
   NSArray* UserMitLeseboxArray=[Utils checkUsersMitLesebox];
   //NSLog(@"Leseboxvorbereiten	 UserMitLeseboxArray: %@",[UserMitLeseboxArray description]);
   
   
   //	LeseboxDa=YES;
   //	LeseboxPfad=@"/Users/sysadmin/Documents/Lesebox";
   
   
   if (!self.LeseboxDa)
   {
      //NSLog(@"User nach gewuenschter Lesebox fragen");
      //User nach gewuenschter Lesebox fragen
      self.LeseboxPfad=(NSMutableString*)[self chooseLeseboxPfadMitUserArray:UserMitLeseboxArray undNetworkArray:NetworkCompArray];
      //NSLog(@"User nach gewuenschter Lesebox fragen LeseboxPfad: %@",LeseboxPfad);
      //Rücgabe: LeseboxPfad ungeprüft
   }
   NSLog(@"Leseboxvorbereiten: LeseboxPfad: %@",self.LeseboxPfad);
   
   BOOL LeseboxOK=NO;
   BOOL ArchivOK=NO;
   BOOL ProjektListeOK=NO;
   
   self.istSystemVolume=NO;
   BOOL NamenListeOK=NO;
   NSString* ArchivString=[NSString stringWithFormat:@"Archiv"];
   NSString* KommentarString=[NSString stringWithString:NSLocalizedString(@"Comments",@"Anmerkungen")];
   //istSystemVolume=[Utils istSystemVolumeAnPfad:LeseboxPfad];
   //NSLog(@"Leseboxvorbereiten vor LeseboxOK");
   
   LeseboxOK=[Utils LeseboxValidAnPfad:self.LeseboxPfad aufSystemVolume:self.istSystemVolume];//Lesebox checken, ev einrichten
   NSLog(@"Leseboxvorbereiten nach LeseboxOK: LeseboxOK: %d  self.istSystemVolume: %d",self.LeseboxOK,self.istSystemVolume);
   
   
   if (LeseboxOK)
   {
      NSLog(@"Leseboxvorbereiten LeseboxOK=1 PListDic lesen");
      self.PListDic=[[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:self.istSystemVolume]mutableCopy];
     
      
      // Anfang busy
      
      if ([self.PListDic objectForKey:@"busy"])
      {
         if ([[self.PListDic objectForKey:@"busy"]boolValue])//Besetzt
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Nochmals versuchen"];
            //[Warnung addButtonWithTitle:@""];
            //[Warnung addButtonWithTitle:@""];
            [Warnung addButtonWithTitle:@"Beenden"];
            NSString* MessageString=@"Datenordner besetzt";
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
            
            NSString* s1=NSLocalizedString(@"The data folder cannot be opened.",@"Der Datenordner kann nicht geöffnet werden");
            NSString* s2=NSLocalizedString(@"It is momentarly used by annother user.",@"Er wird im Moment von einem anderen Computer benutzt");
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            int antwort=[Warnung runModal];
            
            switch (antwort)
            {
               case NSAlertFirstButtonReturn://	1000
               {
                  NSLog(@"NSAlertFirstButtonReturn: Nochmals versuchen");
                  return NO;
                  
               }break;
                  
               case NSAlertSecondButtonReturn://1001
               {
                  //NSLog(@"NSAlertSecondButtonReturn: Beenden");
                  //User fragen, ob busy zurückgesetzt werden soll. Notmassnahme
                  NSAlert *BusyWarnung = [[NSAlert alloc] init];
                  [BusyWarnung addButtonWithTitle:NSLocalizedString(@"Reset Data Folder",@"Datenordner zurücksetzen")];
                  //[BusyWarnung addButtonWithTitle:@""];
                  //[BusyWarnung addButtonWithTitle:@""];
                  [BusyWarnung addButtonWithTitle:NSLocalizedString(@"Just terminate",@"Sofort beenden")];
                  NSString* MessageString=NSLocalizedString(@"Data Folder Busy",@"Datenordner besetzt");
                  [BusyWarnung setMessageText:[NSString stringWithFormat:@"%@",MessageString]];
                  
                  NSString* s1=NSLocalizedString(@"There is a problem with the state of thedata folder.",@"Es gibt ein Problem mit dem Status des Datenordners.");
                  NSString* s2=NSLocalizedString(@"Do you want to reset its state before terminating?",@"Soll sein Status vor dem Beenden zurückgesetzt werden?");
                  NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
                  [BusyWarnung setInformativeText:InformationString];
                  [BusyWarnung setAlertStyle:NSWarningAlertStyle];
                  
                  //[Warnung setIcon:RPImage];
                  int antwort=[BusyWarnung runModal];
                  
                  switch (antwort)
                  {
                     case NSAlertFirstButtonReturn://	1000
                     {
                        NSLog(@"NSAlertFirstButtonReturn: Reset");
                        [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
                        
                        
                     }break;
                        
                     case NSAlertSecondButtonReturn://1001
                     {
                        NSLog(@"NSAlertSecondButtonReturn: Beenden");
                        
                        
                     }break;
                        
                  }//switch
                  //[Utils setPListBusy:NO anPfad:LeseboxPfad];
                  [NSApp terminate:self];
                  
               }break;
               case NSAlertThirdButtonReturn://
               {
                  NSLog(@"NSAlertThirdButtonReturn");
                  
               }break;
               case NSAlertThirdButtonReturn+1://
               {
                  NSLog(@"NSAlertThirdButtonReturn+1");
                  
               }break;
                  
            }//switch
            
            //				return NO;//warten
         }
         else
         {
            
         }
      }
      else
      {
         
      }
      
      //		[Utils setPListBusy:YES anPfad:LeseboxPfad];
      
      
      
      //ende busy
      
      
      
      
      NSLog(@"LB vorbereiten: PListDic: %@",[self.PListDic description]);
      if ([self.PListDic objectForKey:@"userpasswortarray"])
      {
         [self.UserPasswortArray setArray:[self.PListDic objectForKey:@"userpasswortarray"]];//Aus PList einsetzen
      }
      
      if ([self.PListDic objectForKey:@"projektarray"])
      {
         NSLog(@"LB vorbereiten: ProjektArray: %@",[[self.PListDic objectForKey:@"projektarray"] description]);
         [self.ProjektArray setArray:[self.PListDic objectForKey:@"projektarray"]];
         
         
         NSLog(@"LB vorbereiten vor update: ProjektArray: %@",[[self.ProjektArray valueForKey:@"projekt"]description]);
         
         [self updateProjektArray];
         [self updatePasswortListe];
         NSLog(@"LB vorbereiten nach update: ProjektArray: %@",[[self.ProjektArray valueForKey:@"projekt"] description]);
         
      }
      
      if ([self.PListDic objectForKey:RPBewertungKey])
      {
         self.BewertungZeigen=([[self.PListDic objectForKey:RPBewertungKey]intValue]==1);
      }
      else
      {
         self.BewertungZeigen=YES;
      }
      
      if ([self.PListDic objectForKey:RPNoteKey])
      {
         self.NoteZeigen=([[self.PListDic objectForKey:RPNoteKey]intValue]==1);
      }
      else
      {
         self.NoteZeigen=YES;
      }
      
      
      if ([self.PListDic objectForKey:@"timeoutdelay"])
      {
         self.TimeoutDelay=[[self.PListDic objectForKey:@"timeoutdelay"]intValue];
      }
      else
      {
         self.TimeoutDelay=60;
      }
      
      
      //TimeoutDelay=5;
      if ([self.PListDic objectForKey:@"adminpw"])
      {
         self.AdminPasswortDic=[self.PListDic objectForKey:@"adminpw"];
      }
      
      if ([self.PListDic objectForKey:@"knackdelay"])
      {
         //NSLog(@"KnackDelay aus PList: %d",[[PListDic objectForKey:@"knackdelay"]intValue]);
         self.KnackDelay=[[self.PListDic objectForKey:@"knackdelay"]intValue];
      }
      
      
      if ([self.PListDic objectForKey:@"mituserpasswort"])
      {
         self.mitUserPasswort=[[self.PListDic objectForKey:@"mituserpasswort"]boolValue];
      }
      else
      {
         self.mitUserPasswort=1;
      }
      
      if (![self.PListDic objectForKey:@"lastdate"])
      {
         [self.PListDic setObject:[NSCalendarDate calendarDate] forKey:@"lastdate"];
      }
      
      NSLog(@"Leseboxvorbereiten ProjektArray aus PList: %@",[self.ProjektArray description]);
      NSLog(@"Leseboxvorbereiten adminpw aus PList: %@",[[self.PListDic objectForKey:@"adminpw"] description]);
      
      ArchivOK=[Utils ArchivValidAnPfad:self.LeseboxPfad];//Archiv checken, ev einrichten
   }
   else
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      return NO;
   }
   
   if (ArchivOK)
   {
      self.ArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:ArchivString];//Pfad des Archiv-Ordners
      //NSLog(@"vor ProjektListeOK: ProjektListeValidAnPfad: ProjektArray : \n%@",[ProjektArray description]);
      ProjektListeOK=[self ProjektListeValidAnPfad:self.ArchivPfad];//ProjektOrdner checken, ev einrichten,synchronisieren mit PList
      //NSLog(@"nach ProjektListeOK: ProjektListeValidAnPfad: ProjektArray : \n%@",[ProjektArray description]);
   }
   else
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      return NO;
   }
   
   
   if (ProjektListeOK)//
   {
      //NSLog(@"lb vorbereiten nach ProjektListeOK: ProjektListeValidAnPfad: ProjektArray : \n%@",[ProjektArray description]);
      BOOL Pfadsuchen=YES;
      BOOL istOrdner=NO;
      NSFileManager *Filemanager = [NSFileManager defaultManager];
      //	while (Pfadsuchen)
      {
         
         [self showProjektStart:nil];
         
         NSLog(@"lb vorbereiten nach showProjektStart: %@",self.ProjektPfad);
         
         if ([Filemanager fileExistsAtPath:self.ProjektPfad isDirectory:&istOrdner]&&istOrdner)
         {
            NSLog(@"ProjektPfad gefunden");
            Pfadsuchen=NO;
         }
         else
         {
            NSLog(@"ProjektPfad nicht gefunden");
         }
      }
      
      //NSLog(@"//Umgebung: %d  ProjektPfad: %@",Umgebung, ProjektPfad);
      
      NamenListeOK=[self NamenListeValidAnPfad:self.ProjektPfad];
      if (!NamenListeOK)//keine Namen im Projektordner
      {
         //NSLog(@"self.NamenListeOK=NO: Umgebung: %d  ProjektPfad: %@",Umgebung, ProjektPfad);
      }
      
   }//if ProjektListeOK
   
   else
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      return NO;
   }
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   //NSLog(@"LeseboxOK: %d ArchivOK: %d  self.NamenListeOK: %d",LeseboxOK, ArchivOK, self.NamenListeOK);
   
   //NSLog(@"vor ProjektMenu: ProjektListeValidAnPfad: ProjektArray : \n%@ \n@",[ProjektArray description],ProjektPfad);
   
   [self setProjektMenu];	
   
   //NSString* Leserself.NamenListe;
   
   if ([Filemanager fileExistsAtPath:self.ProjektPfad])
   {				
      NSDictionary* tempProjektDic;
      int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
      NSCalendarDate* ProjektSessionDatum;
      if (ProjektIndex<NSNotFound)
      {
         tempProjektDic=[self.ProjektArray objectAtIndex:ProjektIndex];
         [self checkSessionDatumFor:[self.ProjektPfad lastPathComponent]];
         if ([tempProjektDic objectForKey:@"sessiondatum"])
         {
            ProjektSessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
            
         }
         else
         {
            ProjektSessionDatum=[NSCalendarDate date];
         }
         
      }
      NSLog(@"ProjektSessionDatum: %@",ProjektSessionDatum);
      
      
      NSMutableArray * tempProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.ProjektPfad error:NULL]];
      int AnzNamen=[tempProjektNamenArray count];											//Anzahl Leser
      //Leserself.NamenListe=[tempProjektNamenArray description];
      
      if ([tempProjektNamenArray count])
      {
         if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
         {
            [tempProjektNamenArray removeObjectAtIndex:0];
         }
         
      }
      
      [self setArchivNamenPop];
      
      //NSLog(@"Lb vorbereiten tempProjektNamenArray: %@",[tempProjektNamenArray description]);
      
      [self.Zeitfeld setSelectable:NO];
     // [RecPlayFenster makeFirstResponder:RecPlayFenster];
      
      
      
   }			//Archivpfad
   
   
   //AnzLeseboxObjekte++;
   
   //NSMutableArray* test=[self OrdnernamenArrayVonKlassenliste];
   [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
   
   return YES;
}


- (NSString*) chooseLeseboxPfadMitUserArray:(NSArray*)derUserArray undNetworkArray:(NSArray*)derNetworkArray;
{
   NSArray* tempUserArray=[NSArray array];
   tempUserArray=[[NSArray alloc]initWithArray:derUserArray];
   if (VolumesPanel)
   {
      
   }
   else
   {
      VolumesPanel = [[rVolumes alloc]init];
   }
   NSModalSession VolumeSession=[NSApp beginModalSessionForWindow:[VolumesPanel window]];
   
   //in VolumesPanel Daten einsetzen
   [VolumesPanel setUserArray:tempUserArray];
   //NSLog(@"tempUserArray eingesetzt");
   //	if ([tempNetworkArray count])
   //	[VolumesPanel setNetworkArray:tempNetworkArray];
   //    NSLog(@"tempNetworkArray eingesetzt");
   
   int modalAntwort = [NSApp runModalForWindow:[VolumesPanel window]];
   NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);
   
   //LeseboxPfad aus Panel abfragen
   NSString* tempLeseboxPfad=[NSString stringWithString:[VolumesPanel LeseboxPfad]];
   self.istSystemVolume=[VolumesPanel istSystemVolume];
   
   //Für Volumes mit System zeigt der Leseboxpfad auf einen Ordner in Documents
   //Für Externe HDs zeigt der Leseboxpfad auf einen Ordner direkt auf der HD.
   //Die PList wird im Ordner 'Data' in der Lesebox abgelegt.
   
   self.LeseboxURL =[NSURL URLWithString:self.LeseboxPfad];
  // NSLog(@"LeseboxPfad: %@ LeseboxURL: %@",self.LeseboxPfad,self.LeseboxURL);
  // NSLog(@"chooseLeseboxPfadVon: Antwort: %d  LeseboxPfad: %@",modalAntwort,tempLeseboxPfad);
   
   [NSApp endModalSession:VolumeSession];
   
   [[VolumesPanel window] orderOut:NULL];
   //NSLog(@"VolumesPanel: Antwort: %d",modalAntwort);
   
   return tempLeseboxPfad;
   
}//chooseLeseboxPfadVon

- (void)setRepresentedObject:(id)representedObject {
   [super setRepresentedObject:representedObject];

   // Update the view, if already loaded.
}



- (IBAction)showProjektListe:(id)sender
{
   if (!self.ProjektPanel)
	  {
        self.ProjektPanel=[[rProjektListe alloc]init];
     }
   
   NSLog(@"showProjektListe");
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[self.ProjektPanel window]];
   int modalAntwort = [NSApp runModalForWindow:[self.ProjektPanel window]];
   
   [NSApp endModalSession:ProjektSession];
   [[self.ProjektPanel window] orderOut:NULL];
   
}

- (void)showProjektListeVomStart
{
   NSLog(@"showProjektListeVomStart:  Start mit neuem Projekt");
   //NSLog(@"\n\nshowProjektListe start");
   if (!self.ProjektPanel)
	  {
        self.ProjektPanel=[[rProjektListe alloc]init];
     }
   //NSLog(@"showProjektListe nach init:ProjektArray: %@  ",[ProjektArray description]);
   NSLog(@"showProjektListe nach init:ProjektArray: %@  \nProjektPfad: %@",[self.ProjektArray description],self.ProjektPfad);
   
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[self.ProjektPanel window]];
   
   if ([self.ProjektArray count])
	  {
        [self.ProjektPanel  setProjektListeArray:self.ProjektArray  inProjekt:[self.ProjektPfad lastPathComponent]];
     }
   else
	  {
        
        NSLog(@"[ProjektArray count]=0");
        [self.ProjektPanel  setProjektListeLeer];
     }
	  
   //	  [ProjektPanel setMitUserPasswort:mitUserPasswort];
	  [self.ProjektPanel  setVomStart:YES];
   
   int modalAntwort = [NSApp runModalForWindow:[self.ProjektPanel window]];
   //int modalAntwort = [NSApp runModalSession:ProjektSession];
   if (modalAntwort==0)
   {
      
   }
   //NSLog(@"showProjektliste Antwort: %d",modalAntwort);
   [NSApp endModalSession:ProjektSession];							//Ergebnisse aus Notifikation
   
   
   [self.ProjektPanel  setVomStart:YES];
}

- (IBAction)anderesProjekt:(id)sender
{
   //NSLog(@"\n\n************	Menü Ablauf:	anderes Projekt: %@\n",[sender title]);
   [self anderesProjektEinrichtenMit:[sender title]];
   
   [self setArchivNamenPop];
   if (self.Umgebung==kRecPlayUmgebung)
      [Utils startTimeout:self.TimeoutDelay];
}

- (IBAction)anderesProjektMitTitel:(NSString*)derTitel
{
   //NSLog(@"\n\n	Menü Ablauf:	anderesProjektMitTitel; %@",derTitel);
   [self anderesProjektEinrichtenMit:derTitel];
   [self setArchivNamenPop];
   //[Utils startTimeout:TimeoutDelay];
}


- (void)updateProjektArray
{
   //NSLog(@"updateProjektArray start: Leseboxpfad: %@ ProjektArray : %@",LeseboxPfad,[ProjektArray description]);
   
   BOOL ProjektListeValid=NO;
   BOOL erfolg=YES;
   NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   int anzOrdnerImArchiv=0;
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];	//	Projektarray aus PList
   
   //NSLog(@"updateProjektArray ProjektArray aus PList: ProjektArray : %@",[ProjektArray description]);
   
   int anzProjekte=[self.ProjektArray count];//Anzahl Projekte in ProjektArray
   
   //Inhalt von Archiv prüfen
   NSString* tempArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   NSMutableArray* tempArchivProjektNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempArchivPfad error:NULL];
   //NSLog(@"updateProjektArray: ArchivPfad: %@  tempArchivProjektNamenArray roh : %@",tempArchivPfad,[tempArchivProjektNamenArray description]);
   
   if ([tempArchivProjektNamenArray count]&&[[tempArchivProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [tempArchivProjektNamenArray removeObjectAtIndex:0];
      
   }
   anzOrdnerImArchiv=[tempArchivProjektNamenArray count];
   //NSLog(@"updateProjektArray Projektnamen im Archiv: tempArchivProjektNamenArray : %@",[tempArchivProjektNamenArray description]);
   //NSLog(@"updateProjektArray Projektnamen im Archiv: tempArchivProjektNamenArray : %@",[[tempArchivProjektNamenArray valueForKey:@"projekt"]description]);
   
   //Namen im vorhandenen Projektarray aus der PList:
   NSArray* tempProjektArrayNamenArray=[self.ProjektArray valueForKey:@"projekt"];
   //NSLog(@"Projektnamen aus PList: tempProjektArrayNamenArray : %@",[tempProjektArrayNamenArray description]);
   
   //Enum über Namen der Projekte im Projektarray
   NSEnumerator* enumerator=[tempProjektArrayNamenArray objectEnumerator];
   //NSString* tempProjekt;
   BOOL istOrdner=NO;
   int index=0; //Index im Projektarray
   //while (tempProjekt==[enumerator nextObject])
   for (index=0;index<[tempProjektArrayNamenArray  count];index++)
   {
      NSString* tempProjekt =[tempProjektArrayNamenArray  objectAtIndex:index] ;
      //NSLog(@"tempProjekt: %@  index: %d",tempProjekt,index);
      //Ist der Name von tempProjekt im Archiv vorhanden?
      int ArchivPosition=[tempArchivProjektNamenArray indexOfObject:tempProjekt];
      //NSLog(@"tempProjekt: %@  ArchivPosition: %d",tempProjekt,ArchivPosition);
      
      if (ArchivPosition < NSNotFound)//Objekt ist im Archiv
      {
         //Projekt aus Projektarray in neuen ProjektArray kopieren
         [tempProjektArray addObject:[self.ProjektArray objectAtIndex:index]];
      }
      
   }//for
   
   
   //NSLog(@"tempProjektArray : %@",[tempProjektArray description]);
   
   //Projektarray ersetzen
   [self.ProjektArray setArray:tempProjektArray];
   [Utils ProjektArrayInPList:tempProjektArray anPfad:self.LeseboxPfad];
   //NSLog(@"updateProjektArray end");
}

- (void)updatePasswortListe
{
   //NSLog(@"updateself.NamenListe start:");
   
   BOOL ProjektListeValid=NO;
   BOOL erfolg=YES;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   int anzOrdnerImArchiv=0;
   NSArray* tempProjektArray;
   
   NSString* tempArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   NSMutableArray* tempArchivProjektOrdnerArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempArchivPfad error:NULL];
   //NSLog(@"updateProjektArray: ArchivPfad: %@  tempArchivProjektOrdnerArray roh : %@",tempArchivPfad,[tempArchivProjektOrdnerArray description]);
   
   if ([tempArchivProjektOrdnerArray count]&&[[tempArchivProjektOrdnerArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [tempArchivProjektOrdnerArray removeObjectAtIndex:0];
      
   }
   anzOrdnerImArchiv=[tempArchivProjektOrdnerArray count];	//	Namen von Ordnern im Archiv
   //NSLog(@"Projektnamen im Archiv: tempArchivProjektOrdnerArray : %@",[tempArchivProjektOrdnerArray description]);
   
   if ([tempArchivProjektOrdnerArray count]==0)
   {
      return;
   }
   NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSEnumerator* ProjektEnum=[tempArchivProjektOrdnerArray objectEnumerator];
   id einProjektName;
   while (einProjektName=[ProjektEnum nextObject])
   {
      NSString* tempLeserPfad=[tempArchivPfad stringByAppendingPathComponent:einProjektName];
      NSMutableArray* tempLeserNamenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempLeserPfad error:NULL];
      //		NSLog(@"updateProjektArray: tempLeserPfad: %@  tempLeserNamenArray roh : %@",tempLeserPfad,[tempLeserNamenArray description]);
      
      if ([tempLeserNamenArray count]&&[[tempLeserNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
      {
         [tempLeserNamenArray removeObjectAtIndex:0];
         
      }
      NSEnumerator* NamenEnum=[tempLeserNamenArray objectEnumerator];
      id einName;
      while (einName=[NamenEnum nextObject])
      {
         if (!([tempNamenArray containsObject:einName]))
         {
            [tempNamenArray addObject:einName];
         }
      }//while
      //
      
   }//while
   //	tempNamenArray: Namen aller Leser im Archiv
   
   //NSLog(@"updatePasswortliste: tempNamenArray : %@",[tempNamenArray description]);
   NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
   NSMutableArray* tempPWArray=(NSMutableArray*)[tempPListDic objectForKey:@"userpasswortarray"];
   //	 tempPWArray: Dics im PWArray der PList
   
   NSArray* tempNamenMitPWArray=[tempPWArray valueForKey:@"name"];
   //	tempNamenMitPWArray: Namen im PWArray der PList
   
   //NSLog(@"updateProjektArray: tempNamenMitPWArray : %@",[tempNamenMitPWArray description]);
   
   //	Neuer Array mit PWDics zu noch vorhandnenen Namen:
   NSMutableArray* tempneuerUserPWArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSEnumerator* PWEnum=[tempNamenMitPWArray objectEnumerator]; // Leser mit PW in PList
   id einPWName;
   int index=0;
   while ((einPWName =[PWEnum nextObject]))
   {
      if ([tempNamenArray containsObject:einPWName])
      {
         [tempneuerUserPWArray addObject:[tempPWArray objectAtIndex:index]];
      }
      index++;
   }//while PWEnum
   //NSLog(@"updateProjektArray: tempneuerUserPWArray : %@",[tempneuerUserPWArray description]);
   
   NSString* tempDataPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   NSString* tempPListPfad=[tempDataPfad stringByAppendingPathComponent:PListName];
   
   [tempPListDic setObject:[tempneuerUserPWArray copy] forKey:@"userpasswortarray"];
   BOOL PListOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
   
}//updateself.NamenListe

- (BOOL)ArchivValidAnPfad:(NSString*)derLeseboxPfad
{
   NSString* locBeenden=NSLocalizedString(@"Beenden",@"Beenden");
   
   BOOL ArchivValid=0;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempArchivPfad=[derLeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   if ([Filemanager fileExistsAtPath:tempArchivPfad])
	  {
        ArchivValid=YES;
     }
   else
	  {
        ArchivValid=[Filemanager createDirectoryAtPath:tempArchivPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
        if (!ArchivValid)
        {
           NSString* s1=NSLocalizedString(@"Creating The Archive: ",@"Archiv einrichten:");
           NSString* s2=NSLocalizedString(@"The folder 'Archive' couln't be created on the choosen machine",@"Kein Archiv auf gewählten Comp");
           int Antwort=NSRunAlertPanel(s1,s2,locBeenden, nil,nil);
           [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
           [self terminate:NULL];
           
        }
        
     }
   return ArchivValid;
}




- (BOOL)ProjektListeValidAnPfad:(NSString*)derArchivPfad
{
   //NSLog(@"ProjektListeValidAnPfad start derArchivPfad: %@",derArchivPfad);
   BOOL ProjektListeValid=NO;
   BOOL erfolg=YES;
   NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempNeueProjekteArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   int anzOrdnerImArchiv=0;
   
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   
   int anzProjekte=[self.ProjektArray count];//Anzahl Projekte in PList
	  if (anzProjekte)
     {
        [tempNeueProjekteArray setArray:self.ProjektArray];
     }
   NSArray* tempPListProjektnamenArray=[self.ProjektArray valueForKey:@"projekt"];//Namen der Projekte in PList
   //NSLog(@"tempPListProjektnamenArray: %@",[tempPListProjektnamenArray description]);
   
   //Inhalt von Archiv prüfen
   NSMutableArray* tempAdminProjektNamenArray=[[Filemanager contentsOfDirectoryAtPath:derArchivPfad error:NULL]mutableCopy];
   
   //if ([tempAdminProjektNamenArray count])
	  
   if ([tempAdminProjektNamenArray count]&&[[tempAdminProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [tempAdminProjektNamenArray removeObjectAtIndex:0];
      
   }
   anzOrdnerImArchiv=[tempAdminProjektNamenArray count];	//Anzahl Userordner im Archiv
   
   if (anzOrdnerImArchiv)//es hat schon Ordner im Archiv
   {
      NSEnumerator* enumerator=[tempAdminProjektNamenArray objectEnumerator];
      NSString* tempObjekt;
      BOOL istOrdner=NO;
      while (tempObjekt==[enumerator nextObject])
      {
         NSString* tempPfad=[derArchivPfad stringByAppendingPathComponent:tempObjekt];//Pfad des Userordners
         //NSLog(@"tempPfad: %@",tempPfad);
         
         if ([Filemanager fileExistsAtPath:tempPfad isDirectory:&istOrdner] && istOrdner)
         {
            NSMutableDictionary* tempProjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempProjektDic setObject:tempPfad forKey:@"projektpfad"]; //Projektpfad einsetzen
            [tempProjektDic setObject:[tempPfad lastPathComponent] forKey:@"projekt"];
            NSArray* tempNamenArray=[Filemanager contentsOfDirectoryAtPath: tempPfad error:NULL];
            //NSLog(@"tempNamenArray: %@",[tempNamenArray description]);
            int AnzNamen=[tempNamenArray count];
            if (AnzNamen)
            {
               if ([[tempNamenArray objectAtIndex:0] hasPrefix:@".DS"])
               {
                  AnzNamen--;
               }
               //NSLog(@"ProjektlisteValidAnPfad: Projekt: %@   Anz Namen: %d",tempObjekt,AnzNamen);
               
               [tempProjektDic setObject:[NSNumber numberWithInt:AnzNamen] forKey:@"anznamen"];
               
               //if ([ProjektArray containsObject:tempObjekt])
               if ([self.ProjektArray containsObject:tempProjektDic])
               {
                  NSLog(@"Objekt schon da");
               }
               else
               {
                  //NSLog(@"Objekt neu");
                  
                  [tempProjektDic setObject:[NSNumber numberWithInt:1] forKey:@"ok"];
                  [tempProjektDic setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                  [tempProjektDic setObject:[NSNumber numberWithInt:0] forKey:@"mituserpw"];
                  
                  [tempProjektArray addObject:tempProjektDic];
               }
            }//AnzNamen
            
            //[tempProjektArray addObject:tempProjektDic];//Nur einsetzen wenn neu
         }
      }//while
      //NSLog(@"tempProjektArray : %@",[tempProjektArray description]);
      
      //NSLog(@"tempNeueProjekteArray Rest: %@",[tempNeueProjekteArray description]);
      if ([tempProjektArray count])
      {
         NSArray*tempPListArray=[self.PListDic objectForKey:@"projektarray"];
         NSEnumerator* ProjektArrayEnum=[tempProjektArray objectEnumerator];//Array der vorhandenen Ordner im Archiv
         id einProjektDic;
         while (einProjektDic=[ProjektArrayEnum nextObject])
         {
            NSString* tempProjektName=[einProjektDic objectForKey:@"projekt"];
            NSEnumerator* PListArrayEnum=[tempPListArray objectEnumerator];
            id einPListProjektDic;
            while (einPListProjektDic=[PListArrayEnum nextObject])//Abgleich mit Daten im Projektarray aus PList
            {
               NSString* tempPListProjektName=[einPListProjektDic objectForKey:@"projekt"];//Projekt aus plist
               if([tempProjektName isEqualToString:tempPListProjektName])//Projekt hat einen Eintrag in der plist
               {
                  if ([einPListProjektDic objectForKey:@"ok"])//objekt für ok ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"ok"] forKey:@"ok"];
                  }
                  if ([einPListProjektDic objectForKey:@"fix"])//objekt für fix ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"fix"] forKey:@"fix"];
                  }
                  if ([einPListProjektDic objectForKey:@"titelarray"])//objekt für titelarray ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"titelarray"] forKey:@"titelarray"];
                  }
                  if ([einPListProjektDic objectForKey:@"mituserpw"])//objekt für mituserpw ist in plist
                  {
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"mituserpw"] forKey:@"mituserpw"];
                  }
                  
                  if ([einPListProjektDic objectForKey:@"sessiondatum"])//objekt für sessiondatum ist in plist
                  {
                     //NSLog(@"sessiondatum da: %@",[einPListProjektDic objectForKey:@"sessiondatum"]);
                     
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"sessiondatum"] forKey:@"sessiondatum"];
                  }
                  else
                  {
                     [einProjektDic setObject: [NSCalendarDate date] forKey:@"sessiondatum"];
                     [einPListProjektDic setObject: [NSCalendarDate date] forKey:@"sessiondatum"];
                     NSLog(@"neues Sessiondatum: %@",[NSCalendarDate date]);
                     [self saveSessionDatum:[NSCalendarDate date] inProjekt:tempPListProjektName];
                     
                  }
                  
                  if ([einPListProjektDic objectForKey:@"sessionleserarray"])//objekt für sessionleserarray ist in plist
                  {
                     //NSLog(@"sessionleserarray da: %@",[[einPListProjektDic objectForKey:@"sessionleserarray"]description]);
                     
                     [einProjektDic setObject: [einPListProjektDic objectForKey:@"sessionleserarray"] forKey:@"sessionleserarray"];
                  }
                  else
                  {
                     [einPListProjektDic setObject:[NSMutableArray array] forKey:@"sessionleserarray"];
                     
                     [einProjektDic setObject: [NSMutableArray array] forKey:@"sessionleserarray"];
                     //NSLog(@"neuer sessionleserarray datum: %@",[NSCalendarDate date]);
                  }
                  
                  //NSLog(@"einProjektDic: %@",[einProjektDic description]);
               }
               
            }//while ProjektArrayEnum
            
         }//while ProjektArrayEnum
         
         //NSLog(@"ProjektListeValidAnPfad: tempPListArray : %@",[tempPListArray description]);
         [self.ProjektArray setArray:tempProjektArray];
         
      }
      //NSLog(@"ProjektListeValidAnPfad: tempProjektListeArray : %@",[tempProjektListeArray description]);
      //NSLog(@"ProjektListeValidAnPfad: ProjektArray synchronisiert: %@",[ProjektArray description]);
      
   }//anz
   else//Archiv ist leer
   {
      //NSLog(@"ProjektListeValidAnPfad: Archiv ist leer");
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:NSLocalizedString(@"Enter Project",@"Projekt eingeben")];
      [Warnung addButtonWithTitle:NSLocalizedString(@"Create manually",@"Manuell einrichten")];
      [Warnung setMessageText:NSLocalizedString(@"No Project",@"Kein Projekt")];
      [Warnung setInformativeText:NSLocalizedString(@"At least one project folder must be present in the folder 'Archive'.",@"In'Archiv' mindestens ein Ordner für Projekt")];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      NSImage* RPImage = [NSImage imageNamed: @"MicroIcon"];
      
      //[Warnung setIcon:RPImage];
      int antwort=[Warnung runModal];
      NSLog(@"antwort: %d",antwort);
      switch (antwort)
      {
         case NSAlertFirstButtonReturn:
         {
            NSLog(@"eingeben");
            
            [self showProjektListe:nil];
            
            if ([self.ProjektArray count])//Ergebnis von showProjektListe aus Notification
            {
               NSEnumerator* ProjektEnum=[self.ProjektArray objectEnumerator];
               id einProjekt;
               while (einProjekt=[ProjektEnum nextObject])
               {
                  BOOL OrdnereinrichtenOK=YES;
                  NSString* tempProjektName=[einProjekt objectForKey:projekt];
                  NSString* tempProjektPfad=[derArchivPfad stringByAppendingPathComponent:tempProjektName];
                  
                  if (![Filemanager fileExistsAtPath:tempProjektPfad])
                  {
                     BOOL OrdnerOK=NO;
                     
                     OrdnerOK=[Utils ProjektOrdnerEinrichtenAnPfad:tempProjektPfad];
                     
                  }//neues Dir
                  
               }//while einProjekt
            }//count
            else
            {
               
               NSLog(@"Keine Eingabe");
               
            }
            
         }break;
         case NSAlertSecondButtonReturn:
         {
            NSLog(@"manuell");
            [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
            [self terminate:NULL];
            
         }break;
         case NSAlertThirdButtonReturn:
         {
            
         }break;
      }//switch antwort
      
   }
	 	
   return YES;
   
}




- (BOOL)NamenListeValidAnPfad:(NSString*)derProjektPfad
{
   BOOL NamenListeValid=NO;
   BOOL erfolg=YES;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   //Inhalt von Archiv prüfen
   // NSLog(@"ProjektPfad 7:retainCount %d",[ProjektPfad retainCount]);
   
   NSArray* tempProjektNamenArray=[Filemanager contentsOfDirectoryAtPath:derProjektPfad error:NULL];
   //NSLog(@"ProjektPfad 8:retainCount %d",[ProjektPfad retainCount]);
   
   int anz=0;
   if ([tempProjektNamenArray count])
   {
      
      NSEnumerator* enumerator=[tempProjektNamenArray objectEnumerator];
      NSString* tempObjekt;
      BOOL istOrdner=NO;
      while (tempObjekt==[enumerator nextObject])
      {
         NSString* tempPfad=[derProjektPfad stringByAppendingPathComponent:tempObjekt];
         if ([Filemanager fileExistsAtPath:tempPfad isDirectory:&istOrdner] && istOrdner)
         {
            anz++;
         }
      }
      //NSLog(@"self.NamenListeValidAnPfad: anz Ordner: %d\n tempAdminProjektNamenArray: %@",anz,[tempProjektNamenArray description]);
      
   }				
   if (anz)
   {
      NamenListeValid=YES;
      return NamenListeValid;
   }
   return NO;
   
}


- (void)ProjektListeAktion:(NSNotification*)note
{
   NSLog(@"ProjektListeAktion: %@",[[[note userInfo] objectForKey:@"projektarray"]description]);
   
}

- (IBAction)showProjektStart:(id)sender
{
   
   if (!ProjektStartPanel)
   {
      ProjektStartPanel=[[rProjektStart alloc]init];
   }
   NSLog(@"showProjektStartt:ProjektArray: %@",[self.ProjektArray description]);
   
   //[ProjektPanel showWindow:self];
   NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[ProjektStartPanel window]];
   
   //NSLog(@"showProjektStart LeseboxPfad: %@",LeseboxPfad);
   
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];
   NSArray*  tempProjektNamenArray = [NSArray arrayWithArray:[Utils ProjektNamenArrayVon:[self.LeseboxPfad stringByAppendingString:@"/Archiv"]]];
   //NSLog(@"ProjektArray A: %@",[ProjektArray description]);
   
   //   [ProjektArray addObjectsFromArray:tempProjektNamenArray];
   //NSLog(@"ProjektArray B: %@",[ProjektArray description]);
   if ([self.ProjektArray count])
   {
      [ProjektStartPanel  setProjektArray:self.ProjektArray];
      //NSLog(@"showProjektStart setRecorderTaste: ProjektArray count InputDeviceOK: %d",InputDeviceOK);
      [ProjektStartPanel  setRecorderTaste:self.InputDeviceOK];
      
   }
   if ([self AdminPW])
   {
      //NSLog(@"showProjektStart setRecorderTaste: AdminPW OK");
      [ProjektStartPanel  setRecorderTaste:YES];
      
   }
   else
   {
      //NSLog(@"showProjektStart setRecorderTaste: Neue LB, noch kein AdminPW");
      [ProjektStartPanel  setRecorderTaste:NO];//Neue LB, noch kein AdminPW
      
   }
   
   
   if ([self.PListDic objectForKey:@"lastprojekt"])
   {
      //NSLog(@"showProjektStart start lastproject: %@",[PListDic objectForKey:@"lastprojekt"]);
      [ProjektStartPanel selectProjekt:[self.PListDic objectForKey:@"lastprojekt"]];
   }
   
   
   int modalAntwort = [NSApp runModalForWindow:[ProjektStartPanel window]];
   
   NSLog(@"showProjektStart Antwort: %d",modalAntwort);
   [NSApp endModalSession:ProjektSession];
   //[[ProjektPanel window] orderOut:NULL];
   
}

- (void)ProjektStartAktion:(NSNotification*)note
{
   //NSLog(@"ProjektStartAktion: %@",[[note userInfo]description]);
   NSString* tempProjektWahl=[[note userInfo] objectForKey:@"projektwahl"];
   //tempProjektWahl = [tempProjektWahl stringByAppendingPathComponent:tempProjektWahl];
   //NSLog(@"ProjektStartAktion tempProjektWahl: %@",tempProjektWahl);
   
   self.ProjektPfad=[self.ArchivPfad stringByAppendingPathComponent:tempProjektWahl];
   if ([[note userInfo] objectForKey:@"projektpfad"])
   {
      self.ProjektPfad=[[note userInfo] objectForKey:@"projektpfad"];
   }
   NSLog(@"ArchivPfad :%@ ProjektPfad: %@",self.ArchivPfad,self.ProjektPfad);
   NSString* UmgebungString=[[note userInfo] objectForKey:@"umgebunglabel"];
   int UmgebungZahl=[[[note userInfo] objectForKey:@"umgebung"]intValue];
   self.Umgebung=UmgebungZahl;
   self.mitUserPasswort=NO;
   NSString* MitUserPWString=[[note userInfo] objectForKey:@"mituserpw"];
   if (MitUserPWString)
   {
      self.mitUserPasswort=[[[note userInfo] objectForKey:@"mituserpw"]boolValue];
      //In ProjektArray aendern
      
   }
   
   //NSLog(@"ProjektStartAktion ende: %@",[ProjektArray description]);
   if ([[note userInfo] objectForKey:@"aktion"])
   {
      switch ([[[note userInfo] objectForKey:@"aktion"] intValue])
      {
         case 1:
         {
            
         }break;
            
         case 2: //neues Projekt
         {
            //NSLog(@"Start mit neuem Projekt");
            [NSApp abortModal];
            
            self.AdminZugangOK=[self checkAdminZugang];
            if (self.AdminZugangOK)
            {
               NSLog(@"Start showProjektListeVomStart ProjektPfad: %@",self.ProjektPfad);
               [self showProjektListeVomStart];
               
            }
            else
            {
               if ([self AdminPW])
               {
                  //NSLog(@"ProjektStartAktion: AdminPW: YES");
                  self.Umgebung=kRecPlayUmgebung;
               }
               else
               {
                  //NSLog(@"ProjektStartAktion: AdminPW: YES");
                  [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
                  [NSApp terminate:self];
                  
               }
            }
            
         }break;
            
         case 13:
         case 14://Abbrechen beim Start
         {
            [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
            
            [NSApp terminate:self];
         }
      }//switch
      
      
   }
   
}

- (void)setProjektMenu
{
   //NSLog(@"RecPlay   setProjektMenu: ProjektArray %@",[ProjektArray description]);
   int anz=[self.ProjektMenu numberOfItems];
   int i=0;
   if (anz)
   {
      for (i=0;i<anz;i++)
      {
         [self.ProjektMenu removeItemAtIndex:0];
         
      }
   }
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   //NSLog(@"RecPlay   setProjektMenu: ProjektPfad: %@",ProjektPfad);
   NSString* aktuellerProjektName=[self.ProjektPfad lastPathComponent];
   for (i=0;i<[self.ProjektArray count];i++)
   {
      BOOL ProjektOK=[[[self.ProjektArray objectAtIndex:i]objectForKey:OK]boolValue];
      if (ProjektOK)//Projekt ist aktiv und soll in ProjektMenu
      {
         NSString* tempItemString=[[self.ProjektArray objectAtIndex:i]objectForKey:projekt];
         if (![tempItemString isEqualToString:aktuellerProjektName])
         {
            NSMenuItem* tempItem=[[NSMenuItem alloc]initWithTitle:tempItemString
                                                           action:@selector(anderesProjekt:)
                                                    keyEquivalent:@""];
            [tempItem setEnabled:YES];
            [tempItem setTarget:self];
            [self.ProjektMenu addItem:tempItem];
         }
      }//if ProjektOK
   }
   //if (AdminPlayer)
   {
      //[AdminPlayer setProjektPop:ProjektArray];
   }
}

- (IBAction)beginAdminPlayer:(id)sender
{
   BOOL erfolg;
   /*
   if (MoviePlayerbusy)
	  {
        NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
						  [Warnung addButtonWithTitle:@"OK"];
						  //[Warnung addButtonWithTitle:@"Cancel"];
						  [Warnung setMessageText:NSLocalizedString(@"Still Playing",@"Wiedergabe läuft")];
						  [Warnung setInformativeText:NSLocalizedString(@"No switching is possible while playing",@"Kein Umschalten während Play")];
						  [Warnung setAlertStyle:NSWarningAlertStyle];
						  [Warnung beginSheetModalForWindow:RecPlayFenster
                                        modalDelegate:nil
                                       didEndSelector:nil
                                          contextInfo:nil];
						  
        //int Antwort=NSRunAlertPanel(@"", @"",@"OK", NULL,NULL);
        return;
     }
   if ([AufnahmeGrabber isRecording])
	  {
        NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
						  [Warnung addButtonWithTitle:@"OK"];
						  //[Warnung addButtonWithTitle:@"Cancel"];
						  [Warnung setMessageText:NSLocalizedString(@"Still Recording",@"Aufnahme läuft")];
						  [Warnung setInformativeText:NSLocalizedString(@"No switching is possible while recording",@"Kein Umschalten während Aufnahme")];
						  [Warnung setAlertStyle:NSWarningAlertStyle];
						  [Warnung beginSheetModalForWindow:RecPlayFenster
                                        modalDelegate:nil
                                       didEndSelector:nil
                                          contextInfo:nil];
						  
        //int Antwort=NSRunAlertPanel(@"Aufnahme läuft", @"Während dieser Zeit kann nicht umgeschaltet werden",@"OK", NULL,NULL);
        return;
     }
    */
   [self ArchivZurListe:nil];
   [self resetRecPlay];
   [self.RecPlayTab selectTabViewItemAtIndex:0];
//   [self.window setIsVisible:NO];

   /*
   if(!self.AdminPlayer)
	  {
        self.AdminPlayer=[[rAdminPlayer alloc]init];
        //[AdminPlayer showWindow:self];
        //[AdminPlayer setLeseboxPfad:LeseboxPfad];
     }
	  [Utils stopTimeout];
   [self.AdminPlayer showWindow:self];
   */
	  //NSLog(@"beginAdminPlayer LeseboxPfad: %@ Projekt: %@",LeseboxPfad,[ProjektPfad lastPathComponent]);
   
	  //NSLog(@"beginAdminPlayer vor setAdminPlayer");
	  
   //NSLog(@"\n\n\n\n\n\n	in beginAdminPlayer vor setAdminProjektArray: AdminPlayer:      ProjektArray: \n%@",[ProjektArray description]);
   
   //Projektarray aktualisieren: Eventuell Aenderungen von anderen Usern auf dem Netz
   //NSLog(@"beginAdminPlayer PListDic lesen");
   NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
   
   if ([tempAktuellePListDic objectForKey:@"projektarray"])//Es hat schon einen ProjektArray
   {
      //NSLog(@"beginAdminPlayer: Projektarray aus PList lastObject: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
      [self.ProjektArray setArray:[[tempAktuellePListDic objectForKey:@"projektarray"]copy]];
      //NSLog(@"beginAdminPlayer: Projektarray neu: %@",[[ProjektArray lastObject]description]);
      
   }
   
   
   /*
   [self.AdminPlayer setAdminProjektArray:self.ProjektArray];
   
   [self.AdminPlayer setAdminPlayer:self.LeseboxPfad inProjekt:[self.ProjektPfad lastPathComponent]];
	  //NSLog(@"beginAdminPlayer nach setAdminPlayer");
   self.Umgebung=kAdminUmgebung;
   //NSLog(@"in beginAdminPlayer vor setProjektPop: AdminPlayer:      ProjektArray: \n%@",[ProjektArray description]);
   
   [self.AdminPlayer setProjektPopMenu:self.ProjektArray];
   
   // }
   //else
	  {
        
     }
   */
   
}



- (BOOL)AdminPW
{
   BOOL OK=NO;
   if ([self.PListDic objectForKey:@"adminpw"]&&[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"])
   {
      if ([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length])
      {
         OK=YES;
      }
   }
   //NSLog(@"AdminPW: %d",OK);
   return OK;
}

- (void)setArchivNamenPop

{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"setArchivNamenPop: ProjektArray: %@",[ProjektArray description]);
   //NSLog(@"setArchivNamenPop: Utils ProjektArray: %@",[[Utils ProjektArrayAusPListAnPfad:LeseboxPfad] description]);
   
   //	[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   
   NSDictionary* tempProjektDic;
   int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
   NSCalendarDate* ProjektSessionDatum;
   if (ProjektIndex<NSNotFound)
   {
      //Dic des aktuellen Projekts im Projektarray
      tempProjektDic=[self.ProjektArray objectAtIndex:ProjektIndex];
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         ProjektSessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
         
      }
      else
      {
         ProjektSessionDatum=[NSCalendarDate date];
      }
      
   }
   //NSLog(@"ProjektSessionDatum: %@",ProjektSessionDatum);
   
   
   NSMutableArray * tempProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.ProjektPfad error:NULL]];
   int AnzNamen=[tempProjektNamenArray count];											//Anzahl Leser
   //Leserself.NamenListe=[tempProjektNamenArray description];
   
   if ([tempProjektNamenArray count])
   {
      if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
      {
         [tempProjektNamenArray removeObjectAtIndex:0];
      }
      
   }
   
   int PopAnz=[self.ArchivnamenPop numberOfItems];
   //NSLog(@"ArchivnamenPop numberOfItems %d",PopAnz);
   
   if (PopAnz>1)//Alle ausser erstes Item entfernen (Name wählen)
   {
      while (PopAnz>1)
      {
         
         //NSLog(@"ArchivnamenPop removeItemAtIndex  %@",[[ArchivnamenPop itemAtIndex:1]description]);
         [self.ArchivnamenPop removeItemAtIndex:1];
         PopAnz--;
         
      }
   }
   
   NSString* NamenwahlString=NSLocalizedString(@"Choose name",@"Namen auswählen");
   NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor purpleColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
   NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:NamenwahlString attributes:tempItemAttr];
   [[self.ArchivnamenPop itemAtIndex:0]setAttributedTitle:tempNamenItem];
   
   //SessionListe konfig: vorhandene Namen im ProjektArray mit SessionListe abgleichen
   
   //Sessioleserarray
   NSArray* tempSessionLeserArray=[tempProjektDic objectForKey:@"sessionleserarray"];
   
   //NSLog(@"tempSessionLeserArray 1: %@",[tempSessionLeserArray description]);
   NSEnumerator* NamenEnum=[tempProjektNamenArray objectEnumerator];
   id einName;
   while (einName=[NamenEnum nextObject])
   {
      //NSLog(@"einName: %@",einName);
      [self.ArchivnamenPop addItemWithTitle:einName];
   }
	  
   
   
   
   NSEnumerator* SessionNamenEnum=[tempProjektNamenArray objectEnumerator];//Projektnamen im Archiv
   id einSessionName;
   int ItemIndex=1;
   while (einSessionName=[SessionNamenEnum nextObject])
   {
      //NSLog(@"tempProjektNamenArray index: %d: einSessionName: %@",ItemIndex,einSessionName);
      BOOL NameDa=NO;
      
      
      if (tempSessionLeserArray &&[tempSessionLeserArray containsObject:einSessionName])
      {
         //NSLog(@"Name da: %@",einSessionName);
         NameDa=YES;//Name ist in der Sessionsliste
      }
      
      //		[ArchivnamenPop addItemWithTitle:einSessionName];
      NSColor* itemColor=[NSColor blackColor];
      if (NameDa)
      {
         // itemColor=[NSColor greenColor];
         NSColor* SessionColor=[NSColor colorWithDeviceRed:66.0/255 green:185.0/255 blue:37.0/255 alpha:1.0];
         itemColor=SessionColor;
         
      }
      else
      {
         //			   itemColor=[NSColor blackColor];
      }
      
      NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
      NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:einSessionName attributes:tempItemAttr];
      //		[[ArchivnamenPop itemAtIndex:[ArchivnamenPop numberOfItems]-1]setAttributedTitle:tempNamenItem];
      if ([self.ArchivnamenPop numberOfItems]>2)
      {
         [[self.ArchivnamenPop itemAtIndex:ItemIndex]setAttributedTitle:tempNamenItem];
      }
      
      ItemIndex++;
      /*
       NSString* tempDatum;
       //Pfad des Anmerkungenordners:
       BOOL istOrdner=NO;
       NSString* tempAnmerkungenPfad=[ProjektPfad stringByAppendingPathComponent:[einName stringByAppendingPathComponent:NSLocalizedString(@"Comments",@"Anmerkungen")]];
       if ([Filemanager fileExistsAtPath:tempAnmerkungenPfad isDirectory:&istOrdner]&&istOrdner)
       {
       NSMutableArray* tempAnmerkungenArray=(NSMutableArray*)[Filemanager directoryContentsAtPath:tempAnmerkungenPfad];
       if (tempAnmerkungenArray&&[tempAnmerkungenArray count]>1)//ein Object neben .DS
       {
       NSString* tempAnmerkung=[tempAnmerkungenArray lastObject];//neuste Aufnahme
       tempAnmerkungenPfad=[tempAnmerkungenPfad stringByAppendingPathComponent:tempAnmerkung];
       
       NSString* tempAnmerkungString=[NSString stringWithContentsOfFile:tempAnmerkungenPfad encoding:NSMacOSRomanStringEncoding error:NULL];
       if (tempAnmerkungString&&[tempAnmerkungString length])
       {
       tempDatum = [self DatumVon:tempAnmerkungString];//Datum der neusten Aufnahme des Lesers im Projekt
       //NSLog(@"Projekt: %@ Name: %@ tempDatum: %@",[ProjektPfad lastPathComponent],einName,tempDatum);
       }
       }//if Anmerkungenordner nicht leer
       
       }//if Anmerkungenordner da
       //		  BOOL neu=([tempDatum compare:ProjektSessionDatum]==NSOrderedDescending);
       //		  NSLog(@"ProjektSessionDatum: %@ neu: %d",ProjektSessionDatum,neu);
       //NSLog(@"ProjektSessionDatum: %@",ProjektSessionDatum);
       */
   }//while
   
   //NSLog(@"setArchivnamenPop tempProjektNamenArray: %@",[tempProjektNamenArray description]);
   //	  [ArchivnamenPop addItemsWithTitles:tempProjektNamenArray];
   
   [self.Zeitfeld setSelectable:NO];
//   [RecPlayFenster makeFirstResponder:RecPlayFenster];
   
   
}

- (void)checkSessionDatumFor:(NSString*)dasProjekt
{
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
   if (ProjektIndex<NSNotFound)
   {
      NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
      NSCalendarDate* heute=[NSCalendarDate date];
      int heuteJahr=[heute yearOfCommonEra];
      int heuteTag=[heute dayOfYear];
      //NSLog(@"checkSessionDatumFor: %@  heuteJahr: %d heuteTag: %d",dasProjekt,heuteJahr,heuteTag);
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         NSCalendarDate* SessionDatum=[NSCalendarDate date];
         NSTimeInterval SessionIntervall=[[tempProjektDic objectForKey:@"sessiondatum"]timeIntervalSinceReferenceDate];
         SessionDatum=[NSCalendarDate dateWithTimeIntervalSinceReferenceDate:SessionIntervall];
         
         int SessionTag=[SessionDatum dayOfYear];
         int SessionJahr=[SessionDatum yearOfCommonEra];
         //NSLog(@"checkSessionDatumFor: %@  SessionDatum: %@ SessionTag: %d",dasProjekt,SessionDatum,SessionTag);
         
         //		NSLog(@"SessionInterval: %f		heuteInterval: %f",SessionInterval,heuteInterval);
         //NSLog(@"lastJahr: %d		heuteJahr: %d",SessionJahr,heuteJahr);
         //int heuteTag=[heute dayOfYear];
         if (SessionJahr<heuteJahr)//Datum vom letzten Jahr, Tag des Jahres kann höher sein)
         {
            SessionTag=0;
         }
         //NSLog(@"SessionTag: %d		heute: %d",SessionTag,heuteTag);
         if ([tempProjektDic objectForKey:@"sessionleserarray"]&&[[tempProjektDic objectForKey:@"sessionleserarray"]count])
         {
            if (heuteTag>SessionTag)//letzteSession ist mindestens von gestern
            {
               //NSLog(@"CheckSessionDatum: alte Session");
               NSAlert *Warnung = [[NSAlert alloc] init];
               [Warnung addButtonWithTitle:@"Neue Session"];
               [Warnung addButtonWithTitle:@"Session weiterfuehren"];
               [Warnung setMessageText:[NSString stringWithFormat:@"Neue Session?"]];
               
               NSString* s1=@"Die aktuelle Session ist mehr als einen Tag alt.";
               NSString* s2=@"Wie weiterfahren?";
               NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
               [Warnung setInformativeText:InformationString];
               [Warnung setAlertStyle:NSWarningAlertStyle];
               
               //[Warnung setIcon:RPImage];
               int antwort=[Warnung runModal];
               switch (antwort)
               {
                  case NSAlertFirstButtonReturn://neue Session starten
                  {
                     //NSLog(@"neue Session");
                     [self neueSession:NULL];
                  }break;
                     
                  case NSAlertSecondButtonReturn://alte Session weiterführen
                  {
                     //NSLog(@"Session behalten");
                     heuteTag=SessionTag;
                     SessionDatum=[NSCalendarDate date];
                     [tempProjektDic setObject:[NSCalendarDate date] forKey:@"sessiondatum"];
                     
                  }break;
               }//switch
               
            }
            else
            {
               //NSLog(@"checkSessionDatumFor: aktuelle Session");
               
            }
         }
         else
         {
            [tempProjektDic setObject:[NSCalendarDate date] forKey:@"sessiondatum"];//Sessiondatum aktualisieren
         }
      }//if SessionDatum
      
      
   }//if <NSNotFound
   
   
}


- (IBAction)neueSession:(id)sender
{
   [Utils stopTimeout];
   switch (self.Umgebung)
   {
      case kRecPlayUmgebung:
      {
         if ([self checkAdminZugang])
         {
            NSLog(@"neueSession RecPlay");
            NSFileManager *Filemanager=[NSFileManager defaultManager];
            
            NSMutableDictionary* tempProjektDic;
            int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
            
            if (ProjektIndex<NSNotFound)
            {
               tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
               [tempProjektDic setObject:[NSCalendarDate date] forKey:@"sessiondatum"];
               
               NSLog(@"neueSession: neues ProjektSessionDatum: %@",[NSCalendarDate calendarDate]);
               
               NSArray* tempSessionLeserArray=[tempProjektDic objectForKey:@"sessionleserarray"];
               NSLog(@"alter SessionLeserArray: %@",[tempSessionLeserArray description]);
               
               [tempProjektDic setObject:[NSMutableArray array]forKey:@"sessionleserarray"];
               [self saveSessionDatum:[NSDate date] inProjekt:[self.ProjektPfad lastPathComponent]];
               [self clearSessionInProjekt:[self.ProjektPfad lastPathComponent]];
               
               [self setArchivNamenPop];
            }
         }
         
      }break;
         
      case kAdminUmgebung:
      {
         NSLog(@"neueSession Admin");
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"Neue Session"];
         [Warnung addButtonWithTitle:@"Session weiterfuehren"];
         //	[Warnung addButtonWithTitle:@""];
         //	[Warnung addButtonWithTitle:@"Abbrechen"];
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Neue Session?"]];
         
         NSString* s1=@"Soll die Sessionsliste wirklich geloescht werden?";
         NSString* s2=@"";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         int antwort=[Warnung runModal];
         switch (antwort)
         {
            case NSAlertFirstButtonReturn://
            {
               NSLog(@"Neue Session");
               NSFileManager *Filemanager=[NSFileManager defaultManager];
               
               NSMutableDictionary* tempProjektDic;
               int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
               
               if (ProjektIndex<NSNotFound)
               {
                  tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
                  [tempProjektDic setObject:[NSCalendarDate date] forKey:@"sessiondatum"];
                  
                  NSLog(@"neueSession: neues ProjektSessionDatum: %@",[NSCalendarDate calendarDate]);
                  
                  NSArray* tempSessionLeserArray=[tempProjektDic objectForKey:@"sessionleserarray"];
                  NSLog(@"alter SessionLeserArray: %@",[tempSessionLeserArray description]);
                  
                  [tempProjektDic setObject:[NSMutableArray array]forKey:@"sessionleserarray"];
                  [self saveSessionDatum:[NSDate date] inProjekt:[self.ProjektPfad lastPathComponent]];
                  [self clearSessionInProjekt:[self.ProjektPfad lastPathComponent]];
                  
                  [self setArchivNamenPop];
 //                 [AdminPlayer reportAktualisieren:NULL];
               }
               
               
            }break;
               
            case NSAlertSecondButtonReturn://Session weiterführen
            {
               NSLog(@"Session weiterfuehren");
               [self saveSessionDatum:[NSDate date] inProjekt:[self.ProjektPfad lastPathComponent]];
            }break;
               
         }//switch
         
      }break;
         
   }//switch
}


- (void)SessionListeAktualisieren
{
   NSLog(@"SessionListeAktualisieren  PListDic lesen");
   NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
   if ([tempAktuellePListDic objectForKey:@"projektarray"])
   {
      NSLog(@"SessionListeAktualisieren: Projektarray aus PList: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
      [self.ProjektArray setArray:[[tempAktuellePListDic objectForKey:@"projektarray"]copy]];
      
      //NSLog(@"beginAdminPlayer: Projektarray neu: %@",[[ProjektArray lastObject]description]);
   }
}




- (NSArray*)SessionLeserListeVonProjekt:(NSString*)dasProjekt
{
   NSArray* returnLeserListeArray=[NSArray array];
   //NSLog(@"saveSessionForUser: PList: %@",[PListDic  description]);
   //NSLog(@"SessionListeAktualisierenInProjekt: LeseboxPfad: %@",LeseboxPfad);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   NSLog(@"SessionListeAktualisierenInProjekt PListPfad: %@",PListPfad);
   //NSLog(@"***\n                SessionListeAktualisierenInProjekt: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[tempProjektArray objectAtIndex:ProjektIndex];
            [tempProjektDic setObject:[NSNumber numberWithInt:1] forKey:@"extern"];//Hinweis auf neuen leser
            if ([tempProjektDic objectForKey:@"sessionleserarray"])//SessionLeserArray schon da
            {
               //13.2.07
               return [tempProjektDic objectForKey:@"sessionleserarray"];
            }
            
         }//if <notFound
         //		[ProjektArray setArray:[tempProjektArray copy]];
      }//if projektarray
      
   }//if tempPListDic
   return returnLeserListeArray;
   
}

- (BOOL)anderesProjektEinrichtenMit:(NSString*)dasProjekt
{
   
   self.ProjektPfad=(NSMutableString*)[self.ArchivPfad stringByAppendingPathComponent:dasProjekt];
   //NSLog(@"\n*************								anderesProjektEinrichtenMit: Projekt: %@",dasProjekt);
   //Test, ob bei fixiertem Titel für das Projekt schon eine Titelliste vorhanden ist
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
   
   if (ProjektIndex<NSNotFound)
   {
      NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
      
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         NSCalendarDate* SessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
         
         //NSLog(@"anderesProjektEinrichtenMit: %@  SessionDatum: %@",dasProjekt,SessionDatum);
         if ([SessionDatum compare:[NSCalendarDate calendarDate]]==NSOrderedDescending)
         {
            //NSLog(@"anderesProjektEinrichten: alte Session");
         }
         else
         {
            //NSLog(@"anderesProjektEinrichten: aktuelle Session");
         }
         
      }
      
      int titelfix=[[tempProjektDic objectForKey:@"fix"]intValue];
      //NSLog(@"anderesProjektEinrichtenMit: %@  titelfix: %d",dasProjekt, titelfix);
      if ([tempProjektDic objectForKey:@"titelarray"]&&[[tempProjektDic objectForKey:@"titelarray"]count])
      {
         //NSLog(@"anderesProjektEinrichtenMit: %@  Titelarray: %@",dasProjekt,[[tempProjektDic objectForKey:@"titelarray"] description]);
      }
      else //noch kein titelarray, neues Projekt
      {
         if (titelfix)
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"Titelliste anlegen"];
            [Warnung addButtonWithTitle:@"Fixierung aufheben"];
            //[Warnung addButtonWithTitle:@""];
            // [Warnung addButtonWithTitle:@"Abbrechen"];
            [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Keine Titelliste"]];
            
            NSString* s1=@"Die Titel fuer dieses Projekt sind fixiert.";
            NSString* s2=@"Die Titelliste enthaelt aber noch keine Titel.";
            NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
            [Warnung setInformativeText:InformationString];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            int antwort=[Warnung runModal];
            switch (antwort)//Liste anlegen
            {
               case NSAlertFirstButtonReturn://
               {
                  NSLog(@"NSAlertFirstButtonReturn: Liste anlegen");
                  [self showTitelListe:NULL];
               }break;
                  
               case NSAlertSecondButtonReturn://Fix aufgeben
               {
                  NSLog(@"anderesProjektEinrichtenMit NSAlertSecondButtonReturn: Fixierung aufheben");
                  [tempProjektDic setObject:[NSNumber numberWithInt:0]forKey:@"fix"];
                  //PList aktualisieren
                  
                  NSLog(@"anderesProjektEinrichtenMit  PListDic lesen");
                  NSDictionary* tempAktuellePListDic=[Utils PListDicVon:self.LeseboxPfad aufSystemVolume:NO];
                  if ([tempAktuellePListDic objectForKey:@"projektarray"])//Es hat schon einen ProjektArray
                  {
                     NSMutableArray* tempProjektArray=(NSMutableArray*)[tempAktuellePListDic objectForKey:@"projektarray"];
                     int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
                     
                     if (ProjektIndex < NSNotFound)
                     {
                        //NSLog(@"anderesProjektEinrichtenMit: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                        [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                        //NSLog(@"anderesProjektEinrichtenMit nach reset fix: tempProjektArray objectAtIndex:ProjektIndex: %@",[[tempProjektArray objectAtIndex:ProjektIndex]description]);
                        [self saveTitelFix:NO inProjekt:dasProjekt];
                     }
                     else
                     {
                        NSLog(@"anderesProjektEinrichtenMit  : titelfix: Projekt nicht gefunden");
                     }
                     
                     
                     //NSLog(@"beginAdminPlayer: Projektarray aus PList lastObject: %@",[[[tempAktuellePListDic objectForKey:@"projektarray"]lastObject]description]);
                     //NSLog(@"beginAdminPlayer: Projektarray neu: %@",[[ProjektArray lastObject]description]);
                     
                  }
                  
                  int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:dasProjekt];
                  
                  if (ProjektIndex < NSNotFound)
                  {
                     [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithInt:0] forKey:@"fix"];
                  }
                  
                  
                  
                  
               }break;
               case NSAlertThirdButtonReturn://
               {
                  NSLog(@"NSAlertThirdButtonReturn");
                  
               }break;
               case NSAlertThirdButtonReturn+1://cancel
               {
                  NSLog(@"NSAlertThirdButtonReturn+1");
                  [NSApp stopModalWithCode:0];
          //        [[self window] orderOut:NULL];
                  
               }break;
                  
            }//switch
         }//if titelfix
      }//noch keine Titelliste
      //NSLog(@"anderesProjektEinrichtenMit: tempProjektDic: %@",[tempProjektDic description]);
      if ([tempProjektDic objectForKey:@"mituserpw"])//Mit UserPW
      {
         self.mitUserPasswort=[[tempProjektDic objectForKey:@"mituserpw"]boolValue];
         
      }
      else
      {
         self.mitUserPasswort=YES;
      }
      if (self.mitUserPasswort)
      {
         [self.PWFeld setStringValue:NSLocalizedString(@"With Password",@"Mit Passwort")];
      }
      else
      {
         [self.PWFeld setStringValue:NSLocalizedString(@"Without Password",@"Ohne Passwort")];
      }
      //NSLog(@"anderesProjektEinrichtenMit: Umgbung: %d       tempProjektDic: %@",Umgebung, [tempProjektDic description]);
   }
   //NSLog(@"\n+++++++++\nanderesProjektEinrichtenMit:  ProjektPfad: %@\nUmgebung: %d",ProjektPfad,Umgebung);
   [self setProjektMenu];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:self.ProjektPfad forKey:projektpfad];
   [NotificationDic setObject:self.ProjektPfad forKey:projekt];
   [nc postNotificationName:@"Utils" object:self userInfo:NotificationDic];
   
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   switch (self.Umgebung)
   {
      case kRecPlayUmgebung:
      {
         BOOL NamenListeOK=NO;
         [self resetLesebox:nil];
         [self.ProjektFeld setStringValue:[self.ProjektPfad lastPathComponent]];
         //NSLog(@"                    Umg: RecPlay:        anderesProjektEinrichtenMitProjektPfad: %@",ProjektPfad);
         
         
         NamenListeOK=[self NamenListeValidAnPfad:self.ProjektPfad];
         //NSLog(@"ProjektPfad 4a:retainCount %d",[ProjektPfad retainCount]);
         //NSLog(@"ProjektPfad 4b:retainCount %d",[ProjektPfad retainCount]);
         
         NSString* LeserNamenListe;
         [self.ProjektFeld setStringValue:dasProjekt];
         if ([Filemanager fileExistsAtPath:self.ProjektPfad])
            
         {
            [self setArchivNamenPop];
            [self.Zeitfeld setSelectable:NO];
//            [RecPlayFenster makeFirstResponder:RecPlayFenster];
            
         }//File exists
      }break;//case RecPlay
         
      case kAdminUmgebung:
      {
         //NSLog(@"                Umgebung:	Admin anderesProjektEinrichtenMit:LeseboxPfad: %@   Zu Projekt %@",LeseboxPfad,dasProjekt);
         
         
         
         [self beginAdminPlayer:nil];
         if ([self.AbspielzeitTimer isValid])
         {
            [self.AbspielzeitTimer invalidate];
         }
         /*
          AbspielzeitTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
          target:self
          selector:@selector(Abspieltimerfunktion:)
          userInfo:nil
          repeats:YES];
          */
      }break;
   }//switch Umgebung
   return 0;
}

- (IBAction)showEinzelNamen:(id)sender
{
   [Utils showEinzelNamen:NULL];
   
}
- (IBAction)showNamenListe:(id)sender
{
   if (self.Umgebung==kAdminUmgebung)
   {
      [Utils showNamenListe:sender];
   }
}

- (IBAction)showEinzelNamen
{
   //if (Umgebung==kAdminUmgebung)
   {
      [Utils showEinzelNamen:NULL];
   }
}


- (void) Testknopf:(id)sender
{
}


- (void)savePListAktion:(NSNotification*)note
{
   //NSLog(@"savePListAktion: PList: %@",[PListDic  description]);
   //NSLog(@"savePListAktion adminpw aus PList: %@",[[PListDic objectForKey:@"adminpw"] description]);
   
   //	NSLog(@"savePListAktion projektarray aus PList: %@",[[PListDic objectForKey:@"projektarray"] description]);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (!tempPListDic) //noch keine PList
   {
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
   }
   
   if (tempPListDic)
   {
      if (![tempPListDic objectForKey:@"adminpw"])
      {
         NSString* defaultPWString=@"homer";
         const char* defaultpw=[defaultPWString UTF8String];
         NSData* defaultPWData =[NSData dataWithBytes:defaultpw length:strlen(defaultpw)];
         NSMutableDictionary* tempPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPWDic setObject:@"Admin" forKey:@"name"];
         [tempPWDic setObject: [NSData data] forKey:@"pw"];
         [tempPListDic setObject: tempPWDic forKey:@"adminpw"];
         //NSLog(@"\nsavePListAktion:  Default Eintrag fuer 'pw': %@",[tempPListDic description]);
         //return;
      }
      
      if (![tempPListDic objectForKey:@"lastdate"])
      {
         [tempPListDic setObject: [NSCalendarDate calendarDate] forKey:@"lastdate"];
      }
      
      if (![tempPListDic objectForKey:@"projektarray"])
      {
         
         [tempPListDic setObject: [[NSMutableArray alloc]initWithCapacity:0] forKey:@"projektarray"];
      }
      
      //NSLog(@"savePListAktion ProjektPfad: %@",ProjektPfad);
      if (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"])
      {
         [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
      }
      
      //[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
      
      [tempPListDic setObject:[NSNumber numberWithInt:self.RPModus] forKey:@"modus"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.Umgebung] forKey:@"umgebung"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitAdminPasswort] forKey:@"mitadminpasswort"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitUserPasswort] forKey:@"mituserpasswort"];
      [tempPListDic setObject:self.AdminPasswortDic forKey:@"adminpw"];
      [tempPListDic setObject:[NSNumber numberWithInt:(int)self.TimeoutDelay] forKey:@"timeoutdelay"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.KnackDelay] forKey:@"knackdelay"];
      
      const char* ch=[[self.ProjektPfad lastPathComponent] UTF8String];
      NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
      
      //NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
      //NSLog(@"**savePListAktion: d: %@",d);
      [tempPListDic setObject:d forKey:@"leseboxpfad"];
      
      
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
      BOOL istDirectory=YES;
      if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
      {
         BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
      }
      
      PListPfad=[DataPath stringByAppendingPathComponent:PListName];
      
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      //NSLog(@"***\nsavePListAktion end: %@",[PListDic description]);
      BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      //NSLog(@"\nsavePListAktion: PListOK: %d",PListOK);
      
      
   }//if tempPListDic
   
   //
   return;
   
   
   //	[PListDic setObject: ProjektArray forKey:@"projektarray"];
   
   
   if ([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0)
   {
      NSLog(@"\n\nPListAktion:  Kein Eintrag fuer 'pw': %@",[self.PListDic description]);
      
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      [Warnung addButtonWithTitle:@"Stop"];
      [Warnung setMessageText:@"PList sichern: Kein PList-Eintrag fuer 'pw'"];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      // 31.8.07 Warnung entfernt
      //		int antwort=[Warnung runModal];
      //	if (antwort==1)
      //	{
      //	return;
      //	}
   }
   //[PListDic setObject:AdminPasswortDic forKey:@"adminpw"];
   
   if (note)
   {
      if ([[note userInfo]objectForKey:@"adminpasswort"])
      {
         const char* adminpw=[[[note userInfo]objectForKey:@"adminpasswort"] UTF8String];
         NSData* AdminPWData=[NSData dataWithBytes:adminpw length:strlen(adminpw)];
         [self.PListDic setObject:AdminPWData forKey:@"adminpasswort"];
         self.mitAdminPasswort=YES;
      }//if adminpasswort
      
      if ([[note userInfo]objectForKey:@"userpasswortarray"])
      {
         NSArray* tempUserPasswortArray=[[note userInfo]objectForKey:@"userpasswortarray"];
         
         self.mitUserPasswort=YES;
      }//if userpasswortarray
      
   }
   //const char* ch="ABCD\n";
   //const char* ch=[[[NSNumber numberWithUnsignedLong:'RPDF']stringValue] UTF8String];
   const char* ch=[[self.ProjektPfad lastPathComponent] UTF8String];
   NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
   
   //NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
   //NSLog(@"**savePListAktion: d: %@",d);
   [self.PListDic setObject:d forKey:@"leseboxpfad"];
   
   //NSData decodieren:
   //NSData* dd=[PListDic objectForKey:@"leseboxpfad"];
   //NSLog(@"**savePListAktion decodiert: dd: %@",dd);
   //NSString* tempPfad=  [[NSString alloc] initWithData: dd encoding: NSMacOSRomanStringEncoding];
   //NSLog(@"**savePListAktion: tempPfad nach data: %@",tempPfad);
   
   NSString* tempUserPfad=[self.LeseboxPfad copy];
   //	NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   //	NSString* PListPfad;
   //NSLog(@"savePListAktion: tempUserPfad start: %@  istSystemVolume: %d",tempUserPfad,istSystemVolume);
   if (self.istSystemVolume)
   {
      while(![[tempUserPfad lastPathComponent] isEqualToString:@"Documents"])//Pfad von User finden
      {
         tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
         //NSLog(@"tempUserPfad: %@",tempUserPfad);
      }
      
      
      
      tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Library"];
      tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Preferences"];
      PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];
   }
   //	else //PList in Lesebox
   {
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
      BOOL istDirectory=YES;
      if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
      {
         BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
      }
      
      PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   }
   //NSLog(@"tempUserPfad: %@",tempUserPfad);
   //NSLog(@"***\nsavePListAktion: %@",[PListDic description]);
   BOOL PListOK=[self.PListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"\nsavePListAktion: PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}


- (void)saveSessionDatum:(NSDate*)dasDatum inProjekt:(NSString*)dasProjekt
{
   //NSLog(@"saveSessionForUser: PList: %@",[PListDic  description]);
   //NSLog(@"saveSessionDatum: Datum: %@  LeseboxPfad: %@",dasDatum,LeseboxPfad);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            [[tempProjektArray objectAtIndex:ProjektIndex] setObject:dasDatum forKey:@"sessiondatum"];
         }//if <notFound
      }//if projektarray
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES ];
   //NSLog(@"PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}

- (void)saveNeuenProjektArray:(NSArray*)derProjektArray
{
   NSLog(@"saveNeuenProjektArray");
   //NSLog(@"saveNeuenProjektArray: derProjektArray: %@",[derProjektArray  description]);
   //NSLog(@"saveNeuenProjektArray: ProjektNamen: %@  LeseboxPfad: %@",[[derProjektArray valueForKey:@"projekt"]description],LeseboxPfad);
   
   
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   NSMutableDictionary* tempPListDic;
   
   tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      [tempPListDic setObject:derProjektArray forKey:@"projektarray"];
   }//if tempPListDic
   else
   {
      //31.8.07 Noch keine PList bei Einrichten der neuen LB
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [tempPListDic setObject:derProjektArray forKey:@"projektarray"];
   }
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   NSLog(@"PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}

- (void)saveNeuesProjekt:(NSDictionary*)derProjektDic
{
   NSString* ProjektName=[derProjektDic objectForKey:@"projekt"];
   NSLog(@"				saveNeuesProjekt");
   //NSLog(@"saveNeuesProjekt: derProjektDic: %@",[derProjektDic  description]);
   //NSLog(@"saveNeuesProjekt: ProjektName: %@  LeseboxPfad: %@",ProjektName,LeseboxPfad);
   NSString* ArchivPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"];
   self.ProjektPfad=(NSMutableString*)[ArchivPath stringByAppendingPathComponent:ProjektName];
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      NSLog(@"neue PList");
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"saveNeuesProjekt PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   NSMutableArray* tempProjektArray;
   if (tempPListDic)	//PList schon vorhanden
   {
      NSLog(@"tempPListDic da");
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         //NSLog(@"***	saveNeuesProjekt tempProjektArray: %@",[tempProjektArray description]);
      }//if projektarray
      else
      {
         tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
      }
      int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:ProjektName];
      if (ProjektIndex==NSNotFound)
      {
         [tempProjektArray addObject:[derProjektDic copy]];
      }//if notFound
      else
      {
         //			[tempProjektArray addObject:[derProjektDic copy]];
      }
      [self.ProjektArray addObject:[derProjektDic copy]];
      //NSLog(@"saveNeuesProjekt: ProjektArray nach add: %@",[ProjektArray description]);
      
      BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      NSLog(@"PListOK: %d",PListOK);
      
   }//if tempPListDic
   
   else	//keine PList
   {
      [self.ProjektArray addObject:[derProjektDic copy]];
      
      NSMutableDictionary* tempNeuesProjektDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
      [tempProjektArray addObject:[derProjektDic copy]];
      //NSLog(@"saveNeuesProjekt  tempProjektArray: %@",[tempProjektArray description]);
      [tempNeuesProjektDic setObject:tempProjektArray forKey:@"projektarray"];
      //[tempNeuesProjektDic setObject:ProjektName forKey:@"neuesprojektname"];
      NSLog(@"vor savePList: tempNeuesProjektDic: %@",[tempNeuesProjektDic description]);
      BOOL savePListOK=[self savePList:tempNeuesProjektDic anPfad:self.LeseboxPfad];
      
      NSLog(@"nach savePList: savePListOK: %d",savePListOK);
      
      
      
      
   }
   
   
   
   
   
}

- (void)saveTitelListe:(NSArray*)dieTitelListe inProjekt:(NSString*)dasProjekt
{
   
   NSLog(@"saveTitelListe: dieTitelListe: %@ Projekt: %@",[dieTitelListe  description],dasProjekt);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)//Projekt ist da
         {
            [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[dieTitelListe copy]forKey:@"titelarray"];
         }//if notFound
         else
         {
            
         }
      }//if projektarray
      
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   NSLog(@"PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}


- (void)saveTitelFix:(BOOL)derStatus inProjekt:(NSString*)dasProjekt
{
   
   NSLog(@"saveTitelFix: derStatus: %d Projekt: %@",derStatus ,dasProjekt);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)//Projekt ist da
         {
            [[tempProjektArray objectAtIndex:ProjektIndex]setObject:[NSNumber numberWithBool:derStatus]forKey:@"fix"];
         }//if notFound
         else
         {
            
         }
      }//if projektarray
      
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   NSLog(@"PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}

- (void)saveUserPasswortDic:(NSDictionary*)derPasswortDic
{
   //NSLog(@"saveUserPasswortArray: PasswortDic: %@",[derPasswortDic  description]);
   NSLog(@"saveUserPasswortArray: PasswortDic: %@  LeseboxPfad: %@",[derPasswortDic  description],self.LeseboxPfad);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   NSString* PListPfad;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSString* tempUserName=[derPasswortDic objectForKey:@"name"];
   if (tempUserName &&[tempUserName length])
   {
      NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
      if (tempPListDic)
      {
         NSMutableArray* tempUserPWArray=(NSMutableArray*)[tempPListDic objectForKey:@"userpasswortarray"];
         if (tempUserPWArray)//Array schon da
         {
            int UserIndex=[[tempUserPWArray valueForKey:@"name"]indexOfObject:tempUserName];
            if (UserIndex==NSNotFound)//User hat noch kein pw
            {
               [tempUserPWArray addObject:derPasswortDic];
            }
            else
            {
               [tempUserPWArray replaceObjectAtIndex:UserIndex withObject:derPasswortDic];
            }
         }
         else
         {
            tempUserPWArray=[NSArray arrayWithObject:derPasswortDic];
         }
         [tempPListDic setObject:tempUserPWArray forKey:@"userpasswortarray"];
      }//if tempPListDic
      
      BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      
      NSLog(@"saveUserPasswortArray PListOK: %d",PListOK);
   }//if Username
}

- (void)saveUserPasswortArray:(NSArray*)derPasswortArray
{
   //NSLog(@"saveUserPasswortArray: PasswortArray: %@",[derPasswortArray  description]);
   NSLog(@"saveUserPasswortArray: saveUserPasswortArray: %@  LeseboxPfad: %@",[derPasswortArray  description],self.LeseboxPfad);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   NSString* PListPfad;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      [tempPListDic setObject:derPasswortArray forKey:@"userpasswortarray"];
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   NSLog(@"saveUserPasswortArray PListOK: %d",PListOK);
}


- (void)saveAdminPasswortDic:(NSDictionary*)derPasswortDic
{
   //NSLog(@"saveAdminPasswortDic: PasswortArray: %@",[derPasswortArray  description]);
   NSLog(@"saveAdminPasswortDic: AdminPasswortDic: %@  LeseboxPfad: %@",[derPasswortDic  description],self.LeseboxPfad);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   NSString* PListPfad;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      [tempPListDic setObject:derPasswortDic forKey:@"adminpw"];
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   NSLog(@"saveAdminPasswortDic PListOK: %d",PListOK);
}



- (void)saveSessionForUser:(NSString*)derUser inProjekt:(NSString*)dasProjekt
{
   //NSLog(@"saveSessionForUser: PList: %@",[PListDic  description]);
   //NSLog(@"saveSessionForUser: LeseboxPfad: %@",LeseboxPfad);
   //NSLog(@"saveSessionForUser: derUser: %@ dasProjekt: %@",derUser, dasProjekt);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[tempProjektArray objectAtIndex:ProjektIndex];
            [tempProjektDic setObject:[NSNumber numberWithInt:1] forKey:@"extern"];//Hinweis auf neuen leser
            if ([tempProjektDic objectForKey:@"sessionleserarray"])//SessionLeserArray schon da
            {
               if (![[tempProjektDic objectForKey:@"sessionleserarray"]containsObject:derUser])
               {
                  [[tempProjektDic objectForKey:@"sessionleserarray"]addObject:derUser];
               }
            }
            else
            {
               [tempProjektDic setObject:[NSArray arrayWithObject:derUser] forKey:@"sessionleserarray"];
               
            }
            
            
         }//if <notFound
         //		[ProjektArray setArray:[tempProjektArray copy]];
      }//if projektarray
      
   }//if tempPListDic
   
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
   //NSLog(@"saveSessionForUser  PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}

- (void)clearSessionInProjekt:(NSString*)dasProjekt
{
   //NSLog(@"clearSessionInProjekt: PList: %@",[PListDic  description]);
   NSLog(@"clearSessionInProjekt: LeseboxPfad: %@",self.LeseboxPfad);
   
   
   
   //NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   NSString* PListName=@"Name Lesebox.plist";
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   
   //NSLog(@"PListPfad: %@",PListPfad);
   //NSLog(@"***\n                saveSessionForUser: %@",[PListDic description]);
   
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (tempPListDic)
   {
      
      if ([tempPListDic objectForKey:@"projektarray"])
      {
         NSMutableArray* tempProjektArray=[tempPListDic objectForKey:@"projektarray"];
         int ProjektIndex=[[tempProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
         if (ProjektIndex<NSNotFound)
         {
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[tempProjektArray objectAtIndex:ProjektIndex];
            [tempProjektDic setObject:[NSArray array] forKey:@"sessionleserarray"];
            [tempProjektDic setObject:[NSNumber numberWithInt:0] forKey:@"extern"];
         }//if <notFound
      }//if projektarray
      
   }//if tempPListDic
   
   BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES ];
   //NSLog(@"clearSessioInProjekt   PListOK: %d",PListOK);
   
   //[tempUserInfo release];
}


- (BOOL)savePList:(NSDictionary*)diePList anPfad:(NSString*)derLeseboxPfad
{
   BOOL PListOK=NO;
   NSString* tempUserPfad=[derLeseboxPfad copy];
   NSLog(@"savePList: tempUserPfad start: %@",tempUserPfad);
   
   NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
   
   NSString* PListPfad;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
   BOOL istDirectory=YES;
   if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))
   {
      BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath withIntermediateDirectories:NO attributes:NULL error:NULL];
   }
   PListPfad=[DataPath stringByAppendingPathComponent:PListName];
   //NSLog(@"PListPfad: %@",PListPfad);
   NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
   if (!tempPListDic) //noch keine PList
   {
      NSLog(@"savePList: neue PList anlegen");
      tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
   }
   if (tempPListDic)
   {
      if (![tempPListDic objectForKey:@"adminpw"])
      {
         NSString* defaultPWString=@"homer";
         const char* defaultpw=[defaultPWString UTF8String];
         NSData* defaultPWData =[NSData dataWithBytes:defaultpw length:strlen(defaultpw)];
         NSMutableDictionary* tempPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPWDic setObject:@"Admin" forKey:@"name"];
         [tempPWDic setObject: [NSData data] forKey:@"pw"];
         [tempPListDic setObject: tempPWDic forKey:@"adminpw"];
         //NSLog(@"\nsavePList:  Default Eintrag fuer 'pw': %@",[tempPListDic description]);
         //return;
      }
      
      if (![tempPListDic objectForKey:@"lastdate"])
      {
         [tempPListDic setObject: [NSCalendarDate calendarDate] forKey:@"lastdate"];
      }
      
      if (![tempPListDic objectForKey:@"projektarray"])
      {
         if ([diePList objectForKey:@"projektarray"])
         {
            [tempPListDic setObject:[diePList objectForKey:@"projektarray"] forKey:@"projektarray"];
         }
         else	//leerer array
         {
            [tempPListDic setObject: [[NSMutableArray alloc]initWithCapacity:0] forKey:@"projektarray"];
         }
      }
      
      if (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"])
      {
         [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
      }
      
      //[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
      
      [tempPListDic setObject:[NSNumber numberWithInt:self.RPModus] forKey:@"modus"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.Umgebung] forKey:@"umgebung"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitAdminPasswort] forKey:@"mitadminpasswort"];
      [tempPListDic setObject:[NSNumber numberWithBool:self.mitUserPasswort] forKey:@"mituserpasswort"];
      [tempPListDic setObject:self.AdminPasswortDic forKey:@"adminpw"];
      [tempPListDic setObject:[NSNumber numberWithInt:(int)self.TimeoutDelay] forKey:@"timeoutdelay"];
      [tempPListDic setObject:[NSNumber numberWithInt:self.KnackDelay] forKey:@"knackdelay"];
      
      const char* ch=[[self.ProjektPfad lastPathComponent] UTF8String];
      NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
      
      //NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
      //NSLog(@"**savePListAktion: d: %@",d);
      [tempPListDic setObject:d forKey:@"leseboxpfad"];
      
      
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      
      //NSLog(@"tempUserPfad: %@",tempUserPfad);
      NSLog(@"***\nsavePListAktion: %@",[self.PListDic description]);
      PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
      NSLog(@"\nsavePList: PListOK: %d",PListOK);
      
      
   }
   
   NSLog(@"savePList   PListOK: %d",PListOK);
   return PListOK;
   
}

- (BOOL)checkAdminZugang
{
   BOOL ZugangOK=NO;
   //NSLog(@"checkAdminZugang: mitAdminPasswort: %d",mitAdminPasswort);
   if (self.mitAdminPasswort)
   {
      NSMutableDictionary* tempAdminPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      if ((![self.PListDic objectForKey:@"adminpw"])||([[[self.PListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0))//kein Eintrag da
      {
         NSLog(@"kein Eintrag");
         [tempAdminPWDic setObject:@"Admin" forKey:@"name"];
         [tempAdminPWDic setObject:[NSData data] forKey:@"pw"];
      }
      else
      {
         tempAdminPWDic=[self.PListDic objectForKey:@"adminpw"];
         //NSLog(@"Eintrag da: %@",[tempAdminPWDic description]);
      }
      
      
      NSData* tempPWData=[tempAdminPWDic objectForKey:@"pw"];
      if ([tempPWData length])//Passwort existiert
      {
         //NSLog(@"checkAdminZugang: Passwort abfragen");
         ZugangOK=[Utils confirmPasswort:[tempAdminPWDic copy]];
      }
      else//keinPasswort
      {
         //NSLog(@"checkAdminZugang pw="": neues Passwort eingeben");
         NSDictionary* tempNeuesPWDic=[Utils changePasswort:[tempAdminPWDic copy]];
         NSLog(@"checkAdminZugang tempNeuesPWDic: %@",[tempNeuesPWDic description]);
         if ([[tempNeuesPWDic objectForKey:@"pw"]length])//neues PW ist da
         {
            //NSLog(@"tempNeuesPWDic: %@",[tempNeuesPWDic description]);
            //[PListDic setObject:AdminPasswortDic forKey:@"adminpw"];
            [self.PListDic setObject:[tempNeuesPWDic copy] forKey:@"adminpw"];
            //Passwort in PList sichern
            NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
            NSString* PListPfad;
            NSFileManager *Filemanager=[NSFileManager defaultManager];
            NSString* DataPath=[self.LeseboxPfad stringByAppendingPathComponent:@"Data"];
            BOOL istDirectory=YES;
            if(!([Filemanager fileExistsAtPath:DataPath isDirectory:&istDirectory]&&istDirectory))//Ordner Data schon da?
            {
               BOOL DataOK=[Filemanager createDirectoryAtPath:DataPath  withIntermediateDirectories:NO attributes:NULL error:NULL];//Ordner Data einrichten
            }
            
            PListPfad=[DataPath stringByAppendingPathComponent:PListName];
            
            //NSLog(@"checkAdminZugang: PListPfad: %@",PListPfad);
            NSMutableDictionary* tempPListDic;
            if ([Filemanager fileExistsAtPath:PListPfad])
            {
               //PList holen
               NSLog(@"PList holen");
               tempPListDic=[[NSMutableDictionary alloc]initWithContentsOfFile:PListPfad];
            }
            else
            {
               NSLog(@"neue PList");
               tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
               NSLog(@"neue PList geholt");
            }
            
            NSLog(@"checkAdminZugang: tempPListDic: %@",[tempPListDic description]);
            
            if (tempPListDic)
            {
               NSLog(@"neue PList existiert");
               [tempPListDic setObject: tempNeuesPWDic forKey:@"adminpw"];
               
               if (![tempPListDic objectForKey:@"lastdate"])
               {
                  [tempPListDic setObject: [NSCalendarDate calendarDate] forKey:@"lastdate"];
               }
               NSLog(@"checkAdminZugang: tempPListDic mit lastDate: %@",[tempPListDic description]);
               
               if (![[self.ProjektPfad lastPathComponent]isEqualToString:@"Archiv"])
               {
                  [tempPListDic setObject: [self.ProjektPfad lastPathComponent] forKey:@"lastprojekt"];
               }
               NSLog(@"checkAdminZugang: tempPListDic mit lastProjekt: %@",[tempPListDic description]);
               
               //aus savePListAktion:
               //	[tempPListDic setObject:[NSNumber numberWithBool:busy] forKey:@"busy"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:RPModus] forKey:@"modus"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:Umgebung] forKey:@"umgebung"];
               //	[tempPListDic setObject:[NSNumber numberWithBool:mitAdminPasswort] forKey:@"mitadminpasswort"];
               //	[tempPListDic setObject:[NSNumber numberWithBool:mitUserPasswort] forKey:@"mituserpasswort"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:(int)TimeoutDelay] forKey:@"timeoutdelay"];
               //	[tempPListDic setObject:[NSNumber numberWithInt:KnackDelay] forKey:@"knackdelay"];
               
               //	const char* ch=[[ProjektPfad lastPathComponent] UTF8String];
               //	NSData* d=[NSData dataWithBytes:ch length:strlen(ch)];
               
               //	NSData* d=[NSData dataWithBytes:LeseboxPfad length:[LeseboxPfad length]];
               //	NSLog(@"**savePListAktion: d: %@",d);
               //	[tempPListDic setObject:d forKey:@"leseboxpfad"];
               
               
               
               //NSLog(@"tempUserPfad: %@",tempUserPfad);
               //NSLog(@"***\ncheckAdminZugang tempPListDic: %@",[tempPListDic description]);
               BOOL PListOK=[tempPListDic writeToFile:PListPfad atomically:YES];
               //NSLog(@"\nsavePListAktion: PListOK: %d",PListOK);
               
               
            }
            
            
            
            // ende PList sichern
            
            self.AdminPasswortDic =[tempNeuesPWDic copy];
            
            //NSLog(@"PListDic in checkAdminZugang: %@",[PListDic description]);
            ZugangOK=YES;
         }
         else
         {
            //NSLog(@"checkAdminZugang: neues Passwort misslungen");
            //neues PW misslungen
         }
      }
      
      
   }//mitAdminPasswort
   else
   {
      ZugangOK=YES;
   }
   
   return ZugangOK;
}

- (void)showChangePasswort:(id)sender
{
   switch (self.Umgebung)
   {
      case kRecPlayUmgebung:
      {
         if ([self.Leser length])
         {
            NSLog(@"changepasswort von RecPlayUmgebung");
            [Utils stopTimeout];
            BOOL PasswortOK=NO;
            NSData* tempPWData=[NSData data];
            NSEnumerator* PWEnum=[self.UserPasswortArray objectEnumerator];//vorhandenen PWDics
            id einNamenDic;
            int index=0;
            int position=-1;
            while(einNamenDic=[PWEnum nextObject])
            {
               if ([[einNamenDic objectForKey:@"name"]isEqualToString:self.Leser])
               {
                  if (position<0)//erstes Auftreten
                  {
                     tempPWData=[einNamenDic objectForKey:@"pw"];
                     position=index;
                  }
               }//if
               index++;
            }//while einNamenDic
            //const char* altespw=[@"anna" UTF8String];
            //tempPWData =[NSData dataWithBytes:altespw length:strlen(altespw)];
            
            NSMutableDictionary* tempPWDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
            [tempPWDictionary setObject:self.Leser forKey:@"name"];
            [tempPWDictionary setObject:tempPWData forKey:@"pw"];
            
            //NSLog(@"setLeser RecPlay	tempPWDictionary: %@",[tempPWDictionary description]);
            NSDictionary* neuesPWDic=[Utils changePasswort:[tempPWDictionary copy]];
            //NSLog(@"showChangePasswort:		neuesPWDic: %@",[neuesPWDic description]);
            if ([neuesPWDic count]&&!(position<=0))
            {
               PasswortOK=YES;
               //NSLog(@"Passwort ersetzen");
               [self.UserPasswortArray replaceObjectAtIndex:position withObject:neuesPWDic];
               
               
            }
            
            [self saveUserPasswortDic:neuesPWDic];
            
            
            
            [Utils startTimeout:self.TimeoutDelay];
            if(!PasswortOK)
            {
               return;
            }
         }//if leser
      }break;
      case kAdminUmgebung:
      {
         //NSMutableDictionary* tempPWDictionary=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         //[tempPWDictionary setObject:@"Admin" forKey:@"name"];
         //[tempPWDictionary setObject:AdminPasswortData forKey:@"pw"];
         //NSDictionary* neuesPWDic=[Utils changePasswort:AdminPasswortDic];
         NSDictionary* neuesPWDic=[Utils changePasswort:[[self.PListDic objectForKey:@"adminpw"]copy]];
         NSLog(@"neues admin PWDic: %@",[neuesPWDic description]);
         //if ([neuesPWDic count])
         if (neuesPWDic)
         {
            [self.AdminPasswortDic setDictionary:neuesPWDic];
            [self.PListDic setObject:neuesPWDic forKey:@"adminpw"];
            [self saveAdminPasswortDic:neuesPWDic];
         }
         
      }//break;//file://localhost/Users/sysadmin/Desktop/RecPlayVII.app/
   }//switch
}

- (void)showChangeAdminPasswort:(id)sender
{
   
   //NSDictionary* neuesPWDic=[Utils changePasswort:AdminPasswortDic];
   NSDictionary* neuesPWDic=[Utils changePasswort:[[self.PListDic objectForKey:@"adminpw"]copy]];
   NSLog(@"neues admin PWDic: %@",[neuesPWDic description]);
   if (neuesPWDic)
   {
      [self.AdminPasswortDic setDictionary:neuesPWDic];
      [self.PListDic setObject:neuesPWDic forKey:@"adminpw"];
      [self saveAdminPasswortDic:neuesPWDic];
   }
   
}


- (IBAction)showPasswortListe:(id)sender
{
   //NSLog(@"showPasswortListe");
   if (!self.PasswortListePanel)
	  {
        self.PasswortListePanel=[[rPasswortListe alloc]init];
     }
   
   //[ProjektPanel showWindow:self];
   NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[self.PasswortListePanel window]];
   
   if ([self.UserPasswortArray count])
   {
      [self.PasswortListePanel setPasswortArray:self.UserPasswortArray];
   }
   int modalAntwort = [NSApp runModalForWindow:[self.PasswortListePanel window]];
   //NSLog(@"showPasswortliste Antwort: %d",modalAntwort);
   [NSApp endModalSession:PasswortSession];
   if (modalAntwort==1)//OK gedrückt
   {
      [self.UserPasswortArray setArray:[[self.PasswortListePanel PasswortArray]mutableCopy]];
      [self saveUserPasswortArray:[self.PasswortListePanel PasswortArray]];
   }
   //NSLog(@"UserPasswortArray nach change: %@",[UserPasswortArray description]);
   
}



- (IBAction)showTitelListe:(id)sender
{
   //NSLog(@"\n\n\n										showTitelListe\n");
   if (!self.TitelListePanel)
   {
      self.TitelListePanel=[[rTitelListe alloc]init];
   }
   //NSLog(@"showTitelliste Start  Projekt: %@: ProjektArray: %@",[ProjektPfad lastPathComponent],[ProjektArray description]);
   
   //ProjektArray aktualisieren mitneuen Werten aus aktueller PList
   [self.ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:self.LeseboxPfad]];
   NSLog(@"showTitelListe: ProjektArray: %@",[self.ProjektArray description]);
   NSModalSession TitelSession=[NSApp beginModalSessionForWindow:[self.TitelListePanel window]];
   
   NSArray* tempProjektNamenArray;
   
   tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];
   
   //	Projektarray aus PList
   //	tempProjektNamenArray=[[[Utils PListDicVon:LeseboxPfad aufSystemVolume:NO]objectForKey:@"projektarray"] valueForKey:@"projekt"];
   if (tempProjektNamenArray)
   {
      
      int ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];
      
      NSArray* tempTitelArray;
      
      if (!(ProjektIndex==NSNotFound))
      {
         
         tempTitelArray=[[self.ProjektArray objectAtIndex:ProjektIndex]objectForKey:@"titelarray"];
         
         {
            //NSLog(@"showTitelListe:index: %d tempTitelArray: %@",ProjektIndex,[tempTitelArray description]);
            
            [self.TitelListePanel setTitelArray:tempTitelArray  inProjekt:[self.ProjektPfad lastPathComponent]];
            
            //NSLog(@"showTitelliste nach  setTitelArray Projekt: %@:  ProjektArray: %@",[ProjektPfad lastPathComponent],[ProjektArray description]);
         }
      }//if [ProjektArray valueForKey:@"projekt"]
      
   }//if tempProjektNamenArray
   int modalAntwort = [NSApp runModalForWindow:[self.TitelListePanel window]];
   
   //Rückmeldung durch Notifikation
   
   
   //NSLog(@"showTitelListe Antwort: %d",modalAntwort);
   [NSApp endModalSession:TitelSession];
   
   
}


- (void)TitelListeAktion:(NSNotification*)note
{
   //NSLog(@"\n\n\n			TitelListeAktion ProjektPfad: %@",ProjektPfad);
   //NSLog(@"TitellisteAktion: ProjektArray Anfang: %@",[ProjektArray description]);
   
   if ([[note userInfo] objectForKey:@"fix"])
   {
      //NSLog(@"TitelListeAktion: fix: %d",[[[note userInfo] objectForKey:@"fix"]intValue]);
      
   }
   
   if ([[note userInfo] objectForKey:@"titelarray"])
   {
      NSLog(@"TitelListeAktion: TitelArray: %@",[[[note userInfo] objectForKey:@"titelarray"]description]);
      NSArray* tempTitelArray=[[[note userInfo] objectForKey:@"titelarray"]copy];
      
      NSArray* tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];//Liste der Projektnamen
      //NSLog(@"tempProjektNamenArray: %@",[tempProjektNamenArray description]);
      
      int ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];
      //NSLog(@"ProjektIndex: %d",ProjektIndex);
      if (!(ProjektIndex==NSNotFound))
         
      {
         //NSLog(@"TitelListeAktion: Projekt ist da: %@ ",[ProjektPfad lastPathComponent]);
         NSDictionary* tempDic=[self.ProjektArray objectAtIndex:ProjektIndex];
         //NSLog(@"tempDic: %@",[tempDic description]);
         [[self.ProjektArray objectAtIndex:ProjektIndex]setObject:tempTitelArray forKey:@"titelarray"];
      }
      
      [self saveTitelListe:tempTitelArray inProjekt:[self.ProjektPfad lastPathComponent]];
      
      //NSLog(@"TitellisteAktion: ProjektArray Schluss: %@",[ProjektArray description]);
   }
   else
   {
      NSLog(@"TitellisteAktion: noch kein Titelarray");
   }
   
   
}

- (void)stopTimeout
{
   
}

- (void)TimeoutAktion:(NSNotification*)note
{
   NSLog(@"TimeoutAktion");
   if ([[note userInfo]objectForKey:@"abmelden"])
   {
      int  AbmeldenCode=[[[note userInfo]objectForKey:@"abmelden"]intValue];
      NSLog(@"TimeoutAktion: AbmeldenCode: %d",AbmeldenCode);
      switch (AbmeldenCode)
      {
         case 2://Retten
         {
            NSArray* FehlerArray=[self AufnahmeRetten];
            [Utils stopTimeout];
            [self resetRecPlay];
            
         }break;
            
         case 1://Sichern und abmelden
         {
            [self saveRecord:NULL];
            [self resetRecPlay];
            [Utils stopTimeout];
         }break;
            
         case 0://Timeout abbrechen
         {
            [Utils startTimeout:self.TimeoutDelay];
         }break;
      }//switch
   }
}


- (void)SaveKommentarAktion:(NSNotification*)note
{
   NSLog(@"SaveKommentarAktion");
   
   if ([[note userInfo]objectForKey:@"druckview"])
   {
      NSTextView* SaveView=[[note userInfo]objectForKey:@"druckview"];
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      
      // Grab an instance of the global Save Panel:
      NSSavePanel *savePanel = [NSSavePanel savePanel];
      
      // save the text in an rtfd file wrapper
      [savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"doc",nil]];
      
      // run the save panel modally to get the filename
      //NSString* tempSavePfad=@"/users/sysadmin/documents/Lesebox";
      if ([savePanel runModal ])//ForDirectory:LeseboxPfad file:NSLocalizedString(@"Comments.doc",@"Anmerkungen.doc")])
      {
         BOOL RemoveOK=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:[self.LeseboxPfad stringByAppendingPathComponent:NSLocalizedString(@"Comments.doc",@"Anmerkungen.doc")]]error:nil];
         // the text object knows how to save itself:
         //NSData* DataToSave=[DruckView RTFFromRange:NSMakeRange(0,[[DruckView textStorage] length])];
         //[DataToSave writeToFile:[[savePanel filename]stringByAppendingPathComponent:@"Kommentar.doc"]  atomically:YES];
         //[DruckView writeRTFDToFile:[savePanel filename]  atomically:YES];
         //NSLog(@"[savePanel filename]: %@, RemoveOK: %d",[savePanel filename],RemoveOK);
         NSString* Pfad=[[savePanel URL]path];
         NSRange SaveRange=NSMakeRange(0,[[SaveView textStorage] length]);
         [[SaveView RTFFromRange:SaveRange] writeToFile:Pfad  atomically:YES];
         //[DruckView writeRTFDToFile:Pfad  atomically:YES];
      }
   }
}

- (IBAction)KommentarSichern:(id)sender
{
   NSLog(@"RecplayController: KommentarSichern");
   //[AdminPlayer SaveKommentarVonProjekt:[ProjektPfad lastPathComponent]];
//*   [self.AdminPlayer KommentarSichern];
}

- (void)LevelmeterAktion:(NSNotification*)note
{
   NSLog(@"LevelmeterAktion");
   
   if ([[note userInfo]objectForKey:@"level"])
   {
      NSNumber* LevelNumber=[[note userInfo]objectForKey:@"level"];
      int Level=[LevelNumber intValue];
      //NSLog(@"Level: %D",Level);
      [self.Levelmeter setLevel:Level];
   }
}

- (void)BeendenAktion:(NSNotification*)note
{
   
   BOOL OK=[self beenden];
   //NSLog(@"windowShouldClose");
   if (OK)
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      [NSApp terminate:self];
      
   }
   
}

-(IBAction)terminate:(id)sender
{
   BOOL OK=[self beenden];
   NSLog(@"terminate");
   if (OK)
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      [NSApp terminate:self];
      
   }
   
}



- (BOOL)beenden
{
   //BOOL setVersionOK=[Utils setVersion];
   [self savePListAktion:nil];
   [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
   BOOL BeendenOK=YES;
   /*
    if ([[RecordQTKitPlayer movie]rate])
      [self stopPlay:nil];
   
   if ([AufnahmeGrabber isRecording])
   {
      NSAlert *RecorderWarnung = [[[NSAlert alloc] init] autorelease];
      [RecorderWarnung addButtonWithTitle:@"OK"];
      //[RecorderWarnung addButtonWithTitle:@"Cancel"];
      [RecorderWarnung setMessageText:NSLocalizedString(@"Still Recording",@"Aufnahme läuft")];
      [RecorderWarnung setInformativeText:NSLocalizedString(@"The window cannot be closed.",@"Fenster kann nicht geschlossen werden.")];
      [RecorderWarnung setAlertStyle:NSWarningAlertStyle];
      
      //[alert beginSheetModalForWindow:[searchField window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
      [RecorderWarnung beginSheetModalForWindow:RecPlayFenster 
                                  modalDelegate:nil
                                 didEndSelector:nil
                                    contextInfo:nil];
      BeendenOK=NO;
   }//is recording
   
   
   
   if (AufnahmeGrabber)
   {
      //[self saveSettings:NULL];
      NSLog(@"Grabber lauft noch");
      [AufnahmeGrabber stopRecord];
      if (neueSettings)
      {
         [self saveSettings:NULL];
      }
      [AufnahmeGrabber GrabberSchliessen];
      //[self saveSettings:NULL];
   }
    */
   //NSLog(@"AufnahmeGrabber retain: %d",[AufnahmeGrabber retainCount]);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"neueAufnahmepfad: %@",neueAufnahmePfad);
   if (self.neueAufnahmePfad)
   {
      BOOL sauberOK=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:self.neueAufnahmePfad] error:nil];
      return BeendenOK;
   }
   return BeendenOK;
}

- (BOOL)windowShouldClose:(id)sender
{
   BOOL OK=[self beenden];
   //NSLog(@"windowShouldClose");
   if (OK)
   {
      [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
      
      [NSApp terminate:self];
      
   }
   return OK;
}

- (IBAction)print:(id)sender
{
   //NSLog (@"RecPlayController print");
   //[AdminPlayer KommentarDruckenVonProjekt: [ProjektPfad lastPathComponent]];
//*   [self.AdminPlayer KommentarDrucken];
   
   return;
}


- (IBAction)ArchivaufnahmeInPlayer:(id)sender
{
   self.ArchivPlayerGeladen=YES;
   [self.ArchivInListeTaste setEnabled:YES];
   [self.ArchivInPlayerTaste setEnabled:NO];
   //[ArchivPlayTaste setEnabled:YES];
   [self resetArchivPlayer:nil];
   
   //sofort abspielen
   [self startArchivPlayer:nil];
   
   [self.ArchivPlayTaste setEnabled:YES];
//   BOOL erfolg=[RecPlayFenster makeFirstResponder:ArchivInListeTaste];
   [self.ArchivInListeTaste setKeyEquivalent:@"\r"];
   [Utils stopTimeout];
   [self.UserMarkCheckbox setEnabled:YES];
   
}

- (IBAction)ArchivZurListe:(id)sender
{
   //NSLog(@"ArchivZurListe");
   self.ArchivPlayerGeladen=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"ArchivZurListe: ArchivKommentarPfad: %@",ArchivKommentarPfad);
   if ([Filemanager fileExistsAtPath:self.ArchivKommentarPfad])
			{
            //NSLog(@"vor saveUserMarkFuerAufnahmePfad: UserMarkCheckbox: %d",[UserMarkCheckbox state]);
            [self saveUserMarkFuerAufnahmePfad:self.ArchivKommentarPfad];
            //NSLog(@"nach saveUserMarkFuerAufnahmePfad");
            
         }
   
   [self resetArchivPlayer:nil];
   
   [self.ArchivInListeTaste setEnabled:NO];
   [self.ArchivInListeTaste setKeyEquivalent:@""];
   [self.ArchivInPlayerTaste setEnabled:YES];
   [self.ArchivPlayTaste setEnabled:NO];
   [self.ArchivStopTaste setEnabled:NO];
   [self.ArchivZumStartTaste setEnabled:NO];
   //NSLog(@"reset UserMarkCheckbox");
   [self.UserMarkCheckbox setState:NO];
   [self.UserMarkCheckbox setEnabled:NO];
   
   [self clearArchivKommentar];
//   int	erfolg=[RecPlayFenster makeFirstResponder:ArchivView];
   
   [Utils startTimeout:self.TimeoutDelay];
   
}

- (IBAction)reportUserMark:(id)sender
{
   
}

- (void)saveUserMarkFuerAufnahmePfad:(NSString*)derAufnahmePfad
{
   NSMutableString* tempKommentarString=[[NSString stringWithContentsOfFile:derAufnahmePfad encoding:NSMacOSRomanStringEncoding error:NULL]mutableCopy];
   if (tempKommentarString)
   {
      NSMutableArray* tempMarkArray=(NSMutableArray*)[tempKommentarString componentsSeparatedByString:@"\r"];
      //NSLog(@"tempMarkArray: %@ UserMarkCheckbox state: %d",[tempMarkArray description],[UserMarkCheckbox state]);
      NSNumber* MarkNumber =[NSNumber numberWithBool:[self.UserMarkCheckbox state]];
      if ([tempMarkArray count]==8)//Zeile für Mark  ist da
      {
         //NSLog(@"UserMark Hier? %@",[MarkNumber stringValue]);
         [tempMarkArray replaceObjectAtIndex:UserMark withObject:[MarkNumber stringValue]];
         //NSLog(@"tempMarkArray neu: %@",[tempMarkArray description]);
         
         //[tempKommentarString setString:[tempMarkArray componentsJoinedByString:@"\r"]];
         
      }
      else if([tempMarkArray count]==6)//Zeile für Mark  ist nicht da
      {
         [tempMarkArray insertObject:[MarkNumber stringValue] atIndex:UserMarkReturn];
      }
      [tempKommentarString setString:[tempMarkArray componentsJoinedByString:@"\r"]];
      //NSLog(@"saveUserMarkFuerAufnahmePfad: tempKommentarString: %@",tempKommentarString);
      [tempKommentarString writeToFile:derAufnahmePfad atomically:YES encoding:NSMacOSRomanStringEncoding error:NULL];
   }
}


- (void) VolumesAktion:(NSNotification*)note
{
   //NSLog(@"VolumesAktion");
   NSNumber* n=[[note userInfo]objectForKey:@"LeseboxDa"];
   self.LeseboxDa=[n boolValue];
   if ([n intValue]==0)//Abbrechen
   {
      //NSLog(@"VolumesAktion: number=0 %d   ",[n intValue]);
      //Beenden
      NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
      NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
      [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
   }
   //NSLog(@"VolumesAktion: number %d   ",[n intValue]);
}

- (IBAction)PrefsLesen:(id)sender
{
   NSNumber* Testnummer;
   Testnummer=[[NSUserDefaults standardUserDefaults]objectForKey:Wert1Key];
   self.Wert1=[Testnummer intValue];
   //[Levelfeld setIntValue:Wert1];
   //NSLog(@"Prefs lesen Wert 1: %d",Wert1);
   Testnummer=[[NSUserDefaults standardUserDefaults]objectForKey:Wert2Key];
   self.Wert2=[Testnummer intValue];
   //NSLog(@"Prefs lesen Wert 2: %d",Wert2);
   [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.Wert1+2] forKey:Wert2Key];
   self.Wert1=[[[NSUserDefaults standardUserDefaults]objectForKey:Wert2Key]intValue];
   //NSLog(@"Prefs lesen:Wert1 nach: %d",Wert1);
   [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:self.Wert1] forKey:Wert1Key];
   
   self.RPDevicedaten=[[NSUserDefaults standardUserDefaults]objectForKey:RPDevicedatenKey];
   //int l=[RPDevicedaten length];
   //NSLog(@"Prefs lesen: Länge Devicedaten: %d",l);
   
}
- (IBAction)PrefsSchreiben:(id)sender
{
   //Wert1=[Levelfeld intValue];
   //NSLog(@"Prefs schreiben neuer Wert 1: %d",Wert1);
   [[NSUserDefaults standardUserDefaults]setInteger: self.Wert1 forKey: Wert1Key];
   
   //Wert2+=10;
   //NSLog(@"Prefs schreiben neuer Wert 2: %d",Wert2);
   //RPModus=1;
   
   short l=[self.RPDevicedaten length];
   //NSLog(@"Prefs schreiben: Länge Devicedaten: %ddata: %@",l,[RPDevicedaten description]);
   //NSString * datenstring=[RPDevicedaten description];
   //int n,sum=0;   //Summe der unicode-chars bestimmen
   //for (n=0;n<l;n++)
   //	sum+=[datenstring characterAtIndex:n];
   //NSLog(@"Prefs schreiben: Länge Devicedaten: %d  summe: %d",l,sum);
   if(l>0)
   {
      [[NSUserDefaults standardUserDefaults]setObject:self.RPDevicedaten forKey:RPDevicedatenKey];
   }
   [[NSUserDefaults standardUserDefaults]synchronize];
   
   return;
   
   
   
   //NSLog(@"Gesicherte Prefs lesen: %d",ii);
}

- (void)setRecPlay
{
   [self Aufnahmevorbereiten];
   
   if ([self.timer isValid])
   {
      [self.timer invalidate];
   }
   
   
   if ([self.AufnahmezeitTimer isValid])
   {
      [self.AufnahmezeitTimer invalidate];
   }
   /*
    AufnahmezeitTimer=[NSTimer scheduledTimerWithTimeInterval:1.0
    target:self
    selector:@selector(setAufnahmetimerfunktion:)
    userInfo:nil
    repeats:YES];
    */
   /*
    if ([AbspielzeitTimer isValid])
    {
    [AbspielzeitTimer invalidate];
    }
    */
   /*
    AbspielzeitTimer=[NSTimer scheduledTimerWithTimeInterval:0.1
    target:self
    selector:@selector(Abspieltimerfunktion:)
    userInfo:nil
    repeats:YES];
    */
   NSFont* Lesernamenfont;
   Lesernamenfont=[NSFont fontWithName:@"Helvetica" size: 20];
   NSColor * LesernamenFarbe=[NSColor whiteColor];
   [self.Leserfeld setFont: Lesernamenfont];
   [self.Leserfeld setTextColor: LesernamenFarbe];
   
//*   [RecPlayFenster setIsVisible:YES];
   //[Leserfeld setBackgroundColor:[NSColor lightGrayColor]];
   //NSImage* StartRecordImg=[[NSImage alloc]initWithContentsOfFile:@"StartPlayImg.tif"];
   NSImage* StartRecordImg=[NSImage imageNamed:@"StartRecordImg.tif"];
   [[self.StartRecordKnopf cell]setImage:StartRecordImg];
   NSImage* StopRecordImg=[NSImage imageNamed:@"StopRecordImg.tif"];
   [[self.StopRecordKnopf cell]setImage:StopRecordImg];
   
   [[self.StartStopKnopf cell]setImage:StartRecordImg];
   [self.StartStopString setStringValue:@"START"];
   NSImage* StartPlayImg=[NSImage imageNamed:@"StartPlayImg.tif"];
   [[self.StartPlayKnopf cell]setImage:StartPlayImg];
   NSImage* StopPlayImg=[NSImage imageNamed:@"StopPlayImg.tif"];
   [[self.StopPlayKnopf cell]setImage:StopPlayImg];
   NSImage* BackImg=[NSImage imageNamed:@"Back.tif"];
   [[self.BackKnopf cell]setImage:BackImg];
   
   [self.RecPlayTab setDelegate:self];
   [self.RecPlayTab selectFirstTabViewItem:nil];
   self.ArchivView=[[rArchivDS alloc]initWithRowCount:0];
   [self.ArchivView setDelegate: self.ArchivDaten];
   [self.ArchivView setDataSource: self.ArchivDaten];
   //NSLog(@"setRecPlay:	mitUserPasswort: %d",mitUserPasswort);
   if (self.mitUserPasswort)
   {
      [self.PWFeld setStringValue:NSLocalizedString(@"With Password",@"Mit Passwort")];
   }
   else
   {
      [self.PWFeld setStringValue:NSLocalizedString(@"Without Password",@"Ohne Passwort")];
   }
   
}



- (IBAction)ReadDeviceEinstellungen:(id)sender
{
   OSErr err=0;
   /*
   Handle RecordereinstellungenHandle;
   UserData Einstellungsdaten;
   RecordereinstellungenHandle=NewHandle(0);
   err=MemError();
   if (err)
   {
      NSLog(@"ReadDeviceEinstellungen: MemErr nach NewHandle:%d",err);;
   }
   //	*RecordereinstellungenHandle=*(Recorder->GetEinstellungen());
   
   HLock(RecordereinstellungenHandle);
   long l=GetHandleSize(RecordereinstellungenHandle);
   //NSLog(@"GetHandleSize(RecordereinstellungenH): %d",l);
   RPDevicedaten=[NSData dataWithBytes:(UInt8*)*RecordereinstellungenHandle length: l];
   l=[RPDevicedaten length];
   //NSLog(@"Controller: err nach GetEinstellungen Fehler: %d Laenge: %d\n ", err,l);
   //	NSLog(@"************************GetEinstellungen: Devicedaten: %@",[RPDevicedaten description]);
   
   HUnlock(RecordereinstellungenHandle);
   DisposeHandle(RecordereinstellungenHandle);
   
   //[self PrefsSchreiben];
    */
}

- (void)SettingsAktion
{
   //[self GetEinstellungen:nil];
}

- (IBAction)WriteDeviceEinstellungen:(id)sender
{
   Handle RecordereinstellungenHandle;
   RecordereinstellungenHandle=NewHandle(0);
   OSErr err=0;
   int l=[self.RPDevicedaten length];
   //NSLog(@"--------------		SetEinstellungen: Devicedaten: %@",[RPDevicedaten description]);
   HLock(RecordereinstellungenHandle);
   err=PtrToHand([self.RPDevicedaten bytes],&RecordereinstellungenHandle,l);
   l=0;
   l=GetHandleSize(RecordereinstellungenHandle);
   //NSLog(@"GetHandleSize(Recordereinstellungen): %d",l);
   //err=Recorder->SetEinstellungen(	RecordereinstellungenHandle);
   HUnlock(RecordereinstellungenHandle);
   
   //NSLog(@"Controller: err bei SetEinstellungen: %d ", err);
   if (err)
	  {
        //err=Recorder->EinstellungenDialog();
        if (err)
        {
           NSLog(@"Fehler mit EinstellungenDialog ");
           return;
        }
        
     }
   //[self PrefsLesen];
   return;
}


- (BOOL)WriteSystemDeviceEinstellungen
{
   Handle RecordereinstellungenHandle;
   /*
   RecordereinstellungenHandle=NewHandle(0);
   OSErr err=0;
   int l=[SystemDevicedaten length];
   //NSLog(@"--------------		SetEinstellungen: SystemDevicedaten: %@",[SystemDevicedaten description]);
   HLock(RecordereinstellungenHandle);
   err=PtrToHand([SystemDevicedaten bytes],&RecordereinstellungenHandle,l);
   OSErr GrabErr=noErr;
   l=0;
   l=GetHandleSize(RecordereinstellungenHandle);
   //NSLog(@"GetHandleSize(Recordereinstellungen): %d",l);
   //	OSErr GrabErr=Recorder->SetEinstellungen(	RecordereinstellungenHandle);
   HUnlock(RecordereinstellungenHandle);
   
   return ((err==0)&&(GrabErr==0));
    */
   return 0;
}

- (IBAction)changeTitel:(id)sender
{
   [self.TitelPop setEnabled:YES];
   [self.TitelPop setEditable:YES];
}

- (IBAction)Einstellungentest:(id)sender
{
   OSErr err=0;
   //err=Recorder->Einstellungentest();
   //NSLog(@"err bei Einstellungentest: %d ", err);
   
}

- (IBAction)showSettingsDialog:(id)sender
{
   [Utils stopTimeout];
   /*
   OSErr err=0;
   if ([AufnahmeGrabber Grabber])
   {
      SGStop([AufnahmeGrabber Grabber]);
      
      //NSLog(@"showSettingsDialog: anz Kanals: %d",[[AufnahmeGrabber SoundKanalArray]count]);
      rKanal* tempKanal=[[AufnahmeGrabber SoundKanalArray]objectAtIndex:0];
      if (tempKanal)
      {
         UserData GrabberEinstellungen=0;
         if( [[AufnahmeGrabber SoundKanalArray] count])
         {
            rKanal* tempKanal=[[AufnahmeGrabber SoundKanalArray]objectAtIndex:0];
            
            rAudioSettings* AudioSettings=[[rAudioSettings alloc]initWithKanal:tempKanal];
            
            NSModalSession AudioSession=[NSApp beginModalSessionForWindow:[AudioSettings window]];
            int modalAntwort = [NSApp runModalForWindow:[AudioSettings window]];
            //int modalAntwort = [NSApp runModalSession:ProjektSession];
            //NSLog(@"showProjektliste Antwort: %d",modalAntwort);
            
            [NSApp endModalSession:AudioSession];
            if (modalAntwort==2)
            {
               neueSettings=YES;
               //					[self saveSettings:NULL];
            }
            else
            {
               neueSettings=NO;
            }
         }
         
         
      }//if Grabber
      
   }
   
   //NSLog(@"RPController showSettingsDialog: err: %d",err);
   if (err==noErr)
   {
      //[self ReadDeviceEinstellungen:nil];
      //[self PrefsSchreiben:nil];
   }
    */
   [Utils startTimeout:self.TimeoutDelay];
}

#pragma mark QTKit

- (BOOL)isRecording
{
   return 0;//([mCaptureMovieFileOutput outputFileURL] != nil);
}


- (IBAction)startAVRecord:(id)sender
{
  
   if ([self isRecording])
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
   
   /*
   [RecordQTKitPlayer setMovie:[QTMovie movie]];
   if ([[RecordQTKitPlayer movie]duration].timeValue)
   {
      QTTime t=[[RecordQTKitPlayer movie]duration];
      float Zeit=(float)(t.timeValue)/t.timeScale;
      NSLog(@"startAVRecord schon ein Movie da. duration: %2.2f",Zeit);
   }
   */
   [self.Abspieldauerfeld setStringValue:@"0"];
   [self.Abspielanzeige setLevel:0];
   [self.Abspielanzeige setNeedsDisplay:YES];
   self.Pause=0;
   
   //int erfolg=[[self RecPlayFenster]makeFirstResponder:[self RecPlayFenster]];
   [[self.TitelPop cell] addItemWithObjectValue:[[self.TitelPop cell]stringValue]];
   [[self.TitelPop cell] setEnabled:NO];
  self. Aufnahmedauer=0;
   [self.Zeitfeld setStringValue:@"00:00"];
   
   
   self.Leser=[self.ArchivnamenPop titleOfSelectedItem];
   int n=[self.ArchivnamenPop indexOfSelectedItem];
   //NSLog(@"Selected Item: %d",n);
   //NSLog(@"startRecord:Selected Item: %d		Leser: %@",n,Leser);
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
   
   char *tempNameBytes = tempnam([NSTemporaryDirectory() fileSystemRepresentation], "Lesestudio_");
   self.hiddenAufnahmePfad = [[NSString alloc] initWithBytesNoCopy:tempNameBytes length:strlen(tempNameBytes) encoding:NSUTF8StringEncoding freeWhenDone:YES];
   
   //NSLog(@"hiddenAufnahmePfad: %@",hiddenAufnahmePfad);
   self.hiddenAufnahmePfad=[self.hiddenAufnahmePfad stringByAppendingPathExtension:@"mov"];
   //NSLog(@"hiddenAufnahmePfad: %@",hiddenAufnahmePfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL sauberOK=0;
   //	sauberOK=[Filemanager removeFileAtPath:neueAufnahmePfad handler:nil];
   NSMutableDictionary *AufnahmeAttrs = (NSMutableDictionary*)[Filemanager attributesOfItemAtPath:self.neueAufnahmePfad error:NULL];
   //NSDictionary *AufnahmeAttrs = [Filemanager fileAttributesAtPath:neueAufnahmePfad traverseLink:YES];
   //NSLog(@"AufnahmeAttrs: %@",[ AufnahmeAttrs description]);
   NSNumber* POSIX = [AufnahmeAttrs objectForKey:NSFilePosixPermissions];
			if (POSIX)
         {
            NSLog(@"POSIX: %d",	[POSIX intValue]);
         }
   //[AufnahmeAttrs setObject:[NSNumber numberWithInt:777] forKey:NSFilePosixPermissions];
   
   //[Filemanager setAttributes:AufnahmeAttrs ofItemAtPath:neueAufnahmePfad error: NULL];
   
   //	sauberOK=[Filemanager createFileAtPath:neueAufnahmePfad contents:NULL attributes:NULL];
   //NSLog(@"startAVRecord sauberOK: %d",sauberOK);
   //NSLog(@"startAVRecord neueAufnahmePfad: %@",neueAufnahmePfad);
   NSError* startErr;
   
   /*
   [mCaptureMovieFileOutput recordToOutputFileURL:[NSURL fileURLWithPath:self.hiddenAufnahmePfad]];
   */
   
   self.audioLevelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(updateAudioLevels:)
                                                    userInfo:nil
                                                     repeats:YES];
   //NSLog(@"startRecording neueAufnahmePfad: %@ audioLevelTimer: %@ ",hiddenAufnahmePfad,[audioLevelTimer description]);
//*   uint64 filesize =[movieFileOutput  recordedFileSize];
//*/   QTTime duration =[mCaptureMovieFileOutput  recordedDuration];
   
//   QTKitGesamtAufnahmezeit=0;
//   QTKitPause=0;
   //GesamtAufnahmezeit=0;
   //NSLog(@"Error nach StartRecord:%d",err);
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

- (IBAction)goQTKitStart:(id)sender
{
   NSLog(@"goQTKitStart");
   
}

#pragma mark UI updating

- (void)updateAudioLevels:(NSTimer *)timer
{
   // Get the mean audio level from the movie file output's audio connections
   
   float totalDecibels = 0.0;
   
 //*  QTCaptureConnection *connection = nil;
   NSUInteger i = 0;
   NSUInteger numberOfPowerLevels = 0;	// Keep track of the total number of power levels in order to take the mean
   //NSLog(@"updateAudioLevels: %d",[[movieFileOutput connections] count]);
   
   /*
   for (i = 0; i < [[movieFileOutput connections] count]; i++)
   {
      connection = [[movieFileOutput connections] objectAtIndex:i];
      
      if ([[connection mediaType] isEqualToString:QTMediaTypeSound])
      {
         NSArray *powerLevels = [connection attributeForKey:QTCaptureConnectionAudioAveragePowerLevelsAttribute];
         NSUInteger j, powerLevelCount = [powerLevels count];
         
         for (j = 0; j < powerLevelCount; j++)
         {
            NSNumber *decibels = [powerLevels objectAtIndex:j];
            totalDecibels += [decibels floatValue];
            numberOfPowerLevels++;
         }
      }
   }
   */
   if (numberOfPowerLevels > 0)
   {
      [self.audioLevelMeter setFloatValue:(pow(10., 0.05 * (totalDecibels / (float)numberOfPowerLevels)) * 20.0)];
   }
   else
   {
      [self.audioLevelMeter setFloatValue:0];
   }
   
 //  float l=(float)[mCaptureMovieFileOutput  recordedDuration].timeValue/[mCaptureMovieFileOutput  recordedDuration].timeScale;
   //NSLog(@"updateAudioLevels l: %2.1f",l);
   
   
   
//   NSString* TimeString=QTStringFromTime([mCaptureMovieFileOutput  recordedDuration]);
   // 0:00:00:15.18434/22050
   /*
   NSArray* TimeArray=[self.TimeString componentsSeparatedByString:@":"];
   
   NSString* MinutenString=[TimeArray objectAtIndex:2];
   int Sekunden=[[TimeArray objectAtIndex:3]intValue];
   NSString* SekundenString;
   if (Sekunden<10)
   {
      SekundenString=[NSString stringWithFormat:@"0%d",Sekunden];
   }
   else
   {
      SekundenString=[NSString stringWithFormat:@"%d",Sekunden];
   }
   //NSLog(@"updateAudioLevels Min: %@ Sek: %@",MinutenString, SekundenString);
   */
   
   //QTTime aktuelleZeit = [mCaptureMovieFileOutput  recordedDuration];
   //float floatZeit=(float)aktuelleZeit.timeValue/aktuelleZeit.timeScale;
   //NSLog(@"floatZeit : %2.0f",floatZeit );
   //NSString* ZeitString=[NSString stringWithFormat:@"%2.0f",floatZeit];
   //NSLog(@"ZeitString: %@",ZeitString);
   //	NSLog(@"recordedDuration: %2.2f",(float)[mCaptureMovieFileOutput  recordedDuration].timeValue/1000);
   //	NSValue* ZeitVal=[NSValue valueWithQTTime:aktuelleZeit];
   //NSLog(@"aktuelleZeit timescale: %d",aktuelleZeit.timeScale );
   
//   [self.Zeitfeld setStringValue:[NSString stringWithFormat:@"%@:%@",MinutenString, SekundenString]];
   
   // recordedDuration
}

// Do something with your QuickTime movie at the path you've specified at /Users/Shared/My Recorded Movie.mov"

/*
- (void)captureOutput:(QTCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL forConnections:(NSArray *)connections dueToError:(NSError *)error
{
   
   //	[[NSWorkspace sharedWorkspace] openURL:outputFileURL];
   [RecordQTKitPlayer setMovie:[QTMovie movieWithURL:outputFileURL error:NULL]];
   
}
*/
#pragma mark end QTKit


QTMovie* qtMovie;

- (IBAction)handleOpenMovie:(id)sender
{
   /* an array to capture the constants for metadata types:
      kQTMetaDataTypeBinary = 0,
      kQTMetaDataTypeUTF8 = 1,
      kQTMetaDataTypeUTF16BE = 2,
      kQTMetaDataTypeMacEncodedText = 3,
      kQTMetaDataTypeSignedIntegerBE = 21,
      kQTMetaDataTypeUnsignedIntegerBE = 22,
      kQTMetaDataTypeFloat32BE = 23,
      kQTMetaDataTypeFloat64BE = 24
    */
   NSArray* valueTypeDescriptions =
   [NSArray arrayWithObjects: @"Binary", @"UTF-8", @"UTF-16BE", @"Mac-Encoded Text",
    @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined",  // 4-10 undefined
    @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", @"undefined", // 11-20 undefined
    @"Signed Integer (Big-Endian)",
    @"Unsigned Integer (Big-Endian)",
    @"32-bit Float (Big-Endian)",
    @"64-bit Float (Big-Endian)",
    nil];
   
   // these should probably be constants
   NSString* emptyString = @"";
   NSArray* fileTypes = [NSArray arrayWithObjects:@"mov", @"mp4", @"m4a", @"mp3", @"m4p", @"jpg", @"jpeg",nil];
   NSString* moviesDir = [NSHomeDirectory() stringByAppendingString:
                          @"/Movies"];
   
   printf ("\n\nhandleOpenMenuItem!\n");
   NSOpenPanel* panel = [NSOpenPanel openPanel];
   //	[panel runModalForDirectory:moviesDir file:nil types:fileTypes ];
   
   printf ("panel dismissed\n");
   //NSURL* url = [[panel URLs] objectAtIndex: 0];
   NSURL* url=[NSURL fileURLWithPath:@"/Users/sysadmin/Documents/neueAufnahme.mov"];
   NSLog(@"URL: %@\n",url );
   
   printf ("Creating qtmovie\n");
   NSError* openError = nil;
   /*
   qtMovie = [QTMovie movieWithURL: url error:&openError];
   if (openError)
   {
      NSAlert *theAlert = [NSAlert alertWithError:openError];
      [theAlert runModal]; // Ignore return value.
   }
   
   [RecordQTKitPlayer setControllerVisible: YES];
   [RecordQTKitPlayer setMovie: qtMovie];
   [RecordQTKitPlayer play:NULL];
    */
}


- (void)updatePlayBalken:(NSTimer *)derTimer
{
   /*
   QTTime Gesamtzeit=[[RecordQTKitPlayer movie]duration];
   QTTime Spielzeit=[[RecordQTKitPlayer movie]currentTime];
   float Restzeit=(float)(Gesamtzeit.timeValue-Spielzeit.timeValue)/Gesamtzeit.timeScale;
   //NSLog(@"Restzeit: %2.2f",Restzeit);
   [Abspielanzeige setLevel:(Spielzeit.timeValue)];
   if (Restzeit>0)
   {
      [Abspieldauerfeld setStringValue:[self Zeitformatieren:(int)Restzeit]];
   }
   if (Restzeit==0)
   {
      [derTimer invalidate];
      //NSLog(@"Restzeit ist null");
   }
    */
}

- (IBAction)startPlay:(id)sender
{
   NSLog(@"startPlay");
   if([self isRecording])
   {
      NSBeep();
      return;
   }
   //BOOL result=NO;
   
   
   /*
   if (![RecordQTKitPlayer movie])
   {
      NSLog(@"Noch kein Movie da");
      
      NSURL *movieUrl = [NSURL fileURLWithPath:hiddenAufnahmePfad];
      NSError* startErr=0;
      //QTMovie *tempMovie = [QTMovie movieWithURL:[NSURL fileURLWithPath:neueAufnahmePfad]error:NULL];
      QTMovie *tempMovie = [[QTMovie alloc]initWithURL:[NSURL fileURLWithPath:hiddenAufnahmePfad]error:&startErr];
      if (startErr)
      {
         NSAlert *theAlert = [NSAlert alertWithError:startErr];
         [theAlert runModal]; // Ignore return value.
      }
      else
      {
         [tempMovie play];
      }
      
      //[ArchivQTKitPlayer setMovie:tempMovie];
      [RecordQTKitPlayer setMovie:tempMovie];
      if (!tempMovie)
      {
         NSLog(@"Kein Movie da");
      }
      // retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h)
      //PlayerMovie =[tempMovie quickTimeMovie];
      
      //NSLog(@"Beginn startPlay: Dauer in s:%2.2f ",Dauer/600.0);
      
      double PlayerVolume=120.0;
   }
*/
   //NSLog(@"startPlay hiddenAufnahmePfad: %@",hiddenAufnahmePfad);
   NSURL *movieURL = [NSURL fileURLWithPath:self.hiddenAufnahmePfad];
   NSError* err1;
   
   /*
   QTMovie *tempMovie=[QTMovie movieWithURL:movieURL error:&err1];
   
   if (err1)
   {
      NSAlert *theAlert = [NSAlert alertWithError:err1];
      [theAlert runModal]; // Ignore return value.
      
   }
   */
   
   
   //[Volumesteller setFloatValue: GetMovieVolume(PlayerMovie)];
   
   //	QTMovie *tempMovie=[RecordQTKitPlayer movie];
   //Dauer=[tempMovie duration].timeValue/[tempMovie duration].timeScale;
   //NSLog(@"startPlay Dauer: %d",Dauer);
//   QTKitDauer=(float)[tempMovie duration].timeValue/[tempMovie duration].timeScale;
   //NSLog(@"startPlay QTKitDauer: %2.2f",QTKitDauer);
   [Utils stopTimeout];
   //GesamtAbspielzeit=Dauer;
// self.QTKitGesamtAbspielzeit=self.QTKitDauer;
//   [self.Abspielanzeige setMax: [tempMovie duration].timeValue];
   
   if ([self.playBalkenTimer isValid])
   {
      [self.playBalkenTimer invalidate];
   }
   self.playBalkenTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(updatePlayBalken:)
                                                    userInfo:nil
                                                     repeats:YES];
   
   
   //NSLog(@"startPlay QTKitPause: %2.2f", QTKitPause);
   
   if (self.QTKitPause)
   {
      [self.Abspieldauerfeld setStringValue:[self Zeitformatieren:self.QTKitPause]];
      //Abspieldauer=Pause;
      
      //[Levelbalken setDoubleValue: Pause];
//      [self.Abspielanzeige setLevel:QTKitPause];
      self.Pause=0;
      //QTKitPause=0;
      
   }
   else
   {
      
      [self.Abspieldauerfeld setStringValue:[self Zeitformatieren:self.QTKitGesamtAbspielzeit]];
      
      //Abspieldauer=GesamtAbspielzeit;
      
      [self.audioLevelMeter setFloatValue: 0];
      [self.Abspielanzeige setLevel:0];
//*      [self.ArchivQTKitPlayer gotoBeginning:NULL];
   }
   //[ArchivQTKitPlayer play:NULL];
//*   [RecordQTKitPlayer play:NULL];
   
   //NSLog(@"MovieDuration: %d", GesamtAbspielzeit);
   //[tempMovie release];
   [self.StartRecordKnopf setEnabled:NO];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   [self.StopRecordKnopf setEnabled:NO];
   [self.BackKnopf setEnabled:NO];
   [self.StopPlayKnopf setEnabled:YES];
   
   
}


- (void)AbspielenFertigAktion:(NSNotification *)aNotification
{
   /*
   if ([[self.RecordQTKitPlayer movie]duration].timeValue)
   {
      if ([self.playBalkenTimer isValid])
      {
         [playBalkenTimer invalidate];
      }
      
      [StartRecordKnopf setEnabled:YES];
      [SichernKnopf setEnabled:YES];
      [WeitereAufnahmeKnopf setEnabled:YES];
      [StopRecordKnopf setEnabled:YES];
      [BackKnopf setEnabled:NO];
      [StopPlayKnopf setEnabled:NO];
      [Abspieldauerfeld setStringValue:[self Zeitformatieren:(int)QTKitGesamtAbspielzeit]];
      //Abspieldauer=GesamtAbspielzeit;
      [Abspielanzeige setLevel:0];
      [ArchivQTKitPlayer gotoBeginning:NULL];
      Pause=0;
      QTKitPause=0;
   }
   */
}

- (IBAction)stopPlay:(id)sender
{
   
   //*[self.RecordQTKitPlayer pause:NULL];
   int PauseZeit=(self.Laufzeit)/60;
   //NSLog(@"Laufzeit:%d  PauseZeit: %d",Laufzeit,PauseZeit);
   self.Pause=self.Laufzeit/60;
   
//*   self.QTKitPause=(float)[[RecordQTKitPlayer movie] duration].timeValue/[[RecordQTKitPlayer movie] duration].timeScale;
   self.Pause=self.QTKitPause;
   NSLog(@"stopPlay: Pause: %ld QTKitPause: %2.1f",self.Pause, self.QTKitPause);
   
   [self.StartRecordKnopf setEnabled:YES];
   [self.SichernKnopf setEnabled:YES];
   [self.WeitereAufnahmeKnopf setEnabled:YES];
   [self.StopRecordKnopf setEnabled:NO];
   [self.BackKnopf setEnabled:YES];
   [self.StopPlayKnopf setEnabled:NO];
   [Utils startTimeout:self.TimeoutDelay];
   
}

- (IBAction)goStart:(id)sender
{
   if (self.playBalkenTimer)
   {
      [self.playBalkenTimer invalidate];
   }
   
   self.Pause=0;
   self.QTKitPause=0;
   [self.Abspieldauerfeld setStringValue:[self Zeitformatieren:self.QTKitGesamtAbspielzeit]];
   //Abspieldauer=GesamtAbspielzeit;
   [self.Abspielanzeige setLevel:0];
   //	[Utils startTimeout:TimeoutDelay];
   [self.BackKnopf setEnabled:NO];
   //[ArchivQTKitPlayer gotoBeginning:NULL];
 //*  [RecordQTKitPlayer gotoBeginning:NULL];
   [Utils startTimeout:self.TimeoutDelay];
}





- (IBAction)setVolume:(id)sender
{
   /* set the movie volume to correspond to the
    current value of the slider */
   //  SetMovieVolume((Movie)[[MoviePlayer movie] QTMovie],(short)[Volumesteller floatValue]);
   
}



- (void)setLevel:(int)derLevel
{
   NSLog(@"RPC setLevel: %d",derLevel);
   [self.Levelmeter setLevel:derLevel];
}


- (OSErr) finishMovie:(NSString*)derAufnahmePfad zuPfad:(NSString*)derFinishPfad
{
   //NSLog(@"finishMovie: derAufnahmePfad: %@  derFinishPfad: %@",derAufnahmePfad,derFinishPfad);
   /*
    BOOL success = NO;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithBool:YES], QTMovieExport,
    [NSNumber numberWithLong:kQTFileTypeAIFF], QTMovieExportType,
    [NSNumber numberWithLong:SoundMediaType], QTMovieExportManufacturer,
    nil];
    
    success = [audio writeToFile:outFile withAttributes:attributes];
    
    
    
    src = @"/Users/bittercold/Desktop/deadbolt.aif";
    snd = [[QTMovie alloc] initWithFile:src error: NULL];
    [snd play];
    
    
    NSDictionary    *dict = nil;
    dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
    forKey:QTMovieFlatten];
    if (dict)
    {
    // create a new movie file and flatten the movie to the file
    
    // passing the QTMovieFlatten attribute here means the movie
    // will be flattened
    success = [self writeToFile:filePath withAttributes:dict];
    
    
    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc]initWithDictionary: [myFile movieAttributes]];
    [attrDict setObject: [NSNumber numberWithBool:YES] forKey:QTMovieFlatten];
    [attrDict setObject: [NSNumber numberWithBool:YES] forKey:QTMovieExport];
    [attrDict setObject: [NSNumber numberWithInt:kQTFileTypeAIFF] forKey:QTMovieExportType];
    [myFile writeToFile:[savePanel filename] withAttributes: attrDict];
    
    
    */
   
   
   NSError* finishErr;
   BOOL exportErr=0;
 //*  QTMovie * tempQTKitMovie=[QTMovie movieWithURL:[NSURL fileURLWithPath:derAufnahmePfad]error:&finishErr];
   
   //QTMovie * tempQTKitMovie=[[QTMovie alloc]initWithURL:[NSURL fileURLWithPath:derAufnahmePfad] error:&finishErr];
   
   //[[RecordQTKitPlayer movie]play];
   
   if (finishErr) // etwas passiert
   {
      NSAlert *theAlert = [NSAlert alertWithError:finishErr];
      [theAlert runModal]; // Ignore return value.
   }
   
   
 //*   [tempQTKitMovie setAttribute:[NSNumber numberWithBool:YES] forKey:QTMovieEditableAttribute]; // make movie editable
   /*
    [RecordQTKitPlayer setMovie:tempQTKitMovie];
    [RecordQTKitPlayer gotoBeginning:NULL];
    [RecordQTKitPlayer play:NULL];
    */
   
   
   
   // QTKit
   //Startknacks abschneiden
/*   
 QTTime gesamtTime=[tempQTKitMovie duration];
  float floatZeit=(float)gesamtTime.timeValue/gesamtTime.timeScale;
   //NSLog(@"floatZeit: %f",floatZeit);
   //NSLog(@"gesamtTime vor: %2.2f",(float)gesamtTime.timeValue/gesamtTime.timeScale);
   long timeScale=gesamtTime.timeScale;
   
   QTTime startZeit=QTMakeTime(0,timeScale);
   
   QTTime knackZeit=QTMakeTime(KnackDelay,timeScale);
   [tempQTKitMovie deleteSegment:QTMakeTimeRange(startZeit,knackZeit)];
   QTTime startKnackDauer=[tempQTKitMovie duration];
   //NSLog(@"gesamtTime nach: %2.2f",(float)startKnackDauer.timeValue/startKnackDauer.timeScale);
   
   //Endknacks abschneiden
   QTTime endZeit=QTMakeTime(gesamtTime.timeValue,timeScale);
   QTTime endKnackZeit=QTMakeTime(gesamtTime.timeValue-KnackDelay,timeScale);
   [tempQTKitMovie deleteSegment:QTMakeTimeRange(endKnackZeit,endZeit)];
   QTTime endKnackDauer=[tempQTKitMovie duration];
   //NSLog(@"gesamtTime nach end: %2.2f",(float)endKnackDauer.timeValue/endKnackDauer.timeScale);
   */
   /*
    [RecordQTKitPlayer setMovie:tempQTKitMovie];
    [RecordQTKitPlayer gotoBeginning:NULL];
    [RecordQTKitPlayer play:NULL];
    */
   
   /*
   long movieScale = [[tempQTKitMovie attributeForKey:QTMovieTimeScaleAttribute] longValue]; //get movie scale
   //NSLog(@"movieScale: %d duration: %d",movieScale, [tempQTKitMovie duration].timeValue);
   
   NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithBool:YES], QTMovieExport,
                               [NSNumber numberWithBool:YES] ,QTMovieFlatten,
                               [NSNumber numberWithLong:kQTFileTypeAIFF], QTMovieExportType,
                               [NSNumber numberWithLong:SoundMediaType], QTMovieExportManufacturer,
                               nil];
   
   
   
   exportErr=[tempQTKitMovie writeToFile:derFinishPfad withAttributes:attributes];
    */
   //	NSFileManager* Filemanager=[NSFileManager defaultManager];
   //	[Filemanager moveItemAtPath:derAufnahmePfad toPath:derFinishPfad error:NULL];
   
   
   //	NSLog(@"exportErfolg: %d derFinishPfad: %@",exportErr,derFinishPfad);
   
   
   
   FSSpec								finishAufnahmeSpec;
   FSRef									finishAufnahmeRef;
   FSRef									LeserordnerRef;
   short									status;
   UniChar								buffer[255]; // HFS+ filename max is 255
   NSString*							finishAufnahmeName=[[derFinishPfad copy] lastPathComponent];
   
   //	NSLog(@"finishAufnahmeName: %@",finishAufnahmeName);
   
   [finishAufnahmeName getCharacters:buffer];
   
   //NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSString* LeserordnerPfad=[[derFinishPfad copy] stringByDeletingLastPathComponent];
   //NSLog(@"LeserordnerPfad: %@",LeserordnerPfad);
   
   BOOL KommentarOK=[Utils setKommentar:@"Hallo" inAufnahmeAnPfad:derAufnahmePfad];
   
   
   if (exportErr)
   {
      return 0;
   }
   return 1;
   
   
}

- (IBAction)saveRecord:(id)sender
{
   if ([self.playBalkenTimer isValid])
   {
      [self.playBalkenTimer invalidate];
   }
   
   [Utils stopTimeout];
   BOOL erfolg=YES;
   //NSLog(@"saveRecord tag: %d Leser: %@ ",[sender tag],Leser);
   //NSLog(@"saveRecord hiddenAufnahmePfad: %@",hiddenAufnahmePfad);
   /*
   if ([[RecordQTKitPlayer movie]rate])
   {
      NSString* s1=NSLocalizedString(@"Still Playing",@"Wiedergabe läuft");
      NSString* s2=NSLocalizedString(@"No saving during playing",@"Kein Sichern während der Wiedergabe.");
      NSString* s3=NSLocalizedString(@"Stop Recording",@"Stoppen");
      int Antwort=NSRunAlertPanel(s1, s2,@"OK", s3,NULL);
      if (Antwort==1)
      {
         [self resetRecPlay];
      }
      return;
      if (Antwort==2)
      {
         [self stopPlay:nil];
         
      }
   }
    */
   if ([self.Leser length]==0)
   {
      //int Antwort=NSRunAlertPanel(@"Wer hat gelesen?", @"Vor dem Sichern muss ein Name ausgewählt sein",@"OK", NULL,NULL);
      
      //return;
   }
   /*
   if ((QTKitGesamtAufnahmezeit==0)&&([Leser length]==0))
   {
      //NSLog(@"Save ohne Aufnahme");
      NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
      [Warnung addButtonWithTitle:@"OK"];
      //[Warnung addButtonWithTitle:@"Cancel"];
      [Warnung setMessageText:NSLocalizedString(@"No Record",@"Keine Aufnahme")];
      [Warnung setInformativeText:NSLocalizedString(@"No record present ir already saved",@"Keine Aufnahme oder schon gesichert")];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      [Warnung beginSheetModalForWindow:RecPlayFenster
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:nil];
      
      [ArchivnamenPop selectItemAtIndex:0];
      [Leserfeld setStringValue:@""];
      [self resetRecPlay];
      [Utils stopTimeout];
      return;
   }
    */
   [self.Abspieldauerfeld setStringValue:@""];
   [self.Abspielanzeige setLevel:0];
   [self.Zeitfeld setStringValue:@""];
   //NSLog(@"saveRecord: QTKitGesamtAufnahmezeit: %2.2f",QTKitGesamtAufnahmezeit);
   NSString* tempAufnahmePfad;
   //tempLeserPfad=[NSString stringWithString:@""];
   NSFileManager *Manager = [NSFileManager defaultManager];
   if (self.QTKitGesamtAufnahmezeit)
   {
      NSString* Leserinitialen=[self Initialen:self.Leser];
      Leserinitialen=[Leserinitialen stringByAppendingString:@" "];
      if ([Manager fileExistsAtPath: self.hiddenAufnahmePfad])		//neueAufnahme ist vorhanden
      {
         NSMutableArray * tempAufnahmeArray=[[Manager contentsOfDirectoryAtPath:self.LeserPfad error:NULL]mutableCopy];
         int AnzAufnahmen=[tempAufnahmeArray count];
         if (AnzAufnahmen&&[[tempAufnahmeArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
         {
            [tempAufnahmeArray removeObjectAtIndex:0];
            AnzAufnahmen--;
         }
         
         //NSString* Aufnahmenliste=[tempAufnahmeArray description];
         //NSLog(@"tempAufnahmeListe: %@", Aufnahmenliste);
         NSMutableString* tempNummerString=[NSMutableString stringWithCapacity:0];
         NSNumber* tempNummer;
         int maxNummer=0;
         int i;
         if (AnzAufnahmen)
         {
            
            for (i=0;i<AnzAufnahmen;i++)
            {
               int posLeerstelle1=0;
               int posLeerstelle2=0;
               int Leerstellen=0;
               NSString* loopNummerString=[NSString stringWithString:[tempAufnahmeArray objectAtIndex:i]];
               //int n=0;
               int charpos=0;
               while ((Leerstellen<2)&&(charpos<[loopNummerString length]))
               {
                  if ([loopNummerString characterAtIndex:charpos]==' ')
                  {
                     
                     Leerstellen++;
                     if (Leerstellen==1)
                     {
                        posLeerstelle1=charpos;
                     }
                     if (Leerstellen==2)
                     {
                        posLeerstelle2=charpos;
                     }
                     
                     
                  }
                  charpos++;
               }//while pos
               if (posLeerstelle1 && posLeerstelle2)
               {
                  //NSLog(@"loopNummerString: %@   pos Leerstelle1:%d pos Leerstelle2:%d",loopNummerString,posLeerstelle1,posLeerstelle2);
                  NSRange tempRange=NSMakeRange(posLeerstelle1+1,(posLeerstelle2-posLeerstelle1));
                  tempNummerString=(NSMutableString*)[loopNummerString substringWithRange:tempRange];
                  //NSLog(@"loopNummerString: %@   pos Leerstelle1:%d pos Leerstelle2:%d",loopNummerString,posLeerstelle1,posLeerstelle2);
                  
                  int loopNummer=[tempNummerString intValue];
                  if (loopNummer>maxNummer)
                     maxNummer=loopNummer;
               }
               //NSLog(@"neue maxNummer: %d",maxNummer);
               //[loopNummerString release];
            }
         }
         maxNummer++;
         tempNummer=[NSNumber numberWithInt:maxNummer];
         if ( maxNummer<10)
         {
            tempNummerString=@"";
            tempNummerString=(NSMutableString*)[tempNummerString stringByAppendingString:[tempNummer stringValue]];
         }
         else
         {
            tempNummerString=[NSString stringWithString:[tempNummer stringValue]];
         }
         
         Leserinitialen=[Leserinitialen stringByAppendingString:tempNummerString];
         Leserinitialen=[Leserinitialen stringByAppendingString:@" "];
         if (([[self titel]length]==0)||([[self titel]isEqualToString:@"neue Aufnahme"]))
         {
            NSString* s1=NSLocalizedString(@"Title For Record",@"Titel für Aufnahme");
            NSString* s2=NSLocalizedString(@"You have not yet given a matching title.",@"Noch kein passender Titel");
            NSString* s3=NSLocalizedString(@"Enter Title",@"Titel eingeben");
            NSString* s4=NSLocalizedString(@"Continue",@"Weiter");
            
            int Antwort=NSRunAlertPanel(s1, s2, s3, s4,NULL);
            if (Antwort==1)
            {
               [self.TitelPop setEnabled:YES];
               [self.TitelPop selectItemWithObjectValue:[[self.TitelPop cell]stringValue]];
               return;
            }
         }
         NSString* AufnahmeTitel=[Leserinitialen stringByAppendingString:[self titel]];
         if ([tempAufnahmeArray containsObject:AufnahmeTitel])
         {
            NSLog(@"Die Nummer ist schon vorhanden: %d",AnzAufnahmen+1);
            return;
         }
         
         tempAufnahmePfad=[self.LeserPfad stringByAppendingPathComponent:AufnahmeTitel];//Pfad im Ordner in der Lesebox
         
         NSLog(@"saveRecord tempAufnahmePfad : %@", tempAufnahmePfad);
         //[Manager movePath: neueAufnahmePfad toPath:tempAufnahmePfad handler:NULL];
         OSErr err=0;
         BOOL createKommentarOK=[Utils createKommentarFuerLeser:self.Leser FuerAufnahmePfad:tempAufnahmePfad];
         if (createKommentarOK)
         {
            err=[self finishMovie:self.hiddenAufnahmePfad zuPfad:tempAufnahmePfad];
            
            //NSLog(@"err nach finishMovie: %d",err);
            if (err)
            {
               //NSLog(@"err nach finishMovie: %d",err);
               NSAlert *Warnung = [[NSAlert alloc] init];
               [Warnung addButtonWithTitle:@"OK"];
               //[Warnung addButtonWithTitle:@"Cancel"];
               [Warnung setMessageText:NSLocalizedString(@"Error While Saving Record",@"Fehler beim Sichern:")];
               [Warnung setInformativeText:NSLocalizedString(@"The record cannot be saved.",@"Die Aufnahme kann nicht gesichert werden")];
               [Warnung setAlertStyle:NSWarningAlertStyle];
               /*
               [Warnung beginSheetModalForWindow:RecPlayFenster
                                   modalDelegate:nil
                                  didEndSelector:nil
                                     contextInfo:nil];
               */
               [self resetRecPlay];
               return;
               
            }
         } // if saveKommentarOK
         //SessionLeserArray aktualisieren
         
         NSCalendarDate* creatingDatum=[NSCalendarDate calendarDate];
         //NSLog(@"Projekt: %@ creatingDatum: %@",[ProjektPfad lastPathComponent],creatingDatum);
         
         NSString* tempLeser=[self.ArchivnamenPop titleOfSelectedItem];
         //NSLog(@"saveRecord Projekt: %@ tempLeser: %@",[ProjektPfad lastPathComponent],tempLeser);
         
         
         //Leser zur Sessionliste zufügen
         
         int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:[self.ProjektPfad lastPathComponent]];
         //NSLog(@"ProjektIndex: %d",ProjektIndex);
         if (ProjektIndex<NSNotFound)
         {
            //NSLog(@"Projekt da: ");
            NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
            
            NSMutableArray* SessionLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
            
            if ([tempProjektDic objectForKey:@"sessionleserarray"])//Array ist vorhanden
            {
               //NSLog(@"SessionLeserArray da: ");
               [SessionLeserArray addObjectsFromArray:[tempProjektDic objectForKey:@"sessionleserarray"]];
               
               //NSLog(@"SessionLeserArray da2");
            }
            if (![SessionLeserArray containsObject:tempLeser])//tempLeser einsetzen
            {
               [SessionLeserArray addObject:tempLeser];
            }
            //NSLog(@"vor setArchivNamenPop");
            [tempProjektDic setObject:SessionLeserArray forKey:@"sessionleserarray"];
            
            //SessionListe in der PList sichern
            
            [self saveSessionForUser:self.Leser inProjekt:[self.ProjektPfad lastPathComponent]];
            
            if ([sender tag])
            {
               [self setArchivNamenPop];
            }
            //NSLog(@"nach setArchivNamenPop");
         }//projektIndex
         else
         {
            NSLog(@"Projekt noch nicht da: ");
         }
         //BOOL erfolg=[Manager removeFileAtPath:neueAufnahmePfad handler:nil];
         if (!erfolg)
         {
            NSLog(@"erfolg nach removeFileAtPath: %d",err);
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            //[Warnung addButtonWithTitle:@"Cancel"];
            [Warnung setMessageText:NSLocalizedString(@"Error While Saving Record",@"Fehler beim Sichern:")];
            [Warnung setInformativeText:NSLocalizedString(@"The new record is still in folder 'Documents' and must be removed manually","Aufnahme noch in Docs")];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            /*
            [Warnung beginSheetModalForWindow:RecPlayFenster
                                modalDelegate:nil
                               didEndSelector:nil
                                  contextInfo:nil];
            
            //int Antwort=NSRunAlertPanel(@"", @"",@"OK", NULL,NULL);
            //if (Antwort==1)
            //return;
            */
         }
         
      }
      else
      {
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"OK"];
         //[Warnung addButtonWithTitle:@"Cancel"];
         [Warnung setMessageText:NSLocalizedString(@"Error While Saving Record",@"Fehler beim Sichern:")];
         NSString* s1=NSLocalizedString(@"The file for the new record could not be created.",@"Kein File für Aufnahme");
         [Warnung setInformativeText:s1];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         /*
         [Warnung beginSheetModalForWindow:RecPlayFenster
                             modalDelegate:nil
                            didEndSelector:nil
                               contextInfo:nil];
         
         //int Antwort=NSRunAlertPanel(@"", @"",@"OK",NULL,NULL);
          */
         [self resetRecPlay];
         return;
      }
   }
   
   
   
   //NSLog(@" vor     SaveAufnahmeTimer");
   switch  ([sender tag])
   {
      case 1:
      {
         NSTimer*	SaveAufnahmeTimer=[NSTimer scheduledTimerWithTimeInterval:0.5
                                                                      target:self
                                                                    selector:@selector(SaveAufnahmeTimerFunktion:)
                                                                    userInfo:[NSNumber numberWithInt:[sender tag]]
                                                                     repeats:NO];
         //NSLog(@"                                    set        SaveAufnahmeTimer");
         //[Utils startTimeout:TimeoutDelay];
         //[hiddenAufnahmePfad release];
      }break;
      case 0:
      {
         
         [self.StartRecordKnopf setEnabled:YES];
         [self.StartPlayKnopf setEnabled:NO];
         [self.StopPlayKnopf setEnabled:NO];
         [self.BackKnopf setEnabled:NO];
         [self.SichernKnopf setEnabled:NO];
         [self.WeitereAufnahmeKnopf setEnabled:NO];
         [self.LogoutKnopf setEnabled:NO];
         
 //*        [self.RecPlayFenster makeFirstResponder:RecPlayFenster];
         [self.KommentarView setString:@""];
         [self.KommentarView setEditable:NO];
         self.QTKitGesamtAufnahmezeit=0;
         
      }break;
   }//switch
}


- (void)SaveAufnahmeTimerFunktion:(NSTimer*)derTimer
{
   //NSLog(@"        SaveAufnahmeTimerFunktion info: %d",[[derTimer userInfo]intValue]);
   
   if ([[derTimer userInfo]intValue])	//Sichern und abmelden
   {
      //NSLog(@"        SaveAufnahmeTimerFunktion: Sichern und Abmelden");
      [self.ArchivnamenPop selectItemAtIndex:0];
      [self.Leserfeld setStringValue:@""];
      [[self.TitelPop cell]setStringValue:@""];
      [self.TitelPop removeAllItems];
      self.aktuellAnzAufnahmen=0;
      [self.TitelPop setEnabled:NO];
      [self clearArchiv];
   }
   
   
   
   [self.StartRecordKnopf setEnabled:YES];
   [self.StartPlayKnopf setEnabled:NO];
   [self.StopPlayKnopf setEnabled:NO];
   [self.BackKnopf setEnabled:NO];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   [self.LogoutKnopf setEnabled:NO];
   
  // * [RecPlayFenster makeFirstResponder:RecPlayFenster];
   [self.KommentarView setString:@""];
   [self.KommentarView setEditable:NO];
   
   
   self.QTKitGesamtAufnahmezeit=0;
   
}



- (NSArray*)AufnahmeRetten
{
   [Utils stopTimeout];
   NSMutableArray* FehlerArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   BOOL erfolg=YES;
   /*
   if ([[RecordQTKitPlayer movie]rate])
   {
      NSString* s=NSLocalizedString(@"Playing stopped",@"Wiedergabe gestoppt");
      NSDictionary* f=[NSDictionary dictionaryWithObject:s forKey:@"stopplaying"];
      [FehlerArray addObject: f];
      [self stopPlay:nil];
      
   }
   if ([Leser length]==0)
   {
      NSLog(@"[Leser length]==0");
      return FehlerArray;
   }
   
   
   if (QTKitGesamtAufnahmezeit==0)
   {
      //NSLog(@"GesamtAufnahmezeit==0");
      return FehlerArray;
   }
    */
   [self.Abspieldauerfeld setStringValue:@""];
   [self.Abspielanzeige setLevel:0];
   [self.Zeitfeld setStringValue:@""];
   
   NSString* tempAufnahmePfad;
   //tempLeserPfad=[NSString stringWithString:@""];
   NSFileManager *Manager = [NSFileManager defaultManager];
   if (Manager)
   {
      NSString* Leserinitialen=[self Initialen:self.Leser];
      Leserinitialen=[Leserinitialen stringByAppendingString:@" "];
      if ([Manager fileExistsAtPath: self.neueAufnahmePfad])		//neueAufnahme ist vorhanden
      {
         NSMutableArray * tempAufnahmeArray=(NSMutableArray*)[Manager contentsOfDirectoryAtPath:self.LeserPfad error:NULL];
         int AnzAufnahmen=[tempAufnahmeArray count];
         if (AnzAufnahmen&&[[tempAufnahmeArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
         {
            [tempAufnahmeArray removeObjectAtIndex:0];
            AnzAufnahmen--;
         }
         
         //NSString* Aufnahmenliste=[tempAufnahmeArray description];
         //NSLog(@"tempAufnahmeListe: %@", Aufnahmenliste);
         NSMutableString* tempNummerString=[NSMutableString stringWithCapacity:0];
         NSNumber* tempNummer;
         int maxNummer=0;
         int i;
         if (AnzAufnahmen)
         {
            
            for (i=0;i<AnzAufnahmen;i++)
            {
               int posLeerstelle1=0;
               int posLeerstelle2=0;
               int Leerstellen=0;
               NSString* loopNummerString=[NSString stringWithString:[tempAufnahmeArray objectAtIndex:i]];
               //int n=0;
               int charpos=0;
               while ((Leerstellen<2)&&(charpos<[loopNummerString length]))
               {
                  if ([loopNummerString characterAtIndex:charpos]==' ')
                  {
                     
                     Leerstellen++;
                     if (Leerstellen==1)
                     {
                        posLeerstelle1=charpos;
                     }
                     if (Leerstellen==2)
                     {
                        posLeerstelle2=charpos;
                     }
                     
                     
                  }
                  charpos++;
               }//while pos
               if (posLeerstelle1 && posLeerstelle2)
               {
                  //NSLog(@"loopNummerString: %@   pos Leerstelle1:%d pos Leerstelle2:%d",loopNummerString,posLeerstelle1,posLeerstelle2);
                  NSRange tempRange=NSMakeRange(posLeerstelle1+1,(posLeerstelle2-posLeerstelle1));
                  tempNummerString=(NSMutableString*)[loopNummerString substringWithRange:tempRange];
                  //NSLog(@"loopNummerString: %@   pos Leerstelle1:%d pos Leerstelle2:%d",loopNummerString,posLeerstelle1,posLeerstelle2);
                  
                  int loopNummer=[tempNummerString intValue];
                  if (loopNummer>maxNummer)
                     maxNummer=loopNummer;
               }
               //NSLog(@"neue maxNummer: %d",maxNummer);
               //[loopNummerString release];
            }
         }
         maxNummer++;
         tempNummer=[NSNumber numberWithInt:maxNummer];
         if ( maxNummer<10)
         {
            tempNummerString=@"";
            tempNummerString=(NSMutableString*)[tempNummerString stringByAppendingString:[tempNummer stringValue]];
         }
         else
         {
            tempNummerString=[NSString stringWithString:[tempNummer stringValue]];
         }
         
         Leserinitialen=[Leserinitialen stringByAppendingString:tempNummerString];
         Leserinitialen=[Leserinitialen stringByAppendingString:@" "];
         NSString* AufnahmeTitel;
         if (([[self titel]length]==0)||([[self titel]isEqualToString:@"neue Aufnahme"]))
         {
            AufnahmeTitel=[Leserinitialen stringByAppendingString:@"????"];
         }
         else
         {
            AufnahmeTitel=[Leserinitialen stringByAppendingString:[self titel]];
         }
         if ([tempAufnahmeArray containsObject:AufnahmeTitel])//schon eine gerettete Aufnbahem
         {
            AufnahmeTitel=[Leserinitialen stringByAppendingString:@"****"];
         }
         
         tempAufnahmePfad=[self.LeserPfad stringByAppendingPathComponent:AufnahmeTitel];//Pfad im Ordner in der Lesebox
         BOOL createKommentarOK=[Utils createKommentarFuerLeser:self.Leser FuerAufnahmePfad:tempAufnahmePfad];
         if (createKommentarOK)
         {
            NSLog(@"AufnahmePfad : %@", tempAufnahmePfad);
            
            OSErr err=[self finishMovie:self.neueAufnahmePfad zuPfad:tempAufnahmePfad];
            if (err)
            {
               NSString* s=NSLocalizedString(@"Saving failed",@"Sichern misslungen");
               NSDictionary* f=[NSDictionary dictionaryWithObject:s forKey:@"finishfailed"];
               [FehlerArray addObject: f];
               
               [self.ArchivnamenPop selectItemAtIndex:0];
               [self.Leserfeld setStringValue:@""];
               [[self.TitelPop cell]setStringValue:@""];
               [self.TitelPop removeAllItems];
               
               return FehlerArray;
               
            }
            
            
            [self.ArchivnamenPop selectItemAtIndex:0];
            [self.Leserfeld setStringValue:@""];
            [[self.TitelPop cell]setStringValue:@""];
            [self.TitelPop removeAllItems];
         } // if savekommentatok
      }
      else
      {
         NSString* s=NSLocalizedString(@"Saving failed",@"Sichern misslungen");
         NSDictionary* f=[NSDictionary dictionaryWithObject:s forKey:@"savingfailed"];
         [FehlerArray addObject: f];
         
         [self.ArchivnamenPop selectItemAtIndex:0];
         [self.Leserfeld setStringValue:@""];
         [[self.TitelPop cell]setStringValue:@""];
         [self.TitelPop removeAllItems];
         return FehlerArray;
      }
   }
   
   // 16.1.2010
   //SessionLeserArray aktualisieren
   
   NSCalendarDate* creatingDatum=[NSCalendarDate calendarDate];
   //NSLog(@"Projekt: %@ creatingDatum: %@",[ProjektPfad lastPathComponent],creatingDatum);
   
   NSString* tempLeser=[self.ArchivnamenPop titleOfSelectedItem];
   //NSLog(@"saveRecord Projekt: %@ tempLeser: %@",[ProjektPfad lastPathComponent],tempLeser);
   
   //Leser zur Sessionliste zufügen
   
   int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:[self.ProjektPfad lastPathComponent]];
   //NSLog(@"ProjektIndex: %d",ProjektIndex);
   if (ProjektIndex<NSNotFound)
   {
      NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
      
      NSMutableArray* SessionLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
      
      if ([tempProjektDic objectForKey:@"sessionleserarray"])//Array ist vorhanden
      {
         //NSLog(@"SessionLeserArray da: ");
         [SessionLeserArray addObjectsFromArray:[tempProjektDic objectForKey:@"sessionleserarray"]];
         
         //NSLog(@"SessionLeserArray da2");
      }
      if (![SessionLeserArray containsObject:tempLeser])//tempLeser einsetzen
      {
         [SessionLeserArray addObject:tempLeser];
      }
      //NSLog(@"vor setArchivNamenPop");
      [tempProjektDic setObject:SessionLeserArray forKey:@"sessionleserarray"];
      
      //SessionListe in der PList sichern
      
      [self saveSessionForUser:self.Leser inProjekt:[self.ProjektPfad lastPathComponent]];
      
      
   }
   
   
   //
   [self resetRecPlay];
   return 0;
}

- (void)resetRecPlay
{
   //NSLog(@"resetRecPlay");
   if ([self.playBalkenTimer isValid])
   {
      [self.playBalkenTimer invalidate];
   }
   
   [self stopAVRecord:NULL];
   [Utils stopTimeout];
   [self.ArchivnamenPop selectItemAtIndex:0];
   [self.Leserfeld setStringValue:@""];
   [[self.TitelPop cell]setStringValue:@""];
   [self.TitelPop removeAllItems];
   [self resetArchivPlayer:nil];
   [self clearArchivKommentar];
   [self.KommentarView setString:@""];
   [self.KommentarView setEditable:NO];
   [self.TitelPop setEnabled:NO];
   
   [self clearArchiv];
   self.QTKitGesamtAufnahmezeit=0;
   self.Leser =@"";
   [self.Abspieldauerfeld setStringValue:@""];
   [self.Zeitfeld setStringValue:@"00:00"];
//   [RecPlayFenster makeFirstResponder:RecPlayFenster];
   
   self.aktuellAnzAufnahmen=0;
   [self.StartRecordKnopf setEnabled:YES];
   [self.StopRecordKnopf setEnabled:NO];
   [self.StartPlayKnopf setEnabled:NO];
   [self.StopPlayKnopf setEnabled:NO];
   [self.BackKnopf setEnabled:NO];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   [self.LogoutKnopf setEnabled:NO];
   
   //LeserPfad  =@"";
}

- (OSErr) Versorgen
{
   
   return 0;
}



- (OSErr)Aufnahmevorbereiten
{
   OSErr err=noErr;
   FSSpec 		outFileSpec;
   
   //FSRef		neueAufnahmeRef;
   //FSSpec		neueAufnahmeSpec;
   FSRef		DokumentordnerRef;
   
   OSStatus status;
   UniChar buffer[255]; // HFS+ filename max is 255
   
   //Quelle: void makeUserCopyOfFile(NSString* file) //aus LowLevel Filemanager
   
   NSString* neueAufnahmeName=[NSString stringWithFormat:@"neueAufnahme.mov"];
   //[neueAufnahmeName autorelease];
   [neueAufnahmeName getCharacters:buffer];
   NSArray *PfadArray;
   //NSString *neueAufnahmePfad;
   //int i=1;
   NSFileManager *Manager = [NSFileManager defaultManager];
   PfadArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   //NSLog(@"PfadArray  : %@",[PfadArray description]);
   if ([PfadArray count] > 0)
   { //
      //neueAufnahmePfad = [[PfadArray objectAtIndex:0] stringByAppendingPathComponent:[neueAufnahme lastPathComponent]];
      //i++;
      NSString *DokumentordnerPfad = [PfadArray objectAtIndex:0];//[LeseboxPfad stringByDeletingLastPathComponent];
      
      //status = FSPathMakeRef((UInt8*)[DokumentordnerPfad fileSystemRepresentation],  &DokumentordnerRef, NULL);
      //neueAufnahmePfad=[NSString stringWithString:Dokumentordner];
      self.neueAufnahmePfad=[DokumentordnerPfad stringByAppendingPathComponent:neueAufnahmeName];
      //NSLog(@"Aufnahmevorbereiten  neueAufnahmePfad: %@",neueAufnahmePfad);
      
      
      
      
      status=YES;
      
   }//if PfadArray count
   
   [self.Zeitfeld setStringValue:@"00:00"];
   self.Pause=0;
   self.QTKitPause=0;
   //[neueAufnahmePfad release];
   //[PfadArray release];
   //**
   
   return status;
}

- (IBAction)neuOrdnen:(id)sender
{
 //  [self.AdminPlayer Leseboxordnen];
}
- (IBAction)resetLesebox:(id)sender
{
   //NSLog(@"resetLesebox");
   [self resetArchivPlayer:sender];
   [self.RecPlayTab selectFirstTabViewItem:sender];
   [self.ArchivnamenPop selectItemAtIndex:0];
   [self.Leserfeld setStringValue:@""];
   [self.ArchivDaten deleteAllRows];
   [self.ArchivView reloadData];
   [self.ArchivDatumfeld setStringValue:@""];
   [self.ArchivAbspieldauerFeld setStringValue:@""];
   [self.ArchivTitelfeld setStringValue:@""];
   [self.ArchivKommentarView setString:@""];
   [self.TitelPop removeAllItems];
   [self.TitelPop setStringValue:@""];
   [self.TitelPop deselectItemAtIndex:0];
   [self.Abspieldauerfeld setStringValue:@""];
   [self.KommentarView setString:@""];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   self.aktuellAnzAufnahmen=0;
}

- (IBAction)setLesebox:(id)sender;	// Nicht verwendet
{
   BOOL erfolg;
   OSErr err=0;
   NSLog(@"setLesebox Modus: %d",self.RPModus);
   //if Umgebung==1
   switch (self.Umgebung)
   {
      case kAdminUmgebung:
      {
         NSLog(@"setLeseboxcase 1");
         erfolg=[self setNetworkLeseboxPfad:nil];
         if (erfolg)
         {
  //          [self.AdminPlayer setAdminPlayer: self.LeseboxPfad inProjekt:[self.ProjektPfad lastPathComponent]];
         }
      }break;
      case kRecPlayUmgebung:
      {
         NSLog(@"setLeseboxcase 0");
 //        if ([AufnahmeGrabber isRecording])
//return;
         [self resetLesebox:sender];
         BOOL erfolg=[self setNetworkLeseboxPfad:nil];
         
         err=[self Leseboxeinrichten];
         
      }break;
      case 2:
      {
         NSLog(@"setLesebox case 2");
      }break;
   }
   
}

- (BOOL)setHomeLeseboxPfad:(id)sender
{
   BOOL antwort=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempLeseboxPfad=[NSString stringWithString:NSHomeDirectory()];
   NSString* s=NSLocalizedString(@"Lesebox",@"Lesebox");
   tempLeseboxPfad=[[tempLeseboxPfad stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:s];
   //tempLeseboxPfad=[tempLeseboxPfad stringByAppendingPathComponent:@"Lesebox"];
   if ([Filemanager fileExistsAtPath:tempLeseboxPfad])//Es gibt eine Lesebox auf Home
	  {
        if (self.LeseboxPfad)
        {
           self.LeseboxPfad=(NSMutableString*)tempLeseboxPfad;
        }
        else
        {
           self.LeseboxPfad=[NSMutableString stringWithString:tempLeseboxPfad];//M
        }
        antwort=YES;
     }
   return antwort;
}


- (BOOL)setNetworkLeseboxPfad:(id)sender
{
   BOOL erfolg=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSOpenPanel * LeseboxDialog=[NSOpenPanel openPanel];
   [LeseboxDialog setCanChooseDirectories:YES];
   [LeseboxDialog setCanChooseFiles:NO];
   [LeseboxDialog setAllowsMultipleSelection:NO];
   [LeseboxDialog setMessage:@"Auf welchem Computer ist die Lesebox zu finden?"];
   [LeseboxDialog setCanCreateDirectories:NO];
   NSString* tempLeseboxPfad;
   int LeseboxHit=0;
   {
      
      //LeseboxHit=[LeseboxDialog runModalForDirectory:DocumentsPfad file:@"Lesebox" types:nil];
      LeseboxHit=[LeseboxDialog runModal] ;//]ForDirectory:NSHomeDirectory() file:@"Volumes" types:nil];
      [LeseboxDialog  setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
   }
   if (LeseboxHit==NSOKButton)
	  {
        tempLeseboxPfad=[[LeseboxDialog URL]path]; //"home"
        
        tempLeseboxPfad=[tempLeseboxPfad stringByAppendingPathComponent:@"Documents"];
        NSString* lb=NSLocalizedString(@"Lesebox",@"Lesebox");
        tempLeseboxPfad=[tempLeseboxPfad stringByAppendingPathComponent:lb];
        self.LeseboxPfad=(NSMutableString*)tempLeseboxPfad;
        NSLog(@"setNetworkLeseboxPfad:   LeseboxPfad: %@",self.LeseboxPfad);
        
        
        if ([Filemanager fileExistsAtPath:tempLeseboxPfad ])
        {
           NSLog(@"AdminLeseboxPfad da: %@",tempLeseboxPfad);
           erfolg=YES;
        }
        else
        {
           //int Antwort=NSRunAlertPanel(@"Keine Lesebox", @"Im Ordner 'Dokumente' muss ein Ordner mit dem Namen 'Lesebox' eingerichtet sein",@"OK", NULL,NULL);
           return NO;
        }
     }
   
   return erfolg;
}

- (void)ListeAktualisierenAktion:(NSNotification*)note
{
   [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
   [self setLeserliste:NULL];
}

- (IBAction)LeserListeAktualisieren:(id)sender
{
   [Utils setPListBusy:NO anPfad:self.LeseboxPfad];
   [self anderesProjektEinrichtenMit:[self.ProjektPfad lastPathComponent]];
   [self setLeserliste:NULL];
   [self setProjektMenu];
   
   
}

- (IBAction)setLeserliste:(id)sender
{
   
   switch (self.Umgebung)
   {
      case kAdminUmgebung:
      {
         NSLog(@"setLeserliste RPModus=2");
         [self SessionListeAktualisieren];
         
    //     [self.AdminPlayer resetAdminPlayer];
         
    //     [self.AdminPlayer setAdminProjektArray:self.ProjektArray];
    //     [self.AdminPlayer setAdminPlayer:self.LeseboxPfad inProjekt:[self.ProjektPfad lastPathComponent]];
         
      }break;
      case kRecPlayUmgebung:
      {
         NSLog(@"setLeserliste RPModus=0");
         //29.1.
         [self SessionListeAktualisieren];
         [self setArchivNamenPop];
         //
         
         //[self Leseboxvorbereiten];
      }break;
   }
   
}







- (void)setArchivNamenPopMitProjektArray:(NSArray*)derProjektArray
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSDictionary* tempProjektDic;
   NSArray* tempProjektNamenArray=[Utils ProjektNamenArrayVon:[self.LeseboxPfad stringByAppendingPathComponent:@"Archiv"]];
   int ProjektIndex=[[derProjektArray valueForKey:@"projekt"]indexOfObject:[self.ProjektPfad lastPathComponent]];
   NSCalendarDate* ProjektSessionDatum;
   if (ProjektIndex<NSNotFound)
   {
      //Dic des aktuellen Projekts im Projektarray
      tempProjektDic=[derProjektArray objectAtIndex:ProjektIndex];
      if ([tempProjektDic objectForKey:@"sessiondatum"])
      {
         ProjektSessionDatum=[tempProjektDic objectForKey:@"sessiondatum"];
      }
      else
      {
         ProjektSessionDatum=[NSCalendarDate date];
      }
      
   }
   //NSLog(@"ProjektSessionDatum: %@",ProjektSessionDatum);
   
   int PopAnz=[self.ArchivnamenPop numberOfItems];
   //NSLog(@"ArchivnamenPop numberOfItems %d",PopAnz);
   
   if (PopAnz>1)//Alle ausser erstes Item entfernen (Name wählen)
   {
      while (PopAnz>1)
      {
         
         //NSLog(@"ArchivnamenPop removeItemAtIndex  %@",[[ArchivnamenPop itemAtIndex:1]description]);
         [self.ArchivnamenPop removeItemAtIndex:1];
         PopAnz--;
         
      }
   }
   
   NSString* NamenwahlString=NSLocalizedString(@"Choose name",@"Namen auswählen");
   NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:[NSColor purpleColor], NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
   NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:NamenwahlString attributes:tempItemAttr];
   [[self.ArchivnamenPop itemAtIndex:0]setAttributedTitle:tempNamenItem];
   
   //SessionListe konfig: vorhandene Namen im ProjektArray mit SessionListe abgleichen
   
   //Sessioleserarray
   NSArray* tempSessionLeserArray=[self SessionLeserListeVonProjekt:[self.ProjektPfad lastPathComponent]];
   
   //NSLog(@"tempSessionLeserArray 1: %@",[tempSessionLeserArray description]);
   NSEnumerator* NamenEnum=[tempProjektNamenArray objectEnumerator];
   id einName;
   while (einName=[NamenEnum nextObject])
   {
      //NSLog(@"einName: %@",einName);
      [self.ArchivnamenPop addItemWithTitle:einName];
   }
	  
   NSEnumerator* SessionNamenEnum=[tempProjektNamenArray objectEnumerator];//Projektnamen im Archiv
   id einSessionName;
   int ItemIndex=1;
   while (einSessionName=[SessionNamenEnum nextObject])
   {
      //NSLog(@"tempProjektNamenArray index: %d: einSessionName: %@",ItemIndex,einSessionName);
      BOOL NameDa=NO;
      
      
      if (tempSessionLeserArray &&[tempSessionLeserArray containsObject:einSessionName])
      {
         //NSLog(@"Name da: %@",einSessionName);
         NameDa=YES;//Name ist in der Sessionsliste
      }
      
      //		[ArchivnamenPop addItemWithTitle:einSessionName];
      NSColor* itemColor=[NSColor blackColor];
      if (NameDa)
      {
         // itemColor=[NSColor greenColor];
         NSColor* SessionColor=[NSColor colorWithDeviceRed:66.0/255 green:185.0/255 blue:37.0/255 alpha:1.0];
         itemColor=SessionColor;
         
      }
      else
      {
         //			   itemColor=[NSColor blackColor];
      }
      
      NSDictionary* tempItemAttr=[NSDictionary dictionaryWithObjectsAndKeys:itemColor, NSForegroundColorAttributeName,[NSFont systemFontOfSize:13], NSFontAttributeName,nil];
      NSAttributedString* tempNamenItem=[[NSAttributedString alloc]initWithString:einSessionName attributes:tempItemAttr];
      //		[[ArchivnamenPop itemAtIndex:[ArchivnamenPop numberOfItems]-1]setAttributedTitle:tempNamenItem];
      if ([self.ArchivnamenPop numberOfItems]>2)
      {
         [[self.ArchivnamenPop itemAtIndex:ItemIndex]setAttributedTitle:tempNamenItem];
      }
      
      ItemIndex++;
      
   }//while
   
   //NSLog(@"setArchivnamenPop tempProjektNamenArray: %@",[tempProjektNamenArray description]);
   //	  [ArchivnamenPop addItemsWithTitles:tempProjektNamenArray];
   
   [self.Zeitfeld setSelectable:NO];
//*   [RecPlayFenster makeFirstResponder:RecPlayFenster];
   
   
}

- (OSErr)Leseboxeinrichten	//	Nicht verwendet
{
   //Die Lesebox ist da und vollständig
   NSLog(@"Leseboxeinrichten		LeseboxPfad: %@",self.LeseboxPfad);
   OSErr err=0;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray * Leseboxobjekte=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.LeseboxPfad error:NULL]];
   
   int AnzLeseboxObjekte=[Leseboxobjekte count];
   
   NSString* LeserNamenListe=[Leseboxobjekte description];
   
   if (AnzLeseboxObjekte &&[[Leseboxobjekte objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
   {
      [Leseboxobjekte removeObjectAtIndex:0];
      AnzLeseboxObjekte--;
   }
   
   
   NSString* LeserNamenListesauber=[Leseboxobjekte description];
   
   NSEnumerator *enumerator = [Leseboxobjekte objectEnumerator];
   id anObject;
   NSString* tempString;
   
   NSString* ArchivString=[NSString stringWithFormat:@"Archiv"];
   NSString* KommentarString=NSLocalizedString(@"Comments",@"Anmerkungen");
   self.ArchivPfad=[self.LeseboxPfad stringByAppendingPathComponent:ArchivString];//Pfad des Archiv-Ordners
   
   if ([Filemanager fileExistsAtPath:self.ProjektPfad])
   {
      NSMutableArray * ArchivProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.ArchivPfad error:NULL]];
      int AnzArchivProjektNamenArray=[ArchivProjektNamenArray count];											//Anzahl Leser
      LeserNamenListe=[ArchivProjektNamenArray description];
      
      if ([[ArchivProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
      {
         [ArchivProjektNamenArray removeObjectAtIndex:0];
         AnzArchivProjektNamenArray--;
      }
      
      int PopAnz=[self.ArchivnamenPop numberOfItems];
      NSLog(@"ArchivnamenPop numberOfItems %d",PopAnz);
      if (PopAnz>1)//Alle ausser erstel Item entfernen (Name wählen)
      {
         while (PopAnz>1)
         {
            
            //NSLog(@"ArchivnamenPop removeItemAtIndex  %@",[[ArchivnamenPop itemAtIndex:1]description]);
            [self.ArchivnamenPop removeItemAtIndex:1];
            PopAnz--;
            
         }
      }
      
      
      
      [self.ArchivnamenPop addItemsWithTitles:ArchivProjektNamenArray];
//*      [RecPlayFenster makeFirstResponder:RecPlayFenster];
      [self.Zeitfeld setSelectable:NO];
      //AnzAdminProjektNamenArray++;
      
      
   }			//Archivpfad
   
   
   
   return err;
}


- (BOOL)LeseboxEinrichtenAnPfad:(NSString*)derProjektPfad	//	Nicht verwendet
{
   //Die Lesebox ist da und vollständig
   NSLog(@"LeseboxEinrichtenAnPfad: %@\nProjektArray: %@",derProjektPfad,[self.ProjektArray description]);
   OSErr err=0;
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* LeserNamenListe;
   if ([Filemanager fileExistsAtPath:self.ProjektPfad])
	  {
        NSMutableArray * tempProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:derProjektPfad error:NULL]];
        int AnzAdminProjektNamenArray=[tempProjektNamenArray count];											//Anzahl Leser
        //Leserself.NamenListe=[ProjektNamenArray description];
        
        if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
        {
           [tempProjektNamenArray removeObjectAtIndex:0];
           AnzAdminProjektNamenArray--;
        }
        
        int PopAnz=[self.ArchivnamenPop numberOfItems];
        NSLog(@"ArchivnamenPop numberOfItems %d",PopAnz);
        if (PopAnz>1)//Alle ausser erstel Item entfernen (Name wählen)
        {
           while (PopAnz>1)
           {
              
              //NSLog(@"ArchivnamenPop removeItemAtIndex  %@",[[ArchivnamenPop itemAtIndex:1]description]);
              [self.ArchivnamenPop removeItemAtIndex:1];
              PopAnz--;
              
           }
        }
        
        [self.ArchivnamenPop addItemsWithTitles:tempProjektNamenArray];
//*        [RecPlayFenster makeFirstResponder:RecPlayFenster];
        [self.Zeitfeld setSelectable:NO];
        //AnzAdminProjektNamenArray++;
        
        
     }			//Archivpfad
   
   
   
   return err;
}



- (NSArray*)ProjektNamenArrayVon:(NSString*)derArchivPfad
{
   NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempProjektNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   if ([Filemanager fileExistsAtPath:derArchivPfad isDirectory:&istOrdner]&&istOrdner)
   {
      tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:derArchivPfad error:NULL];
      if ([tempArray count])
      {
         if ([[tempArray objectAtIndex:0] hasPrefix:@".DS"])
         {
            [tempArray removeObjectAtIndex:0];
         }
      }//count
      if ([tempArray count])
      {
         NSEnumerator* ProjektEnum=[tempArray objectEnumerator];
         id einProjekt;
         while (einProjekt=[ProjektEnum nextObject])
         {
            if (![[Filemanager contentsOfDirectoryAtPath:einProjekt error:NULL] count])
            {
               [tempProjektNamenArray addObject:[einProjekt lastPathComponent]];
            }//count
         }//while
      }//count
      //NSLog(@"tempProjektNamenArray: %@",[tempProjektNamenArray description]);
   }//fileExists
   return tempProjektNamenArray;
}


- (BOOL)setKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
{
   BOOL erfolg=YES;
   BOOL istDirectory;
   NSString* tempLeser=[derLeser copy];
   
   NSString* tempAufnahme;
   //[tempAufnahme retain];
   tempAufnahme=[dieAufnahme copy];
   NSString* KommentarOrdnerString=NSLocalizedString(@"Comments",@"Anmerkungen");
   NSString* tempKommentarOrdnerPfad=[[self.LeserPfad copy]stringByAppendingPathComponent:KommentarOrdnerString];
   
   NSString* tempKommentarPfad=[NSString stringWithString:self.ProjektPfad];
   
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   if ([Filemanager fileExistsAtPath:tempKommentarOrdnerPfad])
   {
      erfolg=YES;
   }
   else
   {
      erfolg=[Filemanager createDirectoryAtPath:tempKommentarOrdnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
      
   }
   
   if (erfolg)
   {
      NSString* testString;
      testString=@"Bemerkungen:";
      tempKommentarPfad=[tempKommentarOrdnerPfad stringByAppendingPathComponent:tempAufnahme];
      if (![Filemanager fileExistsAtPath:tempAufnahme])
      {
         NSString* Kommentarstring=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
         NSString*inhalt =[self KommentarVon:Kommentarstring];
         if (inhalt)
         {
            [self.KommentarView setString:inhalt];
         }
         //[KommentarView setEditable:NO];
      }
      
   }
   else
   {
      return erfolg;
   }
   return erfolg;
}//Beurteilungvorbereiten


- (void)setTimerfunktion:(NSTimer *)derTimer
{
   //if (!playingOK)
   //NSLog(@"idle");
   //OSErr err=Recorder->Idlefunktion();
   OSErr err=0;
   //err=[AufnahmeGrabber Idlefunktion];
   if (err)
   {
      NSLog(@"Idle-Error: %d Dauer: %ld",err, self.Aufnahmedauer);
      [self stopAVRecord:nil];
   }
   //BOOL fertig=Recorder->PlayingTask();
   if (self.Durchgang  ==2)
   {
      //int l=Recorder->Level;
      //NSLog(@"Level:%d",l);
      //[Levelfeld setIntValue:l];
      
      //[Levelmeter setLevel:l];
      //[Levelmeter display];
      //[Levelbalken setDoubleValue:l];
      //[Volumesteller setFloatValue: l];
      self.Durchgang=0;
      
   }
   self.Durchgang++;
   return;
}



- (NSString*)Zeitformatieren:(long) dieSekunden
{
   //NSLog(@"Zeitformatieren dieSekunden: %d",dieSekunden);
   short Sekunden=dieSekunden%60;
   short Minuten=dieSekunden/60;
   NSNumber * n=0;
   n=[NSNumber numberWithLong:Minuten];
   NSString * stringMinuten=[n stringValue];
   n=[NSNumber numberWithLong:Sekunden];
   NSString*  stringSekunden=[n stringValue];
   NSString* stringZeit;
   if (Minuten < 10)
   {
      stringZeit=@"0";
      stringZeit=[stringZeit stringByAppendingString:stringMinuten];
   }
   else
   {
      stringZeit=[NSString stringWithString:stringMinuten];
   }
   stringZeit=[stringZeit stringByAppendingString:@":"];
   
   if (Sekunden<10)
   {
      
      stringZeit=[stringZeit stringByAppendingString:@"0"];
   }
   stringZeit=[stringZeit stringByAppendingString:stringSekunden];
   //NSLog(@"Zeitformatieren dieSekunden: %d stringZeit: %@",dieSekunden,stringZeit);
   return stringZeit;
   
}

- (void)Logout:(id)sender
{
   
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"OK"];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   [Warnung setMessageText:@"Alles gesichert?:"];
   [Warnung setInformativeText:@"Es werden alle ungesicherten Aufnahmen geloescht."];
   [Warnung setAlertStyle:NSWarningAlertStyle];
   int modalAntwort=[Warnung runModal];
   //NSLog(@"Logout modalAntwort: %d",modalAntwort);
   switch (modalAntwort)
   {
      case NSAlertFirstButtonReturn:
      {
         //NSLog(@"NSAlertFirstButtonReturn");
      }break;
      case NSAlertSecondButtonReturn:
      {
         //NSLog(@"NSAlertSecondButtonReturn");
         return;
      }break;
         
   }//switch
   
   
   [self ArchivZurListe:nil];
   
   [self stopPlay:nil];
   [self resetRecPlay];
   [self stopAVRecord:nil];
   
   [self.TitelPop setEnabled:NO];
   [self.StartRecordKnopf setEnabled:YES];
   [self.StartPlayKnopf setEnabled:NO];
   [self.StopPlayKnopf setEnabled:NO];
   [self.BackKnopf setEnabled:NO];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   [self.LogoutKnopf setEnabled:NO];
   
//*   [RecPlayFenster makeFirstResponder:RecPlayFenster];
   [self.KommentarView setString:@""];
   [self.KommentarView setEditable:NO];
   [self.TitelPop setEnabled:NO];
   [self clearArchiv];
   self.QTKitGesamtAufnahmezeit=0;
   self.aktuellAnzAufnahmen=0;
}


- (IBAction)setLeser:(id)sender
{
   /*
   if ([AufnahmeGrabber isRecording])
   {
      NSString* s1=NSLocalizedString(@"Still Playing",@"Wiedergabe läuft");
      NSString* s2=NSLocalizedString(@"The Name cannot be altered while playing",@"Name kann nicht geändert werden während Abspielen");
      int Antwort=NSRunAlertPanel(s1,s2,@"OK", @"Stop",NULL);
      NSLog(@"Antwort: %d",Antwort);
      if (Antwort==1)
      {
         NSLog(@"Wiedergabe lauft: Antwort=1  weiter");
         return;
      }
      if (Antwort==0)
      {
         NSLog(@"Wiedergabe lauft: Antwort=0  stop");
         [self stopAVRecord:nil];
         NSString* s1=NSLocalizedString(@"Recording Stopped",@"Aufnahme abgebrochen");
         NSString* s2=NSLocalizedString(@"Should the stopped record be saved?",@"Abgebrochene Aufnahme sichern?");
         int Antwort=NSRunAlertPanel(s1, s2,NSLocalizedString(@"YES",@"JA"), NSLocalizedString(@"NO",@"NEIN"),NULL);
         if (Antwort==0)
         {
            NSLog(@"Aufnahme abgebrochen: Antwort=0  return");
            return;
         }
         if (Antwort==1)
         {
            NSLog(@"Aufnahme abgebrochen: Antwort=1  saveRecord");
            [self saveRecord:nil];
            
         }
      }
   }
    */
   NSLog(@"setLeser: LeserPfad: %@ ",[self.LeserPfad description]);
   //NSLog(@"setLeser: ProjektPfad: %@",[ProjektPfad description]);
   //NSLog(@"setLeser		  ProjektPfad 2:retainCount %d",[ProjektPfad retainCount]);
   
   //[ArchivnamenPop synchronizeTitleAndSelectedItem];
   //NSLog(@"setLeser		ProjektPfad9:retainCount %d",[ProjektPfad retainCount]);
   
   //	[AufnahmeGrabber prepare];
   
//   OSErr err=[AufnahmeGrabber startRecord];
   
//   [AufnahmeGrabber stopRecord];
   
   
   
   if ([[sender titleOfSelectedItem] length]>0)
   {
      self.Leser=[NSString stringWithString:[sender titleOfSelectedItem]];
      //NSLog(@"setLeser: neuer Leser: %@",Leser);
      
      self.LeserPfad=[self.ProjektPfad stringByAppendingPathComponent:self.Leser];
      //NSLog(@"setLeser: neuer LeserPfad: %@",[self.LeserPfad description]);
      if (self.mitUserPasswort)
      {
         BOOL PasswortOK=NO;
         NSData* tempPWData=[NSData data];
         NSEnumerator* PWEnum=[self.UserPasswortArray objectEnumerator];
         id einNamenDic;
         int index=0;
         int position=-1;
         while(einNamenDic=[PWEnum nextObject])
         {
            if ([[einNamenDic objectForKey:@"name"]isEqualToString:self.Leser])
            {
               if (position<0)//erstes Auftreten
               {
                  tempPWData=[einNamenDic objectForKey:@"pw"];
                  position=index;
               }
            }//if
            index++;
         }//while einNamenDic
         //const char* altespw=[@"anna" UTF8String];
         //tempPWData =[NSData dataWithBytes:altespw length:strlen(altespw)];
         
         NSMutableDictionary* tempPWDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempPWDictionary setObject:self.Leser forKey:@"name"];
         [tempPWDictionary setObject:tempPWData forKey:@"pw"];
         NSLog(@"setLeser	tempPWDictionary: %@",[tempPWDictionary description]);
         if ([tempPWData length])
         {
            PasswortOK=[Utils confirmPasswort:tempPWDictionary];
         }
         else
         {
            //NSLog(@"UserPasswortArray vor changePasswort: %@\n",[UserPasswortArray description]);
            //NSLog(@"tempPWDictionary vor changePasswort: %@",[tempPWDictionary description]);
            NSMutableDictionary* neuesPWDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            
            neuesPWDic=(NSMutableDictionary*)[Utils changePasswort:tempPWDictionary];
            
            //NSLog(@"tempPWDictionary in setLeser nach changePasswort: %@",[tempPWDictionary description]);
            
            //NSLog(@"UserPasswortArray nach changePasswort: %@\n",[UserPasswortArray description]);
            
            NSLog(@"neuesPWDic: %@",[neuesPWDic description]);
            if ([neuesPWDic objectForKey:@"pw"]&&[[neuesPWDic objectForKey:@"pw"]length])
            {
               PasswortOK=YES;
               //NSEnumerator* neuesPWEnum=[UserPasswortArray objectEnumerator];
               if (position>=0)//Leser hat ein PWDic im UserPasswortArray
               {
                  NSLog(@"Leser %@ hat ein PWDic im UserPasswortArray",self.Leser);
                  [self.UserPasswortArray replaceObjectAtIndex:position withObject:neuesPWDic];
               }
               else
               {
                  //NSLog(@"Alter PasswortArray: %@\nLeser %@ hat kein PWDic im UserPasswortArray\nneues PWDic: %@ ",[UserPasswortArray description],Leser,[neuesPWDic description]);
                  [self.UserPasswortArray addObject:neuesPWDic];
                  //NSLog(@"neuer UserPasswortArray: %@\n",[UserPasswortArray description]);
                  //[UserPasswortArray sortUsingSelector:@selector(compare:)];
                  //UserPasswortArray=[UserPasswortArray sortedArrayUsingFunction:ArrayOfDicSort context:@"name"];
                  
               }
               [self saveUserPasswortArray:self.UserPasswortArray];
            }
            
         }
         
         if(!PasswortOK)
         {
            NSLog(@"Passwort nicht OK");
            [sender selectItemAtIndex:0];
            [self resetLesebox:NULL];
            return;
         }
      }//mitUserPasswort
   }//if ([[sender titleOfSelectedItem] length]>0)
   
   [self.LogoutKnopf setEnabled:YES];
   
   [self.Leserfeld setStringValue:[sender titleOfSelectedItem]];
   //NSLog(@"setLeser: alter LeserPfad: %@",[LeserPfad description]);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:self.LeserPfad])
   {
      NSDictionary* Attribute=[Filemanager attributesOfFileSystemForPath:self.LeserPfad error:NULL];
      //NSLog(@"Attribute: %@",[Attribute description]);
      
      //TitelAufnahmen im Ordner Leser
      NSMutableArray* TitelArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.LeserPfad error:NULL]];
      int i;
      self.aktuellAnzAufnahmen=[TitelArray count];
      NSString* tempTitelString;
      NSString* indexTitelString;
      NSString* nextindexTitelString;
      NSString* tempTitelnummerString;
      int tempNummer;
      
      if (self.aktuellAnzAufnahmen)
      {
         if ([[TitelArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
         {
            [TitelArray removeObjectAtIndex:0];
            self.aktuellAnzAufnahmen--;
         }
      }
      int k;
      int Kommentarindex=NSNotFound;
      for (k=0;k<self.aktuellAnzAufnahmen;k++)//'Kommentar' entfernen
      {
         if([[TitelArray objectAtIndex:k] isEqualToString:NSLocalizedString(@"Comments",@"Anmerkungen")])
         {
            Kommentarindex=k;
         }
      }
      //NSLog(@"Kommentarindex: %d",Kommentarindex);
      if (!(Kommentarindex==NSNotFound))
      {
         [TitelArray removeObjectAtIndex:Kommentarindex];
         self.aktuellAnzAufnahmen--;
      }
      //NSLog(@"TitelArray vor Sortieren: %@",[TitelArray description]);
      
      //**
      
      //bei Löschen im Netz: File 'afpDeletedxxxx' suchen
      //NSLog(@"setLeser: bei Löschen im Netz: File 'afpDeletedxxxx' suchen: %@",[TitelArray description]);
      int afpZeile=-1;
      
      for(k=0;k<self.aktuellAnzAufnahmen;k++)
      {
         if ([[[TitelArray objectAtIndex:k]description]characterAtIndex:0]=='.')
         {
            NSLog(@"String mit Punkt: %@ auf Zeile: %d",[[TitelArray objectAtIndex:k]description],k);
            afpZeile=k;
         }
         //NSLog(@"kein Kommentar bei %d",k);
         
      }
      if (afpZeile>=0) //afpDelete entfernen
      {
         [TitelArray removeObjectAtIndex:afpZeile];
         self.aktuellAnzAufnahmen--;
      }
      
      
      
      
      //**
      
      if (self.aktuellAnzAufnahmen)//der Leser hat schon Aufnahmen
      {
         //Array für die Titel in TitelPop
         NSMutableArray* TitelPopArray=[[NSMutableArray alloc] initWithCapacity:self.aktuellAnzAufnahmen];
         int tausch=1;
         
         while (tausch)
         {
            tausch=0;
            for (i=0;i<self.aktuellAnzAufnahmen-1;i++)//sortieren nach nummer
            {
               indexTitelString=[NSString stringWithString:[TitelArray objectAtIndex:i]];
               nextindexTitelString=[NSString stringWithString:[TitelArray objectAtIndex:i+1]];
               int n1=[self AufnahmeNummerVon:indexTitelString];
               int n2=[self AufnahmeNummerVon:nextindexTitelString];
               //NSLog(@"indexTitelString: %@  Nr:%d",indexTitelString,n1);
               //NSLog(@"nextindexTitelString: %@  Nr:%d",nextindexTitelString,n2);
               if(n2<n1)
               {
                  [TitelArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                  //NSLog(@"tausch: n1: %d    n2: %d",n1,n2);
                  tausch++;
               }
               
            }//for anzahl
         }//while tausch
         //NSLog(@"TitelArray nach Sortieren: %@",[TitelArray description]);
         NSMutableArray* AufnahmenPopArray=[[NSMutableArray alloc] initWithCapacity:self.aktuellAnzAufnahmen];
         [self.ArchivDaten resetArchivDaten];
         for (i=[TitelArray count]-1;i>=0;i--)//Reihenfolge umkehren für TitelPop
         {
            [AufnahmenPopArray addObject:[[TitelArray objectAtIndex:i]description]];
            
            [self.ArchivDaten setAufnahmePfad:[[TitelArray objectAtIndex:i]description] forRow:0];
            //NSLog(@"TitelArray :%@END",[[TitelArray objectAtIndex:i]description]);
            //indexTitelString=[NSString stringWithString:[TitelArray objectAtIndex:i]];
            tempTitelString=[self AufnahmeTitelVon:[TitelArray objectAtIndex:i]];
            //NSLog(@"index: %d           tempTitel: %@",i,tempTitelString);
            if (![TitelPopArray containsObject:tempTitelString])
            {
               //[TitelPopArray insertObject:tempTitelString atIndex:tempNummer];
               int letzterPlatz=[TitelPopArray count];
               //NSLog(@"letzterPlatz: %d      indexTitelString: %@ ",letzterPlatz,tempTitelString);
               
               [TitelPopArray insertObject:tempTitelString atIndex:letzterPlatz];
            }
         }//for anzahl
         
         
         
         [self.ArchivView reloadData];
         self.ArchivZeilenhit=NO;
         
         //NSLog(@"AufnahmenPopArray def: %@",[AufnahmenPopArray description]);
         [self.KommentarPop removeAllItems];
         [self.KommentarPop addItemsWithTitles:AufnahmenPopArray];
         //NSLog(@"TitelPopArray def: %@",[TitelPopArray description]);
         [self.TitelPop removeAllItems];
         [self.TitelPop addItemsWithObjectValues:TitelPopArray];
         //NSLog(@"FirstResponder: %@",[[RecPlayFenster firstResponder]description]);
         //[TitelPop selectText:nil];
         
         //Titel von PList aus Projektordner anfügen
         BOOL PListTitelAktiviert=YES;
         BOOL TitelEditOK=NO;//Titel editierbar?
         NSArray* tempTitelArray;
         NSArray* tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];//Verzeichnis ProjektNamen
         int ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];//Dic des akt. Projekts
         if (!(ProjektIndex==NSNotFound))
         {
            NSDictionary* tempProjectDic=[self.ProjektArray objectAtIndex:ProjektIndex];
            if ([tempProjectDic objectForKey:@"fix"])
            {
               TitelEditOK=![[tempProjectDic objectForKey:@"fix"]boolValue];//Titel sind nicht fixiert
            }
            
            if ([tempProjectDic objectForKey:@"titelarray"])
            {
               tempTitelArray=[NSArray arrayWithArray:[tempProjectDic objectForKey:@"titelarray"]];
               //NSLog(@"tempTitelArray: %@ [TitelPop objectValues]: %@",[tempTitelArray description],[[TitelPop objectValues]description]);
               NSEnumerator* TitelEnum=[tempTitelArray objectEnumerator];
               id einTitelDic;
               while (einTitelDic=[TitelEnum nextObject])
               {
                  //NSLog(@"einTitelDic: %@",[einTitelDic description]);
                  NSString* tempTitel=[einTitelDic objectForKey:@"titel"];
                  if ([[einTitelDic objectForKey:@"ok"]boolValue]&&[tempTitel length])
                  {
                     [self.TitelPop addItemWithObjectValue:tempTitel];
                  }
               }//while
               
            }//if ([[ProjektArray objectAtIndex:ProjektIndex]objectForKey:@"titelarray"])
         }//if (!(ProjektIndex==NSNotFound))
         
         NSLog(@"setLeser nicht leer: LeserPfad: %@ titelfix : %d ",[self.LeserPfad description], TitelEditOK);
         
         
         [self.TitelPop setEnabled:YES];
         [self.TitelPop setEditable:TitelEditOK];//Nur wenn Titel editierbar
         [self.TitelPop setSelectable:TitelEditOK];
         
         BOOL first=[self.RecPlayFenster makeFirstResponder:self.TitelPop];
         
         [self.TitelPop performClick:nil];
         [self.TitelPop selectItemAtIndex:0];
         
         
         [self setKommentarFuerLeser:self.Leser FuerAufnahme:[[TitelArray objectAtIndex:[TitelArray count]-1]description]];
         
      }//if aktuellAnzAufnahmen
      else //noch keine Aufnahmen im Ordner
      {
         
         [self.TitelPop removeAllItems];
         
         //Titel von PList aus Projektordner anfügen
         BOOL PListTitelAktiviert=YES;
         BOOL TitelEditOK=NO;//Titel editierbar?
         NSArray* tempTitelArray;
         NSArray* tempProjektNamenArray=[self.ProjektArray valueForKey:@"projekt"];//Verzeichnis ProjektNamen
         int ProjektIndex=[tempProjektNamenArray indexOfObject:[self.ProjektPfad lastPathComponent]];//Dic des akt. Projekts
         if (!(ProjektIndex==NSNotFound))
         {
            NSDictionary* tempProjectDic=[self.ProjektArray objectAtIndex:ProjektIndex];
            if ([tempProjectDic objectForKey:@"fix"])
            {
               TitelEditOK=![[tempProjectDic objectForKey:@"fix"]boolValue];//Titel sind nicht fixiert
            }
            
            if ([tempProjectDic objectForKey:@"titelarray"])
            {
               tempTitelArray=[NSArray arrayWithArray:[tempProjectDic objectForKey:@"titelarray"]];
               //NSLog(@"tempTitelArray: %@ [TitelPop objectValues]: %@",[tempTitelArray description],[[TitelPop objectValues]description]);
               NSEnumerator* TitelEnum=[tempTitelArray objectEnumerator];
               id einTitelDic;
               while (einTitelDic=[TitelEnum nextObject])
               {
                  //NSLog(@"einTitelDic: %@",[einTitelDic description]);
                  NSString* tempTitel=[einTitelDic objectForKey:@"titel"];
                  if ([[einTitelDic objectForKey:@"ok"]boolValue]&&[tempTitel length])
                  {
                     [self.TitelPop addItemWithObjectValue:tempTitel];
                  }
               }//while
               
            }//if ([[ProjektArray objectAtIndex:ProjektIndex]objectForKey:@"titelarray"])
         }//if (!(ProjektIndex==NSNotFound))
         
         [self.TitelPop setEnabled:YES];
         
         if ([self.TitelPop numberOfItems]==0)//keine Titel aus PList
         {
            TitelEditOK=YES;//Eingabe eines ersten Titels ermöglichen
         }
         
         if (TitelEditOK)//Titel sind editierbar
         {
            [self.TitelPop addItemWithObjectValue:@"neue Aufnahme"];
         }
         //NSLog(@"setLeser leer: LeserPfad: %@ titelfix : %d ",[LeserPfad description], TitelEditOK);
         
         [self.TitelPop setEditable:TitelEditOK];//Nur wenn Titel editierbar
         [self.TitelPop setSelectable:TitelEditOK];
         
         [self.TitelPop selectItemAtIndex:0];
         [self.ArchivDaten resetArchivDaten];
         [self.ArchivView reloadData];
         self.aktuellAnzAufnahmen=0;
      }
      
      
      
   }//if ([Filemanager fileExistsAtPath:LeserPfad])
   
   
   
   //	[AufnahmeGrabber prepare];
   
   [self setArchivView];
   
   [Utils startTimeout:self.TimeoutDelay];
}



- (IBAction)setTitel:(id)sender
{
   //int i=[sender indexOfSelectedItem];
   //NSLog(@"setTitel index: %d  Item: %@",i,[sender objectValueOfSelectedItem]);
   //NSLog(@"Titel: %@",[self titel]);
   
}

- (NSString*)titel
{
   
   return [[self.TitelPop cell]stringValue];
}

- (BOOL)istAktiviert:(NSString*)dasProjekt
{
   BOOL checkAktiviert=NO;
   if ([self.ProjektArray count])
   {
      //NSLog(@"istAktiviert Projekt: %@ ProjektArray: %@",dasProjekt,[ProjektArray description]);
      NSEnumerator* ProjektEnum=[self.ProjektArray objectEnumerator];
      id einProjekt;
      while (einProjekt=[ProjektEnum nextObject])
      {
         if ([einProjekt objectForKey:projekt])
         {
            //NSLog(@"istAktiviert einProjekt: %@",[einProjekt description]);
            if([[einProjekt objectForKey:projekt]isEqualToString:dasProjekt])
            {
               checkAktiviert= [[einProjekt objectForKey:OK]boolValue];
            }
            //NSLog(@"istAktiviert einProjekt: %@ checkAktiviert: %d",[einProjekt description],checkAktiviert);
         }
      }//while
      
   }//count
   return checkAktiviert;
}




- (IBAction)switchAdminPlayer:(id)sender
{
   NSLog(@"switchAdminPlayer start");
   [Utils stopTimeout];
   if ([self checkAdminZugang])
   {
      NSLog(@"switchAdminPlayer ok");
      [[self.ModusMenu itemWithTag:kRecPlayTag]setEnabled:YES];
      [self beginAdminPlayer:nil];
   }
   else
   {
      [Utils startTimeout:self.TimeoutDelay];
      NSBeep();
      NSLog(@"switchAdminPlayer abgebrochen");
      
   }
}


- (IBAction)beginRecPlay:(id)sender
{
   if(self.Umgebung==kRecPlayUmgebung)
      return;
   if (![self istAktiviert:[self.ProjektPfad lastPathComponent]])
   {
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      //[Warnung addButtonWithTitle:@"Cancel"];
      [Warnung setMessageText:NSLocalizedString(@"This Project is not activated",@"Projekt ist nicht aktiviert")];
      [Warnung setInformativeText:NSLocalizedString(@"The recorder cannot be opened",@"Recorder kann nicht geöffnet werden.")];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      NSImage* RPImage = [NSImage imageNamed: @"MicroIcon"];
      [Warnung setIcon:RPImage];
      /*
      [Warnung beginSheetModalForWindow:[self.AdminPlayer window]
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:@"keineLeser"];
      
      //int Antwort=NSRunAlertPanel(@"Leeres Archiv", @"Es hat noch keine Aufnahmen im Archiv",locBeenden, NULL,NULL);
      */
       return;
      
   }
   /*
   if(AdminPlayer)
   {
      [AdminPlayer backZurListe:nil];
      [AdminPlayer resetAdminPlayer];
      //[[AdminPlayer window] performClose:nil];
      [[AdminPlayer window]close];
   }
   */
   [self.RecPlayFenster setIsVisible:YES];
   self.Umgebung=kRecPlayUmgebung;
   
   [self setRecPlay];
   
   //OSErr err=[self Leseboxeinrichten];
   [self.SichernKnopf setEnabled:NO];
   [self.WeitereAufnahmeKnopf setEnabled:NO];
   [self anderesProjektEinrichtenMit:[self.ProjektPfad lastPathComponent]];
   
   if (!self.ArchivDaten)
	  {
        self.ArchivDaten=[[rArchivDS alloc]initWithRowCount:0];
        [self.ArchivView setDelegate: self.ArchivDaten];
        [self.ArchivView setDataSource: self.ArchivDaten];
        
     }
   
}


- (NSString*)Initialen:(NSString*)derName
{
   NSString* tempstring =[derName copy];
   unichar  Anfangsbuchstabe=[tempstring characterAtIndex:0];
   NSMutableString*initial=[NSMutableString stringWithCharacters:&Anfangsbuchstabe length:1];
   int pos=0;;
   int i;
   for (i=0;i<(int)[tempstring length];i++)
   {
      if([tempstring characterAtIndex:i]==' ')
         pos=i;
   }
   if (pos>0)
   {
      unichar  ZweiterBuchstabe=[tempstring characterAtIndex:(pos+1)];
      NSString* s=[NSMutableString stringWithCharacters:&ZweiterBuchstabe length:1];
      initial=(NSMutableString*)[initial stringByAppendingString:s];
   }
   return initial;
}


- (NSString*)AufnahmeTitelVon:(NSString*) dieAufnahme
{
   NSString* tempAufnahme=[dieAufnahme copy];
   int posLeerstelle1=0;
   int posLeerstelle2=0;
   int Leerstellen=0;
   NSString*  tempString;
   
   unsigned int charpos=0;
   int Leerschlag=0;
   int TitelChars=0;
   while (charpos<[tempAufnahme length])
	  {
        if ([tempAufnahme characterAtIndex:charpos]==' ')
        {
           Leerschlag++;
           if (Leerschlag==1)
              Leerstellen++;
           if (Leerstellen==1)
           {
              posLeerstelle1=charpos;//erste Leerstelle gefunden
           }
           if (Leerstellen==2)
           {
              posLeerstelle2=charpos;//zweite Leerstelle gefunden
           }
        }
        else //kein Leerschlag
        {
           Leerschlag=0;
           if (Leerstellen==2)
              TitelChars++; //chars nach 2. Leerstelle
        }
        charpos++;
     }//while pos
   
   //NSLog(@"tempAufnahme: %@   pos Leerstelle1:%d pos Leerstelle2:%d  TitelChars: %d",tempAufnahme,posLeerstelle1,posLeerstelle2,TitelChars);
   
   if ((posLeerstelle2 - posLeerstelle1)>1&&TitelChars)//Nummer an zweiter Stelle und chars nach 2. Leerstelle
	  {
        tempString=[tempAufnahme substringFromIndex:posLeerstelle2+1];
     }
   else
	  {
        tempString=[tempAufnahme copy];
     }
   return tempString;
}//AufnahmeTitelVon



- (int)AufnahmeNummerVon:(NSString*) dieAufnahme
{
   NSString* tempAufnahme=[dieAufnahme copy];
   int posLeerstelle1=0;
   int posLeerstelle2=0;
   int Leerstellen=0;
   int tempNummer=0;
   
   unsigned int charpos=0;
   int Leerschlag=0;
   while (charpos<[tempAufnahme length])
	  {
        if ([tempAufnahme characterAtIndex:charpos]==' ')
        {
           Leerschlag++;
           if (Leerschlag==1)
              Leerstellen++;
           if (Leerstellen==1)
           {
              posLeerstelle1=charpos;//erste Leerstelle gefunden
           }
           if (Leerstellen==2)
           {
              posLeerstelle2=charpos;//zweite Leerstelle gefunden
           }
        }
        else //kein Leerschlag
        {
           Leerschlag=0;
        }
        charpos++;
     }//while pos
   //NSLog(@"indexTitelString: %@   pos Leerstelle1:%d pos Leerstelle2:%d",indexTitelString,posLeerstelle1,posLeerstelle2);
   
   if ((posLeerstelle2 - posLeerstelle1)>1)
	  {
        NSRange tempRange=NSMakeRange(posLeerstelle1+1,(posLeerstelle2-posLeerstelle1));
        tempNummer=[[tempAufnahme substringWithRange:tempRange] intValue];
     }
   else
	  {
        tempNummer=-1;
     }
   return tempNummer;
}//AufnahmeNummerVon


- (NSString*)KommentarVon:(NSString*) derKommentarString
{
   
   NSArray* tempMarkArray=[derKommentarString componentsSeparatedByString:@"\r"];
   NSLog(@"UserMarkVon: anz Components: %d",[tempMarkArray count]);
   if ([tempMarkArray count]==6)//noch keine Zeile für Mark
   {
      
      NSString* tempKommentarString=[tempMarkArray objectAtIndex:5];
      return [tempMarkArray objectAtIndex:5];
      //[tempKommentarString release];
      tempKommentarString=[derKommentarString copy];
      int AnzReturns=0;
      int pos=0;
      int KommentarReturnAlt=5;
      while((AnzReturns<KommentarReturnAlt)&&(pos<[tempKommentarString length]))
      {
         if (([tempKommentarString characterAtIndex:pos]=='\r')||([tempKommentarString characterAtIndex:pos]=='\n'))
         {
            AnzReturns++;
         }
         pos++;
      }//while
      tempKommentarString=[tempKommentarString substringFromIndex:pos];
      NSLog(@"******  tempKommentarString: %@", tempKommentarString);
      
      return tempKommentarString;
   }//noch keine Zeile für Mark
   else
   {
      
      //		NSString* tempKommentarString=[tempMarkArray objectAtIndex:Kommentar];
      NSString* tempKommentarString=[tempMarkArray lastObject];
      //		return [tempMarkArray objectAtIndex:Kommentar];
      return [tempMarkArray lastObject];
      
   }
}

- (NSString*)DatumVon:(NSString*) derKommentarString
{
   NSString* tempDatumString;
   tempDatumString=[derKommentarString copy];
   int AnzReturns=0;
   int returnpos1=0,returnpos2=0;
   int pos=0;
   while(pos<(int)[tempDatumString length])
	  {
        if (([tempDatumString characterAtIndex:pos]=='\r')||([tempDatumString characterAtIndex:pos]=='\n'))
        {
           AnzReturns++;
           if ((returnpos1==0)&&(AnzReturns==DatumReturn))
           {
              returnpos1=pos;
           }
           else
              //if ((returnpos2==0)&&(AnzReturns==DatumReturn+1))
              if (returnpos1&&(returnpos2==0))
              {
                 returnpos2=pos;
              }
           
        }
        pos++;
     }//while
   
   
   returnpos1++;
   if (returnpos2>returnpos1)
	  {
        NSRange r=NSMakeRange(returnpos1,returnpos2-returnpos1);
        tempDatumString=[tempDatumString substringWithRange:r];
        if ([tempDatumString length]==0)
        {
           tempDatumString=@"--";
           return tempDatumString;
        }
        //NSLog(@"tempDatumString: %@", tempDatumString);
        pos=0;
        unsigned int leerpos=0;
        while(pos<[tempDatumString length])
        {
           if ([tempDatumString characterAtIndex:pos]==' ')
           {
              leerpos=pos;
           }
           pos++;
        }//while
        if (leerpos)
        {
           r=NSMakeRange(0,leerpos);
           tempDatumString=[tempDatumString substringWithRange:r];
           //NSLog(@"tempDatumString: %@", tempDatumString);
        }
        else
        {
           tempDatumString=@"--";
        }
     }
   
   
   return tempDatumString;
   
}

- (NSString*)BewertungVon:(NSString*) derKommentarString
{
   NSString* tempBewertungString;
   tempBewertungString=[derKommentarString copy];
   int AnzReturns=0;
   int returnpos1=0,returnpos2=0;
   unsigned int pos=0;
   while(pos<[tempBewertungString length])
	  {
        if (([tempBewertungString characterAtIndex:pos]=='\r')||([tempBewertungString characterAtIndex:pos]=='\n'))
        {
           AnzReturns++;
           if ((returnpos1==0)&&(AnzReturns==BewertungReturn))
           {
              returnpos1=pos;
           }
           else
              //if ((returnpos2==0)&&(AnzReturns==DatumReturn+1))
              if (returnpos1&&(returnpos2==0))
              {
                 returnpos2=pos;
              }
           
        }
        pos++;
     }//while
   
   returnpos1++;
   if (returnpos2>returnpos1)
	  {
        NSRange r=NSMakeRange(returnpos1,returnpos2-returnpos1);
        tempBewertungString=[tempBewertungString substringWithRange:r];
        if ([tempBewertungString length]==0)
        {
           tempBewertungString=@" ";
           return tempBewertungString;
        }
        //NSLog(@"BewertungVon:		tempBewertungString: %@", tempBewertungString);
     }
   else
	  {
        
     }
   // 8.12.08
   //tempBewertungString=@"";
   return tempBewertungString;
   
}

- (BOOL)AdminMarkVon:(NSString*) derKommentarString
{
   BOOL MarkSet=NO;
   NSArray* tempMarkArray=[derKommentarString componentsSeparatedByString:@"\r"];
   //NSLog(@"UserMarkVon: anz Components: %d",[tempMarkArray count]);
   if ([tempMarkArray count]==8)//Zeile für Mark ist da
   {
      if ([[tempMarkArray objectAtIndex:6]isEqualToString:@"1"])
      {
         MarkSet=YES;
      }
   }
   
   
   return MarkSet;
}



- (BOOL)UserMarkVon:(NSString*) derKommentarString
{
   BOOL MarkSet=NO;
   NSArray* tempMarkArray=[derKommentarString componentsSeparatedByString:@"\r"];
   //NSLog(@"UserMarkVon: tempMarkArray: %@",[tempMarkArray description]);
   if ([tempMarkArray count]==8)//Zeile für Mark ist da
   {
      if ([[tempMarkArray objectAtIndex:UserMark]isEqualToString:@"1"])
      {
         MarkSet=YES;
      }
   }
   
   //NSLog(@"UserMarkVon: MarkSet: %d",MarkSet);
   return MarkSet;
}


- (NSString*)NoteVon:(NSString*) derKommentarString
{
   NSString* tempNotenString;
   //[tempKommentarString release];
   tempNotenString=[derKommentarString copy];
   int AnzReturns=0;
   int returnpos1=0,returnpos2=0;
   unsigned int pos=0;
   while(pos<[tempNotenString length])
	  {
        if (([tempNotenString characterAtIndex:pos]=='\r')||([tempNotenString characterAtIndex:pos]=='\n'))
        {
           AnzReturns++;
           if ((returnpos1==0)&&(AnzReturns==NotenReturn))
           {
              returnpos1=pos;
           }
           else
              //if ((returnpos2==0)&&(AnzReturns==DatumReturn+1))
              if (returnpos1&&(returnpos2==0))
              {
                 returnpos2=pos;
              }
           
        }
        pos++;
     }//while
   
   returnpos1++;
   if (returnpos2>returnpos1)
	  {
        NSRange r=NSMakeRange(returnpos1,returnpos2-returnpos1);
        tempNotenString=[tempNotenString substringWithRange:r];
        if ([tempNotenString length]==0)
        {
           tempNotenString=@"--";
           return tempNotenString;
        }
        //NSLog(@"NoteVon:		tempNotenString: %@", tempNotenString);
     }
   else
	  {
        
     }
   return tempNotenString;
   
}



- (void)setArchivPfadFuerAufnahme:(NSString*)dieAufnahme
{
   self.ArchivPlayPfad=[NSString stringWithString:self.LeserPfad];
   self.ArchivPlayPfad=[self.ArchivPlayPfad stringByAppendingPathComponent:[dieAufnahme copy]];
   
   //	BOOL KommentarOK=[Utils setKommentar:@"Hallo" inAufnahmeAnPfad:ArchivPlayPfad];
   //	NSString* Kontrollstring=[Utils KommentarStringVonAufnahmeAnPfad:ArchivPlayPfad];
   //	NSLog(@"setArchivPfadFuerAufnahme ArchivPlayPfad: %@  Kontrollstring: %@",ArchivPlayPfad,Kontrollstring);
   
   
   
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   if ([Filemanager fileExistsAtPath:self.ArchivPlayPfad])
	  {
        
        [self.ArchivInPlayerTaste setEnabled:YES];
        [self.ArchivInListeTaste setEnabled:NO];
        //NSLog(@"gueltiger ArchivPlayPfad: %@",ArchivPlayPfad);
        self.ArchivKommentarPfad=[NSString stringWithString:self.LeserPfad];
        self.ArchivKommentarPfad=[self.ArchivKommentarPfad stringByAppendingPathComponent:NSLocalizedString(@"Comments",@"Anmerkungen")];
        self.ArchivKommentarPfad=[self.ArchivKommentarPfad stringByAppendingPathComponent:[dieAufnahme copy]];
        if ([Filemanager fileExistsAtPath:self.ArchivKommentarPfad])
        {
           [self setArchivKommentarFuerAufnahmePfad:self.ArchivKommentarPfad];
        }
        else //Kein Kommentar da
        {
           [self clearArchivKommentar];
           
        }
        
     }//file exists
   else
	  {
        NSLog(@"kein gueltiger ArchivPlayPfad");
        [self.ArchivPlayTaste setEnabled:NO];
        [self.ArchivInListeTaste setEnabled:NO];
        [self.ArchivInPlayerTaste setEnabled:NO];
        self.ArchivPlayPfad=@"";
        self.ArchivKommentarPfad=@"";
        
     }
   
}


- (void)setArchivKommentarFuerAufnahmePfad:(NSString*)derAufnahmePfad;
{
   
   //NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"setArchivKommentarFuerAufnahmePfad: derAufnahmePfad: %@",derAufnahmePfad);
   NSString* tempKommentarString=[NSString stringWithContentsOfFile:derAufnahmePfad encoding:NSMacOSRomanStringEncoding error:NULL];
   //NSLog(@"\nsetArchivKommentarFuerAufnahmePfad: tempKommentarString: %@",tempKommentarString);
   NSString* inhalt =[self KommentarVon:tempKommentarString];
   //NSLog(@"setArchivKommentarFuerAufnahmePfad: inhalt: %@",inhalt);
   if (inhalt)
      [self.ArchivKommentarView setString:inhalt];
   [self.ArchivKommentarView setSelectable:NO];
   [self.ArchivDatumfeld setStringValue:[self DatumVon:tempKommentarString]];
   [self.ArchivTitelfeld setStringValue:[self AufnahmeTitelVon:[derAufnahmePfad lastPathComponent]]];
   //NSLog(@"setArchivKommentarFuerAufnahmePfad 1");
   if (self.BewertungZeigen)
	  {
        //[ArchivBewertungfeld setHidden:NO];
        [self.ArchivBewertungfeld setStringValue:[self BewertungVon:tempKommentarString]];
     }
   else
	  {
        //[ArchivBewertungfeld setHidden:YES];
        [self.ArchivBewertungfeld setStringValue:@" "];
     }
   if (self.NoteZeigen)
	  {
        //[ArchivNotenfeld setHidden:NO];
        [self.ArchivNotenfeld setStringValue:[self NoteVon:tempKommentarString]];
     }
   else
	  {
        //[ArchivNotenfeld setHidden:YES];
        [self.ArchivNotenfeld setStringValue:@"-"];
     }
   //NSLog(@"setArchivKommentarFuerAufnahmePfad 2");
   BOOL MarkOK=[self UserMarkVon:tempKommentarString];
   //NSLog(@"setArchivKommentarFuerAufnahmePfad 3");
   [self.UserMarkCheckbox setState:MarkOK];
   //NSLog(@"setArchivKommentatFuerAufnahmepfad: MarkOK: %d",MarkOK);
   return ;
}

- (void)clearArchivKommentar
{
   [self.ArchivKommentarView setString:@""];
   [self.ArchivDatumfeld setStringValue:@""];
   [self.ArchivTitelfeld setStringValue:@""];
   [self.ArchivAbspieldauerFeld setStringValue:@""];
   [self.ArchivBewertungfeld setStringValue:@""];
   [self.ArchivNotenfeld setStringValue:@""];
}


- (void)updateArchivPlayBalken:(NSTimer *)derTimer
{
   /*
   QTTime Gesamtzeit=[[ArchivQTKitPlayer movie]duration];
   QTTime Spielzeit=[[ArchivQTKitPlayer movie]currentTime];
   float Restzeit=(float)(Gesamtzeit.timeValue-Spielzeit.timeValue);///Gesamtzeit.timeScale;
   //NSLog(@"Restzeit: %2.2f",Restzeit);
   [ArchivAbspielanzeige setLevel:(Spielzeit.timeValue)];
   
   [ArchivAbspieldauerFeld setStringValue:[self Zeitformatieren:Restzeit]];
   if (Restzeit==0)
   {
      [derTimer invalidate];
      //NSLog(@"Restzeit ist null");
   }
    */
}

- (IBAction)startArchivPlayer:(id)sender
{
   TimeValue ArchivDauer;
   NSLog(@"startArchivPlayer:");
   /*
   {
      NSLog(@"startArchivPlayer:			ArchivPlayPfad: %@",ArchivPlayPfad);
      NSURL *movieUrl = [NSURL fileURLWithPath:ArchivPlayPfad];
      QTMovie *tempMovie = [QTMovie movieWithURL:[NSURL fileURLWithPath:ArchivPlayPfad]error:NULL];
      
      [ArchivQTKitPlayer setMovie:tempMovie];
      [ArchivQTKitPlayer gotoBeginning:NULL];
      [ArchivQTKitPlayer play:NULL];
      
      if (!tempMovie)
      {
         NSLog(@"Kein Movie da");
      }
      ArchivDauer=[tempMovie duration].timeValue/[tempMovie duration].timeScale;
      
      // ArchivAbspielanzeige wird mit timeValue ohne Umrechnung geladen
      [ArchivAbspielanzeige setMax: [tempMovie duration].timeValue];
      
      //		NSLog(@"Beginn startArchivPlayer: Dauer in s:%2.2f ",(float)ArchivDauer);
      
      if (!tempMovie)
      {
         NSLog(@"startArchivPlayer: Kein Movie da");
         //return;
      }
      
      playArchivBalkenTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                               target:self
                                                             selector:@selector(updateArchivPlayBalken:)
                                                             userInfo:nil
                                                              repeats:YES];
      
      [ArchivAbspieldauerFeld setStringValue:[self Zeitformatieren:ArchivDauer]];
      [ArchivAbspieldauerFeld setNeedsDisplay:YES];
      
      [Utils stopTimeout];
      
   }
   
   if (QTKitPause)
   {
      [ArchivAbspieldauerFeld setStringValue:[self Zeitformatieren:QTKitPause]];
      //Abspieldauer=QTKitPause;
      [ArchivAbspielanzeige setLevel:QTKitPause];
      QTKitPause=0;
   }
   else
   {
      [ArchivAbspieldauerFeld setStringValue:[self Zeitformatieren:QTKitGesamtAbspielzeit]];
      //Abspieldauer=GesamtAbspielzeit;
      [ArchivAbspielanzeige setLevel:0];
   }
   */
   
   [self.ArchivPlayTaste setEnabled:NO];
   //[self setBackTaste:YES];
   [self.ArchivStopTaste setEnabled:YES];
   [self.ArchivZumStartTaste setEnabled:YES];
   
}

- (IBAction)stopArchivPlayer:(id)sender
{
//   [ArchivQTKitPlayer pause:NULL];
   self.Pause=self.ArchivLaufzeit/60;
   //NSLog(@"Laufzeit:%d  PauseZeit: %d",Laufzeit,Pause);
   
   [self.ArchivPlayTaste setEnabled:YES];
   [self.ArchivStopTaste setEnabled:NO];
   [self.ArchivZumStartTaste setEnabled:YES];
   [Utils startTimeout:self.TimeoutDelay];
}
- (IBAction)backArchivPlayer:(id)sender
{
   /*
   [ArchivQTKitPlayer gotoBeginning:NULL];
   //	[RecordQTKitPlayer setMovie:NULL];
    */
   [self.ArchivPlayTaste setEnabled:YES];
   [self.ArchivStopTaste setEnabled:YES];
   self.Pause=0;
//   [self.ArchivAbspieldauerFeld setStringValue:[self Zeitformatieren:QTKitGesamtAbspielzeit]];
   //Abspieldauer=GesamtAbspielzeit;
   [self.ArchivAbspielanzeige setLevel:0];
   [Utils startTimeout:self.TimeoutDelay];
   
}

- (void)setArchivView
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* AufnahmenArray;
   AufnahmenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.LeserPfad error:NULL]];
   //NSLog(@"AufnahmenArray: %@",[AufnahmenArray description]);
   SEL DoppelSelektor;
   DoppelSelektor=@selector(ArchivaufnahmeInPlayer:);
   
   [self.ArchivView setDoubleAction:DoppelSelektor];
}

- (IBAction)resetArchivPlayer:(id)sender
{
//   [self.ArchivQTKitPlayer pause:NULL];
//   [self.ArchivQTKitPlayer setMovie:nil];
   [self.ArchivAbspieldauerFeld setStringValue:@""];
   [self.Abspieldauerfeld setStringValue:@""];
   [self.ArchivAbspielanzeige setLevel:0];
   [self.Abspielanzeige setLevel:0];
   
}

- (void)clearArchiv
{
   [self resetArchivPlayer:nil];
   [self clearArchivKommentar];
   [self.ArchivDaten resetArchivDaten];
   [self.ArchivView reloadData];
}

- (void)keyDown:(NSEvent *)theEvent
{
   int nr=[theEvent keyCode];
   NSLog(@"RecPlay  keyDown: nr: %d  char: %@",nr,[theEvent characters]);
   [self keyDownAktion:nil];
   //[super keyDown:theEvent];
}

- (IBAction)keyDownAktion:(id)sender
{
   //if ([ArchivDaten AufnahmePfadFuerZeile:zeilenNr])
   if ([self.ArchivDaten AufnahmePfadFuerZeile:0])
	  {
        [self resetArchivPlayer:nil];
        //[self setArchivPfadFuerAufnahme:[ArchivDaten AufnahmePfadFuerZeile:zeilenNr]];
     }
   else
      [self.ArchivPlayTaste setEnabled:NO];
   
}
- (void) KeyNotifikationAktion:(NSNotification*)note
{
   //NSLog(@"KeyNotifikationAktion: note: %@",[note object]);
   NSNumber* KeyNummer=[note object];
   //int keyNr=(int)[KeyNummer floatValue];
   //NSLog(@"keyDown KeyNotifikationAktion description: %@",[KeyNummer description]);
   //NSLog(@"keyDown KeyNotifikationAktion keyNr: %d",keyNr);
   //[self setLeser:self.NamenListe ];
   //[self startAdminPlayer:AdminQTPlayer];
}
- (void) ZeilenNotifikationAktion:(NSNotification*)note
{
   
   if (self.ArchivZeilenhit)
	  {
        //NSLog(@"ArchivZeilenhit=YES");
        self.ArchivZeilenhit=NO;
        //return ;
     }
   self.ArchivZeilenhit=YES;
   NSDictionary* QuellenDic=[note object];
   
   NSString* Quelle=[QuellenDic objectForKey:@"Quelle"];
   //NSLog(@"ZeilenNotifikationAktion:   Quelle: %@",Quelle);
   
   if ([Quelle isEqualToString:@"ArchivView"])
	  {
        //NSLog(@"ZeilenNotifikationAktion:   Quelle: %@",Quelle);
        NSNumber* ZeilenNummer=[QuellenDic objectForKey:@"ArchivZeilenNummer"];
        int zeilenNr=(int)[ZeilenNummer floatValue];
        //NSLog(@"keyDown ZeilenNotifikationAktion description: %@",[ZeilenNummer description]);
        NSLog(@"\n\nZeilenNotifikationAktion fuer ArchivView       zeilenNr: %d\n",zeilenNr);
        [self.UserMarkCheckbox setState:NO];
        
        self.ArchivSelektierteZeile=zeilenNr;
        if ([self.ArchivDaten AufnahmePfadFuerZeile:zeilenNr])
        {
           [self resetArchivPlayer:nil];
           [self setArchivPfadFuerAufnahme:[self.ArchivDaten AufnahmePfadFuerZeile:zeilenNr]];
           
           //erfolg=[RecPlayFenster makeFirstResponder:ArchivPlayTaste];
           //[self.PlayTaste setKeyEquivalent:@"\r"];
        }
        else
           [self.ArchivPlayTaste setEnabled:NO];
        [self.UserMarkCheckbox setEnabled:NO];
        
     }
   //NSTableColumn* tempKolonne;
   //tempKolonne=[self.NamenListe tableColumnWithIdentifier:@"neu"];
   //[[tempKolonne dataCellForRow:selektierteZeile]setTitle:@"Los"];
}

- (void)EnterKeyNotifikationAktion:(NSNotification*)note
{
   //NSLog(@"RecPlay    EnterKeyNotifikationAktion: note: %@",[note object]);
   NSString* Quelle=[[note object]description];
   //NSLog(@"RecPlay EnterKeyNotifikationAktion: Quelle: %@",Quelle);
   BOOL erfolg;
   if ([Quelle isEqualToString:@"MovieView"])
	  {
        //erfolg=[RecPlayFenster makeFirstResponder:ArchivView];
        //NSLog(@"		Quelle: MovieView->self.NamenListe: erfolg: %d",erfolg);
        [self.ArchivInListeTaste setEnabled:NO];
        [self.ArchivPlayTaste setEnabled:YES];
     }
   
   if ([Quelle isEqualToString:@"ArchivListe"])
	  {
        
        if ([self.ArchivDaten AufnahmePfadFuerZeile:self.ArchivSelektierteZeile])
        {
           [self.ArchivInListeTaste setEnabled:YES];
           [self.ArchivInPlayerTaste setEnabled:NO];
           
           erfolg=[self.RecPlayFenster makeFirstResponder:self.ArchivInListeTaste];
           [self.ArchivInListeTaste setKeyEquivalent:@"\r"];
           [self.ArchivPlayTaste setEnabled:YES];
           
           //[ArchivQTPlayer setHidden:NO];
           [self startArchivPlayer:nil];
           //			[MoviePlayer start:nil];
//           [RecordQTKitPlayer gotoBeginning:NULL];
//           [RecordQTKitPlayer play:nil];
           //NSLog(@"		Quelle: ArchivListe->QTPlayer: Enterkey erfolg: %d",erfolg);
           
        }
        else
        {
           NSBeep();NSBeep();
           [self.ArchivPlayTaste setEnabled:NO];
           [self.ArchivInListeTaste setEnabled:NO];
           [self.ArchivInListeTaste setKeyEquivalent:@""];
        }
        
        
     }
   
}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   BOOL umschalten=YES;
   //NSLog(@"vor shouldSelectTabViewItem: UserMarkCheckbox: %d",[UserMarkCheckbox state]);
   if ([[tabViewItem identifier]isEqualToString:@"archiv"])
	  {
        /*
        NSLog(@"TabView:archiv");
        if (aktuellAnzAufnahmen &&!([AufnahmeGrabber isRecording]))
        {
           [self resetArchivPlayer:nil];
           [self.ArchivnamenPop setEnabled:NO];
           [self.ArchivInPlayerTaste setEnabled:NO];
           [self.ArchivView deselectAll:NULL];
           [self.RecPlayFenster makeFirstResponder:self.ArchivView];
           
        }
        else
        {
           umschalten=NO;
        }
         */
     }
   
	  
   if ([[tabViewItem identifier]isEqualToString:@"recorder"])
   {
      
      NSLog(@"TabView:recorder");
      //NSLog(@"vor shouldSelectTabViewItem: UserMarkCheckbox: %d",[UserMarkCheckbox state]);
      
      umschalten=0;//!MoviePlayerbusy;
      //NSLog(@"TabView:archiv: umschalten: %d isPlaying: %f",umschalten,[[RecordQTKitPlayer movie]rate]);
      if (umschalten)
      {
         if (self.ArchivPlayerGeladen)
         {
            [self ArchivZurListe:nil];
            
         }
         
         [self backArchivPlayer:nil];
         
         
         [self resetArchivPlayer:nil];
         [self.ArchivView deselectAll:NULL];
         [self.ArchivnamenPop setEnabled:YES];
         [self.RecPlayFenster makeFirstResponder:self.RecPlayFenster];
         //umschalten=YES;
      }
   }
   
   //	  	[Utils startTimeout:TimeoutDelay];
   
   return umschalten;
}

- (IBAction)showEinstellungen:(id)sender
{
   if(!self.EinstellungenFenster)
	  {
        if ((self.EinstellungenFenster=[[rEinstellungen alloc]init]))
        {
           [self.EinstellungenFenster awakeFromNib];
        }
     }
	  
   [Utils stopTimeout];
   
   [self.EinstellungenFenster showWindow:self];
   [self.EinstellungenFenster setBewertung:self.BewertungZeigen];
   [self.EinstellungenFenster setNote:self.NoteZeigen];
   [self.EinstellungenFenster setMitPasswort:self.mitUserPasswort];
   NSLog(@"showEinstellungen: TimeoutDelay: %d",(int)self.TimeoutDelay);
   [self.EinstellungenFenster setTimeoutDelay:self.TimeoutDelay];
   
   
}

- (void)BewertungNotifikationAktion:(NSNotification*)note
{
   //NSLog(@"BewertungNotifikationAktion: note: %@",[note userInfo]);
   NSNumber* CheckboxStatus=[[note userInfo]objectForKey:@"Status"];
   int status=(int)[CheckboxStatus floatValue];
   //NSLog(@"BewertungNotifikationAktion: %@  Status: %d",[CheckboxStatus description],status);
   self.BewertungZeigen=(status==1);
   [[NSUserDefaults standardUserDefaults]setInteger: status forKey: RPBewertungKey];
   
   
}
- (void)NotenNotifikationAktion:(NSNotification*)note
{
   //NSLog(@"BewertungNotifikationAktion: note: %@",[note userInfo]);
   NSNumber* CheckboxStatus=[[note userInfo]objectForKey:@"Status"];
   int status=(int)[CheckboxStatus floatValue];
   NSLog(@"NotenNotifikationAktion: %@  Status: %d",[CheckboxStatus description],status);
   self.NoteZeigen=(status==1);
   [[NSUserDefaults standardUserDefaults]setInteger: status forKey: RPNoteKey];
   
}
- (void)StartStatusNotifikationAktion:(NSNotification*)note
{
   NSNumber* mitPasswort=[[note userInfo]objectForKey:@"mituserpasswort"];
   self.mitUserPasswort=[mitPasswort intValue];
   NSLog(@"StartStatusNotifikationAktion	mitPasswort: %@",[mitPasswort description]);
   if (self.mitUserPasswort)
   {
      [self.PWFeld setStringValue:NSLocalizedString(@"With Password",@"Mit Passwort")];
   }
   else
   {
      [self.PWFeld setStringValue:NSLocalizedString(@"Without Password",@"Ohne Passwort")];
   }
   self.TimeoutDelay=[[[note userInfo]objectForKey:@"timeoutdelay"]intValue];
   self.BewertungZeigen=[[[note userInfo]objectForKey:@"bewertungstatus"]intValue];
   [self.PListDic setObject:[NSNumber numberWithInt:self.BewertungZeigen] forKey:RPBewertungKey];
   self.NoteZeigen=[[[note userInfo]objectForKey:@"notenstatus"]intValue];
   [self.PListDic setObject:[NSNumber numberWithInt:self.NoteZeigen] forKey:RPNoteKey];
   
   //[Utils startTimeout:TimeoutDelay];
   //[Utils stopTimeout];
   //[ProjektArray setArray:[Utils ProjektArrayAusPListAnPfad:LeseboxPfad]];
   
   int ProjektIndex=[[self.ProjektArray valueForKey:@"projekt"] indexOfObject:[self.ProjektPfad lastPathComponent]];
   if (ProjektIndex>=0)
   {
      NSMutableDictionary* tempProjektDic=(NSMutableDictionary*)[self.ProjektArray objectAtIndex:ProjektIndex];
      NSLog(@"StatusnotAktion: tempProjektDic: %@",[tempProjektDic description]);
      [tempProjektDic setObject:[[note userInfo] objectForKey:@"mituserpasswort"] forKey:@"mituserpw"];
      //NSLog(@"ProjektStartAktion: tempProjektDic: %@",[tempProjektDic description]);
      
   }
   
   
}
- (void) Umgebung:(NSNotification*)note
{
   NSNumber* UmgebungNumber=[[note userInfo]objectForKey:@"Umgebung"];
   self.Umgebung=(int)[UmgebungNumber floatValue];
}




- (IBAction)showKommentar:(id)sender
{
  // [AdminPlayer showKommentar:sender ];
}


- (IBAction)showClean:(id)sender
{
   //NSLog(@"RecPlayController	showClean: sender tag: %d",[sender tag]);
  // [AdminPlayer showCleanFenster:1];
  // [AdminPlayer setCleanTask:0];
}

- (IBAction)showExport:(id)sender
{
   //NSLog(@"RecPlayController	showExport: sender tag: %d",[sender tag]);
  // [AdminPlayer showCleanFenster:2];
  // [AdminPlayer setCleanTask:1];
}

- (void)MarkierungenWeg:(id)sender
{
   
  // [AdminPlayer MarkierungenEntfernen];
}


- (IBAction)AlleMarkierungenWeg:(id)sender
{
 //  [AdminPlayer AlleMarkierungenEntfernen];
}






- (void)neuesProjektAktion:(NSNotification*)note
{
   //Note von Projektliste über neues Projekt: reportNeuesProjekt
   BOOL neuesProjektOK=NO;
   NSMutableDictionary* tempNeuesProjektDic=[[[note userInfo] objectForKey:@"neuesprojektdic"]mutableCopy];
   NSLog(@"neuesProjektAktion: userInfo: %@",[[note userInfo] description]);
   
   //NSLog(@"RPC neuesProjektAktion: tempNeuesProjektDic: %@",[tempNeuesProjektDic description]);
   //NSString* neuesProjektName=[tempNeuesProjektDic objectForKey:projekt];
   NSString* neuesProjektName=[tempNeuesProjektDic objectForKey:@"projekt"];
   NSMutableDictionary* neuesProjektDic;
   if (neuesProjektName)
   {
      if ([neuesProjektName length])
      {
         NSString* tempProjektPfad=[self.ArchivPfad stringByAppendingPathComponent:neuesProjektName];
         NSLog(@"neuesProjektAktion tempProjektPfad: %@",tempProjektPfad);
         //NSLog(@"ProjektArray ist da: %d",!(ProjektArray==NULL));
         if (self.ProjektArray&&[self.ProjektArray count])
         {
            
            [Utils setUProjektArray:self.ProjektArray];//Bei Wahl von "Neues Projekt" beim Projektstart ist UProjektArray in Utils noch leer
         }
         else
         {
            
         }
         
         if ([Utils ProjektOrdnerEinrichtenAnPfad:tempProjektPfad])
         {
            NSLog(@"ProjektOrdnerEinrichtenAnPfad: ist OK");
            
            neuesProjektDic=[NSMutableDictionary dictionaryWithObject:neuesProjektName forKey:@"projekt"];
            [neuesProjektDic setObject:[tempProjektPfad copy] forKey:@"projektpfad"];
            [neuesProjektDic setObject: [NSNumber numberWithInt:1] forKey:@"ok"];//Projekt ist aktiviert
            [neuesProjektDic setObject:[NSCalendarDate date] forKey:@"sessiondatum"];
            
            NSNumber* tempFix=[tempNeuesProjektDic objectForKey:@"fix"];//Titel fix?
            if (tempFix)
            {
               [neuesProjektDic setObject: tempFix forKey:@"fix"];
               //			[self showTitelListe:NULL];
            }
            else
            {
               [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"fix"];
            }
            //NSLog(@"neuesProjektAktion neuesProjektDic: %@",[neuesProjektDic description]);
            
            NSNumber* tempMitUserPW=[tempNeuesProjektDic objectForKey:@"mituserpw"];//Mit Userpasswort?
            if (tempMitUserPW)
            {
               [neuesProjektDic setObject: tempMitUserPW forKey:@"mituserpw"];
               //			[self showTitelListe:NULL];
            }
            else
            {
               [neuesProjektDic setObject: [NSNumber numberWithInt:0] forKey:@"mituserpw"];
            }
            //NSLog(@"neuesProjektAktion neuesProjektDic: %@",[neuesProjektDic description]);
            
            [self.ProjektArray addObject:neuesProjektDic];
            
            neuesProjektOK=YES;
            NSLog(@"neuesProjektAktion neuesProjektOK: YES");
         }
         else
         {
            //**
            //Kein Projektordner eingerichtet
            NSLog(@"neuesProjektAktion neuesProjektOK: NO kein Pojekt 	ProjektPanel resetPanel");
            [self.ProjektPanel resetPanel];
            neuesProjektOK=NO;
         }
         
      }
   }
   
   if (neuesProjektOK)
   {
      [self setProjektMenu];
      [self.ProjektPanel setNeuesProjekt];
      [self.ProjektPanel setProjektListeArray:self.ProjektArray inProjekt:neuesProjektName];
      NSLog(@"\n\n                    +++++   neuesProjektAktion Schluss: ProjektArray: %@\n",[self.ProjektArray description]);
      
      [self saveNeuesProjekt:neuesProjektDic];
//*      [AdminPlayer setAdminProjektArray:ProjektArray];
      //29.1.		[self savePListAktion:nil];
      
      
   }//if NeueProjektListeOK
   else
   {
      //NSLog(@"*neuesProjektListeAktion Kein neues Projekt %@",[ProjektArray description]);
      [self.ProjektPanel resetPanel];
   }
   
   //8.11.06	[self savePListAktion:nil];
   
   //[[ProjektPanel window]close];
   
   
}

- (void)ProjektMenuAktion:(NSNotification*)note
{
   //NSLog(@"\n\n************ ProjektMenuAktion : \nNeues Projekt: %@",[[note userInfo] objectForKey:@"projekt"]);
   NSString* tempProjektString=[NSString stringWithString:[[note userInfo] objectForKey:@"projekt"]];
   if (tempProjektString)
   {
      
      self.ProjektPfad=(NSMutableString*)[self.ArchivPfad stringByAppendingPathComponent:[[note userInfo] objectForKey:@"projekt"]];
      [self setProjektMenu];
   }
}



- (void)anderesProjektAktion:(NSNotification*)note
{
   //NSLog(@"\nanderesProjektAktion start: \n%@",[[note userInfo] objectForKey:@"projekt"]);
   //NSLog(@"\nanderesProjektAktion start: %@",[[note userInfo] description]);
   [Utils startTimeout:self.TimeoutDelay];
   
   NSArray* tempProjektArray=[[note userInfo] objectForKey:@"projektarray"];
   //NSLog(@"anderesProjektAktion tempProjektArray: %@",[tempProjektArray description]);
   if (tempProjektArray&&[tempProjektArray count])
   {
      NSLog(@"tempProjektarray ist OK");
      [self.ProjektArray setArray:[tempProjektArray mutableCopy]];//Array mit allen Aenderungen aus ProjektlistePanel
      //NSLog(@"anderesProjektAktion Projektarray laden: %@",[ProjektArray description]);
      [self saveNeuenProjektArray:tempProjektArray];
   }
   
   NSString* anderesProjekt=[[note userInfo] objectForKey:@"projekt"];
   if ([anderesProjekt length])
   {
      //Titelliste pruefen
      
      
      
      
      
      
      
      [self anderesProjektMitTitel:anderesProjekt];
   }
   else
   {
      
   }
   
}

- (void)ProjektEntfernenAktion:(NSNotification*)note
{
   //NSLog(@"*********ProjektEntfernenAktion start: %@",[[note userInfo] objectForKey:@"projekt"]);
   NSString* clearProjekt=[[note userInfo] objectForKey:@"projekt"];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   if ([clearProjekt length])
   {
      NSString* EntfernenPfad=[self.ArchivPfad stringByAppendingPathComponent:clearProjekt];
      if (![Filemanager fileExistsAtPath:EntfernenPfad ])
      {
         NSLog(@"Zu entfernender Ordner nicht vorhanden");
         return;
      }
      int wohin=[[[note userInfo] objectForKey:@"wohin"]intValue];
      
      NSString*ZielPfad;
      switch (wohin)
      {
         case 0://>Papierkorb
         {
            //NSLog(@"*ProjektEntfernenAktion: Papierkorb: EntfernenPfad: %@",EntfernenPfad);
            [self fileInPapierkorb:EntfernenPfad];
            NSLog(@"*ProjektEntfernenAktion: nach inPapierkorbMitPfad ");
            [self updateProjektArray];
            NSLog(@"*ProjektEntfernenAktion: nach updateProjektArray");
         }break;
            
         case 1: //Magazin
         {
            //NSLog(@"*ProjektEntfernenAktion: Magazin: EntfernenPfad: %@",EntfernenPfad);
            NSString* MagazinPfad=[self.LeseboxPfad stringByAppendingPathComponent:@"Magazin"];
            //NSLog(@"*ProjektEntfernenAktion: Magazin: MagazinPfad: %@",MagazinPfad);
            BOOL istOrdner=NO;
            
            
            
            
            
            
            if (!([Filemanager fileExistsAtPath:MagazinPfad isDirectory:&istOrdner]&&istOrdner))
            {
               BOOL createMagazinOK=[Filemanager createDirectoryAtPath:MagazinPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
               NSLog(@"createMagazinOK: %d",createMagazinOK);
               if (!createMagazinOK)
               {
                  NSAlert *Warnung = [[NSAlert alloc] init];
                  [Warnung addButtonWithTitle:@"OK"];
                  [Warnung setMessageText:NSLocalizedString(@"No Folder 'Magazin'",@"Kein Ordner 'Magazin'")];
                  
                  NSString* s1=NSLocalizedString(@"The folder 'Magazin' could not be created",@"Der Ordner 'Magazin' konnte nicht angelegt werden.");
                  
                  NSString* s2=NSLocalizedString(@"The folder for project '%@' must be removed manually.",@"Ordner für Projekt manuell entfernen");
                  NSString* s3=[NSString stringWithFormat:s2,clearProjekt];
                  NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s3];
                  [Warnung setInformativeText:InformationString];
                  [Warnung setAlertStyle:NSWarningAlertStyle];
                  
                  //[Warnung setIcon:RPImage];
                  int antwort=[Warnung runModal];
                  break;
               }
            }
            ZielPfad=[[MagazinPfad stringByAppendingPathComponent:clearProjekt]stringByAppendingString:@" alt"];
            //NSLog(@"ZielPfad: %@",ZielPfad);
            if ([Filemanager fileExistsAtPath:ZielPfad])
            {
               [Filemanager removeItemAtURL:[NSURL fileURLWithPath:ZielPfad] error:nil];
            }
            BOOL MagazinOK=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:EntfernenPfad]  toURL:[NSURL fileURLWithPath:ZielPfad] error:nil];
            if (MagazinOK)
            {
               BOOL ProjektOK=[self ProjektListeValidAnPfad:self.ArchivPfad];
            }
            //NSLog(@"MagazinOK: %d",MagazinOK);
            
            
         }break;
         case 2://ex
         {
            //NSLog(@"*ProjektEntfernenAktion: ex: %@",EntfernenPfad);
            if ([Filemanager fileExistsAtPath:EntfernenPfad])
            {
               BOOL ExOK=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:EntfernenPfad] error:nil];
               if (ExOK)
               {
                  BOOL ProjektOK=[self ProjektListeValidAnPfad:self.ArchivPfad];
               }
               
            }
         }break;
         default:
         {
            return;
         }break;
      }//switch
      //NSLog(@"ProjektEntfernen ArchivPfad: %@  \nProjektArray: %@",ArchivPfad,[ProjektArray description]);
      
      
      [self setProjektMenu];
      [self.RecorderMenu setSubmenu:[self.ProjektMenu copy] forItem:[self.RecorderMenu itemWithTag:kRecorderProjektWahlenTag]];
      
//*      [AdminPlayer setProjektPopMenu:ProjektArray];
      
   }
   
}

- (int) fileInPapierkorb:(NSString*) derFilepfad
{
   int tag;
   BOOL succeeded;
   NSString* HomeDir=@"";// = [NSHomeDirectory() stringByAppendingPathComponent:@".Trash"];
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   //NSLog(@"fileInPapierkorb:NSHomeDirectory %@",NSHomeDirectory());
   
   NSMutableArray* PfadKomponenten=(NSMutableArray*)[derFilepfad pathComponents] ;
   int index=0;
   while (index<[PfadKomponenten count] && ![[PfadKomponenten objectAtIndex:index]isEqualToString:@"Documents"])
	  {
        NSString* tempString=[PfadKomponenten objectAtIndex:index];
        HomeDir=[HomeDir stringByAppendingPathComponent:tempString];
        index++;
     }
   if ([HomeDir isEqualToString:NSHomeDirectory()])
	  {
        NSString* trashDir = [NSHomeDirectory() stringByAppendingPathComponent:@".Trash"];
        trashDir=[trashDir stringByAppendingPathComponent:@".Trash"];
        
        NSString* sourceDir=[derFilepfad stringByDeletingLastPathComponent];
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        
        NSArray * vols=[workspace mountedLocalVolumePaths];
        //NSLog(@"fileInPapierkorb volumes: %@   sourceDir:%@ trashDir: %@",[vols description],sourceDir, trashDir);
        
        NSArray *files = [NSArray arrayWithObject:[derFilepfad lastPathComponent]];
        succeeded = [workspace performFileOperation:NSWorkspaceRecycleOperation
                                             source:sourceDir destination:trashDir
                                              files:files tag:&tag];
        return tag;//0 ist OK
     }
   else
	  {
        
        NSString* sourceDir=derFilepfad;
        int removeIt=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:sourceDir] error:nil];
        //NSLog(@"removePath: removeIt: %d",removeIt);
        return 0;
        
     }
}

- (IBAction)setNeuesProjekt:(id)sender
{
   NSLog(@"setNeuesProjekt");
}

@end
