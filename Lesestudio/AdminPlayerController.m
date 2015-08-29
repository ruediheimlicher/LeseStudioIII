//
//  AdminPlayerController.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 15.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "AdminPlayerController.h"

enum
{
   NamenViewTag=1111,
   TitelViewTag=2222
};
enum
{ausEinemProjektOption= 0,
   ausAktivenProjektenOption,
   ausAllenProjektenOption
};

enum
{lastKommentarOption= 0,
   alleVonNameKommentarOption,
   alleVonTitelKommentarOption
};
enum
{alsTabelleFormatOption=0,
   alsAbsatzFormatOption
};

enum
{zweiAufnahmen=2,
   dreiAufnahmen,
   vierAufnahmen,
   sechsAufnahmen=6,
   alleAufnahmen=99
};


typedef NS_ENUM(NSInteger, UYLType)
{
   DatumReturn=2,
   BewertungReturn,
   NotenReturn,
   UserMarkReturn,
   AdminMarkReturn,
   KommentarReturn
};

typedef NS_ENUM(NSInteger, A)
{
   Datum = 2,
   Bewertung,
   Noten,
   UserMark,
   AdminMark,
   Kommentar
};



@implementation AdminPlayerController

- (void)viewDidLoad {
   // [super viewDidLoad];
    // Do view setup here.
   //NSLog(@"awake:start");
   [self.NamenListe reloadData];
   NSColor * TitelFarbe=[NSColor whiteColor];
   NSFont* TitelFont;
   TitelFont=[NSFont fontWithName:@"Helvetica" size: 28];
   [self.TitelString setFont:TitelFont];
   [self.TitelString setTextColor:TitelFarbe];
   [self.ModusString setFont:TitelFont];
   [self.ModusString setTextColor:TitelFarbe];
   [self.AdminFenster setDelegate:self];
   //NSLog(@"FertigTaste int:%d ",[FertigTaste keyEquivalent]);
   //char * ret=[[BackTaste keyEquivalent]UTF8String];
   //NSLog(@"BackTaste string:%@ ",[[BackTaste keyEquivalent]UTF8String]);
   //[FertigTaste setKeyEquivalent:@""];
   //[[self window] setBackgroundColor:[NSColor blueColor]];
   //[[PlayerBox contentView]setBackgroundColor:[NSColor blueColor]];
   //[BackTaste setKeyEquivalent:@"\r"];
   self.OptionAString=[NSString string];
   self.OptionBString=[NSString string];
   self.AdminProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   
   self.RPExportdaten=[[NSUserDefaults standardUserDefaults] objectForKey:@"RPExportdatenKey"];
   //NSLog(@"awake: RPExportdaten; %d",[RPExportdaten description]);
   //NSLog(@"awake: RPExportdaten; %d",[RPExportdaten length]);
   self.ExportFormatString=(NSMutableString*)[[NSUserDefaults standardUserDefaults] stringForKey:@"RPExportformat"];
   
   //NSLog(@"awake: ExportFormatString; %@",ExportFormatString);
   
   //NSColor * FensterFarbe=[NSColor windowBackgroundColor];
   NSColor* FensterFarbe=[NSColor colorWithDeviceRed:100.0/255 green:200.0/255 blue:150.0/255 alpha:1.0];
   [self.AdminFenster setBackgroundColor:FensterFarbe];
   
   self.AufnahmenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   [[[self.AufnahmenTable tableColumnWithIdentifier:@"usermark"]dataCell] setEnabled:NO];
   
   [self.NamenListe setToolTip:@"Liste der Leser im aktuellen Projekt.\nKann im Menü 'Admin->self.NamenListe bearbeiten' verändert werden."];
   [self.ExportierenTaste setToolTip:@"Exportieren der aktuellen Aufnahme in verschiedenen Formaten."];
   [self.LoeschenTaste setToolTip:@"Aktuelle Aufnahme mit verschiedenen Optionen entfernen."];
   [self.MarkCheckbox setToolTip:@"Aktuelle Aufnahme markieren"];
   [self.UserMarkCheckbox setToolTip:@"Zeigt, ob der Leser die aktuelle Aufnahme markiert hat."];
   [self.AdminKommentarView setToolTip:@"Anmerkungen für den Leser schreiben"];
   [self.AdminTitelfeld setToolTip:@"Titel der aktuellen Aufnahme"];
   [self.AdminDatumfeld setToolTip:@"Name des Lesers der aktuellen Aufnahme"];
   [self.ProjektPop setToolTip:NSLocalizedString(@"",@"")];
   [self.AbspieldauerFeld setToolTip:@"Dauer der aktuellen Aufnahme"];
   [self.AdminDatumfeld setToolTip:@"Aufnahmedatum der aktuellen Aufnahme."];
   [self.zurListeTaste setToolTip:@"Aktuelle Aufnahme aus dem Player entfernen."];
   [self.PlayTaste setToolTip:@"Ausgewählte Aufnahme in den Player verschieben."];
   [self.AdminNamenfeld setToolTip:@"Leser der aktuellen Aufnahme."];
   [self.ProjektPop setToolTip:@"Liste der aktiven Projekte.\nKann im Menü 'Admin->Projektliste bearbeiten' bearbeitet werden."];
   [self.AufnahmenTable setToolTip:@"Liste der Aufnahmen des ausgewählten Lesers."];
   [self.LesernamenPop  setToolTip:@"Einen Leser im aktuellen Projekt auswählen."];
   [self.DeleteTaste setToolTip:@"Ausgewählte Aufnahme an verschiedene Orte verschieben."];
   [self.MarkAuswahlOption setToolTip:@"Optionen für die Anzeige der Aufnahmen in der Liste."];
   //[  setToolTip:NSLocalizedString(@"",@"")];
   //[  setToolTip:NSLocalizedString(@"",@"")];
   //[[[self.NamenListe tableColumnWithIdentifier:@"anz"]headerCell]contentView setToolTip:NSLocalizedString(@"Number of records of the reader",@"Anzahl Aufnahmen des Lesers")];
   [self.UserMarkCheckbox setToolTip:@"Vom Leser gesetzte Marke."];
   [self.AufnahmenTab setDelegate:self];

}



BOOL AdminSaved=NO;
NSString* alle=@"alle";
NSString* name=@"name";
NSString* titel=@"titel";
NSString* anzahl=@"anzahl";
NSString* auswahl=@"auswahl";
NSString* leser=@"leser";
NSString* anzleser=@"anzleser";

NSString*	RPExportdatenKey=	@"RPExportdaten";




- (id) init
{
 //  self=[super initWithWindowNibName:@"RPAdmin"];
   self.AdminDaten = [[rAdminDS alloc] initWithRowCount: 10];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   
   self.RPExportdaten=[NSMutableData dataWithCapacity:0];
   self.ExportFormatString=[NSMutableString stringWithCapacity:0];
   [self.ExportFormatString setString:@"AIFF"];
   self.OptionAString=[[NSString alloc]init];
   self.OptionBString=[[NSString alloc]init];
   [nc addObserver:self
          selector:@selector(AdminKeyNotifikationAktion:)
              name:@"Pfeiltaste"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(AdminZeilenNotifikationAktion:)
              name:@"AdminselektierteZeile"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(AdminTabNotifikationAktion:)
              name:@"AdminChangeTab"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(AdminEnterKeyNotifikationAktion:)
              name:@"AdminEnterKey"
            object:nil];
  /*
   [nc addObserver:self
          selector:@selector(UmgebungAktion:)
              name:@"Umgebung"
            object:nil];
   */
   [nc addObserver:self
          selector:@selector(DidChangeNotificationAktion:)
              name:@"NSTextDidChangeNotification"
            object:self.AdminKommentarView];
   
   [nc addObserver:self
          selector:@selector(KommentarNotificationAktion:)
              name:@"KommentarOption"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(EntfernenNotificationAktion:)
              name:@"EntfernenOption"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(CleanOptionNotificationAktion:)
              name:@"CleanOption"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(CleanViewNotificationAktion:)
              name:@"CleanView"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ClearNotificationAktion:)//Taste "Löschen"
              name:@"Clear"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ExportNotificationAktion:)//Taste "Exportieren"
              name:@"Export"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ExportFormatDialogAktion:)//Taste "Optionen"
              name:@"ExportFormatDialog"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(MarkierungNotificationAktion:)//Fenster Markierung
              name:@"MarkierungOption"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(AdminProjektListeAktion:)
              name:@"ProjektWahl"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(anderesAdminProjektAktion:)
              name:@"anderesProjekt"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ProjektArrayNotificationAktion:)
              name:@"ProjektArray"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(NameIstEntferntAktion:)
              name:@"NameIstEntfernt"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(NameIstEingesetztAktion:)
              name:@"NameIstEingesetzt"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(SelectionDidChangeAktion:)
              name:@"NSTableViewSelectionDidChangeNotification"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ButtonWillPopUpAktion:)
              name:@"NSPopUpButtonWillPopUpNotification"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ComboBoxAktion:)
              name:@"NSComboBoxSelectionDidChangeNotification"
            object:nil];
   
   
   
   NSMutableDictionary * defaultWerte=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   [defaultWerte setObject:self.RPExportdaten  forKey:@"RPExportdatenKey"];
   
   [defaultWerte setObject:self.ExportFormatString forKey:@"RPExportformat"];
   
   [[NSUserDefaults standardUserDefaults] registerDefaults: defaultWerte];
   //NSLog(@"INIT: ExportFormatString; %@",ExportFormatString);
   self.selektierteZeile=-1;
   self.AdminLeseboxPfad=@"";
   self.AuswahlOption=0;
   self.AbsatzOption=0;
   self.AnzahlOption=2;
   self.ProjektNamenOption=0;
   self.ProjektAuswahlOption=0;
   
   self.selektierteAufnahmenTableZeile=-1;
   self.Textchanged=NO;
   return self;
   
}


- (BOOL)setHomeAdminLeseboxPfad:(id)sender
{
   BOOL antwort=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempLeseboxPfad=[[[NSString stringWithString:NSHomeDirectory()]
                               stringByAppendingPathComponent:@"Documents"]
                              stringByAppendingPathComponent:NSLocalizedString(@"Lesebox",@"Lesebox")];
   if ([Filemanager fileExistsAtPath:tempLeseboxPfad])
	  {
        self.AdminLeseboxPfad=[NSMutableString stringWithString:tempLeseboxPfad];
        antwort=YES;
     }
   //NSLog(@"setHomeAdminLeseboxPfad antwort: %d",antwort);
   return antwort;
}

- (BOOL)setNetworkAdminLeseboxPfad:(id)sender
{
   BOOL antwort=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSOpenPanel * AdminLeseboxDialog=[NSOpenPanel openPanel];
   [AdminLeseboxDialog setCanChooseDirectories:YES];
   [AdminLeseboxDialog setCanChooseFiles:NO];
   [AdminLeseboxDialog setAllowsMultipleSelection:NO];
   [AdminLeseboxDialog setMessage:@"Auf welchem Computer ist die Lesebox zu finden?"];
   [AdminLeseboxDialog setCanCreateDirectories:NO];
   NSString* tempLeseboxPfad;
   NSURL* tempLeseboxURL;
   int AdminLeseboxHit=0;
   {
      //LeseboxHit=[LeseboxDialog runModalForDirectory:DocumentsPfad file:@"Lesebox" types:nil];
      AdminLeseboxHit=[AdminLeseboxDialog runModal] ;//]ForDirectory:NSHomeDirectory() file:@"Volumes" types:nil];
      [AdminLeseboxDialog setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
   }
   if (AdminLeseboxHit==NSOKButton)
	  {
        
        tempLeseboxPfad=[[AdminLeseboxDialog URL]path ]; //"home"
        tempLeseboxPfad=[tempLeseboxPfad stringByAppendingPathComponent:@"Documents"];
        NSString* lb=@"Lesebox"
        tempLeseboxPfad=[tempLeseboxPfad stringByAppendingPathComponent:lb];
        
        if ([Filemanager fileExistsAtPath:tempLeseboxPfad ])
        {
           NSLog(@"setNetworkAdminLeseboxPfad: AdminLeseboxPfad da: %@",tempLeseboxPfad);
           self.AdminLeseboxPfad=[NSMutableString stringWithString:tempLeseboxPfad];
           
           antwort=YES;
        }
        
     }
   else
	  {
        return NO;
     }
   
   return antwort;
}

- (void)settAdminPlayer:(NSString*)derLeseboxPfad inProjekt:(NSString*)dasProjekt
{
  
   //NSLog(@"setAdminPlayer Projekt: %@",dasProjekt);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   [self.ProjektFeld setStringValue:dasProjekt];
   self.AdminLeseboxPfad=[NSString stringWithString:derLeseboxPfad];
   self.AdminArchivPfad=[NSString stringWithString:[derLeseboxPfad stringByAppendingPathComponent:@"Archiv"]];
   
   
   self.AdminProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:dasProjekt];//Pfad des Archiv-Ordners
   
   NSNotificationCenter * nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:self.AdminProjektPfad forKey:@"projektpfad"];
   [nc postNotificationName:@"Utils" object:self userInfo:NotificationDic];
   
   
   self.AdminProjektNamenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:self.AdminProjektPfad error:NULL]];
   [self.AdminProjektNamenArray removeObject:@".DS_Store"];
   self.AnzLeser=[self.AdminProjektNamenArray count];											//Anzahl Leser
   if (self.AnzLeser==0)
   {
      
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:@"OK"];
      //[Warnung addButtonWithTitle:@"Cancel"];
      [Warnung setMessageText:@"Leerer Projektordner"];
      [Warnung setInformativeText:@"Es hat noch keine Projekte im Projektordner"];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      [Warnung beginSheetModalForWindow:self.AdminFenster
                          modalDelegate:self
                         didEndSelector: @selector(alertDidEnd: returnCode: contextInfo:)
                            contextInfo:@"keineLeser"];
      
      //int Antwort=NSRunAlertPanel(@"Leeres Archiv", @"Es hat noch keine Aufnahmen im Archiv",@"Beenden", NULL,NULL);
      NSLog(@"!!!");
      
      [self AdminBeenden];
      return;
   }
   //NSLog(@"setAdminPlayer AdminProjektNamenArray: %@", AdminProjektNamenArray);
   
   if ([[self.AdminProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
   {
      [self.AdminProjektNamenArray removeObjectAtIndex:0];
      self.AnzLeser--;
   }
   
   //NSString*LeseramenListe=[AdminProjektNamenArray description];
   //[LesernamenPop addItemsWithTitles:AdminProjektNamenArray];
   //NSLog(@"setAdminPlayer Leserself.NamenListe sauber: %@", Leserself.NamenListe);
   [self.AbspieldauerFeld setSelectable:NO];
   //*****************
   self.AdminDaten = [[rAdminDS alloc] initWithRowCount: self.AnzLeser];
   self.comboBox = [[NSComboBoxCell alloc] init];
   [self.comboBox setCompletes: YES];
   [self.comboBox setEditable: YES];
   [self.comboBox setUsesDataSource: NO];
   
   //[comboBox addItemsWithObjectValues:
   //[NSArray arrayWithObjects: @"integer", @"string", @"date-time", @"blob", nil]];
   NSSize PopButtonSize;
   PopButtonSize.height=20;
   
   self.AufnahmenPop=[[NSPopUpButtonCell alloc] init];
   [self.AufnahmenPop setImagePosition:NSImageRight];
   [self.AufnahmenPop synchronizeTitleAndSelectedItem];
   NSFont* Popfont;
   Popfont=[NSFont fontWithName:@"Lucida Grande" size: 10];
   [self.AufnahmenPop setFont:Popfont];
   NSFont* Tablefont;
   Tablefont=[NSFont fontWithName:@"Lucida Grande" size: 12];
   
   
   
   SEL PopSelektor;
   PopSelektor=@selector(AufnahmeSetzen:);
   [self.AufnahmenPop setAction:PopSelektor];
   //[AufnahmenPop insertItemWithTitle:@"Neuste Aufnahme" atIndex:0];
   [self.AufnahmenPop setPullsDown:NO];
   //[AufnahmenPop selectItemAtIndex:0];
   //[self.NamenListe setEditable:YES];
   [[self.NamenListe tableColumnWithIdentifier: @"aufnahmen"]setEditable:NO];
   
   [[self.NamenListe tableColumnWithIdentifier: @"aufnahmen"] setDataCell: (NSCell*)self.AufnahmenPop];
   [self.NamenListe setRowHeight: PopButtonSize.height];
   [[self.NamenListe tableColumnWithIdentifier: @"namen"]setEditable:NO];
   [[[self.NamenListe tableColumnWithIdentifier: @"namen"]dataCell]setFont:Tablefont];
   [[[self.NamenListe tableColumnWithIdentifier: @"anz"]dataCell]setFont:Tablefont];
   int i;
   NSDictionary* NamenDic;
   NSDictionary* AnzDic;
   NSDictionary* MarkDic;
   NSString* tempLeserPfad;
   NSMutableArray* tempAufnahmenliste;
   int tempAnzAufnahmen;
   NSMutableArray* tempAnzAufnahmenListe;
   tempAnzAufnahmenListe=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* AufnahmeFilesArray;
   
   [self.LesernamenPop removeAllItems];
   [self.LesernamenPop insertItemWithTitle:NSLocalizedString(@"Namen wählen:",@"Namen wählen") atIndex:0];
   //NSLog(@"\nAdminProjektNamenArray: %@\n\n",[AdminProjektNamenArray description]);
   NSArray* SessionNamenArray=[NSArray array];
   NSUInteger ProjektIndex=[[self.AdminProjektArray valueForKey:@"projekt"]indexOfObject:dasProjekt];
   if (ProjektIndex<NSNotFound)
   {
      NSDictionary* tempProjektDic=[self.AdminProjektArray objectAtIndex:ProjektIndex];
      //NSLog(@"setAdminPlayer: Projekt: %@ tempProjektDic: %@\n\n",dasProjekt,[tempProjektDic description]);
      
      if ([tempProjektDic objectForKey:@"sessionleserarray"])
      {
         SessionNamenArray=[tempProjektDic objectForKey:@"sessionleserarray"];
      }
   }
   //NSLog(@"setAdminPlayer: SessionLeserArray: %@",[SessionNamenArray description]);
   for (i=0; i < [self.AdminProjektNamenArray count]; i++)
   {
      //LesernamenPop setzen
      [self.LesernamenPop addItemWithTitle:[self.AdminProjektNamenArray objectAtIndex:i]];
      NSNumber* inSessionNumber;
      if ([SessionNamenArray containsObject:[self.AdminProjektNamenArray objectAtIndex:i]])
      {
         inSessionNumber=[NSNumber numberWithBool:YES];
      }
      else
      {
         inSessionNumber=[NSNumber numberWithBool:NO];
      }
      
      
      //Namen einsetzen, inSessionNumber einsetzen
      NamenDic=[NSDictionary dictionaryWithObjectsAndKeys:[self.AdminProjektNamenArray objectAtIndex:i], @"namen",inSessionNumber,@"insession",nil];
      //NSLog(@"setAdminPlayer    NamenDic: %@",[NamenDic description]);
      
      //Anzahl Aufnahmen für den Namen ausrechnen
      tempLeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:[[self.AdminProjektNamenArray objectAtIndex:i]description]];
      //NSLog(@"tempLeserPfad: %@",tempLeserPfad);
      tempAufnahmenliste=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempLeserPfad error:NULL]];
      
      
      
      //Anzahl Aufnahmen:
      tempAnzAufnahmen=[[Filemanager contentsOfDirectoryAtPath:tempLeserPfad error:NULL]count];
      //tempAnzAufnahmen=[tempAufnahmenliste count];
      //Unsichtbare Ordner entfernen
      
      if (tempAnzAufnahmen&&[[tempAufnahmenliste objectAtIndex:0] hasPrefix:@".DS"])
      {
         [tempAufnahmenliste removeObjectAtIndex:0];
         tempAnzAufnahmen--;
      }
      
      int k;
      int Kommentarzeile=-1;
      
      //Kommentarordner aus Liste entfernen
      NSString* KommentarString=[NSString stringWithString:@"Anmerkungen"];
      for(k=0;k<tempAnzAufnahmen;k++)
      {
         if ([[[tempAufnahmenliste objectAtIndex:k]description]isEqualToString: KommentarString])
         {
            //NSLog(@"Kommentar bei %d",k);
            Kommentarzeile=k;
            //[tempAufnahmenliste removeObjectAtIndex:k];
         }
         //bei Löschen im Netz: File 'afpDeletedxxxx' suchen
         //NSLog(@"kein Kommentar bei %d",k);
         
      }
      
      if (Kommentarzeile>=0) //Kommentarordner entfernen
      {
         [tempAufnahmenliste removeObjectAtIndex:Kommentarzeile];
         tempAnzAufnahmen--;
      }
      
      //bei Löschen im Netz: File 'afpDeletedxxxx' suchen
      int afpZeile=-1;
      for(k=0;k<tempAnzAufnahmen;k++)
      {
         if ([[[tempAufnahmenliste objectAtIndex:k]description]characterAtIndex:0]=='.')
         {
            NSLog(@"String mit Punkt: %@ auf Zeile: %d",[[tempAufnahmenliste objectAtIndex:k]description],k);
            afpZeile=k;
         }
         //NSLog(@"kein Kommentar bei %d",k);
         
      }
      if (afpZeile>=0) //afpDelete entfernen
      {
         [tempAufnahmenliste removeObjectAtIndex:afpZeile];
         tempAnzAufnahmen--;
      }
      
      AnzDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:tempAnzAufnahmen],@"anz",nil];
      
      //AufnahmeFilesArray=[NSArray arrayWithArray:	tempAufnahmenliste];
      AufnahmeFilesArray=[NSMutableArray arrayWithCapacity:tempAnzAufnahmen];
      NSString* indexString, *nextIndexString;
      int tausch=1;
      int m;
      while (tausch)
      {
         tausch=0;
         for (m=0;m<tempAnzAufnahmen-1;m++)//sortieren nach nummer
         {
            indexString=[NSString stringWithString:[tempAufnahmenliste objectAtIndex:m]];
            nextIndexString=[NSString stringWithString:[tempAufnahmenliste objectAtIndex:m+1]];
            int n1=[self AufnahmeNummerVon:indexString];
            int n2=[self AufnahmeNummerVon:nextIndexString];
            //NSLog(@"indexTitelString: %@  Nr:%d",indexTitelString,n1);
            //NSLog(@"nextindexTitelString: %@  Nr:%d",nextindexTitelString,n2);
            if(n2<n1)
            {
               [tempAufnahmenliste exchangeObjectAtIndex:m withObjectAtIndex:m+1];
               //NSLog(@"tausch: n1: %d    n2: %d",n1,n2);
               tausch++;
            }
            
         }//for anzahl
      }//while tausch
      
      
      int pos;
      //NSLog(@"setAdminPlayer Leser: %@ tempAufnahmenliste nach sortieren: %@",[tempLeserPfad lastPathComponent],[tempAufnahmenliste description]);
      //Reihenfolge der Aufnahmen umkehren: Neueste zuoberst
      NSNumber* FileCreatorNumber=[NSNumber numberWithUnsignedLong:'RPDF'];
      //NSLog(@"FileCreatorNumber: %d\r",[FileCreatorNumber intValue]);
      NSMutableArray* tempMarkArray=[[NSMutableArray alloc]initWithCapacity:tempAnzAufnahmen];
      int kk;
      for (kk=0;kk<tempAnzAufnahmen;kk++)
      {
         //NSNumber* tempMark=[NSNumber numberWithBool:0];
         [tempMarkArray addObject:[NSNumber numberWithBool:NO]];
      }
      
      for (m=0;m<tempAnzAufnahmen;m++)
      {
         NSString* tempAnmerkungPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
         tempAnmerkungPfad=[tempAnmerkungPfad stringByAppendingPathComponent:[tempAufnahmenliste objectAtIndex:m]];
         BOOL tempAdminMark=NO;
         //
         if ([Filemanager fileExistsAtPath:tempAnmerkungPfad])
         {
            //NSLog(@"File exists an Pfad: %@",tempAnmerkungPfad);
            tempAdminMark=[self AufnahmeIstMarkiertAnAnmerkungPfad:tempAnmerkungPfad];
            
            /*
             NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempAnmerkungPfad];
             NSMutableArray* tempKommentarArrary=(NSMutableArray *)[tempKommentarString componentsSeparatedByString:@"\r"];
             NSLog(@"tempKommentarArrary vor: %@",[tempKommentarArrary description]);
             if (tempKommentarArrary &&[tempKommentarArrary count])
             {
             NSNumber* AdminMarkNumber=[tempKommentarArrary objectAtIndex:3];
             NSLog(@"istMarkiert		AdminMarkNumber: %d",[AdminMarkNumber intValue]);
             
             AdminMark=[AdminMarkNumber intValue];
             
             }
             */
            
         }//file exists
         
         //
         //NSLog(@"setAdminPlayer zeile: %d Pfad: %@ Mark: %d",m,tempAnmerkungPfad,AdminMark);
         
         [tempMarkArray replaceObjectAtIndex:(tempAnzAufnahmen-m-1) withObject:[NSNumber numberWithBool:tempAdminMark]];
         
         /*
          NSDictionary* AufnahmeAttribute=[Filemanager fileAttributesAtPath:tempAttributesPfad traverseLink:YES];
          if (AufnahmeAttribute )
          {
          NSNumber* AufnahmeMarke=[AufnahmeAttribute objectForKey:NSFileHFSCreatorCode];
          //NSLog(@"Aufnahme: %@ index: %d  Aufn.Marke: %d",[tempAufnahmenliste objectAtIndex:m],m,[AufnahmeMarke intValue]);
          //NSString * Type=NSHFSTypeOfFile(tempAttributesPfad);
          if ([AufnahmeMarke intValue]==[FileCreatorNumber intValue])
          {
          //NSLog(@"**** Aufnahme: %@ index: %d  Aufn.Marke: %d",[tempAufnahmenliste objectAtIndex:m],m,[AufnahmeMarke intValue]);
          [tempMarkArray replaceObjectAtIndex:(tempAnzAufnahmen-m-1) withObject:[NSNumber numberWithBool:YES]];
          //In willDisplayCell wird die Reihenfolge umgekehrt
          }
          else
          {
          //NSLog(@"Aufnahme: ");
          }
          }
          */
      }
      [self.AdminDaten setMarkArray:tempMarkArray forRow:i];
      
      if (tempAnzAufnahmen)
      {
         for(pos=0;pos<tempAnzAufnahmen;pos++)
         {
            [AufnahmeFilesArray insertObject:[tempAufnahmenliste objectAtIndex:(tempAnzAufnahmen-1)-pos] atIndex:pos ];
            
         }
      }
      //NSLog(@"AufnahmeFilesArray nach wenden: %@   index: %d",[AufnahmeFilesArray description],i);
      //
      
      [self.AdminDaten setAufnahmeFiles:AufnahmeFilesArray forRow:i];
      //NSLog(@"setAufnahmeFiles");
      //Aufnahmen ins Pop einsetzen
      //NSPopUpButtonCell* tempPopUpButtonCell;
      //tempPopUpButtonCell =[[self.NamenListe tableColumnWithIdentifier: @"aufnahmen"]dataCellForRow:i];
      //[tempPopUpButtonCell addItemsWithTitles:tempAufnahmenliste];
      
      [self.AdminDaten setData: NamenDic  forRow:i];
      
      
      //NSLog(@"setData: NamenDic");
      //[NamenDic autorelease];
      [self.AdminDaten setData: AnzDic  forRow:i];
      //NSLog(@"setData: AnzDic");
      //[AnzDic release];
   }
   
   
   
   //NSButtonCell* PlayNeu;
   //PlayNeu=[[NSButtonCell alloc]init];
   //[PlayNeu setButtonType:NSMomentaryLight];
   //[PlayNeu setTitle:@">"];
   //SEL PlayNeuSelektor;
   //PlayNeuSelektor=@selector(AufnahmeInPlayer:);
   //[PlayNeu setAction:PlayNeuSelektor];
   
   //[PlayNeu setControlSize: NSMiniControlSize];
   //[[self.NamenListe tableColumnWithIdentifier: @"neu"] setDataCell: PlayNeu];
   //for (i=0; i < AnzLeser; i++)
   //{
   //	[[[self.NamenListe tableColumnWithIdentifier: @"neu"]dataCellForRow:i]setTag:i];
   //}
   
   [self.AdminDaten setEditable:YES];
   [self.NamenListe setDataSource:self.AdminDaten];
   [self.NamenListe setDelegate: self.AdminDaten];
   [self.NamenListe reloadData];
   SEL DoppelSelektor;
   DoppelSelektor=@selector(AufnahmeInPlayer:);
   [self.NamenListe setDoubleAction:DoppelSelektor];
   NSFont* n1;
   n1=[NSFont fontWithName:@"Helvetica" size:10];
   [self.AbspieldauerFeld setFont:n1];
   //[self.NamenListe setRowHeight: 24];
   //NSLog(@"setAdminplayer fertig");
   self.Moviegeladen=NO;
   [self.AufnahmenTab setDelegate:self];
   
   [self.AufnahmenTable setDoubleAction:DoppelSelektor];
}

- (IBAction)AufnahmeSetzen:(id)sender
{
   //NSLog(@"AufnahmeSetzen: Zeile: %d",[sender selectedRow]);
   //[self setLeserFuerZeile:[sender selectedRow]];
}

- (IBAction)setNeuesAdminProjekt:(id)sender
{
   //NSLog(@"\n\n*********setNeuesAdminProjekt: %@\nAdminProjektArray: %@",[sender titleOfSelectedItem],AdminProjektArray);
   [self setAdminPlayer:self.AdminLeseboxPfad inProjekt:[sender titleOfSelectedItem]];
   [self setProjektPopMenu:self.AdminProjektArray];
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   
   [NotificationDic setObject:[self.AdminProjektPfad lastPathComponent] forKey:@"projekt"];
   
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"ProjektMenu" object:self userInfo:NotificationDic];
   
}

- (void)setAdminProjektArray:(NSArray*)derProjektArray
{
   //NSLog(@"\n\n			--------setAdminProjektArray: derProjektArray: %@",derProjektArray);
   [self.AdminProjektArray removeAllObjects];
   [self.AdminProjektArray setArray:derProjektArray];
   //NSLog(@"setAdminProjektArray: AdminProjektArray: %@",[[AdminProjektArray lastObject]description]);
   
   [self setProjektPopMenu:self.AdminProjektArray];
   
}

- (void)setProjektPopMenu:(NSArray*)derProjektArray
{
   NSString* tempProjektName=[self.AdminProjektPfad lastPathComponent];
   //NSLog(@"setProjektPop  derProjektArray: %@",[derProjektArray description]);
   int anz=[self.ProjektPop numberOfItems];
   int i=0;
   if (anz>1)
   {
      while (anz>1)
      {
         [self.ProjektPop removeItemAtIndex:1];
         anz--;
      }
   }
   if ([derProjektArray count])
   {
      NSImage* MarkOnImg=[NSImage imageNamed:@"MarkOnImg.tif"];
      NSImage* MarkOffImg=[NSImage imageNamed:@"MarkOffImg.tif"];
      
      NSEnumerator* ProjektEnum=[derProjektArray objectEnumerator];
      id einProjektDic;
      
      while (einProjektDic=[ProjektEnum nextObject])
      {
         //NSLog(@"*setProjektPopMenu einProjektDic: %@",einProjektDic);
         NSString* tempTitel=[einProjektDic objectForKey:@"projekt"];
         if (tempTitel&&[tempTitel length]&&![tempTitel isEqualToString:tempProjektName])
         {
            [self.ProjektPop addItemWithTitle:tempTitel];
            //NSLog(@"*setProjektPopMenu einProjektDic: %@",einProjektDic);
            
            if ([einProjektDic objectForKey:@"OK"] && [[einProjektDic objectForKey:@"OK"]boolValue])
            {
               NSImage* CrossImg=[NSImage imageNamed:@"CrossImg.tif"];
               [[self.ProjektPop itemWithTitle:tempTitel]setImage:CrossImg];
            }
            else
            {
               NSImage* BoxImg=[NSImage imageNamed:@"BoxImg.tif"];
               [[self.ProjektPop itemWithTitle:tempTitel]setImage:BoxImg];
            }
            
         }
      }
   }//ProjektArray count
   
}

- (void) resetAdminPlayer
{
   //NSLog(@"AdminPlayer resetAdminPlayer");
   [self.NamenListe deselectAll:nil];
   [self.zurListeTaste setEnabled:NO];
   [self.PlayTaste setEnabled:NO];
   [self.AdminDaten deleteAllData];
   [self.NamenListe reloadData];
   self.Textchanged=NO;
   self.Moviegeladen=NO;
   
   /*
    [AdminQTKitPlayer pause:NULL];
    [AdminQTKitPlayer gotoBeginning:nil];
    [AdminQTKitPlayer setMovie:nil];
    [AdminQTKitPlayer setHidden:YES];
    */
   
   
   [self setBackTaste:NO];
   [self.AbspieldauerFeld setStringValue:@""];
   //NSLog(@"vor saveKommentarFuerLeser");
   if ([self.AdminAktuellerLeser length]&&[self.AdminAktuelleAufnahme length]&&self.Textchanged)
	  {
        BOOL OK=[self saveKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
        self.AdminAktuellerLeser=@"";
        self.AdminAktuelleAufnahme=@"";
     }
   [self clearKommentarfelder];
   [self.AdminKommentarView setEditable:NO];
   [self.AdminKommentarView setSelectable:NO];
   //	[AdminBewertungfeld setEditable:NO];
   [self.AdminNotenfeld setEnabled:NO];
   [self.AdminNotenfeld setEditable:NO];
   [self.ExportierenTaste setEnabled:NO];
   [self.LoeschenTaste setEnabled:NO];
   [self.zurListeTaste setEnabled:NO];
   
}

- (int)selektierteZeile
{
   return [self.NamenListe selectedRow];
   
}

- (void) setLeseboxPfad:(NSString*)derPfad inProjekt: (NSString*)dasProjekt
{
   self.AdminLeseboxPfad=derPfad;
   self.AdminArchivPfad =[self.AdminLeseboxPfad stringByAppendingString:@"Archiv"];
   self.AdminProjektPfad =[self.AdminArchivPfad stringByAppendingString:dasProjekt];
}

- (NSString*)AdminLeseboxPfad
{
   if (self.AdminLeseboxPfad)
      return self.AdminLeseboxPfad;
   else
	  {
        //NSLog(@"++++++++++++++++++++++++++AdminLeseboxPfad NULL");
        return NULL;
     }
}
- (IBAction)setLeser:(id)sender
{
   //	*********************************** wird von AdminListeaufgerufen: Löst Aktion des PopMenues aus !!!
   int hitZeile=[sender selectedRow];
   //NSLog(@"hitZeile: %d ",hitZeile);
   if (hitZeile<0)
      return;
   if ([[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]count])
   {
      int hit=[[[self.AdminDaten dataForRow:hitZeile]objectForKey:@"aufnahmen"]intValue];
      NSString* Leser=[[self.AdminProjektNamenArray objectAtIndex:hitZeile]description];
      self.AdminAktuellerLeser=[[self.AdminProjektNamenArray objectAtIndex:hitZeile]description];
      //NSLog(@"setLeser Zeile: %d",[sender selectedRow]);
      //NSLog(@"Leser: %@",[[AdminProjektNamenArray objectAtIndex:[sender selectedRow]]description]);
      //NSLog(@"setLeser:     Zeile: %d   hit:%d ",hitZeile,hit);
      //NSLog(@"i:%d ",hitZeile);
      
      [self.AdminDaten setAuswahl:hit forRow:hitZeile];
      //NSString* tempAufnahmePfad=[[[AdminDaten AufnahmeFilesFuerZeile:hitZeile]objectAtIndex:hit]description];
      //NSString* tempAdminAktuelleAufnahme=AdminAktuelleAufnahme;
      if (![self.AdminAktuelleAufnahme isEqualToString:[[[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]objectAtIndex:hit]description]])//andere Aufnahme gewählt
      {
         //NSLog(@"andere Aufnahme");
         if (self.Moviegeladen)
         {
            NSLog(@"save alten Kommentar, Movie geladen");
            [self backZurListe:nil];//Aufnahme zurücklegen
         }
      }
      //NSLog(@"setLeser   Leser: %@  zeile: %d  hit: %d   File:  %@",Leser, hitZeile, hit, tempAufnahmePfad);
      self.AdminAktuelleAufnahme=[[[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]objectAtIndex:hit]description];
      
      
      BOOL OK=[self setPfadFuerLeser: Leser FuerAufnahme:self.AdminAktuelleAufnahme];
      OK=[self setKommentarFuerLeser: Leser FuerAufnahme:self.AdminAktuelleAufnahme];
      
      NSString* tempAufnahmePfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];
      tempAufnahmePfad=[tempAufnahmePfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];
      if ([self.AdminDaten MarkForRow:hitZeile forItem:hit])
      {
         [self.MarkCheckbox setState:YES];
      }
      else
      {
         [self.MarkCheckbox setState:NO];
         
      }
      
      
   }
   else
   {
      NSLog(@"SetLeser        Keine Aufnahme");
      NSBeep();
      [self.PlayTaste setEnabled:NO];
      [self.ExportierenTaste setEnabled:NO];
      [self.LoeschenTaste setEnabled:NO];
      [self.MarkCheckbox setState:NO];
      [self clearKommentarfelder];
      
   }
}

- (BOOL)AnzahlAufnahmenFuerZeile:(int)dieZeile
{
   if ([[self.AdminDaten AufnahmeFilesFuerZeile:dieZeile]count])
      return YES;
   else
      return NO;
}

- (BOOL)AnzahlAufnahmen
{
   int hitZeile;
   hitZeile=[self.NamenListe selectedRow];
   if (hitZeile<0)
      return NO;
   //NSLog(@"hitZeile: %d",hitZeile);
   if ([[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]count])
      return YES;
   else
      return NO;
}
- (void)setLeserFuerZeile:(int)dieZeile
{
   int hitZeile=dieZeile;
   //NSLog(@"setLeserFuerZeile: hitZeile: %d ",hitZeile);
   
   if (hitZeile<0) return;
   
   if ([[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]count])
   {
      //[AdminKommentarView selectAll:nil];
      //[AdminKommentarView delete:nil];
      [self.AdminKommentarView setString:@""];
      //NSLog(@"setLeserFuerZeile    Leser Zeile: %d",hitZeile);
      
      int hit=[[[self.AdminDaten dataForRow:hitZeile]objectForKey:@"aufnahmen"]intValue];
      NSString* Leser=[[self.AdminProjektNamenArray objectAtIndex:hitZeile]description];
      self.AdminAktuellerLeser=[[self.AdminProjektNamenArray objectAtIndex:hitZeile]description];
      //NSLog(@"setLeserFuerZeile    Leser Zeile: %d",hitZeile);
      //NSLog(@"Leser: %@",[[AdminProjektNamenArray objectAtIndex:[sender selectedRow]]description]);
      //NSLog(@"Zeile: %d   hit:%d ",hitZeile,hit);
      //NSLog(@"i:%d ",hitZeile);
      [self.AdminDaten setAuswahl:hit forRow:hitZeile];
      NSString* Ziel=[[[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]objectAtIndex:hit]description];
      self.AdminAktuelleAufnahme=[[[self.AdminDaten AufnahmeFilesFuerZeile:hitZeile]objectAtIndex:hit]description];
      
      //NSLog(@"setLeserFuerZeile Leser: %@  zeile: %d  hit: %d   File:  %@",Leser, hitZeile, hit, Ziel);
      BOOL OK;
      OK=[self setPfadFuerLeser: Leser FuerAufnahme:Ziel];
      //Pfad für Aufnahme: AdminPlayPfad
      OK=[self setKommentarFuerLeser: Leser FuerAufnahme:Ziel];
      
      
      
      NSString* tempAufnahmePfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];
      tempAufnahmePfad=[tempAufnahmePfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];
      //NSFileManager *Filemanager=[NSFileManager defaultManager];
      //if ([Filemanager fileExistsAtPath
      if ([self.AdminDaten MarkForRow:hitZeile forItem:hit])
      {
         [self.MarkCheckbox setState:YES];
      }
      else
      {
         [self.MarkCheckbox setState:NO];
         
      }
      
      [self.PlayTaste setEnabled:YES];
      //		[MarkCheckbox setEnabled:YES];
   }
   else
   {
      //NSLog(@"setLeserFuerZeile		Keine Aufnahme");
      NSBeep();
      self.AdminAktuellerLeser=@"";
      self.AdminAktuelleAufnahme=@"";
      [self clearKommentarfelder];
      [self.PlayTaste setEnabled:NO];
      [self.zurListeTaste setEnabled:NO];
      [self.zurListeTaste setKeyEquivalent:@""];
      [self.MarkCheckbox setState:NO];
      [self.MarkCheckbox setEnabled:NO];
   }
}

- (BOOL)setPfadFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
{
   //NSLog(@"setPfadFuerLeser:%@ dieAufnahme: %@",derLeser, dieAufnahme);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* Leser=[derLeser copy];
   
   
   NSString* Ziel=[dieAufnahme copy];
   NSString* ZielPfad;//=[NSString stringWithString:AdminProjektPfad];
   ZielPfad=[self.AdminProjektPfad stringByAppendingPathComponent:Leser];
   
   if ([Filemanager fileExistsAtPath:ZielPfad])
   {
      ZielPfad=[ZielPfad stringByAppendingPathComponent:Ziel];
      if ([Filemanager fileExistsAtPath:ZielPfad])
      {
         
         //NSLog(@"File da: %@",ZielPfad);
         self.AdminPlayPfad=[NSString stringWithString:ZielPfad];
         
         /*
          if (AdminPlayerMovie)
          {
          SetMovieActive(AdminPlayerMovie,false);
          }
          [AdminQTKitPlayer pause:NULL];
          [AdminQTKitPlayer  gotoBeginning:NULL];
          [AdminQTKitPlayer setMovie:NULL];
          */
         
         
         
      }
      else
      {
         NSLog(@"Kein File da");
         return NO;
      }
   }
   return YES;
}

- (BOOL)setKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* Leser=[derLeser copy];
   [self.AdminNamenfeld setStringValue: Leser];
   //[Leser release];
   NSString* Ziel=[dieAufnahme copy];
   [self.AdminTitelfeld setStringValue:[self AufnahmeTitelVon:Ziel]];
   //NSLog(@"setKommentarFuerLeser:%@		FuerAufnahme:%@",derLeser, dieAufnahme);
   BOOL istDirectory;
   NSString* tempKommentarPfad=[NSString stringWithString:self.AdminProjektPfad];
   NSString* KommentarOrdnerString=@"Anmerkungen";
   NSString* KommentarString;
   tempKommentarPfad=[tempKommentarPfad stringByAppendingPathComponent:Leser];
   [self.AdminKommentarView setString:@""];
   
   [self.AdminKommentarView setEditable:YES];
   [self.AdminKommentarView setString:@""];
   //[AdminKommentarView selectAll:nil];
   //[AdminKommentarView delete:nil];
   
   if ([Filemanager fileExistsAtPath:tempKommentarPfad isDirectory:&istDirectory])//Ordner für Leser vorhanden
   {
      if (istDirectory)
      {
         tempKommentarPfad=[tempKommentarPfad stringByAppendingPathComponent:KommentarOrdnerString];
         if ([Filemanager fileExistsAtPath:tempKommentarPfad isDirectory:&istDirectory])//Ordner Kommentar vorhanden
         {
            if (istDirectory)
            {
               tempKommentarPfad=[tempKommentarPfad stringByAppendingPathComponent:Ziel];
               if ([Filemanager fileExistsAtPath:tempKommentarPfad])//Kommentar vorhanden
               {
                  KommentarString=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                  if ([KommentarString length])
                  {
                     //NSLog(@"setKommentar KommentarString: %@",KommentarString);
                     //[AdminKommentarfeld setStringValue: KommentarString];
                     
                     [self.AdminKommentarView setString:[self KommentarVon:KommentarString]];
                     [self.AdminDatumfeld setStringValue:[self DatumVon:KommentarString]];
                     int index=[self.AdminBewertungfeld indexOfItemWithTitle:[self BewertungVon:KommentarString]];
                     if (index>=0)
                     {
                        [self.AdminBewertungfeld selectItemAtIndex:index];
                     }
                     else
                     {
                        int index=[self.AdminBewertungfeld indexOfItemWithTitle:@"+"];
                     }
                     [self.AdminNotenfeld setStringValue:[self NoteVon:KommentarString]];
                     //NSLog(@"BestCheckbox Mark: %d",[self UserMarkVon:KommentarString]);
                     [self.UserMarkCheckbox setState:[self UserMarkVon:KommentarString]];
                  }
                  else
                  {
                     [self.AdminKommentarView setString:@"neue Anmerkungen:"];
                     //[AdminKommentarView selectAll:nil];
                     [self.AdminDatumfeld setStringValue:@""];
                     //  [AdminBewertungfeld setStringValue:@""];
                     [self.AdminNotenfeld setStringValue:@""];
                     [self.UserMarkCheckbox setState:NO];
                  }
               }
               else
               {
                  
                  [self.AdminKommentarView setString:@"Keine Anmerkungen"];
                  //[AdminKommentarView selectAll:nil];
                  [self.AdminDatumfeld setStringValue:@""];
                  [self.AdminBewertungfeld setStringValue:@""];
                  [self.AdminNotenfeld setStringValue:@""];
                  [self.UserMarkCheckbox setState:NO];
               }
               
               
            }
         }
      }
   }
   [self.AdminKommentarView setEditable:NO];
   [self.AdminKommentarView setSelectable:NO];
   [self.AdminDatumfeld setEditable:NO];
   //	[AdminBewertungfeld setEditable:NO];
   [self.AdminNotenfeld setEditable:NO];
   
   
   
   return YES;
}


- (BOOL)saveKommentarFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
{
   NSLog(@"saveKommentarFuerLeser Leser: %@ Aufnahme: %@",derLeser, dieAufnahme);
   
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* tempLeser=[derLeser copy];
   if ([tempLeser length]==0)
   {
      NSLog(@"saveKommentarFuerLeser: Kein Leser");
      self.Textchanged=NO;
      return NO;
   }
   NSString* tempAufnahme;
   tempAufnahme=[dieAufnahme copy];
   //NSLog(@"");
   NSString* tempAdminAufnahmePfad=[NSString stringWithString:self.AdminProjektPfad];
   tempAdminAufnahmePfad=[tempAdminAufnahmePfad stringByAppendingPathComponent:tempLeser];
   if ([Filemanager fileExistsAtPath:tempAdminAufnahmePfad])//Ordner für Aufnahmen des Lesers ist da
   {
      tempAdminAufnahmePfad=[tempAdminAufnahmePfad stringByAppendingPathComponent:tempAufnahme];
      if ([Filemanager fileExistsAtPath:tempAdminAufnahmePfad])//Aufnahme gibt es
      {
         //NSLog(@"Aufnahme da");
      }
      else
      {
         //NSLog(@"Aufnahme nicht da");
         return NO;
      }
      
   }
   NSString* KommentarOrdnerString=@"Anmerkungen";
   NSString* tempAdminKommentarPfad=[[self.AdminProjektPfad copy] stringByAppendingPathComponent:tempLeser];
   NSString* tempKommentarString;
   NSString* tempKopfString;
   //NSLog(@"in saveKommentarFuerLeser 1");
   if ([Filemanager fileExistsAtPath:tempAdminKommentarPfad isDirectory:&istDirectory])//Ordner des Lesers ist da
   {
      if (istDirectory)
      {
         tempAdminKommentarPfad=[tempAdminKommentarPfad stringByAppendingPathComponent:KommentarOrdnerString];
         NSLog(@"saveKommentarFuerLeser: tempAdminKommentarPfad: %@",tempAdminKommentarPfad);
         if (![Filemanager fileExistsAtPath:tempAdminKommentarPfad isDirectory:&istDirectory])//noch kein Kommentarordner des Lesers ist da
         {
            erfolg=[Filemanager createDirectoryAtPath:tempAdminKommentarPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
            NSLog(@"saveKommentarFuerLeser: tempAdminKommentarPfad: %@ erfolg: %d",tempAdminKommentarPfad,erfolg);
            
            if (!erfolg)
            {
               return erfolg;
            }
            
         }
         //NSLog(@"in saveKommentarFuerLeser: Kommentarordner da");
         
         tempAdminKommentarPfad=[tempAdminKommentarPfad stringByAppendingPathComponent:tempAufnahme];
         
         //Kopfstring aufbauen
         tempKopfString=[NSString stringWithString:self.AdminAktuellerLeser];
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         if ([self.AdminAktuelleAufnahme length]>1)
         {
            tempKopfString=[tempKopfString stringByAppendingString:self.AdminAktuelleAufnahme];
         }
         else
         {
            tempKopfString=[tempKopfString stringByAppendingString:@"Kein Titel"];
         }
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         
         NSNumber *AufnahmeSize;
         
         NSDictionary *AufnahmeAttrs = [Filemanager attributesOfItemAtPath:tempAdminAufnahmePfad error:NULL];
         if (AufnahmeAttrs)
         {
            NSDate* CreationDate = [AufnahmeAttrs objectForKey:NSFileCreationDate];
         }
         else
         {
            NSLog(@"AufnahmeAttrs: Path is incorrect!");
         }
         
         NSDate* CreationDate = [AufnahmeAttrs objectForKey:NSFileCreationDate];
         if (CreationDate)
         {
            NSCalendarDate* tempDatum=[CreationDate dateWithCalendarFormat:@"%d.%m.%Y %H:%M:%S" timeZone:nil];
            tempKopfString=[tempKopfString stringByAppendingString:[tempDatum description]];
            //NSLog(@"ModDate: %@  Datum: %@",[moddate description],[tempDatum description]);
         }
         else
         {
            tempKopfString=[tempKopfString stringByAppendingString:@"Kein Datum"];
         }
         //NSLog(@"Kopfstring: %@",[tempKopfString description]);
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         
         AufnahmeSize = [AufnahmeAttrs objectForKey:NSFileSize];
         if (AufnahmeSize)
         {
            //tempKopfString=[tempKopfString stringByAppendingString:@"Dateigrösse:"];
            //tempKopfString=[tempKopfString stringByAppendingString:[AufnahmeSize stringValue]];
            //tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
            
         }
         
         NSNumber* POSIX = [AufnahmeAttrs objectForKey:NSFilePosixPermissions];
         if (POSIX)
         {
            NSLog(@"POSIX: %d",	[POSIX intValue]);
         }
         
         // Bewertung
         NSString* BewertungString=[self.AdminBewertungfeld titleOfSelectedItem];
         NSLog(@"saveKommentar	 BewertungString: %@",BewertungString);
         if ([BewertungString length]==0)
         {
            BewertungString=@" ";
         }
         tempKopfString=[tempKopfString stringByAppendingString:BewertungString];
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         
         NSLog(@"saveKommentar	tempKopfString mit Bewertungstring: %@",tempKopfString);
         
         // Notenstring
         NSString* NotenString=[self.AdminNotenfeld stringValue];
         NSLog(@"saveKommentar	xx NotenString: %@",NotenString);
         if ([NotenString length]==0)
         {
            NotenString=@"-";
         }
         tempKopfString=[tempKopfString stringByAppendingString:NotenString];
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         //NSLog(@"saveKommentar	tempKopfString mit Notenstring: %@",tempKopfString);
         
         //UserMark
         NSString* UserMarkString;
         NSNumber* UserMarkNumber=[NSNumber numberWithBool:[self.UserMarkCheckbox state]];
         //NSLog(@"saveKommentar	xx MarkString: %@",MarkString);
         if ([UserMarkNumber boolValue]==0)
         {
            UserMarkString=@"0";
         }
         else
         {
            UserMarkString=@"1";
         }
         tempKopfString=[tempKopfString stringByAppendingString:UserMarkString];
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         
         // AdminMark
         NSNumber* AdminMarkNumber=[NSNumber numberWithBool:[self.MarkCheckbox state]];
         //NSLog(@"saveKommentar	xx BewertungString: %@",BewertungString);
         NSString* AdminMarkString;
         if ([AdminMarkNumber boolValue]==0)
         {
            AdminMarkString=@"0";
         }
         else
         {
            AdminMarkString=@"1";
         }
         tempKopfString=[tempKopfString stringByAppendingString:AdminMarkString];
         
         tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
         
         
         
         //			  NSLog(@"+++++++++++++				saveKommentar	tempKopfString mit MarkString: %@",MarkString);
         
         
         if ([Filemanager fileExistsAtPath:tempAdminKommentarPfad])//schon ein Kommentar zur Aufnahme da
         {
            //NSLog(@"saveKommentar: schon ein Kommentar da");
            erfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempAdminKommentarPfad ] error:nil];
            if (!erfolg)
            {
               return NO;
            }
            
            //NSLog(@"in saveKommentarFuerLeser alter Kommentar gelöscht");
            
         }
         //NSLog(@"saveKommentar: noch kein Kommentar da");
         
         NSString* tempKommentarViewString=[NSString stringWithString:[self.AdminKommentarView string]];
         if ([tempKommentarViewString length])
         {
            //	NSLog(@"tempKommentarViewString: substring bis 2: %@  substring ab 2: %@",[tempKommentarViewString substringToIndex:2],[tempKommentarViewString substringFromIndex:2]);
            if ([[tempKommentarViewString substringToIndex:2] isEqualToString:@"--"])//entfernen
            {
               tempKommentarViewString=[tempKommentarViewString substringFromIndex:2];
            }
            tempKommentarString=[tempKopfString stringByAppendingString:tempKommentarViewString];
            //NSLog(@"saveKommentar:      tempKommentarString:\r %@",tempKommentarString);
         }
         else
         {
            tempKommentarString=[tempKopfString stringByAppendingString:@"--"];
            NSLog(@"saveKommentar                       tempKommentarString ist leer: %@",tempKommentarString);
         }
         
         NSData* tempData=[tempKommentarString dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:NO];
         NSMutableDictionary* AufnahmeAttribute=[[NSMutableDictionary alloc]initWithCapacity:0];
         NSNumber* POSIXNumber=[NSNumber numberWithInt:438];
         [AufnahmeAttribute setObject:POSIXNumber forKey:NSFilePosixPermissions];
         
         erfolg=[Filemanager createFileAtPath:tempAdminKommentarPfad contents:tempData attributes:AufnahmeAttribute];
         
      }
   }
   [self clearKommentarfelder];
   self.Textchanged=NO;
   
   return erfolg;
   
}//saveKommentar


- (BOOL)saveAdminMarkFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
                  mitAdminMark:(int)dieAdminMark

{
   NSLog(@"in saveAdminMarkFuerLeser Anfang Leser: %@ Aufnahme: %@ AdminMark: %d",derLeser,dieAufnahme,dieAdminMark);
   
   BOOL erfolg;
   BOOL tempAdminMark=NO;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* tempLeser=[derLeser copy];
   if ([tempLeser length]==0)
   {
      NSLog(@"saveAdminMarkFuerLeser: Kein Leser");
      return NO;
   }
   NSString* tempAufnahme;
   tempAufnahme=[dieAufnahme copy];
   NSLog(@"\n");
   NSString* tempAdminAufnahmePfad=[NSString stringWithString:self.AdminProjektPfad];
   tempAdminAufnahmePfad=[tempAdminAufnahmePfad stringByAppendingPathComponent:tempLeser];
   
   NSString* KommentarOrdnerString=@"Anmerkungen";
   NSString* tempAdminKommentarPfad=[[self.AdminProjektPfad copy] stringByAppendingPathComponent:tempLeser];
   NSString* tempKommentarString;
   NSString* tempKopfString;
   NSLog(@"in saveAdminMarkFuerLeser tempAdminKommentarPfad: %@",tempAdminKommentarPfad);
   if ([Filemanager fileExistsAtPath:tempAdminKommentarPfad isDirectory:&istDirectory])//Ordner des Lesers ist da
   {
      if (istDirectory)
      {
         tempAdminKommentarPfad=[tempAdminKommentarPfad stringByAppendingPathComponent:KommentarOrdnerString];
         tempAdminKommentarPfad=[tempAdminKommentarPfad stringByAppendingPathComponent:tempAufnahme];
         if ([Filemanager fileExistsAtPath:tempAdminKommentarPfad])
         {
            NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempAdminKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
            NSMutableArray* tempKommentarArrary=(NSMutableArray *)[tempKommentarString componentsSeparatedByString:@"\r"];
            //NSLog(@"tempKommentarArrary vor: %@",[tempKommentarArrary description]);
            if (tempKommentarArrary &&[tempKommentarArrary count]>7)
            {
               NSNumber* AdminMarkNumber=[NSNumber numberWithInt:dieAdminMark];
               NSLog(@"saveMark		replaceObjectAtIndex1");
               [tempKommentarArrary replaceObjectAtIndex:tempAdminMark withObject:[AdminMarkNumber stringValue]];
               NSLog(@"tempKommentarArrary nach: %@ AdminMark:%d",[tempKommentarArrary description],[AdminMarkNumber intValue]);
               
               
            }
            NSString* newKommentarString=[tempKommentarArrary componentsJoinedByString:@"\r"];
            //NSLog(@"newKommentarString: %@",newKommentarString);
            [newKommentarString writeToFile:tempAdminKommentarPfad atomically:YES encoding:NSMacOSRomanStringEncoding error:NULL];
         }//if Kommentar da
         else
         {
            NSLog(@"Kein Kommentar an tempAdminKommentarPfad");
         }
         
      }
      else
      {
         NSLog(@"Kein Directory an tempAdminKommentarPfad");
      }
   }
   else
   {
      NSLog(@"Kein Ordner an tempAdminKommentarPfad");
   }
   
   return erfolg;
   
}

- (BOOL)saveMarksFuerLeser:(NSString*) derLeser FuerAufnahme:(NSString*)dieAufnahme
              mitAdminMark:(int)dieAdminMark
               mitUserMark:(int)dieUserMark
{
   NSLog(@"in saveMarksFuerLeser Anfang Leser: %@ Aufnahme: %@ AdminMark: %d UserMark: %d",derLeser,dieAufnahme,dieAdminMark,dieUserMark);
   
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* tempLeser=[derLeser copy];
   if ([tempLeser length]==0)
   {
      NSLog(@"saveAdminMarkFuerLeser: Kein Leser");
      return NO;
   }
   NSString* tempAufnahme;
   tempAufnahme=[dieAufnahme copy];
   NSLog(@"\n");
   NSString* tempAdminAufnahmePfad=[NSString stringWithString:self.AdminProjektPfad];
   tempAdminAufnahmePfad=[tempAdminAufnahmePfad stringByAppendingPathComponent:tempLeser];
   if ([Filemanager fileExistsAtPath:tempAdminAufnahmePfad])//Ordner für Aufnahmen des Lesers ist da
   {
      tempAdminAufnahmePfad=[tempAdminAufnahmePfad stringByAppendingPathComponent:tempAufnahme];
      
   }
   NSString* KommentarOrdnerString=@"Anmerkungen";
   NSString* tempAdminKommentarPfad=[[self.AdminProjektPfad copy] stringByAppendingPathComponent:tempLeser];
   NSString* tempKommentarString;
   NSString* tempKopfString;
   //NSLog(@"in saveKommentarFuerLeser 1");
   if ([Filemanager fileExistsAtPath:tempAdminKommentarPfad isDirectory:&istDirectory])//Ordner des Lesers ist da
   {
      if (istDirectory)
      {
         tempAdminKommentarPfad=[tempAdminKommentarPfad stringByAppendingPathComponent:KommentarOrdnerString];
         tempAdminKommentarPfad=[tempAdminKommentarPfad stringByAppendingPathComponent:tempAufnahme];
         if ([Filemanager fileExistsAtPath:tempAdminKommentarPfad])
         {
            NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempAdminKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
            NSMutableArray* tempKommentarArrary=(NSMutableArray *)[tempKommentarString componentsSeparatedByString:@"\r"];
            //NSLog(@"tempKommentarArrary vor: %@",[tempKommentarArrary description]);
            if (tempKommentarArrary &&[tempKommentarArrary count])
            {
               if ([tempKommentarArrary count]==8)//Zeile für Mark ist da
               {
                  NSNumber* AdminMarkNumber=[NSNumber numberWithInt:dieAdminMark];
                  NSLog(@"saveMark		replaceObjectAtIndex1");
                  [tempKommentarArrary replaceObjectAtIndex:AdminMark withObject:[AdminMarkNumber stringValue]];
                  NSLog(@"tempKommentarArrary nach: %@ AdminMark:%@",[tempKommentarArrary description],[AdminMarkNumber stringValue]);
                  
                  NSNumber* UserMarkNumber=[NSNumber numberWithInt:dieUserMark];
                  NSLog(@"saveMark		replaceObjectAtIndex1");
                  [tempKommentarArrary replaceObjectAtIndex:UserMark withObject:[UserMarkNumber stringValue]];
                  NSLog(@"tempKommentarArrary nach: %@ UserMark:%@",[tempKommentarArrary description],[UserMarkNumber stringValue]);
                  
               }
               else if([tempKommentarArrary count]==6)//Zeile für Mark ist noch nicht da
               {
                  NSNumber* UserMarkNumber=[NSNumber numberWithInt:dieUserMark];
                  [tempKommentarArrary insertObject:[UserMarkNumber stringValue] atIndex:5];
                  
               }
            }
            NSString* newKommentarString=[tempKommentarArrary componentsJoinedByString:@"\r"];
            //NSLog(@"newKommentarString: %@",newKommentarString);
            [newKommentarString writeToFile:tempAdminKommentarPfad atomically:YES encoding:NSMacOSRomanStringEncoding error:NULL];
         }//if Kommentar da
         
      }
   }
   
   return erfolg;
   
}//saveKommentar


- (IBAction)startAdminPlayer:(id)sender
{
   //[AdminQTKitPlayer setControllerVisible:YES];
   //	if (![AdminQTKitPlayer movie])
   {
      //NSLog(@"startAdminPlayer: AdminPlayPfad: %@",AdminPlayPfad);
      //NSLog(@"Sender: %@",[sender description]);
      //NSLog(@"Noch kein Movie da");
      
      NSURL *movieUrl = [NSURL fileURLWithPath:self.AdminPlayPfad];
      NSError* loadError=0;
      /*
       QTMovie* tempQTKitMovie= [[QTMovie alloc]initWithURL:movieUrl error:&loadError];
       if (loadError)
       {
       NSAlert *theAlert = [NSAlert alertWithError:loadError];
       [theAlert runModal]; // Ignore return value.
       }
       AdminPlayerMovie =[tempQTKitMovie quickTimeMovie];
       */
      //Fixed n=GetMovieRate(PlayerMovie);
      //NSLog(@"MovieRate: %d", n);
      
      
      //AdminAbspielzeit=GetMovieDuration(AdminPlayerMovie)/60;
      //AdminAbspielzeit=GetMovieDuration(AdminPlayerMovie)/60;
      
      //		AdminAbspielzeit=[tempQTKitMovie duration].timeValue/[tempQTKitMovie duration].timeScale;
      
      
      [self.AbspieldauerFeld setStringValue:[self Zeitformatieren:self.AdminAbspielzeit]];
      [self.AbspieldauerFeld setNeedsDisplay:YES];
      
      //Abspieldauer=GesamtAbspielzeit;
      //[Levelbalken setMaxValue: GesamtAbspielzeit];
      //[Levelbalken setDoubleValue: 0];
      
      //NSLog(@"MovieDuration: %d", AdminAbspielzeit);
      /*
       [AdminQTPlayer showController:YES adjustingSize:NO];
       [AdminQTPlayer setNeedsDisplay:YES];
       
       [AdminQTPlayer setMovie:tempMovie];
       //[AdminQTPlayer gotoBeginning:sender];
       [AdminQTPlayer gotoBeginning:nil];
       SetMovieActive(AdminPlayerMovie,true);
       //[tempMovie release];
       */
      
      /*
       [AdminQTKitPlayer setMovie:tempQTKitMovie];
       [AdminQTKitPlayer gotoBeginning:NULL];
       [AdminQTKitPlayer play:NULL];
       */
      
      
   }
   /*
    else
    {
    //NSLog(@"Schon ein Movie da");
    if (AdminPlayerMovie)
    {
    //SetMovieActive(AdminPlayerMovie,true);
    //NSLog(@"err nach setmovieactive: %d",GetMoviesError());
    [AdminQTKitPlayer gotoBeginning:NULL];
    [AdminQTKitPlayer play:NULL];
    }
    
    }
    */
   [self.AdminKommentarView setEditable:YES];
   //	[AdminBewertungfeld setEditable:YES];
   [self.AdminNotenfeld setEnabled:YES];
   [self.AdminNotenfeld setEditable:YES];
   
   [self.PlayTaste setEnabled:NO];
   [self setBackTaste:YES];
   
}
- (void)setBackTaste:(BOOL)istDefault
{
   
   if (istDefault)
   {
      
      [self.zurListeTaste setEnabled:YES];
      //NSLog(@"setBackTaste:    def");
      
      [self.zurListeTaste setKeyEquivalent:@"\r"];
   }
   else
   {
      
      [self.zurListeTaste setEnabled:YES];
      //NSLog(@"setBackTaste:nicht def");
      [self.zurListeTaste setKeyEquivalent:@""];
   }
   
}

- (void)TableDoppelAktion
{
   NSLog(@"Doppelaktion");
}
- (void)AufnahmeInPlayer:(id)sender
{
   //NSLog(@"AufnahmeInPlayer: AufnahmenTab tab: %d",[[[AufnahmenTab selectedTabViewItem]identifier]intValue]);
   
   switch ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])
   {
      case 1://Alle Aufnahmen
      {
         BOOL erfolg;
         //NSLog(@"		Quelle: AufnahmeInPlayer->QTPlayer: erfolg: %d",erfolg);
         //NSLog(@"AufnahmeInPlayer	clickedRow: %d",[self.NamenListe numberOfSelectedRows]);
         // 8.12.08
         if ( [self.NamenListe numberOfSelectedRows] && [self AnzahlAufnahmen])
         {
            erfolg=[self.AdminFenster makeFirstResponder:self.zurListeTaste];
            //NSLog(@"		Quelle: AufnahmeInPlayer->QTPlayer: erfolg: %d",erfolg);
            [self.AdminKommentarView setEditable:YES];
            [self.AdminKommentarView setSelectable:YES];
            [self setLeserFuerZeile:self.selektierteZeile];
            //[AdminKommentarView setEditable:NO];
            //			[AdminQTKitPlayer setHidden:NO];
            [self startAdminPlayer:nil];
            //			[AdminQTKitPlayer play :nil];
            [self setBackTaste:YES];
            self.Moviegeladen=YES;
            [self.ExportierenTaste setEnabled:YES];
            [self.LoeschenTaste setEnabled:YES];
            [self.MarkCheckbox setEnabled:YES];
            [self.AdminBewertungfeld setEnabled:YES];
         }
         else
         {
            NSBeep;
            [self backZurListe:nil];
            [self.PlayTaste setEnabled:NO];
         }
      }break;
         
      case 2://Aufnahmen nach Namen
      {
         if ([self.AufnahmenTable numberOfSelectedRows])//eine Aufnahme ist selektiert
         {
            [self.AdminKommentarView setEditable:YES];
            [self.AdminKommentarView setSelectable:YES];
            
            int AufnahmenIndex=[self.AufnahmenTable selectedRow];
            self.AdminAktuelleAufnahme=[[self.AufnahmenDicArray objectAtIndex:AufnahmenIndex]objectForKey:@"aufnahme"];
            self.AdminAktuellerLeser=[self.LesernamenPop titleOfSelectedItem];
            BOOL AufnahmeOK=[self setPfadFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
            BOOL OK=[self setKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
            if ([[[self.AufnahmenDicArray objectAtIndex:AufnahmenIndex]objectForKey:@"adminmark"]intValue])
            {
               [ self.MarkCheckbox setState:YES];
            }
            else
            {
               [self.MarkCheckbox setState:NO];
               
            }
            //				[AdminQTKitPlayer setHidden:NO];
            [self startAdminPlayer:nil];
            //				[AdminQTKitPlayer play:nil];
            [self setBackTaste:YES];
            self.Moviegeladen=YES;
            [self.ExportierenTaste setEnabled:YES];
            [self.LoeschenTaste setEnabled:YES];
            [self.MarkCheckbox setEnabled:YES];
            [self.AdminBewertungfeld setEnabled:YES];
            //[self.PlayTaste setEnabled:NO];
         }
         else
         {
            NSBeep;
            [self backZurListe:nil];
            [self.PlayTaste setEnabled:NO];
            self.AdminAktuellerLeser=@"";
            self.AdminAktuelleAufnahme=@"";
            [self clearKommentarfelder];
            [self.zurListeTaste setEnabled:NO];
            [self.zurListeTaste setKeyEquivalent:@""];
            [self.MarkCheckbox setState:NO];
            [self.AdminBewertungfeld setEnabled:NO];
            
            
         }
      }break;
   }//switch
}

- (void)backZurListe:(id)sender
{
   /*
    [AdminQTKitPlayer pause :nil];
    [AdminQTKitPlayer gotoBeginning:nil];
    [AdminQTKitPlayer setMovie:nil];
    */
   NSString* EnterKeyQuelle;
   EnterKeyQuelle=@"MovieView";
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"AdminEnterKey" object:EnterKeyQuelle];
   //	[AdminQTKitPlayer setHidden:YES];
   [self setBackTaste:NO];
   [self.zurListeTaste setEnabled:NO];
   [self.PlayTaste setEnabled:[self.NamenListe numberOfSelectedRows]];
   
   [self.AbspieldauerFeld setStringValue:@""];
   //NSLog(@"vor saveKommentarFuerLeser");
   if ([self.AdminAktuellerLeser length]&&[self.AdminAktuelleAufnahme length]&&self.Textchanged)
	  {
        BOOL OK=[self saveKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
        
        //AdminAktuellerLeser=@"";//herausgenommen infolge KommentarfürLeser
        
        self.AdminAktuelleAufnahme=@"";
        NSLog(@"backZurListe AdminMark: %d UserMark: %d",[self.MarkCheckbox state],[self.UserMarkCheckbox state]);
        [self saveMarksFuerLeser:self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme mitAdminMark: [self.MarkCheckbox state] mitUserMark:[self.UserMarkCheckbox state]];
        
     }
   [self clearKommentarfelder];
   [self.AdminKommentarView setEditable:NO];
   [self.AdminKommentarView setSelectable:NO];
   [self.AdminBewertungfeld setEnabled:NO];
   [self.AdminNotenfeld setEnabled:NO];
   [self.AdminNotenfeld setEditable:NO];
   self.Moviegeladen=NO;
   [self.ExportierenTaste setEnabled:NO];
   [self.LoeschenTaste setEnabled:NO];
   self.Textchanged=NO;
   
   [self.MarkCheckbox setState:NO];
   [self.MarkCheckbox setEnabled:NO];
}

- (void)setMark:(BOOL)derStatus
{
   [self.MarkCheckbox setState:derStatus];
}

- (int)Mark
{
   return [self.MarkCheckbox state];
}

- (void)AufnahmeMarkieren:(id)sender
{
   
   NSLog(@"Aufnahmemarkieren: setMark: %d zeile: %d",[sender state],[self.NamenListe selectedRow]);
   switch ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])
   {
      case 1://Alle Aufnahmen
      {
         int tempZeile=[self.NamenListe selectedRow];
         if(tempZeile>=0)
         {
            int tempItem=[[[self.AdminDaten dataForRow:tempZeile]objectForKey:@"aufnahmen"]intValue];
            
            [self.AdminDaten setMark:[sender state] forRow:[self.NamenListe selectedRow] forItem:tempItem];
            [self.NamenListe reloadData];
         }
         else
         {
            NSLog(@"keine Zeile aktiviert");
            [sender setState:NO];
            return;
         }
         
         
         
         
         
      }break;
         
      case 2://nach Namen
      {
         NSString* tempLeser=[self.LesernamenPop titleOfSelectedItem];
         int LeserZeile=[self.AdminDaten ZeileVonLeser:tempLeser];//Zeile von tempLeser in AdminDaten
         int AufnahmenZeile=[self.AufnahmenTable selectedRow];		//Zeile in der AufnahmenTable,
         // ist auch Zeile der Aufnahme für tempLeser im AufnahmenArray in AdminDaten
         //NSLog(@"AufnahmeMarkieren tempLeser: %@ LeserZeile: %d AufnahmenZeile: %d",tempLeser,LeserZeile,AufnahmenZeile);
         [self.AdminDaten setMark:[sender state] forRow:LeserZeile forItem:AufnahmenZeile];
         [self setAdminMark:[sender state] fuerZeile:[self.AufnahmenTable selectedRow]];
         
         
      }break;
   }//switch
   
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSString* tempAufnahmePfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];
   tempAufnahmePfad=[tempAufnahmePfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];
   
   NSLog(@"Aufnahmemarkieren: tempAufnahmePfad: %@",tempAufnahmePfad);
   
   
   
   
   if ([Filemanager fileExistsAtPath:tempAufnahmePfad])
   {
      //NSLog(@"File exists");
      [self saveAdminMarkFuerLeser:self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme
                      mitAdminMark:[self.MarkCheckbox state]];
      
      
      
   }//file exists
}

- (BOOL)AufnahmeIstMarkiertAnPfad:(NSString*)derAufnahmePfad
{
   BOOL istMarkiert=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* AnmerkungenPfad=[[derAufnahmePfad stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Anmerkungen"];
   
   AnmerkungenPfad=[AnmerkungenPfad stringByAppendingPathComponent:[derAufnahmePfad lastPathComponent]];
   
   if ([Filemanager fileExistsAtPath:AnmerkungenPfad])
   {
      //NSLog(@"File exists an Pfad: %@",derAufnahmePfad);
      NSString* tempKommentarString=[NSString stringWithContentsOfFile:AnmerkungenPfad encoding:NSMacOSRomanStringEncoding error:NULL];
      NSMutableArray* tempKommentarArrary=(NSMutableArray *)[tempKommentarString componentsSeparatedByString:@"\r"];
      //NSLog(@"tempKommentarArrary vor: %@",[tempKommentarArrary description]);
      if (tempKommentarArrary &&[tempKommentarArrary count])
      {
         NSNumber* AdminMarkNumber=[tempKommentarArrary objectAtIndex:AdminMark];
         //NSLog(@"istMarkiert		AdminMarkNumber: %d",[AdminMarkNumber intValue]);
         
         istMarkiert=[AdminMarkNumber intValue];
         
      }
      
      
   }//file exists
   return istMarkiert;
}

- (BOOL)AufnahmeIstMarkiertAnAnmerkungPfad:(NSString*)derAnmerkungPfad
{
   BOOL istMarkiert=NO;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   if ([Filemanager fileExistsAtPath:derAnmerkungPfad])
   {
      //NSLog(@"File exists an Pfad: %@",derAnmerkungPfad);
      NSString* tempKommentarString=[NSString stringWithContentsOfFile:derAnmerkungPfad encoding:NSMacOSRomanStringEncoding error:NULL];
      NSMutableArray* tempKommentarArrary=(NSMutableArray *)[tempKommentarString componentsSeparatedByString:@"\r"];
      //NSLog(@"tempKommentarArrary vor: %@",[tempKommentarArrary description]);
      if (tempKommentarArrary &&[tempKommentarArrary count]>7)
      {
         NSNumber* AdminMarkNumber=[tempKommentarArrary objectAtIndex:AdminMark];
         //NSLog(@"istMarkiert		AdminMarkNumber: %d",[AdminMarkNumber intValue]);
         
         istMarkiert=[AdminMarkNumber intValue];
         
      }
      
      
   }//file exists
   return istMarkiert;
}


-(void)MarkierungAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
   NSLog(@"alertDidEnd");
   if (returnCode==NSAlertFirstButtonReturn)
   {
      //NSLog(@"alertDidEnd: NSAlertFirstButtonReturn");
      [self Markierungenreset];
      
   }
}

- (void)AlleMarkierungenEntfernen
{
   NSAlert *Warnung = [[NSAlert alloc] init];
   [Warnung addButtonWithTitle:@"Markierungen entfernen"];
   [Warnung addButtonWithTitle:@"Abbrechen"];
   [Warnung setMessageText:@"Markierungen entfernen?"];
   [Warnung setInformativeText:@"Sollen wirklich alle Markierungen von allen Lesern entfernt werden?"];
   [Warnung setAlertStyle:NSWarningAlertStyle];
   [Warnung beginSheetModalForWindow:self.AdminFenster
                       modalDelegate:self
                      didEndSelector:@selector(MarkierungAlertDidEnd: returnCode: contextInfo:)
                         contextInfo:nil];
   
}


- (void)MarkierungEntfernenFuerZeile:(int)dieZeile
{
   NSDictionary* tempZeilenDic=[self.AdminDaten dataForRow:dieZeile];
   NSLog(@"tempZeilenDic: %@",[tempZeilenDic description]);
   
   NSString* tempName=[tempZeilenDic objectForKey:@"namen"];
   int tempAnzahlAufnahmen=[[tempZeilenDic objectForKey:@"anz"]intValue];
   
   
   //int x=[[[self.NamenListe tableColumnWithIdentifier:@"aufnahmen"]dataCellForRow:tempZeile]indexOfSelectedItem];
   //NSLog(@"tempZeile: %d  tempItem: %d  x: %d",tempZeile,tempItem,x);
   if (tempAnzahlAufnahmen>0)
   {
      int i=0;
      for (i=0;i<tempAnzahlAufnahmen;i++)
      {
         [self.AdminDaten setMark:NO forRow:dieZeile forItem:i];
         
      }//for i
      
   }//tempItem>0
   [self.NamenListe reloadData];
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* tempLeserArchivPfad=[self.AdminProjektPfad stringByAppendingPathComponent:tempName];
   NSLog(@"MarkierungEntfernenFuerZeile: tempLeserArchivPfad: %@",tempLeserArchivPfad);
   
   BOOL istOrdner=NO;
   if ([Filemanager fileExistsAtPath:tempLeserArchivPfad isDirectory:&istOrdner]&&istOrdner)//Ordner ist da
   {
      // Markierung in Anmerkungen loeschen
      NSString* tempAnmerkungenPfad=[tempLeserArchivPfad stringByAppendingPathComponent:@"Anmerkungen"];
      if ([Filemanager fileExistsAtPath:tempAnmerkungenPfad isDirectory:&istOrdner]&&istOrdner)//Ordner ist da
      {
         NSLog(@"Anmerkungen sind da");
         NSMutableArray* tempAnmerkungenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempAnmerkungenPfad error:NULL]];
         
         if ([tempAnmerkungenArray count])
         {
            if ([[tempAnmerkungenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
            {
               [tempAnmerkungenArray removeObjectAtIndex:0];
            }
            if ([tempAnmerkungenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
            {
               [tempAnmerkungenArray removeObject:@"Anmerkungen"];
            }
            
            NSEnumerator* AnmerkungenEnum=[tempAnmerkungenArray objectEnumerator];
            id eineAnmerkung;
            while(eineAnmerkung=[AnmerkungenEnum nextObject])
            {
               NSString* tempAnmerkungPfad=[tempAnmerkungenPfad stringByAppendingPathComponent:eineAnmerkung];
               if ([Filemanager fileExistsAtPath:tempAnmerkungPfad])
               {
                  
                  NSLog(@"File exists: %@",tempAnmerkungPfad);
                  [self saveAdminMarkFuerLeser:tempName FuerAufnahme:eineAnmerkung
                                  mitAdminMark:0];
                  
                  
               }//file exists
               
            }//while
         }//count
         
      }
      
      
      
      
      
      
      
      
      // Markierung in Aufnahme loeschen
      NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempLeserArchivPfad error:NULL]];
      
      if ([tempAufnahmenArray count])
      {
         if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"])					//Unsichtbare Ordner entfernen
         {
            [tempAufnahmenArray removeObjectAtIndex:0];
         }
         if ([tempAufnahmenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
         {
            [tempAufnahmenArray removeObject:@"Anmerkungen"];
         }
         
      }//count
   }//Ordner ist da
   else
   {
      NSLog(@"Kein Ordner da");
   }
   [self.NamenListe reloadData];
   
}


- (void)MarkierungenEntfernen
{
   int tempZeile=[self.NamenListe selectedRow];
   if(tempZeile>=0)
	  {
        NSString* tempLeser=[[self.AdminDaten dataForRow:tempZeile]objectForKey:@"namen"];
        
        self.MarkierungFenster=[[rMarkierung alloc]init];
        int modalAntwort;
        SEL MarkierungSelektor;
        MarkierungSelektor=@selector(sheetDidEnd: returnCode: contextInfo:);
        NSLog(@"MarkierungenWeg: tempLeser: %@",tempLeser);
        [self.MarkierungFenster setNamenString:tempLeser];
        [NSApp beginSheet:[self.MarkierungFenster window]
           modalForWindow:self.AdminFenster
            modalDelegate:self.MarkierungFenster
         //didEndSelector:EntfernenSelektor
           didEndSelector:NULL
              contextInfo:@"Markierung"];
        [self.MarkierungFenster setNamenString:tempLeser];
        modalAntwort = [NSApp runModalForWindow:[self.MarkierungFenster window]];
        
        
        [NSApp endSheet:[self.MarkierungFenster window]];
        
        [[self.MarkierungFenster window] orderOut:NULL];
        NSLog(@"endSheet: Antwort: %d",modalAntwort);
        
     }//tempZeile>=0
   
}



- (void)reportUserMark:(id)sender
{
   switch ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])
   {
      case 2:// Aufnahmen nach Namen
      {
         int ZeilenIndex=[self.AufnahmenTable selectedRow];
         [self setUserMark:[sender state] fuerZeile:ZeilenIndex];
      }break;
   }//switch
}

- (void)reportAdminMark:(id)sender
{
   switch ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])
   {
      case 2:// Aufnahmen nach Namen
      {
         int ZeilenIndex=[self.AufnahmenTable selectedRow];
         [self setUserMark:[sender state] fuerZeile:ZeilenIndex];
      }break;
   }//switch
}



- (IBAction) AufnahmeLoeschen:(id)sender
{
   self.EntfernenFenster=[[rEntfernen alloc]init];
   //NSLog(@"AdminPlayer EntfernenFenster init");
   
   //[EntfernenFenster showWindow:self];
   
   
   
   int modalAntwort;
   SEL EntfernenSelektor;
   EntfernenSelektor=@selector(sheetDidEnd: returnCode: contextInfo:);
   
   [NSApp beginSheet:[self.EntfernenFenster window]
      modalForWindow:self.AdminFenster
       modalDelegate:self.EntfernenFenster
    //didEndSelector:EntfernenSelektor
      didEndSelector:NULL
         contextInfo:@"Entfernen"];
   
   modalAntwort = [NSApp runModalForWindow:[self.EntfernenFenster window]];
   
   //NSLog(@"beginSheet: Antwort: %d",modalAntwort);
   [NSApp endSheet:[self.EntfernenFenster window]];
   
   [[self.EntfernenFenster window] orderOut:NULL];
   
   
   return;
   
}

- (void)EntfernenNotificationAktion:(NSNotification*)note
{
   int var=[[[note userInfo]objectForKey:@"EntfernenVariante"]intValue];
   //NSLog(@"AdminPlayer EntfernenNotificationAktion  Variante: %d AdminAktuelleAufnahme: %@",var,AdminAktuelleAufnahme);
   switch (var)
	  {
        case 0://in den Papierkorb
        {
           //NSLog(@"EntfernenNotificationAktion AdminAktuelleAufnahme: %@",AdminAktuelleAufnahme);
           
           [self inPapierkorb:self.AdminAktuelleAufnahme];
        }break;
        case 1://ins Magazin
        {
           [self insMagazin:self.AdminAktuelleAufnahme];
        }break;
        case 2://ex und hopp
        {
           [self ex:self.AdminAktuelleAufnahme];
        }break;
     }//switch
   [self resetAdminPlayer];
   //NSLog(@"EntfernenNotificationAktion: AdminLeseboxPfad: %@",AdminLeseboxPfad);
   [self setAdminPlayer:self.AdminLeseboxPfad inProjekt:[self.AdminProjektPfad lastPathComponent]];
   
}

- (void) moveFileToUserTrash:(NSString *)filePath
{
   CFURLRef        trashURL;
   FSRef           trashFolderRef;
   CFStringRef     trashPath;
   OSErr           err;
   NSFileManager   *mgr = [NSFileManager defaultManager];
   err = FSFindFolder(kUserDomain, kTrashFolderType, kDontCreateFolder, &trashFolderRef);
   if (err == noErr)
	  {
        trashURL = CFURLCreateFromFSRef(kCFAllocatorSystemDefault, &trashFolderRef);
        if (trashURL)
        {
           trashPath = CFURLCopyFileSystemPath (trashURL, kCFURLPOSIXPathStyle);
           //if (![mgr movePath:filePath toPath:[(NSString *)trashPath stringByAppendingPathComponent:[filePath lastPathComponent]] handler:nil])
           //{
           if (![mgr moveItemAtURL:[NSURL fileURLWithPath:filePath]  toURL:[NSURL fileURLWithPath:[(__bridge NSString*)trashPath stringByAppendingPathComponent:[filePath lastPathComponent]]] error:nil])
              
           {
              NSLog(@"Move operation did not succeed!");
           }
        }// if trashURL
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


- (void)inPapierkorb:(NSString*)dieAufnahme
{
   BOOL istDirectory;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSLog(@"Papierkorb: %@",dieAufnahme);
   NSString* tempLeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];//Leserordner im Archiv
   if ([self.AdminAktuellerLeser length]&&[Filemanager fileExistsAtPath:tempLeserPfad isDirectory:&istDirectory]&&istDirectory)
   {
      NSString* tempAufnahmePfad=[tempLeserPfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];//Pfad akt. Aufn.
      if ([self.AdminAktuelleAufnahme length]&&[Filemanager fileExistsAtPath:tempAufnahmePfad isDirectory:&istDirectory]&&!istDirectory)
      {
         //[self moveFileToUserTrash:tempAufnahmePfad];
         int result=[self fileInPapierkorb:tempAufnahmePfad];//0 ist OK
         NSLog(@"inPapierkorb result von Aufnahme: %d",result);
      }
      NSString* tempKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
      if ([Filemanager fileExistsAtPath:tempKommentarPfad isDirectory:&istDirectory]&&istDirectory)
      {
         tempKommentarPfad=[tempKommentarPfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];
         if ([Filemanager fileExistsAtPath:tempKommentarPfad])
         {
            //[self moveFileToUserTrash:tempKommentarPfad];
            int result=[self fileInPapierkorb:tempKommentarPfad];
            NSLog(@"inPapierkorb result von Kommentar: %d",result);
         }
         
      }
      
   }
   
}

- (void)inPapierkorbMitPfad:(NSString*)derAufnahmePfad
{
   BOOL istDirectory;
   NSString* tempAufnahmePfad=[derAufnahmePfad copy];//Pfad akt. Aufn.
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   //NSLog(@"inPapierkorbmitPfad: %@",derAufnahmePfad);
   NSString* tempLeserOrdnerPfad=[tempAufnahmePfad stringByDeletingLastPathComponent];//Leserordner im Archiv
   if ([Filemanager fileExistsAtPath:tempLeserOrdnerPfad isDirectory:&istDirectory]&&istDirectory)
   {
      if ([Filemanager fileExistsAtPath:tempAufnahmePfad])
      {
         //[self moveFileToUserTrash:tempAufnahmePfad];
         int result=[self fileInPapierkorb:tempAufnahmePfad];//0 ist OK
         //NSLog(@"inPapierkorb result von Aufnahme: %d",result);
      }
      NSString* tempKommentarOrdnerPfad=[tempLeserOrdnerPfad stringByAppendingPathComponent:@"Anmerkungen"];
      if ([Filemanager fileExistsAtPath:tempKommentarOrdnerPfad isDirectory:&istDirectory]&&istDirectory)
      {
         NSString* tempKommentarPfad=[tempKommentarOrdnerPfad stringByAppendingPathComponent:[tempAufnahmePfad lastPathComponent]];
         if ([Filemanager fileExistsAtPath:tempKommentarPfad])
         {
            //[self moveFileToUserTrash:tempKommentarPfad];
            int result=[self fileInPapierkorb:tempKommentarPfad];
            //NSLog(@"inPapierkorb result von Kommentar: %d",result);
         }
         
      }
      
   }
}

- (void)insMagazin:(NSString*)dieAufnahme
{
   NSLog(@"Magazin");
   BOOL istDirectory;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSString* tempMagazinPfad=[[[self.AdminProjektPfad stringByDeletingLastPathComponent]stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Magazin"];
   NSLog(@"insMagazin: tempMagazinPfad: \n%@\n",tempMagazinPfad);
   if (![Filemanager fileExistsAtPath:tempMagazinPfad isDirectory:&istDirectory])
	  {
        BOOL magazinOK=[Filemanager createDirectoryAtPath:tempMagazinPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
        if (!magazinOK)
        {
           //NSString* s1=NSLocalizedString(@"The folder 'Magazin' could not be created in folder 'Lecturebox'",@"Ordner 'Magazin' im Ordner 'Lesebox' nicht eingerichtet");
           NSString* s1=@"Ordner 'Magazin' konnte im Ordner 'Lesebox' nicht eingerichtet werden.";
           
           //NSString* s2=NSLocalizedString(@"Folder %@ not moved",@"Ordner von %@ nicht verschoben");
           NSString* s2=@"Ordner von %@ nicht verschoben";
           NSString* MagazinString=[NSString stringWithFormat:@"%@%@%@%@",s1,@"\r",s2,dieAufnahme];
           //NSLog(@"MagazinString: %@",MagazinString);
           NSString* TString=@"Magazin einrichten";
           int magazinAntwort=NSRunAlertPanel(TString, MagazinString,@"OK", NULL,NULL);
           return;
        }
     }
   NSString* tempLeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];//Leserordner im Archiv
   if ([self.AdminAktuellerLeser length]&&[Filemanager fileExistsAtPath:tempLeserPfad isDirectory:&istDirectory]&&istDirectory)
   {
      NSString* tempZielPfad=[tempMagazinPfad stringByAppendingPathComponent:[self.AdminAktuelleAufnahme stringByAppendingString:@" alt"]];
      NSString* tempAufnahmePfad=[tempLeserPfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];//Pfad akt. Aufn.
      if ([self.AdminAktuelleAufnahme length]&&[Filemanager fileExistsAtPath:tempAufnahmePfad])
      {
         if ([Filemanager fileExistsAtPath:tempZielPfad])//File ist schon vorhanden: ex
         {
            BOOL del=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempZielPfad ] error:nil];
         }
         //BOOL result=[Filemanager movePath:tempAufnahmePfad toPath:tempZielPfad handler:nil];
         
         BOOL result=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:tempAufnahmePfad]  toURL:[NSURL fileURLWithPath:tempZielPfad] error:nil];
         NSLog(@"result von Aufnahme insMagazin: %d",result);
      }
      NSString* tempMagazinKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
      NSArray* Inhalt=[Filemanager contentsOfDirectoryAtPath:tempMagazinKommentarPfad error:NULL];
      //NSLog(@"tempKommentarPfad: %@",[Inhalt description]);
      
      if ([Filemanager fileExistsAtPath:tempMagazinKommentarPfad isDirectory:&istDirectory]&&istDirectory)
      {
         NSString* tempZielPfad=[tempMagazinPfad stringByAppendingPathComponent:[self.AdminAktuelleAufnahme stringByAppendingString:@" Komm alt"]];
         tempMagazinKommentarPfad=[tempMagazinKommentarPfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];
         BOOL da=[Inhalt containsObject:tempMagazinKommentarPfad];
         NSLog(@"Inhalt da: %d",da);
         if ([Filemanager fileExistsAtPath:tempMagazinKommentarPfad])
         {
            if ([Filemanager fileExistsAtPath:tempZielPfad])//File ist schon vorhanden: ex
            {
               BOOL del=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempZielPfad ]error:nil];
            }
            da=[Filemanager fileExistsAtPath:tempMagazinKommentarPfad];
            //BOOL result=[Filemanager movePath:tempMagazinKommentarPfad toPath:tempZielPfad handler:NULL];
            BOOL result=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:tempMagazinKommentarPfad]  toURL:[NSURL fileURLWithPath:tempZielPfad] error:nil];
            
            NSLog(@"result von Kommentar insMagazin: %d",result);
         }
         
      }
      
   }
   
}


- (void)insMagazinMitPfad:(NSString*)derAufnahmePfad
{
   NSLog(@"insMagazinMitPfad: %@",derAufnahmePfad);
   NSString* tempAufnahmePfad=[derAufnahmePfad copy];//Pfad akt. Aufn.
   
   BOOL istDirectory;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSString* tempMagazinPfad=[[self.AdminArchivPfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Magazin"];
   NSLog(@"tempMagazinPfad: %@",tempMagazinPfad);
   if (![Filemanager fileExistsAtPath:tempMagazinPfad])
	  {
        BOOL magazinOK=[Filemanager createDirectoryAtPath:tempMagazinPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
        if (!magazinOK)
        {
           NSString* s1=@"Der Ordner 'Magazin' konnte im Ordner 'Lesebox' nicht eingerichtet werden.";
           NSString* s2=@"Die Aufnahme wurde nicht verschoben";
           NSString* MagazinString=[NSString stringWithFormat:@"%@%@%@",s1,@"\r",s2];
           int magazinAntwort=NSRunAlertPanel(@"Magazin einrichten", MagazinString,@"OK", NULL,NULL);
           
           return;
        }
     }
   
   NSString* tempLeserPfad=[tempAufnahmePfad stringByDeletingLastPathComponent];//Leserordner im Archiv
   if ([Filemanager fileExistsAtPath:tempLeserPfad isDirectory:&istDirectory]&&istDirectory)
   {
      NSString* tempZielPfad=[tempMagazinPfad stringByAppendingPathComponent:[[tempAufnahmePfad lastPathComponent] stringByAppendingString:@" alt"]];
      if ([Filemanager fileExistsAtPath:tempAufnahmePfad])
				  {
                 if ([Filemanager fileExistsAtPath:tempZielPfad])//File ist schon vorhanden: ex
                 {
                    BOOL del=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempZielPfad ]error:nil];
                 }
                 //BOOL result=[Filemanager movePath:tempAufnahmePfad toPath:tempZielPfad handler:nil];
                 BOOL result=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:tempAufnahmePfad]  toURL:[NSURL fileURLWithPath:tempZielPfad] error:nil];
                 
                 NSLog(@"result von Aufnahme insMagazin: %d",result);
              }
      NSString* tempMagazinKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
      NSArray* Inhalt=[Filemanager contentsOfDirectoryAtPath:tempMagazinKommentarPfad error:NULL];
      //NSLog(@"tempKommentarPfad: %@",[Inhalt description]);
      
      if ([Filemanager fileExistsAtPath:tempMagazinKommentarPfad isDirectory:&istDirectory]&&istDirectory)
				  {
                 NSString* tempZielPfad=[tempMagazinPfad stringByAppendingPathComponent:[[tempAufnahmePfad lastPathComponent] stringByAppendingString:@" Komm alt"]];
                 tempMagazinKommentarPfad=[tempMagazinKommentarPfad stringByAppendingPathComponent:[tempAufnahmePfad lastPathComponent]];
                 BOOL da=[Inhalt containsObject:tempMagazinKommentarPfad];
                 NSLog(@"Inhalt da: %d",da);
                 if ([Filemanager fileExistsAtPath:tempMagazinKommentarPfad])
                 {
                    if ([Filemanager fileExistsAtPath:tempZielPfad])//File ist schon vorhanden: ex
                    {
                       BOOL del=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempZielPfad ] error:nil];
                    }
                    da=[Filemanager fileExistsAtPath:tempMagazinKommentarPfad];
                    //BOOL result=[Filemanager movePath:tempMagazinKommentarPfad toPath:tempZielPfad handler:NULL];
                    BOOL result=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:tempMagazinKommentarPfad]  toURL:[NSURL fileURLWithPath:tempZielPfad] error:nil];
                    
                    NSLog(@"result von Kommentar insMagazin: %d",result);
                 }
                 
              }
      
   }
   
}


- (void)ex:(NSString*)dieAufnahme
{
   BOOL istDirectory;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSLog(@"ex");
   NSString* tempLeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];//Leserordner im Archiv
   if ([self.AdminAktuellerLeser length]&&[Filemanager fileExistsAtPath:tempLeserPfad isDirectory:&istDirectory]&&istDirectory)
   {
      NSString* tempAufnahmePfad=[tempLeserPfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];//Pfad akt. Aufn.
      if ([self.AdminAktuelleAufnahme length]&&[Filemanager fileExistsAtPath:tempAufnahmePfad isDirectory:&istDirectory]&&!istDirectory)
      {
         //[self moveFileToUserTrash:tempAufnahmePfad];
         int result=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempAufnahmePfad] error:nil];
         NSLog(@"result von Aufnahme: %d",result);
      }
      NSString* tempKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
      if ([Filemanager fileExistsAtPath:tempKommentarPfad isDirectory:&istDirectory]&&istDirectory)
      {
         tempKommentarPfad=[tempKommentarPfad stringByAppendingPathComponent:self.AdminAktuelleAufnahme];
         if ([Filemanager fileExistsAtPath:tempKommentarPfad])
         {
            //[self moveFileToUserTrash:tempKommentarPfad];
            int result=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempKommentarPfad ] error:nil];
            NSLog(@"result von Kommentar: %d",result);
         }
         
      }
      
   }
   
}

- (void)exMitPfad:(NSString*)derAufnahmePfad
{
   NSString* tempAufnahmePfad=[derAufnahmePfad copy];//Pfad akt. Aufn.
   BOOL istDirectory;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSLog(@"exMitPfad");
   NSString* tempLeserPfad=[tempAufnahmePfad stringByDeletingLastPathComponent];//Leserordner im Archiv
   if ([Filemanager fileExistsAtPath:tempLeserPfad isDirectory:&istDirectory]&&istDirectory)
   {
      if ([Filemanager fileExistsAtPath:tempAufnahmePfad isDirectory:&istDirectory]&&!istDirectory)
      {
         //[self moveFileToUserTrash:tempAufnahmePfad];
         int result=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempAufnahmePfad]error:nil];
         NSLog(@"ex: result von Aufnahme: %d",result);
      }
      NSString* tempKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
      if ([Filemanager fileExistsAtPath:tempKommentarPfad isDirectory:&istDirectory]&&istDirectory)
      {
         tempKommentarPfad=[tempKommentarPfad stringByAppendingPathComponent:[tempAufnahmePfad lastPathComponent]];
         if ([Filemanager fileExistsAtPath:tempKommentarPfad])
         {
            //[self moveFileToUserTrash:tempKommentarPfad];
            int result=[Filemanager removeItemAtURL:[NSURL fileURLWithPath :tempKommentarPfad] error:nil];
            NSLog(@"result von Kommentar: %d",result);
         }
         
      }
      
   }
   
}

- (IBAction)reportAktualisieren:(id)sender
{
   NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"aktualisieren"];
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"ListeAktualisieren" object:self userInfo:NotificationDic];
   
   
}

- (void)Leseboxordnen
{
   BOOL istDirectory;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSString* tempLeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:self.AdminAktuellerLeser];//Leserordner im Archiv
   
   if ([self.AdminAktuellerLeser length]&&[Filemanager fileExistsAtPath:tempLeserPfad isDirectory:&istDirectory]&&istDirectory)
   {
      [self neuNummerierenVon:self.AdminAktuellerLeser];
   }
   else
   {
      NSString* s1=@"Welcher Ordner?";
      NSString* s2=@"Ein Name muss ausgewählt sein";
      NSAlert* OrdnenAlert=[NSAlert alertWithMessageText:s1
                                           defaultButton:@"OK"
                                         alternateButton:NULL
                                             otherButton:NULL
                               informativeTextWithFormat:s2];
      
      [OrdnenAlert beginSheetModalForWindow:self.AdminFenster
                              modalDelegate:self
                             didEndSelector: @selector(alertDidEnd: returnCode: contextInfo:)
                                contextInfo:@""];
      
   }
}

- (void)neuNummerierenVon:(NSString*) derLeser
{
   BOOL istDirectory;
   BOOL erfolg=YES;
   NSFileManager* Filemanager=[NSFileManager defaultManager];
   NSString* LeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:derLeser];//Leserordner im Archiv
   
   if ([Filemanager fileExistsAtPath:LeserPfad isDirectory:&istDirectory]&&istDirectory)
	  {
        NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:@"Anmerkungen"];//Kommentarordner des Lesers
        NSMutableArray* AufnahmenArray=[[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL]mutableCopy];
        if ([AufnahmenArray count])
        {
           if ([[AufnahmenArray objectAtIndex:0]hasPrefix:@".DS"])//Unsichtbarer Ordner
           {
              [AufnahmenArray removeObjectAtIndex:0];
           }
           int Kommentarindex=-1;
           Kommentarindex=[AufnahmenArray indexOfObject:@"Anmerkungen"];
           if (!(Kommentarindex==-1))
           {
              NSLog(@"Kommentarordner da");
              [AufnahmenArray removeObjectAtIndex:Kommentarindex];//Kommentarordner nicht ändern
              
           }
           
           NSLog(@"AufnahmenArray sauber: %@",[AufnahmenArray description]);
           int index=0;
           for(index=0;index<[AufnahmenArray count];index++)
           {
              NSString* tempAufnahme=[AufnahmenArray objectAtIndex:index];
              NSString* alterPfad=[LeserPfad stringByAppendingPathComponent:tempAufnahme];
              NSString* neuerName=[self neuerNameVonAufnahme:tempAufnahme mitNummer:index+1];
              NSLog(@"neuerName: %@ index: %d",neuerName,index);
              NSString* neuerPfad=[LeserPfad stringByAppendingPathComponent:neuerName];
              if (![neuerPfad isEqualToString: alterPfad])
              {
                 //erfolg=[Filemanager movePath:alterPfad toPath:neuerPfad handler:nil];
                 
                 erfolg=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:alterPfad]  toURL:[NSURL fileURLWithPath:neuerPfad] error:nil];
                 
                 if (!erfolg)//Umnumerieren erfolglos
                 {
                    NSString* s1=@"Die Aufnahme %@ konnte nicht neu nummeriert werden.";
                    NSString* s2=@"Fehler beim Umnummerieren";
                    NSString* FehlerString=[NSString stringWithFormat:s1,tempAufnahme];
                    NSAlert *Warnung = [[NSAlert alloc] init];
                    [Warnung addButtonWithTitle:@"OK"];
                    //[Warnung addButtonWithTitle:@"Cancel"];
                    [Warnung setMessageText:s2];
                    [Warnung setInformativeText:FehlerString];
                    [Warnung setAlertStyle:NSWarningAlertStyle];
                    [Warnung beginSheetModalForWindow:self.AdminFenster
                                        modalDelegate:nil
                                       didEndSelector:nil
                                          contextInfo:nil];
                    
                    //int Antwort=NSRunAlertPanel(@"Fehler beim Umnummerieren", FehlerString,@"OK", NULL,NULL);
                    return;
                 }
                 NSString*alterKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:tempAufnahme];
                 if([Filemanager fileExistsAtPath:alterKommentarPfad])//Kommentar für diese Aufn. existiert
                 {
                    //NSLog(@"Kommentar für Aufnahme %@ existiert",tempAufnahme);
                    NSString* neuerKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:neuerName];
                    if (![neuerKommentarPfad isEqualToString: alterKommentarPfad])
                    {
                       //erfolg=[Filemanager movePath:alterKommentarPfad toPath:neuerKommentarPfad handler:nil];
                       erfolg =[Filemanager moveItemAtURL:[NSURL fileURLWithPath:alterKommentarPfad]  toURL:[NSURL fileURLWithPath:neuerKommentarPfad] error:nil];
                       
                       if (!erfolg)//Umnumerieren erfolglos
                       {
                          NSString* FehlerString=[NSString stringWithFormat:@"Der Kommentar zur Aufnahme %@ konnte nicht neu nummeriert werden.",tempAufnahme];
                          NSAlert *Warnung = [[NSAlert alloc] init];
                          [Warnung addButtonWithTitle:@"OK"];
                          //[Warnung addButtonWithTitle:@"Cancel"];
                          [Warnung setMessageText:@"Fehler beim Umnummerieren des Kommentars"];
                          [Warnung setInformativeText:FehlerString];
                          [Warnung setAlertStyle:NSWarningAlertStyle];
                          [Warnung beginSheetModalForWindow:self.AdminFenster
                                              modalDelegate:nil
                                             didEndSelector:nil
                                                contextInfo:nil];
                          
                          //int Antwort=NSRunAlertPanel(@"", FehlerString,@"OK", NULL,NULL);
                          return;
                       }
                    }
                    
                 }//if alterKommentarPfad
                 
              }
              
           }//for index
           
        }//count
        if ([Filemanager fileExistsAtPath:LeserKommentarPfad isDirectory:&istDirectory]&&istDirectory)//Ordner des Lesers ist da)
        {
           NSLog(@"Kommentarordner da");
           
           NSArray* KommentareArray=[Filemanager contentsOfDirectoryAtPath:LeserKommentarPfad error:NULL];
           if ([KommentareArray count])
           {
              NSEnumerator* enumerator=[KommentareArray objectEnumerator];
              NSString* tempKommentar;
              while (tempKommentar=[enumerator nextObject])
              {
                 NSString* tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:tempKommentar];
                 NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                 //NSLog(@"Kommentarordner letztes Objekt: %@",letzteAufnahme);
              }
           }
           else
           {
              NSLog(@"keine Kommentare da");//keine Kommentare
           }
           
        }
        else
        {
           //Kein Kommentarordner für Leser
        }
        
        
     }// Leserordner da
}

- (NSString*)neuerNameVonAufnahme:(NSString*)dieAufnahme mitNummer:(int)dieNummer
{
   NSString* tempAufnahme=[dieAufnahme copy];
   NSString* tempInitialen=[tempAufnahme substringToIndex:2];
   NSString* tempTitel=[NSString stringWithString:[self AufnahmeTitelVon:tempAufnahme]];
   
   NSString* neuerName=[NSString stringWithFormat:@"%@ %d %@",tempInitialen,dieNummer,tempTitel];
   NSLog(@"neuerNameVonName: neuerName: %@",neuerName);
   return neuerName;
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
   //NSLog(@"returnCode: %d  contextInfo: %@: ",returnCode,contextInfo);
   NSString* locKommentar=@"Anmerkungen";
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   if ([(__bridge NSString*)contextInfo isEqualToString:@"TextchangedWarnung"])
	  {
        switch (returnCode)
        {
           case 	NSAlertFirstButtonReturn:
           {
              //NSLog(@"NSAlertFirstButtonReturn: Sichern %d",returnCode);
              [[alert window]orderOut:NULL];
              if ([self saveKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme])
              {
                 [self AdminBeenden];
              }
              
           }break;
              
           case NSAlertSecondButtonReturn:
           {
              //NSLog(@"NSAlertSecondButtonReturn: nicht Sichern %d",returnCode);
              [[alert window]orderOut:NULL];
              [self AdminBeenden];
           }break;
           case NSAlertThirdButtonReturn:
           {
              
           }break;
              
        }
     }//TextchangedWarnung
   
   if ([(__bridge NSString*)contextInfo isEqualToString:@"Entfernen"])
	  {
        switch (returnCode)
        {
           case  NSAlertDefaultReturn://Papierkorb
           {
              //NSLog(@"NSAlertDefaultReturn: Papier %d",returnCode);
              if ([Filemanager fileExistsAtPath:self.AdminPlayPfad])
              {
                 
              }
              break;
           }
           case  NSAlertAlternateReturn://Löschen
           {
              //NSLog(@"NSAlertAlternateReturn: Löschen %d",returnCode);
              if ([Filemanager fileExistsAtPath:self.AdminPlayPfad])
              {
                 [Filemanager removeItemAtURL:[NSURL fileURLWithPath:self.AdminPlayPfad] error:nil];
                 NSString* DeleteAufnahmeName=[self.AdminPlayPfad lastPathComponent];
                 NSString* KommentarPfad=[NSString stringWithString:[self.AdminPlayPfad stringByDeletingLastPathComponent]];
                 KommentarPfad=[KommentarPfad stringByAppendingPathComponent:locKommentar];
                 KommentarPfad=[KommentarPfad stringByAppendingPathComponent:DeleteAufnahmeName];
                 if ([Filemanager fileExistsAtPath:KommentarPfad])
                 {
                    [Filemanager removeItemAtURL:[NSURL fileURLWithPath:KommentarPfad ] error:nil];
                    [self.zurListeTaste setEnabled:NO];
                    [self.NamenListe reloadData];
                 }
                 
              }
              
              break;
           }
           case  NSAlertOtherReturn://Magazin
           {
              //NSLog(@"NSAlertOtherReturn: Magazin %d",returnCode);
              if ([Filemanager fileExistsAtPath:self.AdminPlayPfad])
              {
                 int erfolg=1;
                 NSString* MagazinPfad=[NSString stringWithString:self.AdminPlayPfad];
                 MagazinPfad=[MagazinPfad stringByDeletingLastPathComponent];
                 
                 MagazinPfad=[MagazinPfad stringByDeletingLastPathComponent];
                 MagazinPfad=[MagazinPfad stringByDeletingLastPathComponent];
                 MagazinPfad=[MagazinPfad stringByAppendingPathComponent:@"Magazin"];
                 if (![Filemanager fileExistsAtPath:MagazinPfad])
                    erfolg=[Filemanager createDirectoryAtPath:MagazinPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
                 if (erfolg)
                 {
                    MagazinPfad=[MagazinPfad stringByAppendingPathComponent:[self.AdminPlayPfad lastPathComponent]];
                    //[Filemanager movePath: AdminPlayPfad toPath:MagazinPfad handler:nil];
                    BOOL MagazinOK=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:self.AdminPlayPfad]  toURL:[NSURL fileURLWithPath:MagazinPfad] error:nil];
                    
                    [self.NamenListe reloadData];
                    [self.zurListeTaste setEnabled:NO];
                 }
                 NSString* KommentarPfad=[[self.AdminPlayPfad copy] stringByDeletingLastPathComponent];
                 KommentarPfad=[KommentarPfad stringByAppendingPathComponent:@"Anmerkungen"];
                 if ([Filemanager fileExistsAtPath:KommentarPfad])
                 {
                    KommentarPfad=[KommentarPfad stringByAppendingPathComponent:[self.AdminPlayPfad lastPathComponent]];
                    if ([Filemanager fileExistsAtPath:KommentarPfad])
                    {
                       erfolg= [Filemanager removeItemAtURL:[NSURL fileURLWithPath:KommentarPfad] error:NULL];
                    }
                 }
                 
              }
           }break;
        } // switch
     }//Entfernen
   if ([(__bridge NSString*)contextInfo isEqualToString:@"keineLeser"])
	  {
        NSLog(@"shouldEnd: keineLeser");
        [self AdminBeenden];
     }
   [[alert window]orderOut:NULL];
}

/*
 - (QTMovieView*)AdminQTKitPlayer
 {
	return AdminQTKitPlayer;
 }
 */
- (void)keyDown:(NSEvent *)theEvent
{
   int nr=[theEvent keyCode];
   
   NSLog(@"AdminPlayer  keyDown: nr: %d  char: %@",nr,[theEvent characters]);
   switch (nr)
   {
      case 51://delete
      {
         if ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])//Aufanhmen nach Namen
         {
            if (([self.AufnahmenDicArray count])&&([self.AufnahmenTable numberOfSelectedRows]))//nicht leer und eine Zeile selektiert
            {
               int index=[self.AufnahmenTable selectedRow];
               if (![[[self.AufnahmenDicArray objectAtIndex:index] objectForKey:@"aufnahme"]isEqualToString:@"Keine Aufnahme"])
               {
                  NSLog(@"AdminPlayer  delete:Zeile:%d",[self.AufnahmenTable selectedRow]);
                  
               }
            }
            
         }
      }break;
         
      case 36://return
      {
         if ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])
         {
            NSLog(@"return");
            NSNotificationCenter * nc;
            nc=[NSNotificationCenter defaultCenter];
            
            NSString* EnterKeyQuelle;
            EnterKeyQuelle=@"AufnahmenTable";
            [nc postNotificationName:@"AdminEnterKey" object:EnterKeyQuelle];
            
            
            
            //[AdminQTPlayer becomeFirstResponder];
            //[self setLeserFuerZeile:selektierteZeile];
            
            //[AdminQTPlayer setHidden:NO];
            //[self startAdminPlayer:nil];
            //[AdminQTPlayer start:nil];
         }break;
      }
      case 123:
      case 124:
         break;
         
      default:
      {
         NSLog(@"default");
         [super keyDown:theEvent];
      }
   }//switch
}
- (void)AdminKeyNotifikationAktion:(NSNotification*)note
{
   NSLog(@"KeyNotifikationAktion: note: %@",[note object]);
   NSNumber* KeyNummer=[note object];
   int keyNr=(int)[KeyNummer floatValue];
   NSLog(@"keyDown KeyNotifikationAktion description: %@",[KeyNummer description]);
   //NSLog(@"keyDown KeyNotifikationAktion keyNr: %d",keyNr);
   [self setLeser:self.NamenListe ];
   //[self startAdminPlayer:AdminQTPlayer];
}

- (void) AdminZeilenNotifikationAktion:(NSNotification*)note

{
   BOOL erfolg;
   //NSLog(@"AdminZeilenNotifikationAktion: note: %@",[[note object]description]);
   NSDictionary* QuellenDic=[note object];
   
   [self.MarkCheckbox setEnabled:NO];
   //[MarkCheckbox setEnabled:YES];
   NSString* Quelle=[QuellenDic objectForKey:@"Quelle"];
   //NSLog(@"AdminZeilenNotifikationAktion: Quelle: %@",Quelle);
   
   if ([Quelle isEqualToString:@"AdminView"])
	  {
        //NSLog(@"AdminZeilenNotifikationAktion:  AdminView  Quelle: %@",Quelle);
        
        int lastZeilenNr=[[QuellenDic objectForKey:@"AdminLastZeilenNummer"] intValue];
        int nextZeilenNr=[[QuellenDic objectForKey:@"AdminNextZeilenNummer"] intValue];
        //NSLog(@"lastZeilenNr: %d, lastZeilenNr: %d",lastZeilenNr,nextZeilenNummer);
        //NSLog(@"keyDown AdminZeilenNotifikationAktion lastZeilenNr: %d",lastZeilenNr);
        
        if ((self.selektierteZeile>=0)&&(self.selektierteZeile != nextZeilenNr))//selektierte zeile ist nicht -1 wie beim ersten Klick
        {
           //NSLog(@"AdminAktuellerLeser: %@  AdminAktuelleAufnahme: %@",AdminAktuellerLeser,AdminAktuelleAufnahme);
           
           if ([self.AdminAktuellerLeser length]&&[self.AdminAktuelleAufnahme length]&&self.Moviegeladen&&self.Textchanged)
           {
              //NSLog(@"AdminZeilenNotifikationAktion: save in Notification");
              BOOL OK=[self saveKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
              self.Moviegeladen=NO;
              //Textchanged=NO;
           }
           
           //[self backZurListe:nil];
           
           
        }
        self.selektierteZeile=nextZeilenNr;
        if (lastZeilenNr<0)//erster Klick, ZeilenNr ist -1
        {
           lastZeilenNr=0;
        }
        [self setLeserFuerZeile:nextZeilenNr];
        int AnzahlAufnahmenFuerZeile=[self AnzahlAufnahmenFuerZeile:nextZeilenNr];
        //NSLog(@"AdminZeilenNotifikationAktion: nextZeilenNr: %d AnzahlAufnahmenFuerZeile: %d",nextZeilenNr,AnzahlAufnahmenFuerZeile);
        if ((nextZeilenNr>=0)&&AnzahlAufnahmenFuerZeile)
        {
           [self.PlayTaste setEnabled:YES];
           //erfolg=[AdminFenster makeFirstResponder:self.PlayTaste];
           [self.PlayTaste setKeyEquivalent:@"\r"];
           //[MarkCheckbox setEnabled:YES];
           int hit=[[[self.AdminDaten dataForRow:nextZeilenNr]objectForKey:@"aufnahmen"]intValue];
           
           //NSLog(@"AdminZeilenNotifikationAktion zeilenNr: %d",zeilenNr);
        }
        else
        {
           [self.PlayTaste setEnabled:NO];
           [self.PlayTaste setKeyEquivalent:@""];
           //[MarkCheckbox setEnabled:NO];
        }
        
        [self.ExportierenTaste setEnabled:NO];
        [self.LoeschenTaste setEnabled:NO];
        [self.zurListeTaste setEnabled:NO];
        //NSTableColumn* tempKolonne;
        //tempKolonne=[self.NamenListe tableColumnWithIdentifier:@"neu"];
        //[[tempKolonne dataCellForRow:selektierteZeile]setTitle:@"Los"];
        self.Textchanged=NO;
        //NSLog(@"AdminZeilenNotifikationAktion selektierteZeile: %d",selektierteZeile);
     }
	  
   if ([Quelle isEqualToString:@"AufnahmenTable"])
   {
      //NSLog(@"\n\nAdminZeilenNotifikationAktion:  AufnahmenTable  Quelle: %@",Quelle);
      NSNumber* ZeilenNummer=[QuellenDic objectForKey:@"zeilennummer"];
      
      int zeilenNr=[ZeilenNummer intValue];
      
      [self.zurListeTaste setEnabled:NO];
      [self.PlayTaste setEnabled:YES];
      [self.PlayTaste setKeyEquivalent:@"\r"];
      
      [self.MarkCheckbox setState:NO];
      
      NSString* tempAktuellerLeser=[QuellenDic objectForKey:@"leser"];
      NSString* tempAktuelleAufnahme=[QuellenDic objectForKey:@"aufnahme"];
      
      //NSLog(@" zeilenNr: %d tempAktuellerLeser: %@  tempAktuelleAufnahme: %@",zeilenNr,tempAktuellerLeser,tempAktuelleAufnahme);
      if ([tempAktuellerLeser length]&&[tempAktuelleAufnahme length]&&self.Moviegeladen&&self.Textchanged)
      {
         //NSLog(@"save in Notification");
         BOOL OK=[self saveKommentarFuerLeser: tempAktuellerLeser FuerAufnahme:tempAktuelleAufnahme];
         self.Moviegeladen=NO;
         //Textchanged=NO;
      }
      
      //[self backZurListe:nil];
      
      if ([self.AufnahmenDicArray count]>self.selektierteAufnahmenTableZeile)//neu selektierte Zeile
      {
         NSDictionary* tempAufnahmenDic=[self.AufnahmenDicArray objectAtIndex:self.selektierteAufnahmenTableZeile];
         //NSLog(@"AdminZeilenNotifikationAktion NamenTable neuer AufnahmenDic: %@",[tempAufnahmenDic description]);
         NSString* tempAufnahme=[tempAufnahmenDic objectForKey:@"aufnahme"];
         BOOL OK;
         //NSLog(@"AdminAktuellerLeser: %@ tempAufnahme: %@",AdminAktuellerLeser,tempAufnahme);
         OK=[self setPfadFuerLeser: tempAktuellerLeser FuerAufnahme:tempAufnahme];//Movie geladen, wenn OK
         OK=[self setKommentarFuerLeser: tempAktuellerLeser FuerAufnahme:tempAufnahme];
         if([[tempAufnahmenDic objectForKey:@"adminmark"]intValue])
         {
            [self.MarkCheckbox setState:YES];
         }
         else
         {
            [self.MarkCheckbox setState:NO];
         }
         [self.MarkCheckbox setEnabled:self.AufnahmeDa];
         if([[tempAufnahmenDic objectForKey:@"usermark"]intValue])
         {
            [self.UserMarkCheckbox setState:YES];
         }
         else
         {
            [self.UserMarkCheckbox setState:NO];
         }
         
         //[self.PlayTaste setEnabled:YES];
      }//if count
      
      
      [self.ExportierenTaste setEnabled:NO];
      [self.LoeschenTaste setEnabled:NO];
      //[self.PlayTaste setEnabled:YES];
      self.Textchanged=NO;
      [self.MarkCheckbox setEnabled:NO];
      
   }//if Quelle==AufnahmenTable
   
}

- (void) AdminTabNotifikationAktion:(NSNotification*)note
{
   BOOL erfolg;
   //NSLog(@"AdminTabNotifikationAktion: note: %@",[note object]);
   NSDictionary* QuellenDic=[note object];
   [self.MarkCheckbox setEnabled:YES];
   NSString* Quelle=[QuellenDic objectForKey:@"Quelle"];
   
   if ([Quelle isEqualToString:@"AdminView"])
	  {
        //NSLog(@"AdminTabNotifikationAktion:  AdminView  Quelle: %@",Quelle);
        NSNumber* ZeilenNummer=[QuellenDic objectForKey:@"zeilennnummer"];
        
        int zeilenNr=(int)[ZeilenNummer floatValue];
        
        {
           [self.zurListeTaste setEnabled:NO];
           [self.MarkCheckbox setState:NO];
           //[AdminNotenfeld setEnabled:NO];
           //NSLog(@"AdminAktuellerLeser: %@  AdminAktuelleAufnahme: %@",AdminAktuellerLeser,AdminAktuelleAufnahme);
           
           if ([self.AdminAktuellerLeser length]&&[self.AdminAktuelleAufnahme length]&&self.Moviegeladen&&self.Textchanged)
           {
              //NSLog(@"save in Notification");
              BOOL OK=[self saveKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
              self.Moviegeladen=NO;
              //Textchanged=NO;
           }
           
           
        }
        
        
        [self.ExportierenTaste setEnabled:NO];
        [self.LoeschenTaste setEnabled:NO];
        
        //NSTableColumn* tempKolonne;
        //tempKolonne=[self.NamenListe tableColumnWithIdentifier:@"neu"];
        //[[tempKolonne dataCellForRow:selektierteZeile]setTitle:@"Los"];
        self.Textchanged=NO;
     }
	  
   if ([Quelle isEqualToString:@"AufnahmenTable"])
   {
      //NSLog(@"AdminTabNotifikationAktion:  AufnahmenTable  Quelle: %@",Quelle);
      //NSLog(@"QuellenDic :%@",[QuellenDic description]);
      NSNumber* ZeilenNummer=[QuellenDic objectForKey:@"zeilennummer"];
      
      int zeilenNr=[ZeilenNummer intValue];
      //if (selektierteAufnahmenTableZeile != zeilenNr)
      {
         [self.zurListeTaste setEnabled:NO];
         //[self.PlayTaste setEnabled:YES];
         
         
         [self.MarkCheckbox setState:NO];
         //NSLog(@" Zeile: %d AdminAktuellerLeser: %@  AdminAktuelleAufnahme: %@",zeilenNr,AdminAktuellerLeser,AdminAktuelleAufnahme);
         
         if ([self.AdminAktuellerLeser length]&&[self.AdminAktuelleAufnahme length]&&self.Moviegeladen&&self.Textchanged)
         {
            NSLog(@"save in Notification");
            BOOL OK=[self saveKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:self.AdminAktuelleAufnahme];
            self.Moviegeladen=NO;
            //Textchanged=NO;
         }
         
         //[self backZurListe:nil];
         self.selektierteAufnahmenTableZeile=0;
         
         if ([self.AufnahmenDicArray count]>self.selektierteAufnahmenTableZeile)
         {
            NSDictionary* tempAufnahmenDic=[self.AufnahmenDicArray objectAtIndex:self.selektierteAufnahmenTableZeile];
            //NSLog(@"AdminTabNotifikationAktion tempAufnahmenDic: %@",[tempAufnahmenDic description]);
            NSString* tempAufnahme=[tempAufnahmenDic objectForKey:@"aufnahme"];
            BOOL OK;
            
            OK=[self setPfadFuerLeser: self.AdminAktuellerLeser FuerAufnahme:tempAufnahme];
            OK=[self setKommentarFuerLeser: self.AdminAktuellerLeser FuerAufnahme:tempAufnahme];
            if([[tempAufnahmenDic objectForKey:@"adminmark"]intValue])
            {
               [self.MarkCheckbox setState:YES];
            }
            else
            {
               [self.MarkCheckbox setState:NO];
            }
            [self.MarkCheckbox setEnabled:self.AufnahmeDa];
            if([[tempAufnahmenDic objectForKey:@"usermark"]intValue])
            {
               [self.UserMarkCheckbox setState:YES];
            }
            else
            {
               [self.UserMarkCheckbox setState:NO];
            }
            
            //[self.PlayTaste setEnabled:YES];
         }//if count
      }
      
      [self.ExportierenTaste setEnabled:NO];
      [self.LoeschenTaste setEnabled:NO];
      //[self.PlayTaste setEnabled:YES];
      self.Textchanged=NO;
   }//if Quelle==AufnahmenTable
   
}

- (void)AdminEnterKeyNotifikationAktion:(NSNotification*)note
{
   //NSLog(@"Adminliste    EnterKeyNotifikationAktion: note: %@",[note object]);
   NSString* Quelle=[[note object]description];
   //NSLog(@"EnterKeyNotifikationAktion: Quelle: %@",Quelle);
   BOOL erfolg;
   if ([Quelle isEqualToString:@"MovieView"])
   {
      switch ([[[self.AufnahmenTab selectedTabViewItem]identifier]intValue])
      {
         case 1://alle Aufnahmen
         {
            erfolg=[self.AdminFenster makeFirstResponder:self.NamenListe];
         }break;
         case 2://nach 
         {
            erfolg=[self.AdminFenster makeFirstResponder:self.AufnahmenTable];
         }break;
            
            
      }//switch
      //NSLog(@"		Quelle: MovieView->self.NamenListe: erfolg: %d",erfolg);
      [self setBackTaste:NO];
      [self.zurListeTaste setEnabled:NO];
      [self.PlayTaste setEnabled:YES];
   }
   
   if ([Quelle isEqualToString:@"AdminListe"])
	  {
        NSLog(@"(AdminEnterKeyNotifikationAktion  selektierteZeile): %d",self.selektierteZeile);
        if (self.selektierteZeile>=0)
        {
           if ([[self.AdminDaten AufnahmeFilesFuerZeile:self.selektierteZeile]count])
           {
              NSLog(@"1");
              [self setBackTaste:YES];
              erfolg=[self.AdminFenster makeFirstResponder:self.zurListeTaste];
              //erfolg=[[self window]makeFirstResponder:self.PlayTaste];
              [self.PlayTaste setEnabled:NO];
              [self.MarkCheckbox setEnabled:YES];
              [self setLeserFuerZeile:self.selektierteZeile];
              NSLog(@"2");
              //				[AdminQTKitPlayer setHidden:NO];
              [self startAdminPlayer:nil];
              //				[AdminQTKitPlayer play:nil];
              //NSLog(@"		Quelle: AdminListe->QTPlayer: erfolg: %d",erfolg);
              
           }
           else
           {
              NSBeep();
              [self.PlayTaste setEnabled:NO];
              //[MarkCheckbox setEnabled:NO];
              [self.ExportierenTaste setEnabled:NO];
              [self.LoeschenTaste setEnabled:NO];
              [self.zurListeTaste setEnabled:NO];
              [self.zurListeTaste setKeyEquivalent:@""];
              
              
           }
        }
        
     }//if AdminListe
	  
   if ([Quelle isEqualToString:@"AufnahmenTable"])
   {
      NSLog(@"Quelle: AufnahmenTable");
      [self AufnahmeInPlayer:NULL];
      
   }//if AufnahmenTable
}

- (void)DidChangeNotificationAktion:(NSNotification*)note
{
   //NSLog(@"rAdminPlayer: NSTextDidChangeNotification note: %@",[[note object]description]);
   if ([note object]==self.AdminKommentarView)
      
	  {
        NSLog(@"rAdminPlayer: NSTextDidChangeNotification textchanged YES");
        self.Textchanged=YES;
     }
}

- (void)NSTableViewSelectionDidChangeNotification:(NSNotification*)note
{
   NSLog(@"rAdminPlayer: NSTableViewSelectionDidChangeNotification note: %@",[[note object]description]);
   if ([note object]==self.AdminKommentarView)
      
	  {
        NSLog(@"rAdminPlayer: NSTableViewSelectionDidChangeNotification textchanged YES");
        self.Textchanged=YES;
     }
}



- (void) Umgebung:(NSNotification*)note
{
   NSNumber* UmgebungNumber=[[note userInfo]objectForKey:@"Umgebung"];
   self.Umgebung=(int)[UmgebungNumber floatValue];
}


- (NSString*)Zeitformatieren:(long) dieSekunden
{
   short Sekunden=dieSekunden%60;
   short Minuten=dieSekunden/60;
   NSNumber * n=0;
   n=[NSNumber numberWithLong:Minuten];
   NSString * stringMinuten=[n stringValue];
   n=[NSNumber numberWithLong:Sekunden];
   //NSLog(@"Zeitform:%d",n);
   NSString*  stringSekunden=[n stringValue];
   NSString* stringZeit;
   if (Minuten<10)
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
   
   return stringZeit;
   
}


- (void)clearKommentarfelder
{
   BOOL editierbar=[self.AdminKommentarView isEditable];
   BOOL selektierbar=[self.AdminKommentarView isSelectable];
   [self.AdminKommentarView setEditable:YES];
   //[AdminKommentarView selectAll:nil];
   //[AdminKommentarView delete:nil];
   [self.AdminKommentarView setString:@""];
   [self.AdminKommentarView setEditable:editierbar];
   [self.AdminKommentarView setSelectable:selektierbar];
   
   [self.AdminNamenfeld setStringValue: @""];
   [self.AdminDatumfeld setStringValue: @""];
   [self.AdminTitelfeld setStringValue: @""];
   //	[AdminBewertungfeld setStringValue: @""];
   [self.AdminNotenfeld setStringValue: @""];
   [self.MarkCheckbox setState:NO];
   
}

- (OSErr)ExportMovieVonPfad:(NSString*) derAufnahmePfad
{	
   OSErr erfolg=0;
   FSSpec	*tempExportFSSpec;
   FSRef tempExportRef;
   short status;
   UniChar buffer[255]; // HFS+ filename max is 255
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSString* ExportAufnahmeName=[[derAufnahmePfad copy] lastPathComponent];
   //NSLog(@"ExportAufnahmeName: %@",ExportAufnahmeName);
   [ExportAufnahmeName getCharacters:buffer];
   //NSString* tempExportOrdnerPfad=[NSString stringWithString:NSHomeDirectory()];
   //tempExportOrdnerPfad=[ExportOrdnerPfad stringByAppendingPathComponent:@"Documents"];
   NSString* tempExportOrdnerPfad=[self.AdminLeseboxPfad stringByDeletingLastPathComponent];
   status = FSPathMakeRef((UInt8*)[tempExportOrdnerPfad fileSystemRepresentation],  &tempExportRef, NULL);
   
   // QTKit
   NSError* loadErr;
   NSURL *movieURL = [NSURL fileURLWithPath:derAufnahmePfad];
   //	QTMovie* tempMovie= [[QTMovie alloc]initWithURL:movieURL error:&loadErr];
   if (loadErr)
   {
      NSAlert *theAlert = [NSAlert alertWithError:loadErr];
      [theAlert runModal]; // Ignore return value.
   }
   /*
    if (!tempMovie)
    NSLog(@"Kein Movie da");
    // retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h) 
    Movie tempExportMovie =[tempMovie quickTimeMovie];
    
    long exportFlags = showUserSettingsDialog |
    movieToFileOnlyExport |
    movieFileSpecValid |
    createMovieFileDeleteCurFile;
    
    // If the movie is currently playing stop it
    if (GetMovieRate(tempExportMovie))
    StopMovie(tempExportMovie);
    
    // use the default progress procedure, if any
    SetMovieProgressProc(tempExportMovie,					// the movie specifier
    (MovieProgressUPP)-1L,		// pointer to a progress function; -1 indicades default
    0);						// reference constant
    
    // export the movie into a file
    ConvertMovieToFile(tempExportMovie,					// the movie to convert
    NULL,						// all tracks in the movie
    tempExportFSSpec,					// the output file
    0,							// the output file type
    0,							// the output file creator
    smSystemScript,				// the script
    NULL, 						// no resource ID to be returned
    exportFlags,					// no flags
    NULL);						// no specific component
    //NSOKButton
    
    */
   return erfolg;
}//Export





- (BOOL) FensterschliessenOK
{
   BOOL allOK=YES;
   
   if (self.Textchanged)
   {
      NSString* s1=@"Anmerkungen";
      NSString* s2=@"Sichern";
      NSString* s3=@"Nicht sichern";
      NSString* s4=@"Die Anmerkungen für die aktuelle Aufnahme sind noch nicht gesichert.";
      NSAlert *Warnung = [[NSAlert alloc] init];
      [Warnung addButtonWithTitle:s2];
      [Warnung addButtonWithTitle:s3];
      [Warnung setMessageText:s1];
      [Warnung setInformativeText:s4];
      
      [Warnung setAlertStyle:NSWarningAlertStyle];
      [Warnung beginSheetModalForWindow:self.AdminFenster
                          modalDelegate:self
                         didEndSelector:@selector(alertDidEnd: returnCode: contextInfo:)
                            contextInfo:@"TextchangedWarnung"];
      NSLog(@"TextchangedWarnung nach Alert");
      allOK=NO;
   }
   
   return allOK;
}

- (BOOL)windowShouldClose:(id)sender
{
   
   BOOL OK=[self FensterschliessenOK];
   //NSLog(@"windowShouldClose");
   if (OK)
	  {
        NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
        [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
        NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"externbeenden" object:self userInfo:NotificationDic];
        
     }
   return OK;
}


-(void)AdminBeenden
{
   if ([self FensterschliessenOK])
   {
      NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      [NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"externbeenden" object:self userInfo:NotificationDic];
   }
}

- (void)showCleanFenster:(int)tab
{
   NSLog(@"AdminPlayer showClean  AnzNamen: %d",[self.AdminProjektNamenArray count]);
   if (!self.CleanFenster)
	  {
        //		CleanFenster=[[rClean alloc]initWithRowCount:[AdminProjektNamenArray count]];
     }
   
   //NSLog(@"AdminPlayer showClean: tab: %d",tab);
   
   self.nurTitelZuNamenOption=0;
   
   [self.CleanFenster showWindow:self];
   
   //[CleanFenster setAnzahlPopMenu:AnzahlOption];
   
   NSMutableDictionary* SettingDic=[NSMutableDictionary dictionaryWithObject:self.ExportFormatString
                                                                      forKey:@"exportformat"];
   [self.CleanFenster setClean:SettingDic];
   [self.CleanFenster setNamenArray:self.AdminProjektNamenArray];
   
   
   
   
   
}

- (void)setCleanTask:(int)dieTask
{
   //NSLog(@"AdminPlayer: vor setTaskTab: %d",dieTask);
   
   [self.CleanFenster setTaskTab:dieTask];
   //NSLog(@"AdminPlayer: nach setTaskTab");
}

- (void)MarkierungNotificationAktion:(NSNotification*)note
{
   int var=[[[note userInfo]objectForKey:@"MarkierungVariante"]intValue];
   NSLog(@"MarkierungNotificationAktion  Variante: %d ",var);
   switch (var)
   {
      case 0://Nur Leser
      {
         [self.AufnahmenTab selectTabViewItemAtIndex:0];
         NSLog(@"MarkierungNotificationAktion Nur markierungen von einem Leser");
         [self MarkierungEntfernenFuerZeile:[self.NamenListe selectedRow]];
         
      }break;
      case 1://alle
      {
         NSLog(@"MarkierungNotificationAktion alle  markierungen");
         [self Markierungenreset];
      }break;
   }//switch
   
}
- (void)AdminProjektListeAktion:(NSNotification*)note
{
   //aus Projektwahl
   //NSLog(@"AdminProjektListeAktion: %@",[[note userInfo]description]);
}

- (void)anderesAdminProjektAktion:(NSNotification*)note
{
   NSLog(@"AdminProjektListeAktion: %@",[[note userInfo]description]);
   
}

- (void)ProjektArrayNotificationAktion:(NSNotification*)note
{
   NSArray* tempProjektArray =[[note userInfo]objectForKey:@"ProjektArray"];
   NSLog(@"ProjektArrayNotificationAktion  tempProjektArray: %@ ",tempProjektArray);
   if (tempProjektArray)
   {
      if ([tempProjektArray count])
      {
         [self.AdminProjektArray removeAllObjects];
         [self.AdminProjektArray setArray:tempProjektArray];
      }
   }//if tempProjektArray
}


- (void)NameIstEntferntAktion:(NSNotification*)note
{
   NSString* tempEntfernenName;
   int entfernenOK=-1;
   if ([[note userInfo] objectForKey:@"namen"])
   {
      //NSLog(@"// Name: %@",[[note userInfo] objectForKey:@"namen"]);
      tempEntfernenName=[[note userInfo] objectForKey:@"namen"];
      
   }
   if ([[note userInfo] objectForKey:@"entfernenOK"])
   {
      //NSLog(@"*AdminPlayer NamenEntfernenAktion entfernenOK: %@",[[note userInfo] objectForKey:@"entfernenOK"]);
      entfernenOK=[[[note userInfo] objectForKey:@"entfernenOK"]intValue];
   }	
   if (entfernenOK==0)//allesOK
   {
      [self setAdminPlayer:self.AdminLeseboxPfad inProjekt:[self.AdminProjektPfad lastPathComponent]];
      
      //[AdminDaten deleteDataZuName:tempEntfernenName];
      //[self.NamenListe reloadData];
   }
}
- (void)NameIstEingesetztAktion:(NSNotification*)note
{
   //NSLog(@"NameIstEingesetztNotificationAktion: %@",[note description]);
   if ([[note userInfo]objectForKey:@"einsetzenOK"])
   {
      int EinsetzenOK=[[[note userInfo]objectForKey:@"einsetzenOK"]intValue];	
      if (EinsetzenOK)
      {
         [self setAdminPlayer:self.AdminLeseboxPfad inProjekt:[self.AdminProjektPfad lastPathComponent]];
      }//if 
   }//note
}

// KommentarKontroller

- (NSString*)OptionA;
{
   NSString* OptionString=[self.KommentarFenster PopAOption];
   return OptionString;
}
- (NSString*)OptionB
{
   NSString* OptionString=[self.KommentarFenster PopBOption];
   return OptionString;
}

- (BOOL)nurMarkierte
{
   return [self.KommentarFenster nurMarkierte];
}

- (BOOL)mitMarkierungAufnehmenOptionAnPfad:(NSString*)derAufnahmePfad
{
   BOOL AufnehmenOK=YES;
   BOOL nurMarkierteAufnehmenOK=[self nurMarkierte];
   BOOL AufnahmeIstMarkiertOK=[self AufnahmeIstMarkiertAnPfad:derAufnahmePfad];
   if (nurMarkierteAufnehmenOK &&!AufnahmeIstMarkiertOK)
   {
      AufnehmenOK=NO;
   }
   return AufnehmenOK;
}

- (NSView*)KommentarView
{
   return [self.KommentarFenster KommentarView];
   NSLog(@"AdminPlayer return Kommentar");
}

- (IBAction)showKommentar:(id)sender
{
   //NSString* alle=@"alle";
   //NSLog(@"AdminPlayer showKommentar: AdminProjektArray: %@",[AdminProjektArray description]);
   if (!self.KommentarFenster)
	  {
        self.KommentarFenster=[[rKommentar alloc]init];
     }
   [self.KommentarFenster showWindow:self];
   [self.KommentarFenster setAnzahlPopMenu:self.AnzahlOption];
   if ([self.AdminAktuellerLeser length])
	  {
        self.AuswahlOption=alleVonNameKommentarOption;
        [self.KommentarFenster setAuswahlPop:alleVonNameKommentarOption];
        [self.KommentarFenster setPopAMenu:self.AdminProjektNamenArray erstesItem:alle aktuell:self.AdminAktuellerLeser];
        NSArray* TitelArray=[self TitelArrayVon:self.AdminAktuellerLeser anProjektPfad:self.AdminProjektPfad];
        
        if ([self.AdminAktuelleAufnahme length])
        {
           [self.KommentarFenster setPopBMenu:TitelArray erstesItem:alle aktuell:[self AufnahmeTitelVon:self.AdminAktuelleAufnahme] mitPrompt:@"mit Titel:"];
        }
     }
   else
	  {
        self.AuswahlOption=lastKommentarOption;
        [self.KommentarFenster setAuswahlPop:lastKommentarOption];
     }
   self.nurMarkierteOption=0;
   self.ProjektPfadOptionString=self.AdminProjektPfad;
   //NSLog(@"AdminProjektArray: %@",[AdminProjektArray description]);
   NSArray* StartProjektArray=[self.AdminProjektArray valueForKey:@"projekt"];
   NSLog(@"StartProjektArray: %@",[StartProjektArray description]);
   
   [self.KommentarFenster setProjektMenu:StartProjektArray mitItem:[self.AdminProjektPfad lastPathComponent]];
   
   NSArray* startProjektPfadArray=[NSArray arrayWithObject:self.AdminProjektPfad];
   NSArray* startKommentarStringArray=[self createKommentarStringArrayWithProjektPfadArray:startProjektPfadArray];
   
   //NSString* startKommentarString=[self createKommentarStringInProjekt:AdminProjektPfad];
   
   NSMutableDictionary* KommentarStringDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   //[KommentarStringDic setObject:startKommentarString forKey:@"kommentarstring"];
   [KommentarStringDic setObject:[self.AdminProjektPfad lastPathComponent] forKey:@"projekt"];
   [KommentarStringDic setObject:self.AdminProjektPfad forKey:@"projektpfad"];
   NSArray* startKommentarArray=[NSArray arrayWithObject:KommentarStringDic];
   //NSLog(@"showKommentar KommentarStringDic: %@",[KommentarStringDic description]);
   
   //[KommentarFenster setKommentar:[self createKommentarStringInProjekt:AdminProjektPfad]];
   [self.KommentarFenster setKommentarMitKommentarDicArray:startKommentarStringArray];
   
}


- (void)KommentarDrucken
{
   //NSLog(@"\n****************									AdminPlayer KommentarDruckenMitKommentarDicArray");
   NSArray* tempProjektPfadArray=[self ProjektPfadArrayMitKommentarOptionen];
   NSLog(@"tempProjektPfadArray: %@",[tempProjektPfadArray description]);
   
   NSArray* tempKommentarDicArray=[self createDruckKommentarStringDicArrayWithProjektPfadArray:[tempProjektPfadArray valueForKey:@"projektpfad"]];
   
   NSLog(@"AdminPlayer KommentarDrucken nach create: Anzahl Dics: %d",[tempKommentarDicArray count]);
   
   [self.KommentarFenster KommentarDruckenMitProjektDicArray:tempKommentarDicArray];
   NSLog(@"AdminPlayer KommentarDrucken nach KommentarFenster KommentarDruckenMitProjektDicArray\n");
}


- (void)KommentarSichern
{
   NSLog(@"\n								AdminPlayer KommentarSichernMitKommentarDicArray");
   NSArray* tempProjektPfadArray=[self ProjektPfadArrayMitKommentarOptionen];
   NSLog(@"tempProjektPfadArray: %@",[tempProjektPfadArray description]);
   
   NSArray* tempKommentarDicArray=[self createDruckKommentarStringDicArrayWithProjektPfadArray:[tempProjektPfadArray valueForKey:@"projektpfad"]];
   
   NSLog(@"AdminPlayer KommentarSichern nach create: Anzahl Dics: %d",[tempKommentarDicArray count]);
   
   [self.KommentarFenster KommentarSichernMitProjektDicArray:tempKommentarDicArray];
   NSLog(@"AdminPlayer KommentarDrucken nach KommentarFenster KommentarSichernMitProjektDicArray\n");
}


/*
 - (void)KommentarDruckenVonProjekt:(NSString*)dasProjekt
 {
	//NSLog(@"AdminPlayer KommentarDrucken");
	[KommentarFenster KommentarDruckenVonProjekt:dasProjekt];
 }
 
 - (void)SaveKommentarVonProjekt:(NSString*)dasProjekt
 {
 NSLog(@"AdminPlayer SaveKommentar");
 [KommentarFenster SaveKommentarVonProjekt:dasProjekt];
 }
 
 
 */

- (NSArray*)createKommentarStringArrayWithProjektPfadArray:(NSArray*)derProjektPfadArray
{
   NSLog(@"\n\n*********\n			                                     Beginn createKommentarStringArrayWithProjektPfadArray\n\n");
   NSLog(@"\nderProjektPfadArray: %@",[derProjektPfadArray description]);
   NSLog(@"AuswahlOption: %d  OptionAString: %@  OptionBString: %@",self.AuswahlOption,self.OptionAString,self.OptionBString);
   NSLog(@"   [self OptionA]: %@  [self OptionB]: %@  AnzahlDics: %d",[self OptionA],[self OptionB],[derProjektPfadArray count]);
   //OptionAString=[[KommentarFenster PopAOption]retain];
   //OptionBString=[[KommentarFenster PopBOption]retain];
   //NSLog(@"AuswahlOption: %d  OptionAString: %@  OptionBString: %@",AuswahlOption,OptionAString,OptionBString);
   NSArray* tempProjektPfadArray=[NSArray arrayWithArray:derProjektPfadArray];
   
   NSString* name=NSLocalizedString(@"Name:",@"Name:");
   NSString* datum=NSLocalizedString(@"Datum:",@"Datum:");
   NSString* titel=NSLocalizedString(@"Titel:",@"Titel:");
   NSString* bewertung=NSLocalizedString(@"Bewertung:",@"Bewertung:");
   
   NSString* anmerkungen=NSLocalizedString(@"Anmerkungen",@"Anmerkungen:");
   NSString* note=NSLocalizedString(@"Note:",@"Note:");
   NSString* tabSeparator=@"\t";
   NSString* crSeparator=@"\r";
   NSString* alle=NSLocalizedString(@"alle",@"alle");
   
   NSArray* TabellenkopfArray=[NSArray arrayWithObjects:name,titel,datum,bewertung,note,anmerkungen,nil];
   //	NSArray* TabellenkopfArray=[NSArray arrayWithObjects:name,titel,datum,note,anmerkungen,nil];
   
   NSMutableArray* tempKommentarStringArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   
   NSEnumerator* ProjektPfadEnum=[tempProjektPfadArray objectEnumerator];
   id einProjektPfad;
   while (einProjektPfad=[ProjektPfadEnum nextObject])
   {
      //NSLog(@"while einProjektPfad:        einProjektPfad: %@",einProjektPfad);
      //KommentarString enthält den Kopfstring und die Kommentare für einProjektPfad
      NSMutableString* KommentarString=[NSMutableString stringWithCapacity:0];
      
      //tempKommentarArray enthält die Kommentare entsprechend den Einstellungen im Kommentarfenster
      //Er wird nachher zusammen mit dem Kopfstring zu KommentarString zusammengesetzt
      NSMutableArray* tempKommentarArray=[[NSMutableArray alloc]initWithCapacity:0];
      NSLog(@"createKommentarStringArrayWithProjekt AuswahlOption: %d ProjektPfad: %@",self.AuswahlOption,einProjektPfad);
      
      switch (self.AuswahlOption) // AusProjekt ( ), aus allen aktiven Projekten, aus allen Projekten
      {
         case ausEinemProjektOption:
         {
            NSLog(@"switch (AuswahlOption): ausEinemProjektOption: einProjektPfad: %@",einProjektPfad);
            tempKommentarArray=(NSMutableArray*)[self lastKommentarVonAllenAnProjektPfad:einProjektPfad]; // OK
         }break;
            
         case ausAktivenProjektenOption:
         {
            NSLog(@"switch (AuswahlOption): ausAktivenProjektenOption");
            NSString* tempLeser=[self.KommentarFenster PopAOption];
            //NSLog(@"alleVonNameKommentarOption tempLeser: %@",[self OptionA]);
            
            if ([[self OptionA] isEqualToString:alle])
            {
               tempKommentarArray=(NSMutableArray*)[self alleKommentareNachNamenAnProjektPfad:einProjektPfad
                                                                                    bisAnzahl:self.AnzahlOption];
               NSLog(@"Projekt: %@	tempKommentarArray: %@",[einProjektPfad lastPathComponent], [tempKommentarArray description]);
               NSLog(@"\n\n\n");
            }
            else
            {
               if ( [[self OptionB] isEqualToString:alle])
               {
                  NSLog(@"\n++++++ alleVonNameKommentarOption OptionAString: %@       OptionBString= alle ",[self OptionA]);
                  tempKommentarArray=(NSMutableArray*)[self alleKommentareVonLeser :[self OptionA]
                                                                      anProjektPfad:einProjektPfad
                                                                          bisAnzahl:self.AnzahlOption];
                  //NSLog(@"++	tempKommentarArray:  \n%@  ",[tempKommentarArray description]);
                  
               }
               else //Titel ausgewählt
               {
                  NSLog(@"alleVonNameKommentarOption OptionAString: %@ OptionBString:%@ ",[self OptionA],[self OptionB]);
                  //NSLog(@"tempKommentarArray: Anz: %d %@",[tempKommentarArray count],[tempKommentarArray description]);
                  tempKommentarArray=[[self KommentareVonLeser:[self OptionA]
                                                      mitTitel:[self OptionB]
                                                       maximal:self.AnzahlOption
                                                 anProjektPfad:einProjektPfad]mutableCopy];
                  
                  
                  //NSLog(@"createKomm.String\ntempKommentarArray: Anz: %d %@",[tempKommentarArray count],[tempKommentarArray description]);
                  
                  
               }
               
            }
            
         }break;
            
         case ausAllenProjektenOption:
         {
            NSLog(@"switch (AuswahlOption): ausAllenProjektenOption");
            //NSLog(@" OptionAString %@	OptionBString: %@",[self OptionA],[self OptionB]);
            if ([[self OptionA] isEqualToString:alle])//Alle Titel
            {
               tempKommentarArray=(NSMutableArray*)[self alleKommentareNachTitelAnProjektPfad:einProjektPfad
                                                                                    bisAnzahl:self.AnzahlOption];
               //NSLog(@"createKomm.String: OptionAString ist alle  tempKommentarArray: %@",[tempKommentarArray description]);
               if ([[self OptionB] isEqualToString:alle])//alle Namen Zu Titel
               {
                  // tempKommentarArray=(NSMutableArray*)[self alleKommentareNachTitel:AnzahlOption];
               }
               else
               {
                  //tempKommentarArray=(NSMutableArray*)[self alleKommentareVonLeser :[self OptionB]
                  //												  maximal:AnzahlOption];
               }
               
            }
            else
            {
               if ([self OptionB])
               {
                  if ([[self OptionB] isEqualToString:alle])//alle Namen Zu Titel
                  {
                     //NSLog(@"OptionBString ist alle: -> alleKommentareZuTitel");
                     tempKommentarArray=(NSMutableArray*)[self alleKommentareZuTitel:[self OptionA]
                                                                       anProjektPfad:einProjektPfad
                                                                             maximal:self.AnzahlOption];
                  }
                  else
                  {
                     tempKommentarArray=(NSMutableArray*)[self KommentareMitTitel:[self OptionA]
                                                                         vonLeser:[self OptionB]
                                                                    anProjektPfad:einProjektPfad
                                                                          maximal:self.AnzahlOption];
                  }
               }
            }
            //NSLog(@"createKommentarString: alleVonTitelKommentarOption**ende");
         }break;
            
      }//switch KommentarOption
      
      //
      //tempKommentarArray enthält die Kommentare für einProjektPfad
      
      NSLog(@"\n******************\n\ntempKommentarArray nach switch: : %@\n\n**********",[tempKommentarArray description]);
      
      //entsprechend den Optionen im Kommentarfenster
      //
      if ([tempKommentarArray count])
      {
         switch (self.AbsatzOption)
         {
            case alsTabelleFormatOption:
            {
               int index;
               //NSLog(@"alleVonTitelKommentarOption 2");
               
               for (index=0;index<[TabellenkopfArray count];index++)
               {
                  NSString* tempKopfString=[TabellenkopfArray objectAtIndex:index];
                  //NSLog(@"tempKopfString: %@",tempKopfString);
                  //Kommentar als Array von Zeilen
                  [KommentarString appendFormat:@"%@%@",tempKopfString,tabSeparator];
                  //NSLog(@"KommentarString: %@  index:%d",KommentarString,index);
               }
               //NSLog(@"createKommentarString tempKommentarArray  %@  count:%d",[tempKommentarArray description],[tempKommentarArray count]);
               
               if ([tempKommentarArray count]==0)
               {
                  NSMutableDictionary* returnDic=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [returnDic setObject:[einProjektPfad lastPathComponent] forKey:@"projekt"];
                  [returnDic setObject:@"Keine Kommentare für diese Einstellungen" forKey:@"kommentarstring"];
                  
                  NSArray* returnArray=[NSArray arrayWithObject: returnDic];
                  
                  break;
               }
               
               
               [KommentarString appendString:crSeparator];
               
               
               for (index=0;index<[tempKommentarArray count];index++)
               {
                  //ganzer Kommentar zu einem Leser als String
                  NSString* tempKommentarString=[tempKommentarArray objectAtIndex:index];
                  
                  //Kommentar als Array von Zeilen
                  NSMutableArray* tempKomponentenArray=(NSMutableArray*)[tempKommentarString componentsSeparatedByString:crSeparator];
                  int zeile;
                  NSLog(@"++	tempKomponentenArray count: %d   TabellenkopfArray count: %d",[tempKomponentenArray count],[TabellenkopfArray count]);
                  if ([tempKomponentenArray count]>[TabellenkopfArray count]+1)
                  {
                     NSLog(@"Anz Zeilen > als Elemente der Kopfzeile: tempKomponentenArray: %@",[tempKomponentenArray description]);
                  }
                  if ([tempKomponentenArray count]>8)
                  {
                     NSLog(@"Zu viele Elemente: %d%@tempKomponentenArray: %@",[tempKomponentenArray count],crSeparator,[tempKomponentenArray description]);
                  }
                  
                  if ([tempKomponentenArray count]==7)//neue Version mit usermark
                  {
                     [tempKomponentenArray removeObjectAtIndex:UserMark];//UserMark weg
                     
                  }
                  if ([tempKomponentenArray count]==8)//neue Version mit usermark und AdminMark
                  {
                     // AdminMark zuerst loeschen, da hoeherer Index
                     [tempKomponentenArray removeObjectAtIndex:AdminMark];//AdminMark weg
                     [tempKomponentenArray removeObjectAtIndex:UserMark];//UserMark weg
                     
                  }
                  
                  
                  
                  NSLog(@"index: %d\n           tempKomponentenArray: %@",index, [tempKomponentenArray description]);
                  
                  if ([tempKomponentenArray count]==6)//korrekte Version mit 6 Zeilen
                  {
                     NSLog(@"Array hat 6 Zeilen: index: %d",index);
                     for (zeile=0;zeile<6;zeile++)
                     {
                        // Zeile im KomponentenArray
                        NSMutableString* tempString=[[tempKomponentenArray objectAtIndex:zeile]mutableCopy];
                        if ([[TabellenkopfArray objectAtIndex:zeile]isEqualToString:datum])
                        {
                           //Zeit loeschen
                           NSArray* tempArray=[tempString componentsSeparatedByString:@" "];
                           tempString=[tempArray objectAtIndex:0]; // Nur Datum
                        }
                        if (zeile==5)//Anmerkungen
                        {
                           
                           //Zeilenwechsel entfernen
                           NSRange r=NSMakeRange(0,[tempString length]);
                           int anzn, anzr;
                           //NSLog(@"tempString orig: %s",[tempString cString]);
                           anzn=[tempString replaceOccurrencesOfString:@"\n" withString:@" " options:NSBackwardsSearch range:r];
                           anzr=[tempString replaceOccurrencesOfString:@"\r" withString:@" " options:NSBackwardsSearch range:r];
                           //NSLog(@"Zeilenwechsel in tempString: %s n: %d r: %d",[tempString cString],anzn,anzr);
                        }
                        [KommentarString appendFormat:@"%@%@",tempString,tabSeparator];
                     }
                     
                  }
                  
                  else
                  {
                     NSLog(@"Zuwenig Elemente: tempKommentarString: %@",tempKommentarString);
                  }
                  
                  //for (zeile=0;zeile<[TabellenkopfArray count];zeile++)//Zusätzliche Zeilen werden ignoriert
                  
                  [KommentarString appendString:crSeparator];
               }//for index
               //NSLog(@"alsTabelleFormatOption ende");
            }break;//alsTabelleFormatOption
               
            case alsAbsatzFormatOption:
            {
               NSLog(@"alsAbsatzFormatOption");
               
               int index;
               for (index=0;index<[tempKommentarArray count];index++)
               {
                  //ganzer Kommentar zu einem Leser als String
                  NSString* tempKommentarString=[tempKommentarArray objectAtIndex:index];
                  //Kommentar als Array von Zeilen
                  NSMutableArray* tempKomponentenArray=(NSMutableArray*)[tempKommentarString componentsSeparatedByString:crSeparator];
                  
                  //NSLog(@"tempKomponentenArray count: %d   TabellenkopfArray count: %d",[tempKomponentenArray count],[TabellenkopfArray count]);
                  if ([tempKomponentenArray count]==7)//neue Version mit usermark
                  {
                     //
                     [tempKomponentenArray removeObjectAtIndex:5];//UserMark weg
                     //
                     
                  }
                  
                  int zeile;
                  for (zeile=0;zeile<[tempKomponentenArray count];zeile++)
                  {
                     NSMutableString* tempString=[[tempKomponentenArray objectAtIndex:zeile]mutableCopy];
                     if (zeile==5)//Anmerkungen
                     {//Zeilenwechsel entfernen
                        NSRange r=NSMakeRange(0,[tempString length]);
                        int anz;
                        anz=[tempString replaceOccurrencesOfString:@"\n" withString:@" " options:NSBackwardsSearch range:r];
                        anz=[tempString replaceOccurrencesOfString:@"\r" withString:@" " options:NSBackwardsSearch range:r];
                     }
                     
                     
                     [KommentarString appendFormat:@"%@%@%@",[TabellenkopfArray objectAtIndex:zeile],tabSeparator, tempString];
                     [KommentarString appendString:crSeparator];
                  }
                  [KommentarString appendString:crSeparator];
               }//for index
               
            }break;//alsAbsatzFormatOption
         }//switch FormatOption
         
         NSMutableDictionary* tempKommentarStringDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         
         [tempKommentarStringDic setObject: KommentarString forKey:@"kommentarstring"];
         [tempKommentarStringDic setObject: [einProjektPfad lastPathComponent] forKey:@"projekt"];
         
         // tempKommentarStringDic in Array einsetzen
         [tempKommentarStringArray addObject:tempKommentarStringDic];
         
         //****
      }//if [tempKommentarArray count]
      //NSLog(@"*createKommentarStringArray  *ende while*");
   }//while einProjektPfad
   //NSLog(@"*createKommentarString **ende*: Anzahl Dics: %d",[tempKommentarStringArray count]);
   //[TabellenkopfArray release];
   //NSLog(@"*createKommentarString **ende*: KommentarString: %@%@%@",@"\r" ,KommentarString,@"\r");
   
   
   //**********
   
   NSMutableArray* returnKommentarStringArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSEnumerator* KommentarEnum=[tempKommentarStringArray objectEnumerator];
   id einKommentarDic;
   while (einKommentarDic =[KommentarEnum nextObject])
   {
      NSString*  tempAlleKommentareString=[einKommentarDic objectForKey:@"kommentarstring"];
      if (tempAlleKommentareString && [tempAlleKommentareString length])
      {
         //NSLog(@"tempAlleKommentareString: %@",[tempAlleKommentareString description]);
         NSMutableArray* neuerKommentarArray=[[NSMutableArray alloc]initWithCapacity:0];
         
         NSArray* tempKommentarArray=[tempAlleKommentareString componentsSeparatedByString:@"\r"];//Einzelne KommentarStrings
         if (tempKommentarArray &&[tempKommentarArray count])
         {
            NSEnumerator* ElementArrayEnum=[tempKommentarArray objectEnumerator];
            id einElement;
            while (einElement=[ElementArrayEnum nextObject])
            {
               NSArray* tempElementArray=[einElement componentsSeparatedByString:@"\t"];//Einzelne KommentarZeilen
               //NSLog(@"tempElementArray: %@",[tempElementArray description]);
               if ([tempElementArray count]>=5)
               {
                  //10.12.08					if (!([[tempElementArray objectAtIndex:5]isEqualToString:@"--"]))//leere Kommentare nicht kopieren
                  {
                     [neuerKommentarArray addObject:[tempElementArray componentsJoinedByString:@"\t"]];
                  }
               }
            }//while
            
         }
         if ([neuerKommentarArray count])
         {
            [einKommentarDic setObject:[neuerKommentarArray componentsJoinedByString:@"\r"] forKey:@"kommentarstring"];
         }
      }//if tempKommentar£String
      [returnKommentarStringArray addObject:einKommentarDic];
   }//while
   
   //if ([tempKommentarStringArray count]==0)
   if ([returnKommentarStringArray count]==0)
   {
      //Keine Kommentare für diese Settings
      NSMutableDictionary* keinKommentarStringDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      NSString* keinKommentarProjektString=@"Leerer Ordner für Anmerkungen";
      NSString* keinKommentarString=@"Keine Kommentare für diese Einstellungen";
      
      [keinKommentarStringDic setObject: keinKommentarString forKey:@"kommentarstring"];
      [keinKommentarStringDic setObject: keinKommentarProjektString forKey:@"projekt"];
      //[keinKommentarStringDic setObject: [einProjektPfad lastPathComponent] forKey:@"projekt"];
      
      // tempKommentarStringDic in Array einsetzen
      [returnKommentarStringArray addObject:keinKommentarStringDic];
      //[tempKommentarStringArray addObject:keinKommentarStringDic];
      
   }
   
   //	return tempKommentarStringArray;
   return returnKommentarStringArray;
}

- (NSArray*)ProjektPfadArrayMitKommentarOptionen
{
   NSMutableArray* tempProjektDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   int DruckAuswahlOption=[self.KommentarFenster AuswahlOption];
   //NSLog(@"createDruckKommentarStringDicArrayWithProjektPfadArray   DruckAuswahlOption: %d",DruckAuswahlOption);
   switch (DruckAuswahlOption)
   {
      case 0://Nur ein Projekt
      {
         
         //NSString* tempProjektPfad=[[AdminProjektArray objectAtIndex:ProjektNamenOption]objectForKey:@"projektpfad"];
         //NSLog(@"tempProjektPfad: %@",tempProjektPfad);
         NSMutableDictionary* tempProjektDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempProjektDictionary setObject:self.ProjektPfadOptionString forKey:@"projektpfad"];
         [tempProjektDictionary setObject:[self.ProjektPfadOptionString lastPathComponent] forKey:@"projekt"];
         [tempProjektDicArray addObject:tempProjektDictionary];
         
      }break;
         
      case 1://Nur aktive Projekte
      {
         NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
         id einProjektDic;
         while (einProjektDic=[ProjektArrayEnum nextObject])
         {
            //NSLog(@"		Nur aktive Projekte: %@",[einProjektDic description]);
            if ([einProjektDic objectForKey:@"OK"])
            {
               if ([[einProjektDic objectForKey:@"OK"]boolValue]&&[einProjektDic objectForKey:@"projektpfad"])
               {
                  NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                  NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                  //NSLog(@"Nur aktive Projekte: tempProjektPfad: %@",tempProjektPfad);
                  NSMutableDictionary* tempProjektDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [tempProjektDictionary setObject:tempProjektPfad forKey:@"projektpfad"];
                  [tempProjektDictionary setObject:[tempProjektPfad lastPathComponent] forKey:@"projekt"];
                  [tempProjektDicArray addObject:tempProjektDictionary];
                  
               }
            }
         }//while enum
         
      }break;
         
      case 2://Alle Projekte
      {
         NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
         id einProjektDic;
         while (einProjektDic=[ProjektArrayEnum nextObject])
         {
            //NSLog(@"		alle Projekte: %@",[einProjektDic description]);
            if ([einProjektDic objectForKey:@"OK"])
            {
               if ([einProjektDic objectForKey:@"projektpfad"])
               {
                  NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                  NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                  //NSLog(@"Alle Projekte: tempProjektPfad: %@",tempProjektPfad);
                  NSMutableDictionary* tempProjektDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [tempProjektDictionary setObject:tempProjektPfad forKey:@"projektpfad"];
                  [tempProjektDictionary setObject:[tempProjektPfad lastPathComponent] forKey:@"projekt"];
                  [tempProjektDicArray addObject:tempProjektDictionary];
                  
               }
            }
         }//while enum
         
      }break;
         
   }
   //NSLog(@"tempProjektDicArray: %@",[tempProjektDicArray description]);	//Array mit ProjektPfaden
   
   return tempProjektDicArray;
}


- (NSArray*)createDruckKommentarStringDicArrayWithProjektPfadArray:(NSArray*)derProjektPfadArray
{
   NSArray* tempProjektDicArray=[self ProjektPfadArrayMitKommentarOptionen];
   
   //NSLog(@"tempProjektDicArray: %@",[tempProjektDicArray description]);	//Array mit ProjektPfaden
   
   //KommentarstringArray aufbauen
   NSArray* tempKommentarStringDicArray=[self createKommentarStringArrayWithProjektPfadArray:[tempProjektDicArray valueForKey:@"projektpfad"]];
   
   return tempKommentarStringDicArray;
}


- (void)KommentarNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach Änderungen in den Pops des Kommentarfensters
   //NSString* alle=@"alle";
   NSLog(@"\n\n********				Beginn KommentarNotificationAktion\n\n ");
   NSDictionary* OptionDic=[note userInfo];
   NSLog(@"KommentarNotificationAktion: UserInfo OptionDic: %@",[OptionDic description]);
   NSString* tempProjektName;
   if ([OptionDic objectForKey:@"projektname"])
   {
      tempProjektName=[OptionDic objectForKey:@"projektname"];
   }
   //NSLog(@"tempProjektName: %@ AdminLeseboxPfad: %@ AdminArchivPfad: %@",tempProjektName,AdminLeseboxPfad,AdminArchivPfad);
   //Pop Auswahl
   //Einstellung, welche Auswahl aus den Kommentaren getroffen werden soll.
   //Grundeinstellung ist: lastKommentarOption. Die neuesten Kommentare werden angezeigt
   
   
   NSNumber* AuswahlNummer=[OptionDic objectForKey:@"Auswahl"];
   if (AuswahlNummer)
   {
      self.AuswahlOption=(int)[AuswahlNummer intValue];
      NSLog(@"KommentarNotificationAktion AuswahlOption: %d",[AuswahlNummer intValue]);
      switch (self.AuswahlOption)
      {
         case lastKommentarOption:
         {
            [self.KommentarFenster resetPopAMenu];
            [self.KommentarFenster resetPopBMenu];
            
            
            
         }break;//lastKommentarOption
            
         case alleVonNameKommentarOption:
         {
            //NSLog(@"alleVonNameKommentarOption: ProjektAuswahlOption: %d",ProjektAuswahlOption);
            switch (self.ProjektAuswahlOption)
            {
               case 0://Nur ein Projekt
               {
                  //NSLog(@"alleVonNameKommentarOption: Nur 1 Projekt AdminProjektPfad: %@ tempProjektName: %@",AdminProjektPfad,tempProjektName);
                  
                  NSString* tempAdminProjektPfad=[[self.AdminProjektPfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:tempProjektName];
                  //NSLog(@"tempAdminProjektPfad: %@",tempAdminProjektPfad);
                  NSArray* tempNamenArray=[self LeserArrayAnProjektPfad:tempAdminProjektPfad];
                  //NSLog(@"alleVonNameKommentarOption: Nur 1 Projekt tempNamenArray: %@",[tempNamenArray description]);
                  //NSArray* tempNamenArray=[self LeserArrayAnProjektPfad:ProjektPfadOptionString];
                  [self.KommentarFenster setPopAMenu:tempNamenArray erstesItem:alle aktuell:NULL];
                  [self.KommentarFenster resetPopBMenu];
                  
               }break;
                  
               case 1://Nur aktive Projekte
               {
                  //NSLog(@"    ++++++++++++++       alleVonNameKommentarOption	Nur aktive Projekte\n");
                  //[KommentarFenster setPopAMenu:NULL erstesItem:alle aktuell:alle];
                  NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
                  
                  NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
                  id einProjektDic;
                  while (einProjektDic=[ProjektArrayEnum nextObject])
                  {
                     //NSLog(@"		Nur aktive Projekte: %@",[einProjektDic description]);
                     if ([einProjektDic objectForKey:@"OK"])
                     {
                        if ([[einProjektDic objectForKey:@"OK"]boolValue]&&[einProjektDic objectForKey:@"projektpfad"])
                        {
                           NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                           NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                           NSArray* tempProjektNamenArray=[self LeserArrayAnProjektPfad:tempProjektPfad];
                           //NSLog(@"tempProjektNamenArray: %@",[tempProjektNamenArray description]);
                           //
                           //		Namen addieren
                           //
                        }
                     }
                  }//while enum
                  //NSLog(@"tempNamenArray: %@",[tempNamenArray description]);
                  
                  [self.KommentarFenster setPopAMenu:tempNamenArray erstesItem:alle aktuell:alle];
                  [self.KommentarFenster setPopBMenu:NULL erstesItem:alle aktuell:alle mitPrompt:@"mit Titel:"];
               }break;
                  
               case 2://Alle Projekte
               {
                  
               }break;
                  
            }
            
            
         }break;//alleVonNameKommentarOption
            
         case alleVonTitelKommentarOption:
         {
            NSArray* tempTitelArray= [self TitelArrayVonAllenAnProjektPfad:self.ProjektPfadOptionString
                                                         bisAnzahlProLeser:self.AnzahlOption ];
            //NSLog(@"alleVonTitelKommentarOption tempTitelArray: %@",[tempTitelArray description]);
            [self.KommentarFenster setPopAMenu:tempTitelArray erstesItem:alle aktuell:NULL];
            [self.KommentarFenster resetPopBMenu];
            
         }break;//alleVonTitelKommentarOption
      }//switch AuswahlOption
      
      //NSLog(@"Notifik: AuswahlOption: %d  OptionAString: %@  OptionBString: %@",AuswahlOption,[self OptionA],[self OptionB]);
      //OptionAString=[[KommentarFenster PopAOption]retain];
      //OptionBString=[[KommentarFenster PopBOption]retain];
      NSLog(@"AuswahlOption: %d  OptionAString: %@  OptionBString: %@",self.AuswahlOption,[self OptionA],[self OptionB]);
      
      
   }//if (AuswahlNummer)
   
   NSNumber* AbsatzNummer=[OptionDic objectForKey:@"Absatz"];
   if(AbsatzNummer)
   {
      self.AbsatzOption=(int)[AbsatzNummer intValue];
      //NSLog(@"KommentarNotificationAktion AbsatzOption: %d",[AbsatzNummer intValue]);
   }
   
   //NSNumber* ZusatzNummer=[OptionDic objectForKey:@"Zusatz"];
   //ZusatzOption=(int)[ZusatzNummer intValue];
   //NSLog(@"KommentarNotificationAktion ZusatzOption: %d",[ZusatzNummer intValue]);
   
   NSNumber* AnzahlNummer=[OptionDic objectForKey:@"Anzahl"];
   if (AnzahlNummer)
   {
      self.AnzahlOption=(int)[AnzahlNummer intValue];
      NSLog(@"KommentarNotificationAktion AnzahlOption: %d",[AnzahlNummer intValue]);
   }
   
   NSNumber* nurMarkierteNummer=[OptionDic objectForKey:@"nurMarkierte"];
   if (nurMarkierteNummer)
   {
      self.nurMarkierteOption=(int)[nurMarkierteNummer intValue];
      //NSLog(@"KommentarNotificationAktion nurMarkierteOption: %d",[nurMarkierteNummer intValue]);
   }
   
   NSNumber* tempProjektNamenOptionNumber=[OptionDic objectForKey:@"projektnamenoption"];
   if (tempProjektNamenOptionNumber )
   {
      self.ProjektNamenOption=[tempProjektNamenOptionNumber intValue];
      self.ProjektPfadOptionString=[[self.AdminProjektArray objectAtIndex:self.ProjektNamenOption]objectForKey:@"projektpfad"];
      //NSLog(@"KommentarNotificationAktion   tempProjektNamenOptionNumber: %@ ProjektNamenOption: %d",[tempProjektNamenOptionNumber description],ProjektNamenOption);
      //NSLog(@"KommentarNotificationAktion  AuswahlOption: %d",AuswahlOption);
      switch (self.AuswahlOption)
      {
         case lastKommentarOption:
         {
            //NSLog(@"ProjektnamenOption lastKommentarOption: %d",lastKommentarOption);
            
         }break;//lastKommentarOption
            
         case alleVonNameKommentarOption:
         {
            
            NSArray* LeserArray=[self LeserArrayAnProjektPfad:self.ProjektPfadOptionString];
            //NSLog(@"alleVonTitelKommentarOption LeserArray: %@",[LeserArray description]);
            
            [self.KommentarFenster setPopAMenu:LeserArray erstesItem:alle aktuell:alle];
            [self.KommentarFenster resetPopBMenu];
         }break;//alleVonNameKommentarOption
            
         case alleVonTitelKommentarOption:
         {
            NSArray* tempTitelArray= [self TitelArrayVonAllenAnProjektPfad:self.ProjektPfadOptionString
                                                         bisAnzahlProLeser:self.AnzahlOption ];
            //NSLog(@"alleVonTitelKommentarOption tempTitelArray: %@",[tempTitelArray description]);
            [self.KommentarFenster setPopAMenu:tempTitelArray erstesItem:alle aktuell:NULL];
            
            
            NSArray* LeserArray=[self LeserArrayVonTitel:[self OptionA] anProjektPfad:self.ProjektPfadOptionString];
            //NSLog(@"Komm.Not.Aktion LeserArray: %@	OptionAString: %@  OptionBString. %@",	[LeserArray description],[self OptionA],[self OptionB]);
            if ([LeserArray count]==1)//Nur ein Leser für diesen Titel
            {
               [self.KommentarFenster setPopBMenu:LeserArray erstesItem:NULL aktuell:NULL mitPrompt:@"für Leser:"];
            }
            else
            {
               [self.KommentarFenster setPopBMenu:LeserArray erstesItem:alle aktuell:NULL mitPrompt:@"für Leser:"];
            }
            
            
            
         }break;//alleVonTitelKommentarOption
            
      }
      
   }
   
   
   NSString* tempAString=[OptionDic objectForKey:@"PopA"];
   if (tempAString )//&& [tempAString length])
   {
      //NSLog(@"KommentarNotificationAktion   tempAString: %@   Länge: %d" ,tempAString, [tempAString length]);
      self.OptionAString=[tempAString copy];
      switch (self.AuswahlOption)
      {
         case lastKommentarOption:
         {
            
         }break;//lastKommentarOption
            
         case alleVonNameKommentarOption:
         {
            if ([[self OptionA] isEqualToString:alle])
            {
               [self.KommentarFenster resetPopBMenu];
               
            }
            else
            {
               //NSLog(@"\n******\nKommentarNotifikation alleVonNameKommentarOption: OptionAString: %@",[self OptionA]);
               
               
               NSMutableArray* TitelArray=[[self TitelMitKommentarArrayVon:[self OptionA] anProjektPfad:self.ProjektPfadOptionString]mutableCopy];
               
               
               
               //NSLog(@"KommentarNotifilkation alleVonNameKommentarOption: \nProjektPfadOptionString: %@   \nTitelArray: %@",ProjektPfadOptionString,[TitelArray description]);
               //NSLog(@"TitelArray: %@	OptionAString: %@  OptionBString. %@",	[TitelArray description],[self OptionA],[self OptionB]);
               if(self.ProjektAuswahlOption==0)//nur bei einzelnem Projekt
               {
                  [self.KommentarFenster setPopBMenu:TitelArray erstesItem:alle aktuell:alle mitPrompt:@"mit Titel:"];
               }
            }
         }break;//alleVonNameKommentarOption
            
         case alleVonTitelKommentarOption:
         {
            //NSLog(@"alleVonTitelKommentarOption: OptionA: %@ ",[self OptionA]);
            {
               if ([[self OptionA] isEqualToString:alle])
               {
                  [self.KommentarFenster resetPopBMenu];
               }
               else
               {
                  NSMutableArray* LeserArray=[[self LeserArrayVonTitel:[self OptionA] anProjektPfad:self.ProjektPfadOptionString]mutableCopy];
                  //NSLog(@"alleVonTitelKommentarOption vor .DS: LeserArray: %@	[self OptionA]: %@  OptionBString. %@",	[LeserArray description],[self OptionA],[self OptionB]);
                  if ([LeserArray count]>0)//ES HAT LESER MIT KOMMENTAR FÜR DIESENJ TITEL
                  {
                     
                     if ([[LeserArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
                     {
                        //NSLog(@"LeserArray .DS");
                        [LeserArray removeObjectAtIndex:0];
                     }
                     
                     //NSLog(@"alleVonTitelKommentarOption: LeserArray: %@	[self OptionA]: %@  OptionBString. %@",	[LeserArray description],[self OptionA],[self OptionB]);
                     if ([LeserArray count]==1)//Nur ein Leser für diesen Titel
                     {
                        [self.KommentarFenster setPopBMenu:LeserArray erstesItem:NULL aktuell:NULL mitPrompt:@"für Leser:"];
                     }
                     else
                     {
                        [self.KommentarFenster setPopBMenu:LeserArray erstesItem:alle aktuell:NULL mitPrompt:@"für Leser:"];
                     }
                  }//Count>0
               }
               
            }
         }break;//alleVonTitelKommentarOption
            
      }//switch AuswahlOption
      
   }
   
   NSString* tempBString=[OptionDic objectForKey:@"PopB"];
   if (tempBString )//&& [tempBString length])
   {
      //NSLog(@"\nKommentarNotificationAktion   tempBString: %@\n",tempBString);
      self.OptionBString=[tempBString copy];
      
      
   }
   
   //	OptionAString=[[KommentarFenster PopAOption]retain];
   //	OptionBString=[[KommentarFenster PopBOption]retain];
   
   
   NSNumber* tempProjektAuswahlOptionNumber=[OptionDic objectForKey:@"projektauswahloption"];
   if (tempProjektAuswahlOptionNumber )
   {
      self.ProjektAuswahlOption=[tempProjektAuswahlOptionNumber intValue];
      //NSLog(@"KommentarNotificationAktion   tempProjektAuswahlOptionNumber: %@ ProjektOption: %d",[tempProjektAuswahlOptionNumber description],ProjektAuswahlOption);
      switch (self.ProjektAuswahlOption)
      {
         case 0://Nur ein Projekt
         {
            NSLog(@"tempProjektAuswahlOptionNumber: Nur 1 Projekt");
         }break;
            
         case 1://Nur aktive Projekte
         {
            //NSLog(@"tempProjektAuswahlOptionNumber Nur aktive Projeke");
            [self.KommentarFenster setAuswahlPop:alleVonNameKommentarOption];
            self.AuswahlOption=alleVonNameKommentarOption;
            
            //[KommentarFenster setPopAMenu:NULL erstesItem:alle aktuell:alle];
            NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
            
            NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
            id einProjektDic;
            while (einProjektDic=[ProjektArrayEnum nextObject])
            {
               //NSLog(@"		Nur aktive Projekte: %@",[einProjektDic description]);
               if ([einProjektDic objectForKey:@"OK"])
               {
                  if ([[einProjektDic objectForKey:@"OK"]boolValue]&&[einProjektDic objectForKey:@"projektpfad"])
                  {
                     NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                     NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                     //NSLog(@"tempProjektPfad: %@",tempProjektPfad);
                     
                     NSArray* tempProjektNamenArray=[self LeserArrayAnProjektPfad:tempProjektPfad];
                     
                     //NSLog(@"tempProjektNamenArray: %@",[tempProjektNamenArray description]);
                     NSEnumerator* ProjektNamenEnum=[tempProjektNamenArray objectEnumerator];
                     id einProjektName;
                     while(einProjektName=[ProjektNamenEnum nextObject])
                     {
                        if(![tempNamenArray containsObject:einProjektName])
                        {
                           [tempNamenArray addObject:einProjektName];
                        }
                     }//while
                  }
               }
            }//while enum
            //NSLog(@"tempNamenArray: %@",[tempNamenArray description]);
            
            [self.KommentarFenster setPopAMenu:tempNamenArray erstesItem:alle aktuell:alle];
            [self.KommentarFenster setPopBMenu:NULL erstesItem:alle aktuell:alle mitPrompt:@"mit Titel:"];
         }break;
            
         case 2://Alle Projekte
         {
            //NSLog(@"tempProjektAuswahlOptionNumberNur alle Projekte");
            [self.KommentarFenster setAuswahlPop:alleVonNameKommentarOption];
            self.AuswahlOption=alleVonNameKommentarOption;
            
            //[KommentarFenster setPopAMenu:NULL erstesItem:alle aktuell:alle];
            NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
            
            NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
            id einProjektDic;
            while (einProjektDic=[ProjektArrayEnum nextObject])
            {
               //NSLog(@"		Alle Projekte: %@",[einProjektDic description]);
               if ([einProjektDic objectForKey:@"OK"])
               {
                  if ([einProjektDic objectForKey:@"projektpfad"])
                  {
                     NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                     NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                     NSArray* tempProjektNamenArray=[self LeserArrayAnProjektPfad:tempProjektPfad];
                     //NSLog(@"tempProjektNamenArray: %@",[tempProjektNamenArray description]);
                     NSEnumerator* ProjektNamenEnum=[tempProjektNamenArray objectEnumerator];
                     id einProjektName;
                     while(einProjektName=[ProjektNamenEnum nextObject])
                     {
                        if(![tempNamenArray containsObject:einProjektName])
                        {
                           [tempNamenArray addObject:einProjektName];
                        }
                     }//while
                  }
               }
            }//while enum
            //NSLog(@"tempNamenArray: %@",[tempNamenArray description]);
            
            [self.KommentarFenster setPopAMenu:tempNamenArray erstesItem:alle aktuell:alle];
            [self.KommentarFenster setPopBMenu:NULL erstesItem:alle aktuell:alle mitPrompt:@"mit Titel:"];
            
         }break;
            
      }
   }
   
   //****
   //NSLog(@"KommentarArray entsprechend den Settings aufbauen");
   
   //KommentarArray entsprechend den Settings aufbauen
   
   NSMutableArray* tempProjektDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   switch (self.ProjektAuswahlOption)
   {
      case 0://Nur ein Projekt
      {
         
         NSString* tempProjektPfad=[[self.AdminProjektArray objectAtIndex:self.ProjektNamenOption]objectForKey:@"projektpfad"];
         //NSLog(@"tempProjektPfad: %@",tempProjektPfad);
         NSMutableDictionary* tempProjektDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
         [tempProjektDictionary setObject:self.ProjektPfadOptionString forKey:@"projektpfad"];
         [tempProjektDictionary setObject:[self.ProjektPfadOptionString lastPathComponent] forKey:@"projekt"];
         [tempProjektDicArray addObject:tempProjektDictionary];
         
      }break;
         
      case 1://Nur aktive Projekte
      {
         NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
         id einProjektDic;
         while (einProjektDic=[ProjektArrayEnum nextObject])
         {
            //NSLog(@"		Nur aktive Projekte: %@",[einProjektDic description]);
            if ([einProjektDic objectForKey:@"OK"])
            {
               if ([[einProjektDic objectForKey:@"OK"]boolValue]&&[einProjektDic objectForKey:@"projektpfad"])
               {
                  NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                  NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                  //NSLog(@"Nur aktive Projekte: tempProjektPfad: %@",tempProjektPfad);
                  NSMutableDictionary* tempProjektDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [tempProjektDictionary setObject:tempProjektPfad forKey:@"projektpfad"];
                  [tempProjektDictionary setObject:[tempProjektPfad lastPathComponent] forKey:@"projekt"];
                  [tempProjektDicArray addObject:tempProjektDictionary];
                  
               }
            }
         }//while enum
         
      }break;
         
      case 2://Alle Projekte
      {
         NSEnumerator* ProjektArrayEnum=[self.AdminProjektArray objectEnumerator];
         id einProjektDic;
         while (einProjektDic=[ProjektArrayEnum nextObject])
         {
            //NSLog(@"		Nur aktive Projekte: %@",[einProjektDic description]);
            if ([einProjektDic objectForKey:@"OK"])
            {
               if ([einProjektDic objectForKey:@"projektpfad"])
               {
                  NSString* tempProjektName=[[einProjektDic objectForKey:@"projektpfad"]lastPathComponent];
                  NSString* tempProjektPfad=[einProjektDic objectForKey:@"projektpfad"];
                  //NSLog(@"Nur aktive Projekte: tempProjektPfad: %@",tempProjektPfad);
                  NSMutableDictionary* tempProjektDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
                  [tempProjektDictionary setObject:tempProjektPfad forKey:@"projektpfad"];
                  [tempProjektDictionary setObject:[tempProjektPfad lastPathComponent] forKey:@"projekt"];
                  [tempProjektDicArray addObject:tempProjektDictionary];
                  
               }
            }
         }//while enum
         
      }break;
         
   }//switch ProjektAuswahlOption
   
   
   //Angepassten Kommentarstring an Kommentarfenster schicken
   
   //NSLog(@"KommentarNotificationAktion vor setKommentar");
   //NSLog(@"\n+++++++++++\n˙KommentarNotificationAktion tempProjektDicArray: %@%@%@",@"\r",[tempProjektDicArray description],@"\r");
   //NSLog(@"\nKommentarNotificationAktion ProjektPfadArray für create: %@%@%@",@"\r",[tempProjektDicArray valueForKey:@"projektpfad"],@"\r");
   
   NSArray* KommentarStringArray=[self createKommentarStringArrayWithProjektPfadArray:[tempProjektDicArray valueForKey:@"projektpfad"]];
   
   //NSLog(@"KommentarNotificationAktion nach Create:  KommentarStringArray: %@%@%@",@"\r",[KommentarStringArray description],@"\r");
   //NSLog(@"\n**********\nvor KommentarFenster setKommentarMitKommentarDicArray");
   [self.KommentarFenster setKommentarMitKommentarDicArray:KommentarStringArray];
   //NSLog(@"\nnach KommentarFenster setKommentarMitKommentarDicArray\n**********\n");
   
}

- (NSArray*)KommentareVonLeser:(NSString*)derLeser
                      mitTitel:(NSString*)derTitel
                       maximal:(int)dieAnzahl
                 anProjektPfad:(NSString*)derProjektPfad
{
   BOOL erfolg;
   BOOL istDirectory;
   NSString* crSeparator=@"\r";
   NSString* locKommentar=@"Anmerkungen";
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"KommentareVonLeser : LeserPfad: %@ mitTitel: %@",derLeser,derTitel);
   NSMutableArray* KommentareVonLeserMitTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSMutableArray* tempAufnahmen=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmen=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        //NSLog(@":   tempAufnahmen roh: %@",[tempAufnahmen description]);
        if ([tempAufnahmen count])//Aufnahmen vorhanden
        {
           NSUInteger KommentarIndex=NSNotFound;
           KommentarIndex=[tempAufnahmen indexOfObject:locKommentar];
           if (!(KommentarIndex==NSNotFound))
           {
              [tempAufnahmen removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Array entfernen
           }
           //NSLog(@":   tempAufnahmen ohne Kommentar: %@",[tempAufnahmen description]);
           
           if ([tempAufnahmen count])
           {
              if ([[tempAufnahmen objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
              {
                 [tempAufnahmen removeObjectAtIndex:0];
              }
              
              tempAufnahmen=(NSMutableArray*)[self sortNachNummer:tempAufnahmen];
              //NSLog(@":  KommentareVonLeser mitTitel:   tempAufnahmen ohne .DS: %@",[tempAufnahmen description]);
              NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
              int passendeAufnahmen=0;
              NSEnumerator* enumerator=[tempAufnahmen objectEnumerator];
              id eineAufnahme;
              int pos=0;
              while ((eineAufnahme=[enumerator nextObject])&&(passendeAufnahmen<dieAnzahl))
              {
                 //NSLog(@": eineAufnahme: %@    passendeAufnahmen: %d",eineAufnahme,passendeAufnahmen);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 BOOL OK=[self mitMarkierungAufnehmenOptionAnPfad:tempAufnahmePfad];
                 
                 if (OK&&[[self AufnahmeTitelVon:eineAufnahme] isEqualToString:derTitel])
                 {
                    
                    {
                       NSString* tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:eineAufnahme];
                       if ([Filemanager fileExistsAtPath:tempKommentarPfad])//Kommentar für Aufnahme ist da)
                       {
                          NSString* tempKommentarMitTitelString=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                          if (pos)//Ab zweitem Kommentar Name entfernen
                          {
                             //NSLog(@"Namen entfernt: %d",pos);
                             NSMutableArray* tempZeilenArray=[[NSMutableArray alloc]initWithCapacity:0];
                             tempZeilenArray=[[tempKommentarMitTitelString componentsSeparatedByString:crSeparator]mutableCopy];
                             NSString* tempName=[tempZeilenArray objectAtIndex:0];
                             int n=[tempName length];
                             NSRange r=NSMakeRange(0,n-1);
                             tempName=[[tempZeilenArray objectAtIndex:0]substringFromIndex:n];
                             tempName=[NSString stringWithFormat:@"%@  %@",@"  -  ",tempName];
                             //[tempZeilenArray replaceObjectAtIndex:0 withObject:@"\n    -"];
                             [tempZeilenArray replaceObjectAtIndex:0 withObject:tempName];
                             
                             //
                             [tempZeilenArray removeObjectAtIndex:3];
                             
                             //
                             
                             NSString* redZeile=[tempZeilenArray componentsJoinedByString:@" "];
                             tempKommentarMitTitelString=[tempZeilenArray componentsJoinedByString:crSeparator];
                             
                          }
                          pos++;
                          [KommentareVonLeserMitTitelArray addObject:tempKommentarMitTitelString];
                          
                          passendeAufnahmen++;
                       }
                    }//ist Markiert
                 }//Titel stimmt
                 
              }//while enumerator
              //NSLog(@"Leserordner letztes Objekt: %@",letzteAufnahme);
           }
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   return KommentareVonLeserMitTitelArray;
   
}

- (NSString*)KommentarZuAufnahme:(NSString*)dieAufnahme
                        vonLeser:(NSString*)derLeser
                   anProjektPfad:(NSString*)derProjektPfad

{
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"KommentarZuAufnahme: dieAufnahme: %@  derLeser: %@ ",dieAufnahme,derLeser);
   //NSMutableArray* KommentareMitTitelVonLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   NSString* tempKommentar=[NSString string];
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSMutableArray* tempAufnahmen=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        //NSLog(@":   tempAufnahmen roh: %@",[tempAufnahmen description]);
        if ([tempAufnahmen count])//Aufnahmen vorhanden
        {
           NSUInteger KommentarIndex=NSNotFound;
           KommentarIndex=[tempAufnahmen indexOfObject:locKommentar];
           if (!(KommentarIndex==NSNotFound))
           {
              NSString* LeserKommentarOrdnerPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
              NSString* KommentarPfad=[LeserKommentarOrdnerPfad stringByAppendingPathComponent:dieAufnahme];//Kommentar der Aufnahme
              //NSLog(@"   KommentarPfad: %@",KommentarPfad );
              if ([Filemanager fileExistsAtPath:KommentarPfad])//Kommentar ist da
              {
                 tempKommentar=[NSString stringWithContentsOfFile: KommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                 
              }
           }
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        else
        {
           NSLog(@"KommentareMitTitel:count=0");
        }
        
        
     }//if exists LeserPfad
   //NSLog(@"KommentareMitTitel:ende");
   return tempKommentar;
}

- (NSArray*)KommentareMitTitel:(NSString*)derTitel
                      vonLeser:(NSString*)derLeser
                 anProjektPfad:(NSString*)derProjektPfad
                       maximal:(int)dieAnzahl
{
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"KommentareMitTitel: mitTitel: %@  LeserPfad: %@ ",derTitel,derLeser);
   NSMutableArray* KommentareMitTitelVonLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSMutableArray* tempAufnahmen=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        //NSLog(@":   tempAufnahmen roh: %@",[tempAufnahmen description]);
        if ([tempAufnahmen count])//Aufnahmen vorhanden
        {
           NSUInteger KommentarIndex=NSNotFound;
           KommentarIndex=[tempAufnahmen indexOfObject:locKommentar];
           if (!(KommentarIndex == NSNotFound))
           {
              [tempAufnahmen removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Array entfernen
           }
           //NSLog(@":   tempAufnahmen ohne Kommentar: %@",[tempAufnahmen description]);
           
           if ([tempAufnahmen count])
           {
              if ([[tempAufnahmen objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
              {
                 [tempAufnahmen removeObjectAtIndex:0];
              }
              //NSLog(@":   tempAufnahmen ohne .DS: %@",[tempAufnahmen description]);
              
              if (![tempAufnahmen count])
                 return KommentareMitTitelVonLeserArray;
              
              tempAufnahmen=(NSMutableArray*)[self sortNachNummer:tempAufnahmen];
              NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
              int passendeAufnahmen=0;
              NSEnumerator* enumerator=[tempAufnahmen objectEnumerator];
              id eineAufnahme;
              while ((eineAufnahme=[enumerator nextObject])&&(passendeAufnahmen<dieAnzahl))
              {
                 //NSLog(@": eineAufnahme: %@    passendeAufnahmen: %d",eineAufnahme,passendeAufnahmen);
                 if ([[self AufnahmeTitelVon:eineAufnahme] isEqualToString:derTitel])
                 {
                    NSString* tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:eineAufnahme];
                    if ([Filemanager fileExistsAtPath:tempKommentarPfad])//Kommentar für letzte Aufnahme ist da)
                    {
                       // lastKommentarMitTitelString=[NSString stringWithContentsOfFile:lastKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                       
                       
                       
                       
                       [KommentareMitTitelVonLeserArray addObject:[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL]];
                       passendeAufnahmen++;
                    }
                    
                 }
              }//while enumerator
              //NSLog(@"Leserordner letztes Objekt: %@",letzteAufnahme);
           }
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        else
        {
           NSLog(@"KommentareMitTitel:count=0");
        }
        
     }//if exists LeserPfad
   //NSLog(@"KommentareMitTitel:ende");
   
   return KommentareMitTitelVonLeserArray;
}




- (NSArray*)alleKommentareZuTitel:(NSString*)derTitel
                    anProjektPfad:(NSString*)derProjektPfad
                          maximal:(int)dieAnzahl
{
   NSLog(@"alleKommentareZuTitel: Titel: %@",derTitel);
   BOOL erfolg;
   BOOL istDirectory;
   NSString* locKommentar=@"Anmerkungen";
   NSMutableArray* alleKommentareArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSMutableArray* tempKommentarArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSMutableArray* LeserArray;
   LeserArray=[[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL]mutableCopy];
   if ([[LeserArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
	  {
        [LeserArray removeObjectAtIndex:0];
     }
   if (![LeserArray count])
	  {
        NSLog(@"alleKommentareZuTitel: Archiv ist leer");
        NSString* ArchivLeerString=@"Für dieses Projekt hat es keine Anmerkungen";
        [alleKommentareArray addObject:ArchivLeerString];
     }
   
   NSLog(@"alleKommentareZuTitel: LeserArray: %@",[LeserArray description]);
   
   NSEnumerator* LeserEnumerator =[LeserArray objectEnumerator];
   NSString* tempLeser;
   while (tempLeser = [LeserEnumerator nextObject])
   {
      NSString* tempLeserKommentarPfad=[tempProjektPfad stringByAppendingPathComponent:tempLeser];
      tempLeserKommentarPfad=[tempLeserKommentarPfad stringByAppendingPathComponent:locKommentar];
      if ([Filemanager fileExistsAtPath:tempLeserKommentarPfad isDirectory:&istDirectory]&&istDirectory)
      {
         //Kommentarordner des Lesers ist da
         NSLog(@"alleKommentareZuTitel: %@: Kommentarordner von %@ ist da",derTitel, tempLeser);
         NSMutableArray* tempKommentarArray=[[NSMutableArray alloc]initWithCapacity:0];
         tempKommentarArray=[[Filemanager contentsOfDirectoryAtPath:tempLeserKommentarPfad error:NULL]mutableCopy];
         if (![tempKommentarArray count])
         {
            NSLog(@"alleKommentareZuTitel: Kommentarordner von %@ ist leer",tempLeser);
            NSString* ArchivLeerString=@"Für dieses Projekt hat es keine Anmerkungen";
            [alleKommentareArray addObject:ArchivLeerString];
            
            //return alleKommentareArray;
         }
         else
         {
            if ([[tempKommentarArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
            {
               [tempKommentarArray removeObjectAtIndex:0];
            }
            //NSLog(@"alleKommentareZuTitel: tempKommentarArray: %@",[tempKommentarArray description]);
            if (![tempKommentarArray count])
            {
               NSLog(@"alleKommentareZuTitel: Kommentarordner nach .DS von %@ ist leer",tempLeser);
               NSString* ArchivLeerString=@"Für dieses Projekt hat es keine Anmerkungen";
               [alleKommentareArray addObject:ArchivLeerString];
               
               //return alleKommentareArray;
            }
            else
            {
               tempKommentarArray=(NSMutableArray*)[self sortNachNummer:tempKommentarArray];
               NSLog(@"alleKommentareZuTitel: tempKommentarArray nach sort: %@",[tempKommentarArray description]);
               
               //[tempKommentarArray retain];
               int anzVonTitel=0;
               NSEnumerator* KommentarEnumerator =[tempKommentarArray objectEnumerator];
               NSString* tempKommentar;
               while (tempKommentar = [KommentarEnumerator nextObject])
               {
                  NSLog(@"tempKommentar: %@",tempKommentar);
                  if ([[self AufnahmeTitelVon:tempKommentar]isEqualToString:derTitel])
                  {
                     
                     if (anzVonTitel<dieAnzahl)
                     {
                        NSString* tempKommentarPfad=[tempLeserKommentarPfad stringByAppendingPathComponent:tempKommentar];
                        NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                        
                        [alleKommentareArray addObject:tempKommentarString];
                     }
                     anzVonTitel++;
                  }
               }//while tempKommentar
            }// Ordner nach .DS leer
         } // Ordner von Anfang an leer
      }//if  fileExistsAtPath:tempLeserKommentarPfad
   }//while tempLeser
	  NSLog(@"alleKommentareZuTitel Ergebnis: alleKommentareArray: %@",[alleKommentareArray description]);
   return alleKommentareArray;
}



- (NSArray*)alleKommentareNachTitelAnProjektPfad:(NSString*)derProjektPfad bisAnzahl:(int)dieAnzahl
{
   //BOOL istDirectory;
   NSMutableArray* alleKommentareNachTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   //NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSMutableArray* tempKommentarArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSArray* tempTitelArray=[self TitelArrayVonAllenAnProjektPfad:tempProjektPfad
                                               bisAnzahlProLeser:self.AnzahlOption];
   
   NSEnumerator* TitelEnumerator =[tempTitelArray objectEnumerator];
   NSString* einTitel;
   while (einTitel = [TitelEnumerator nextObject])
	  {
        NSArray* tempKommentareZuTitelArray=[self alleKommentareZuTitel:einTitel
                                                          anProjektPfad:tempProjektPfad
                                                                maximal:self.AnzahlOption];
        
        [alleKommentareNachTitelArray addObjectsFromArray:tempKommentareZuTitelArray];
        
     }//while einTitel
   return alleKommentareNachTitelArray;
}




- (NSString*)lastKommentarVonLeser:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad
{
   BOOL erfolg;
   BOOL istDirectory;
   NSString* locKommentar=@"Anmerkungen";
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSLog(@"lastKommentarVon: LeserPfad: %@ anPfad: %@",derLeser,derProjektPfad);
   NSString* letzteAufnahme=@"xxx";
   NSString* lastKommentarString=[NSString string];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSLog(@"Leser %@ da",derLeser);
        NSMutableArray* tempAufnahmen=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmen=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        
        if (tempAufnahmen && [tempAufnahmen count])//Aufnahmen vorhanden
        {
           NSLog(@"tempAufnahmen: %@",[tempAufnahmen description]);
           NSUInteger KommentarIndex = NSNotFound;
           KommentarIndex=[tempAufnahmen indexOfObject:locKommentar];
           if (!(KommentarIndex == NSNotFound))
           {
              //[tempAufnahmen removeObjectAtIndex:KommentarIndex];
           }
           if ([[tempAufnahmen objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
           {
              [tempAufnahmen removeObjectAtIndex:0];
           }
           
           //NSLog(@"tempAufnahmen: %@",[tempAufnahmen description]);
           if ([tempAufnahmen count])
           {
              int letzte=0;
              NSEnumerator* enumerator=[tempAufnahmen objectEnumerator];
              id eineAufnahme;
              NSString* tempLeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
              while (eineAufnahme=[enumerator nextObject])
              {
                 NSString* tempKommentarPfad=[tempLeserKommentarPfad stringByAppendingPathComponent:eineAufnahme];
                 if ([Filemanager fileExistsAtPath:tempKommentarPfad])//Kommentar für diese Aufnahme ist da)
                 {
                    int n=[self AufnahmeNummerVon:eineAufnahme];
                    if (n>letzte)
                    {
                       letzte=n;
                       letzteAufnahme=eineAufnahme;
                    }
                 }
              }//while enumerator
              tempLeserKommentarPfad=[tempLeserKommentarPfad stringByAppendingPathComponent:letzteAufnahme];
              lastKommentarString=[NSString stringWithContentsOfFile:tempLeserKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
              
              NSDictionary* Attrs=[Filemanager attributesOfItemAtPath:tempLeserKommentarPfad error:NULL];
              NSNumber *fsize, *refs, *owner;
              NSDate *moddate;
              if (Attrs)
              {
                 if ((refs = [Attrs objectForKey:NSFilePosixPermissions]))
                 {
                    ;//NSLog(@"Leser: %@   POSIX: %d\n",letzteAufnahme, [refs intValue]);
                 }
              }
              
           }
           else
           {
              NSLog(@"Keine Aufnahmen von: %@",derLeser);
              //NSLog(@"alleKommentareZuTitel: Kommentarordner von %@ ist leer",tempLeser);
              NSString* keineAufnahmeString=@"Für dieses Leser hat es keine Aufnahmen";
              lastKommentarString=keineAufnahmeString;
           }
        }//[tempAufnahmen count]
        else
        {
           NSLog(@"Leser %@ hat keine ",derLeser);
        }
        //[tempAufnahmen release];
        
     }//if exists LeserPfad
   return lastKommentarString;
   
}



- (NSArray*)alleKommentareVonLeser:(NSString*)derLeser
                     anProjektPfad:(NSString*)derProjektPfad
                         bisAnzahl:(int)dieAnzahl
{
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //NSLog(@"alleKommentarVonLeser: Leser: %@  derProjektPfad: %@  dieAnzahl: %d",derLeser ,derProjektPfad,dieAnzahl);
   NSMutableArray* tempKommentareArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   NSString* crSeparator=@"\r";
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
        //Kommentarordner des Lesers
        //NSLog(@"alleKommentareVonLeser: LeserPfad: %@",LeserKommentarPfad);
        if ([Filemanager fileExistsAtPath:LeserKommentarPfad isDirectory:&istDirectory]&&istDirectory)//Ordner des Lesers ist da)
        {
           //NSLog(@"Kommentarordner von %@ ist da",derLeser);
           NSMutableArray*  tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
           tempTitelArray= [[Filemanager contentsOfDirectoryAtPath:LeserKommentarPfad error:NULL]mutableCopy];
           
           if ([tempTitelArray count])
           {
              if ([[tempTitelArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
              {
                 [tempTitelArray removeObjectAtIndex:0];
              }
              
              //NSLog(@"\nalleKommentareVonLeser: %@  KommentareArray: %@",derLeser,[tempTitelArray description]);
              NSArray* sortArray=[self sortNachNummer:[tempTitelArray copy]];
              tempTitelArray=(NSMutableArray*)[self sortNachNummer:tempTitelArray];
              //NSLog(@"\nalleKommentareVonLeser  nach sortArray: %@\n",[tempTitelArray description]);
              
              NSEnumerator* enumerator =[tempTitelArray objectEnumerator];
              NSString* tempTitel;
              int pos=0;
              while ((tempTitel = [enumerator nextObject])&&pos<dieAnzahl)
              {
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:tempTitel];
                 
                 BOOL OK=[self mitMarkierungAufnehmenOptionAnPfad:tempAufnahmePfad];
                 //if (OK)
                 //NSLog(@"Kommentar zu File %@ kann aufgenommen werden",tempTitel);
                 //else
                 //NSLog(@"Kommentar zu File %@ kann nicht aufgenommen werden",tempTitel);
                 
                 NSString* tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:tempTitel];
                 
                 if (OK&&[Filemanager fileExistsAtPath:tempKommentarPfad])//Kommentar existiert
                 {
                    NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                    if (pos)
                    {//Ab zweitem Kommentar Name entfernen
                       NSMutableArray* tempZeilenArray=[[NSMutableArray alloc]initWithCapacity:0];
                       tempZeilenArray=[[tempKommentarString componentsSeparatedByString:crSeparator]mutableCopy];
                       NSString* tempName=[tempZeilenArray objectAtIndex:0];
                       int n=[tempName length];
                       NSRange r=NSMakeRange(0,n-1);
                       tempName=[[tempZeilenArray objectAtIndex:0]substringFromIndex:n];
                       tempName=[NSString stringWithFormat:@"%@  %@",@"  -  ",tempName];
                       //[tempZeilenArray replaceObjectAtIndex:0 withObject:@"\n    -"];
                       [tempZeilenArray replaceObjectAtIndex:0 withObject:tempName];
                       
                       //
                       [tempZeilenArray removeObjectAtIndex:3];
                       
                       //
                       
                       
                       NSString* redZeile=[tempZeilenArray componentsJoinedByString:@" "];
                       tempKommentarString=[tempZeilenArray componentsJoinedByString:crSeparator];
                    }
                    pos++;
                    [tempKommentareArray addObject:tempKommentarString];
                 }//OK
              }//enumerator
              //NSLog(@"lastKommentarVonAllen:    Kommentar: %@", lastKommentarString);
              
              NSLog(@"nach enum:  Leser: %@  ",derLeser);
              NSLog(@"nach enum:  Kommentarordner : %@", [tempKommentareArray description]);
           }
           else
           {
              NSLog(@"keine Kommentare da");//keine Kommentare
           }
           
        }
        else
        {
           //Kein Kommentarordner für Leser
        }
        //NSLog(@"vor ende if: Leser: %@  Kommentarordner : %@",derLeser, tempKommentareArray);
     }//if exists LeserPfad
   
   //NSLog(@"vor return: Leser: %@  Kommentarordner : %@",derLeser, tempKommentareArray);
   
   return tempKommentareArray;
   
}


- (NSArray*)lastKommentarVonAllenAnProjektPfad:(NSString*)derProjektPfad
{
   BOOL erfolg;
   BOOL istDirectory;
   NSString* lastKommentarString=@"";//Anmerkungen in Tabelle mit 6 Kolonnen konvertieren \r";
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* tempKommentarArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* LeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   if (![Filemanager fileExistsAtPath:tempProjektPfad isDirectory:&istDirectory]&&istDirectory)
	  {
        NSLog(@"lastKommentarVonAllen: kein Archiv");
     }
	  //NSLog(@"lastKommentarVonAllenAnProjektPfad: derProjektPfad: %@",derProjektPfad);
   LeserArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL];
   if (![LeserArray count])
   {
      NSLog(@"lastKommentarVonAllen: Archiv ist leer");
   }
   if ([[LeserArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
   {
      [LeserArray removeObjectAtIndex:0];
   }
   
   NSLog(@"lastKommentarVonAllenAnProjektPfad: LeserArray: %@",[LeserArray description]);
   NSEnumerator* enumerator =[LeserArray objectEnumerator];
   NSString* tempLeser;
   while (tempLeser = [enumerator nextObject])
	  {
        NSString* tempKommentar=[self lastKommentarVonLeser:tempLeser anProjektPfad:tempProjektPfad];
        if ([tempKommentar length])
        {
           //NSLog(@"lastKommentarVonAllen A: tempLeser: %@ ",tempLeser);
           
           [tempKommentarArray addObject:tempKommentar];
           //NSLog(@"lastKommentarVonAllen B: tempLeser: %@ ",tempLeser);
        }
     }//enumerator
   //
   NSLog(@"lastKommentarVonAllen:    Kommentar: %@", [tempKommentarArray description]);
   return tempKommentarArray;
}



- (NSString*)heutigeKommentareVon:(NSString*)derLeser
{
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSLog(@"heutigeKommentareVon: LeserPfad: %@",derLeser);
   NSString* tempDatum=@"xxx";
   NSCalendarDate* heute=[NSCalendarDate date];
   [heute setCalendarFormat:@"%d.%m.%Y"];
   NSLog(@"heutigeKommentareVon  heute: %@   LeserPfad: %@",heute,derLeser);
   
   NSString* heutigerKommentarString=@"*";
   NSString* LeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:derLeser];//Leserordner im Archiv
   if ([Filemanager fileExistsAtPath:LeserPfad])
	  {
        NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:@"Anmerkungen"];//Kommentarordner des Lesers
        //NSLog(@"lastKommentarVon: LeserPfad: %@",LeserKommentarPfad);
        if ([Filemanager fileExistsAtPath:LeserKommentarPfad isDirectory:&istDirectory]&&istDirectory)//Ordner des Lesers ist da)
        {
           NSLog(@"Kommentarordner da");
           
           NSArray* KommentareArray=[Filemanager contentsOfDirectoryAtPath:LeserKommentarPfad error:NULL];
           if ([KommentareArray count])
           {
              NSEnumerator* enumerator=[KommentareArray objectEnumerator];
              NSString* tempKommentar;
              while (tempKommentar=[enumerator nextObject])
              {
                 NSString* tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:tempKommentar];
                 NSString* tempKommentarString=[NSString stringWithContentsOfFile:tempKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                 tempDatum=[self DatumVon:tempKommentarString];
                 NSLog(@"tempDatum: %@",tempDatum);
                 if ([tempDatum isEqualTo:[heute description]])
                 {
                    NSLog(@"Heutiger Kommentar da: %@",tempKommentarString);
                    heutigerKommentarString=tempKommentarString;
                 }
                 //NSLog(@"Kommentarordner letztes Objekt: %@",letzteAufnahme);
              }
           }
           else
           {
              NSLog(@"keine Kommentare da");//keine Kommentare
           }
           
        }
        else
        {
           //Kein Kommentarordner für Leser
        }
        
        
     }//if exists LeserPfad
   
   return heutigerKommentarString;
}




- (NSArray*)alleKommentareNachNamenAnProjektPfad:(NSString*)derProjektPfad bisAnzahl:(int)dieAnzahl
{
   BOOL erfolg;
   BOOL istDirectory;
   NSMutableArray* alleKommentareArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* tempKommentarArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSMutableArray* LeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   if (![Filemanager fileExistsAtPath:tempProjektPfad isDirectory:&istDirectory]&&istDirectory)
   {
      NSLog(@"alleKommentareNachNamen: kein Archiv");
      
   }
   LeserArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL];
   if ([[LeserArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
   {
      [LeserArray removeObjectAtIndex:0];
   }
   if (![LeserArray count])
   {
      NSLog(@"alleKommentareNachNamen: Archiv ist leer");
      
      return alleKommentareArray;
   }
   
   //NSLog(@"alleKommentareNachNamen: LeserArray: %@",[LeserArray description]);
   NSEnumerator* enumerator =[LeserArray objectEnumerator];
   NSString* tempLeser;
   while (tempLeser = [enumerator nextObject])
   {
      NSArray* tempArray=[self alleKommentareVonLeser:tempLeser
                                        anProjektPfad:tempProjektPfad
                                            bisAnzahl:dieAnzahl];
      //NSLog(@"alleKommentareVonLeser: tempArray: %@",[tempArray description]);
      
      if ([tempArray count])
      {
         [alleKommentareArray addObjectsFromArray:tempArray];
         //NSLog(@"alleKommentareNachNamen: tempLeser: %@ ",tempLeser);
      }
   }//enumerator
   //NSLog(@"alleKommentareNachNamen:    Kommentar: %@", alleKommentareArray);
   
   return alleKommentareArray;
}



- (NSArray*)TitelArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad
{
   //NSLog(@"TitelArrayVon: derLeser: %@  derProjektPfad: %@",derLeser, derProjektPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   //NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:kommentar];//Kommentarordner des Lesers
   
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmenArray count])//Aufnahmen vorhanden
        {
           int KommentarIndex=(int)NSNotFound;
           KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
           if (!(KommentarIndex==(int)NSNotFound))
           {
              [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
           }
           if ([tempAufnahmenArray count])
           {
              if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
              {
                 [tempAufnahmenArray removeObjectAtIndex:0];
                 
              }
              //NSLog(@"\n\nTitelArrayVon:  tempAufnahmenArray: %@\n\n",[tempAufnahmenArray description]);
              
              NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
              id eineAufnahme;
              while (eineAufnahme=[enumerator nextObject])
              {
                 //NSLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 //NSLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                 if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                 {
                    NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                    if ([tempTitel length])
                    {
                       if (![tempTitelArray containsObject:tempTitel])
                       {
                          [tempTitelArray insertObject: tempTitel atIndex:[tempTitelArray count]];
                       }
                    }
                    //NSLog(@"TitelArrayVon: %@  tempTitel: %@",derLeser,tempTitel);
                 }
                 else
                 {
                    //NSLog(@"kein Kommentare da");//keine Kommentare
                    
                 }
              }//while enumerator
              //NSLog(@"TitelArrayVon:  tempTitelArray: %@",[tempTitelArray description]);
              
           }// if tempAufnahmen count
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   //NSLog(@"TitelArrayVon: ende");
   return tempTitelArray;
}


- (NSArray*)TitelMitKommentarArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad
{
   /*
    Sucht alle Titel von 'derLeser' am Projektpfad 'derProjektPfad', die einen Kommentar haben
    */
   //NSLog(@"TitelMitKommentarArrayVon: derLeser: %@  derProjektPfad: %@",derLeser, derProjektPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   NSString* KommentarString=@"Anmerkungen";
   NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:KommentarString];//Kommentarordner des Lesers
   BOOL KommentarordnerDa=[Filemanager fileExistsAtPath:LeserKommentarPfad];
   if ([Filemanager fileExistsAtPath:LeserPfad]&&KommentarordnerDa)//Ordner des Lesers und der Kommentarordner ist da
	  {
        NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmenArray count])//Aufnahmen vorhanden
        {
           int KommentarIndex=(int)NSNotFound;
           KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
           if (!(KommentarIndex==(int)NSNotFound))
           {
              [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Zeile mit Kommentarordner aus Liste entfernen
           }
           if ([tempAufnahmenArray count])
           {
              if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
              {
                 [tempAufnahmenArray removeObjectAtIndex:0];
                 
              }
              //NSLog(@"\n\nTitelArrayVon:  tempAufnahmenArray: %@\n\n",[tempAufnahmenArray description]);
              
              NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
              id eineAufnahme;
              while (eineAufnahme=[enumerator nextObject])
              {
                 //NSLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 //NSLog(@"TitelMitKommentarArrayVon: tempAufnahmePfad: %@",tempAufnahmePfad);
                 if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da
                 {
                    NSString* tempAufnahmeKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:eineAufnahme];//Pfad des Kommentars
                    if ([Filemanager fileExistsAtPath:tempAufnahmeKommentarPfad])// ein Kommentar ist da
                    {
                       NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                       if ([tempTitel length])
                       {
                          if (![tempTitelArray containsObject:tempTitel])
                          {
                             [tempTitelArray insertObject: tempTitel atIndex:[tempTitelArray count]];
                          }
                       }
                       //NSLog(@"TitelArrayVon: %@  tempTitel: %@",derLeser,tempTitel);
                    }//Kommentar für Aufnahme da
                 }
                 else
                 {
                    //NSLog(@"kein Kommentare da");//keine Kommentare
                    
                 }
              }//while enumerator
              //NSLog(@"TitelArrayVon:  tempTitelArray: %@",[tempTitelArray description]);
              
           }// if tempAufnahmen count
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   //NSLog(@"TitelArrayVon: ende");
   return tempTitelArray;
}




- (NSArray*)TitelArrayVonAllenAnProjektPfad:(NSString*)derProjektPfad
                          bisAnzahlProLeser:(int)dieAnzahl
{
   /*
    Sucht alle Titel in einem Projekt mit einem Kommentar
    
    */
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSLog(@"TitelArrayVonAllenAnPfad  derProjektPfad: %@\n AdminLeseboxPfad: %@\nAdminArchivPfad: %@", derProjektPfad,self.AdminLeseboxPfad,self.AdminArchivPfad);
   NSLog(@"AdminProjektPfad: %@",self.AdminProjektPfad);
   NSMutableArray* tempTitelArrayVonAllen= [[NSMutableArray alloc]initWithCapacity:0];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   if ([Filemanager fileExistsAtPath:tempProjektPfad isDirectory:&istDirectory]&&istDirectory)
   {
      tempNamenArray=[[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL]mutableCopy];
      [tempNamenArray removeObject:@".DS_Store"];
      NSLog(@"TitelArrayVonAllenAnPfad  tempNamenArray: %@", [tempNamenArray description]);
      
      NSEnumerator* LeserEnumerator=[tempNamenArray objectEnumerator];
      id einLeser;
      while (einLeser=[LeserEnumerator nextObject])
      {
         // Vorhandene Titel suchen
         NSArray* tempTitelArray=[self TitelMitKommentarArrayVon:einLeser anProjektPfad:tempProjektPfad];
         
         //NSLog(@"TitelArrayVonAllenAnProjektPfad  Leser: %@  tempTitelArray: %@%@",einLeser,@"\r", [tempTitelArrayVonAllen description]);
         
         if ([tempTitelArray count])
         {
            id einTitel;
            int anzTitelVonLeser=0;
            NSEnumerator* TitelEnumerator=[tempTitelArray objectEnumerator];
            while (einTitel=[TitelEnumerator nextObject])
            {
               
               if (![tempTitelArrayVonAllen containsObject:einTitel]&&anzTitelVonLeser<dieAnzahl)
               {
                  [tempTitelArrayVonAllen addObject:einTitel];
                  anzTitelVonLeser++;
               }
               
            }//while einTitel
            
         }//tempTitelArray count
      }//while einLeser
      //NSLog(@"TitelArrayVonAllenAnPP   tempTitelArrayVonAllen: %@%@",@"\r",[tempTitelArrayVonAllen description]);
      
   }
   else
   {
      NSLog(@"Kein Ordner fuer Projekt: %@",tempProjektPfad);
   }
   //[tempTitelArrayVonAllen retain];
   return tempTitelArrayVonAllen;
}




- (NSArray*)LeserArrayVonTitel:(NSString*)derTitel
{
   NSLog(@"LeserArrayVonTitel: AdminProjektPfad: %@",self.AdminProjektPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   
   NSEnumerator* enumerator=[self.AdminProjektNamenArray objectEnumerator];
   id einLeser;
   while (einLeser=[enumerator nextObject])
   {
      NSString* LeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:einLeser];
      NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
      
      if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
      {
         NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
         tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
         if ([tempAufnahmenArray count])//Aufnahmen vorhanden
         {
            int KommentarIndex=(int)NSNotFound;
            KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
            if (!(KommentarIndex==(int)NSNotFound))
            {
               [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
            }
            
            if ([tempAufnahmenArray count])
            {
               if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
               {
                  [tempAufnahmenArray removeObjectAtIndex:0];
                  
               }
               //NSLog(@"TitelArrayVon:  tempAufnahmenArray: %@",[tempAufnahmenArray description]);
               
               NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
               id eineAufnahme;
               while (eineAufnahme=[enumerator nextObject])
               {
                  //NSLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                  NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                  //NSLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                  if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                  {
                     //if ([[[self AufnahmeTitelVon:eineAufnahme]lowercaseString] isEqualToString:[derTitel lowercaseString]])
                     if ([[self AufnahmeTitelVon:eineAufnahme] isEqualToString:derTitel])
                     {
                        NSString* 	tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:eineAufnahme];
                        if ([Filemanager fileExistsAtPath:tempKommentarPfad])// Kommentar für eineAufnahme ist da)
                        {
                           if (![tempLeserArray containsObject:einLeser])
                           {
                              [tempLeserArray addObject:einLeser];
                           }
                        }
                     }
                     //NSLog(@"tempLeserArray: %@  tempTitel: %@",derLeser,tempTitel);
                  }
                  else
                  {
                     //NSLog(@"kein Leser mit diesem Titel");//
                     
                  }
               }//while enumerator
               //NSLog(@"tempLeserArray: %@",[tempLeserArray description]);
               
            }// if tempAufnahmen count
            else
            {
               //NSLog(@"Keine Aufnahmen von: %@",derLeser);
            }
         }//[tempAufnahmen count]
         
         
         
      }//if exists LeserPfad
      
      
      
   }//while (einLeser
   
   //NSLog(@"tempLeserArray: %@",[tempLeserArray description]);
   return tempLeserArray;
}


- (NSArray*)LeserArrayAnProjektPfad:(NSString*)derProjektPfad
{
   //NSLog(@"LeserArrayAnProjektPfad:  derProjektPfad: %@",derProjektPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   //NSString* locKommentar=@"Anmerkungen";
   
   NSMutableArray* tempProjektNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   tempProjektNamenArray=[[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL]mutableCopy];
   if (tempProjektNamenArray)
   {
      if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
      {
         [tempProjektNamenArray removeObjectAtIndex:0];
         
      }
      //NSLog(@"LeserArrayAnProjektPfad: tempProjektNamenArray: %@",[tempProjektNamenArray description]);
   }//if tempProjektnamenArray
   //NSLog(@"LeserArrayAnProjektPfad: tempProjektNamenArray: %@",[tempProjektNamenArray description]);
   //[tempProjektNamenArray retain];
   return tempProjektNamenArray;
}

- (NSArray*)LeserArrayVonTitel:(NSString*)derTitel anProjektPfad:(NSString*)derProjektPfad
{
   //NSLog(@"LeserArrayVonTitel: derTitel: %@  derProjektPfad: %@",derTitel,derProjektPfad);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempLeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   
   NSMutableArray* tempProjektNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   tempProjektNamenArray=[[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL]mutableCopy];
   if (tempProjektNamenArray)
   {
      if ([[tempProjektNamenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
      {
         [tempProjektNamenArray removeObjectAtIndex:0];
         
      }
      //NSLog(@"LeserArrayVonTitel: tempProjektNamenArray: %@",[tempProjektNamenArray description]);
      NSEnumerator* enumerator=[tempProjektNamenArray objectEnumerator];
      id einLeser;
      while (einLeser=[enumerator nextObject])
      {
         
         NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:einLeser];
         NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
         
         if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
         {
            NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
            tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
            if ([tempAufnahmenArray count])//Aufnahmen vorhanden
            {
               int KommentarIndex=(int)NSNotFound;
               KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
               if (!(KommentarIndex==(int)NSNotFound))
               {
                  [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
               }
               
               if ([tempAufnahmenArray count])
               {
                  if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
                  {
                     [tempAufnahmenArray removeObjectAtIndex:0];
                     
                  }
                  //NSLog(@"TitelArrayVon:  tempAufnahmenArray: %@",[tempAufnahmenArray description]);
                  
                  NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
                  id eineAufnahme;
                  while (eineAufnahme=[enumerator nextObject])
                  {
                     //NSLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                     NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                     //NSLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                     if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                     {
                        //if ([[[self AufnahmeTitelVon:eineAufnahme]lowercaseString] isEqualToString:[derTitel lowercaseString]])
                        if ([[self AufnahmeTitelVon:eineAufnahme] isEqualToString:derTitel])
                        {
                           NSString* 	tempKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:eineAufnahme];
                           if ([Filemanager fileExistsAtPath:tempKommentarPfad])// Kommentar für eineAufnahme ist da)
                           {
                              if (![tempLeserArray containsObject:einLeser])
                              {
                                 [tempLeserArray addObject:einLeser];
                              }
                           }
                        }
                        //NSLog(@"tempLeserArray: %@  tempTitel: %@",derLeser,tempTitel);
                     }
                     else
                     {
                        //NSLog(@"kein Leser mit diesem Titel");//
                        
                     }
                  }//while enumerator
                  //NSLog(@"tempLeserArray: %@",[tempLeserArray description]);
                  
               }// if tempAufnahmen count
               else
               {
                  //NSLog(@"Keine Aufnahmen von: %@",derLeser);
               }
            }//[tempAufnahmen count]
            
            
            
         }//if exists LeserPfad
         
         
         
      }//while (einLeser
   }//if tempProjektnamenArray
   //NSLog(@"tempLeserArray: %@",[tempLeserArray description]);
   return tempLeserArray;
}




- (NSString*)lastKommentarVonLeser:(NSString*)derLeser mitTitel:(NSString*)derTitel
{
   BOOL erfolg;
   BOOL istDirectory;
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSLog(@"lastKommentarVonLeser: LeserPfad: %@ mitTitel: %@",derLeser,derTitel);
   NSString* letzteAufnahme=@"xxx";
   NSString* lastKommentarMitTitelString=[NSString string];
   NSString* locKommentar=@"Anmerkungen";
   NSString* LeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:derLeser];
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        NSMutableArray* tempAufnahmen=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmen count])//Aufnahmen vorhanden
        {
           int KommentarIndex=(int)NSNotFound;
           KommentarIndex=[tempAufnahmen indexOfObject:locKommentar];
           if (!(KommentarIndex==(int)NSNotFound))
           {
              [tempAufnahmen removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Array entfernen
           }
           //NSLog(@"tempAufnahmen: %@",[tempAufnahmen description]);
           if ([tempAufnahmen count])
           {
              int letzte=0;
              if ([[tempAufnahmen objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
              {
                 [tempAufnahmen removeObjectAtIndex:0];
              }
              
              NSEnumerator* enumerator=[tempAufnahmen objectEnumerator];
              id eineAufnahme;
              while (eineAufnahme=[enumerator nextObject])
              {
                 //NSLog(@"eineAufnahme: %@",eineAufnahme);
                 if ([[self AufnahmeTitelVon:eineAufnahme] isEqualToString:derTitel])
                 {
                    int n=[self AufnahmeNummerVon:eineAufnahme];
                    if (n>letzte)
                    {
                       letzte=n;
                       letzteAufnahme=eineAufnahme;
                       
                    }
                 }
              }//while enumerator
              //NSLog(@"Leserordner letztes Objekt: %@",letzteAufnahme);
              NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:locKommentar];//Kommentarordner des Lesers
              NSString* lastKommentarPfad=[LeserKommentarPfad stringByAppendingPathComponent:letzteAufnahme];
              if ([Filemanager fileExistsAtPath:lastKommentarPfad])//Kommentar für letzte Aufnahme ist da)
              {
                 lastKommentarMitTitelString=[NSString stringWithContentsOfFile:lastKommentarPfad encoding:NSMacOSRomanStringEncoding error:NULL];
                 //NSLog(@"lastKommentarMitTitelString: %@  TitelPfad: %@",lastKommentarMitTitelString,lastKommentarPfad);
                 
              }
              else
              {
                 //NSLog(@"kein Kommentare da");//keine Kommentare
                 
              }
           }
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   return lastKommentarMitTitelString;
   
}

- (NSArray*)TitelMitAnzahlArrayVon:(NSString*)derLeser
{
   NSString* titel=@"titel";
   NSString* anzahl=@"anzahl";
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* LeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:derLeser];
   //NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:kommentar];//Kommentarordner des Lesers
   
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        //NSLog(@"TitelMitAnzahlArrayVon: %@" ,derLeser);
        NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmenArray count])//Aufnahmen vorhanden
        {
           int KommentarIndex=(int)NSNotFound;
           KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
           if (!(KommentarIndex==(int)NSNotFound))
           {
              [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
           }
           [tempAufnahmenArray removeObject:@"Kommentar"];//Sicherheit. Eventuell von alten Versionen noch vorhanden
           if ([tempAufnahmenArray count])
           {
              if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
              {
                 [tempAufnahmenArray removeObjectAtIndex:0];
                 
              }
              //NSLog(@"TitelMtAnzahlArrayVon:  tempAufnahmenArray: %@",[tempAufnahmenArray description]);
              tempAufnahmenArray=(NSMutableArray*)[self sortNachABC:tempAufnahmenArray];
              //NSLog(@"TitelMtAnzahlArrayVon:  tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
              
              NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
              id eineAufnahme;
              int anz=1;
              NSString* lastTitel=[NSString string];
              while (eineAufnahme=[enumerator nextObject])
              {
                 //NSLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 //NSLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                 if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                 {
                    NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                    if ([tempTitel length])
                    {
                       if ([tempTitelArray containsObject:tempTitel])
                       {
                          anz++;
                          // if (![lastTitel length])
                          {
                             //NSLog(@"Titel schon in Liste       tempTitel: %@ anz: %d lastTitel: %@",tempTitel,anz, lastTitel);
                          }
                       }
                       else
                       {
                          //NSLog(@"neuer Titel: %@ lastTitel: %@  anz: %d",tempTitel,lastTitel,anz);
                          [tempTitelArray insertObject: tempTitel atIndex:[tempTitelArray count]];
                          if ((![tempTitel isEqualToString:lastTitel])&&[lastTitel length])
                          {
                             NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:lastTitel
                                                                                             forKey:titel];
                             [tempDic setObject:[NSNumber numberWithInt:anz] forKey:anzahl];
                             [tempTitelDicArray insertObject:tempDic
                                                     atIndex:[tempTitelDicArray count]];
                             
                             anz=1;
                             
                          }
                          lastTitel=tempTitel;
                       }
                    }
                    //NSLog(@"TitelMitAnzahlArrayVon: %@  tempTitel: %@",derLeser,tempTitel);
                 }
                 else
                 {
                    //NSLog(@"kein Kommentare da");//keine Kommentare
                    
                 }
              }//while enumerator
              //letztes Dic einsetzen:
              NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:lastTitel
                                                                              forKey:titel];
              [tempDic setObject:[NSNumber numberWithInt:anz] forKey:anzahl];
              [tempTitelDicArray insertObject:tempDic 
                                      atIndex:[tempTitelDicArray count]];
              
              //NSLog(@"TitelArrayVon:  tempTitelArray: %@",[tempTitelArray description]);
              
           }// if tempAufnahmen count
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   //NSLog(@"TitelMitAnzahlArrayVon: %@   %@",derLeser, [tempTitelDicArray description]);
   return tempTitelDicArray;
}


- (NSArray*)TitelMitAnzahlArrayVon:(NSString*)derLeser anProjektPfad:(NSString*)derProjektPfad
{
   NSString* titel=@"titel";
   NSString* anzahl=@"anzahl";
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   NSMutableArray* tempTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   NSString* locKommentar=@"Anmerkungen";
   NSString* tempProjektPfad=[self.AdminArchivPfad stringByAppendingPathComponent:[derProjektPfad lastPathComponent]];
   
   NSString* LeserPfad=[tempProjektPfad stringByAppendingPathComponent:derLeser];
   //NSString* LeserKommentarPfad=[LeserPfad stringByAppendingPathComponent:kommentar];//Kommentarordner des Lesers
   
   if ([Filemanager fileExistsAtPath:LeserPfad])//Ordner des Lesers ist da
	  {
        //NSLog(@"TitelMitAnzahlArrayVon: %@" ,derLeser);
        NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc]initWithCapacity:0];
        tempAufnahmenArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:LeserPfad error:NULL];
        if ([tempAufnahmenArray count])//Aufnahmen vorhanden
        {
           int KommentarIndex=(int)NSNotFound;
           KommentarIndex=[tempAufnahmenArray indexOfObject:locKommentar];
           if (!(KommentarIndex==(int)NSNotFound))
           {
              [tempAufnahmenArray removeObjectAtIndex:KommentarIndex];//Kommentarordner aus Liste entfernen
           }
           if ([tempAufnahmenArray count])
           {
              if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
              {
                 [tempAufnahmenArray removeObjectAtIndex:0];
                 
              }
              //NSLog(@"TitelMtAnzahlArrayVon:  tempAufnahmenArray: %@",[tempAufnahmenArray description]);
              tempAufnahmenArray=(NSMutableArray*)[self sortNachABC:tempAufnahmenArray];
              //NSLog(@"TitelMtAnzahlArrayVon:  tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
              
              NSEnumerator* enumerator=[tempAufnahmenArray objectEnumerator];
              id eineAufnahme;
              int anz=1;
              NSString* lastTitel=[NSString string];
              while (eineAufnahme=[enumerator nextObject])
              {
                 //NSLog(@"tempAufnahmenArray eineAufnahme: %@",eineAufnahme);
                 NSString* tempAufnahmePfad=[LeserPfad stringByAppendingPathComponent:eineAufnahme];
                 //NSLog(@"tempAufnahmePfad: %@",tempAufnahmePfad);
                 if ([Filemanager fileExistsAtPath:tempAufnahmePfad])// eineAufnahme ist da)
                 {
                    NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                    if ([tempTitel length])
                    {
                       if ([tempTitelArray containsObject:tempTitel])
                       {
                          anz++;
                          // if (![lastTitel length])
                          {
                             //NSLog(@"Titel schon in Liste       tempTitel: %@ anz: %d lastTitel: %@",tempTitel,anz, lastTitel);
                          }
                       }
                       else
                       {
                          //NSLog(@"neuer Titel: %@ lastTitel: %@  anz: %d",tempTitel,lastTitel,anz);
                          [tempTitelArray insertObject: tempTitel atIndex:[tempTitelArray count]];
                          if ((![tempTitel isEqualToString:lastTitel])&&[lastTitel length])
                          {
                             NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:lastTitel
                                                                                             forKey:titel];
                             [tempDic setObject:[NSNumber numberWithInt:anz] forKey:anzahl];
                             [tempTitelDicArray insertObject:tempDic 
                                                     atIndex:[tempTitelDicArray count]];
                             
                             anz=1;
                             
                          }
                          lastTitel=tempTitel;
                       }
                    }
                    //NSLog(@"TitelMitAnzahlArrayVon: %@  tempTitel: %@",derLeser,tempTitel);
                 }
                 else
                 {
                    //NSLog(@"kein Kommentare da");//keine Kommentare
                    
                 }
              }//while enumerator
              //letztes Dic einsetzen:
              NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:lastTitel
                                                                              forKey:titel];
              [tempDic setObject:[NSNumber numberWithInt:anz] forKey:anzahl];
              [tempTitelDicArray insertObject:tempDic 
                                      atIndex:[tempTitelDicArray count]];
              
              //NSLog(@"TitelArrayVon:  tempTitelArray: %@",[tempTitelArray description]);
              
           }// if tempAufnahmen count
           else
           {
              //NSLog(@"Keine Aufnahmen von: %@",derLeser);
           }
        }//[tempAufnahmen count]
        
        
        
     }//if exists LeserPfad
   
   //NSLog(@"TitelMitAnzahlArrayVon: %@   %@",derLeser, [tempTitelDicArray description]);
   return tempTitelDicArray;
}

- (int)AufnahmeNummerVon:(NSString*) dieAufnahme
{
   NSString* tempAufnahme=[dieAufnahme copy];
   int posLeerstelle1=0;
   int posLeerstelle2=0;
   int Leerstellen=0;
   int tempNummer=0;
   
   int charpos=0;
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



- (NSString*)AufnahmeTitelVon:(NSString*) dieAufnahme
{
   
   NSString* tempAufnahme=[dieAufnahme copy];
   int posLeerstelle1=0;
   int posLeerstelle2=0;
   int Leerstellen=0;
   NSString*  tempString;
   
   int charpos=0;
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
   return [tempString stringByDeletingPathExtension];
}//AufnahmeTitelVon

- (NSString*)KommentarVon:(NSString*) derKommentarString
{
   
   NSArray* tempMarkArray=[derKommentarString componentsSeparatedByString:@"\r"];
   //NSLog(@"tempMarkVon: anz Components: %d",[tempMarkArray count]);
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
      //NSLog(@"******  tempKommentarString: %@", tempKommentarString);
      
      return tempKommentarString;
   }//noch keine Zeile für Mark
   else if ([tempMarkArray count]==8)//neue version von Kommentar
   {
      NSString* tempKommentarString=[tempMarkArray objectAtIndex:Kommentar];
      
      return tempKommentarString;
      
   }
   return @"alt";
}
- (NSString*)DatumVon:(NSString*) derKommentarString
{
   NSString* tempDatumString;
   //[tempKommentarString release];
   tempDatumString=[derKommentarString copy];
   int AnzReturns=0;
   int returnpos1=0,returnpos2=0;
   int pos=0;
   while(pos<[tempDatumString length])
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
        int leerpos=0;
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
           tempDatumString=@" ";
        }
     }
   
   
   return tempDatumString;
   
}

- (NSString*)BewertungVon:(NSString*) derKommentarString
{
   NSString* tempBewertungString;
   //[tempKommentarString release];
   tempBewertungString=[derKommentarString copy];
   int AnzReturns=0;
   int returnpos1=0,returnpos2=0;
   int pos=0;
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
           tempBewertungString=@"--";
           return tempBewertungString;
        }
        //NSLog(@"BewertungVon:		tempBewertungString: %@", tempBewertungString);
     }
   else
	  {
        
     }
   
   
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



- (NSString*)NoteVon:(NSString*) derKommentarString
{
   NSString* tempNotenString;
   //[tempKommentarString release];
   tempNotenString=[derKommentarString copy];
   int AnzReturns=0;
   int returnpos1=0,returnpos2=0;
   int pos=0;
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



- (int)UserMarkVon:(NSString*)derKommentarString
{
   int tempUserMark=0;
   NSArray* tempMarkArray=[derKommentarString componentsSeparatedByString:@"\r"];
   //NSLog(@"UserMarkVon: anz Components: %d inhalt: %@",[tempMarkArray count],[tempMarkArray description]);
   if ([tempMarkArray count]==8)//Zeile für Mark da
   {
      //NSLog(@"UserMarkVon: Mark da");
      tempUserMark=[[tempMarkArray objectAtIndex:UserMarkReturn]intValue];
   }
   
   return tempUserMark;
   
}


- (NSArray*)sortNachNummer:(NSArray*)derArray
{
   NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   tempArray =[derArray mutableCopy];
   //return derArray;
   //[derArray release];
   int anz=[tempArray count];
   BOOL tausch=YES;
   int index=0;
   int stop=0;
   //NSLog(@"sortNachNummer: derArray vor sortieren: %@",[derArray description]);
   while (tausch&&stop<100)
	  {
        tausch=NO;
        for (index=0;index<anz-1;index++)
        {
           int n=[[[[tempArray objectAtIndex:index]componentsSeparatedByString:@" "]objectAtIndex:1]intValue];
           int m=[[[[tempArray objectAtIndex:index+1]componentsSeparatedByString:@" "]objectAtIndex:1]intValue];
           //NSLog(@"m: %d  n:%d",m,n);
           if (m>n)
           {
              //NSLog(@"m: %d  n:%d",m,n);
              tausch=YES;
              [tempArray exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
           }
        }//for index
        stop++;
     }//while tausch
   //NSLog(@"sortNachNummer: derArray nach sortieren: %@",[tempArray description]);
   
   
   return tempArray;
}

- (NSArray*)sortNachABC:(NSArray*)derArray
{
   NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   tempArray =[derArray mutableCopy];
   //return derArray;
   //[derArray release];
   int anz=[tempArray count];
   BOOL tausch=YES;
   int index=0;
   int stop=0;
   //NSLog(@"sortNachABC: derArray vor sortieren: %@",[derArray description]);
   while (tausch&&stop<100)
	  {
        tausch=NO;
        for (index=0;index<anz-1;index++)
        {
           NSString* n=[[[tempArray objectAtIndex:index]componentsSeparatedByString:@" "]objectAtIndex:2];
           NSString* m=[[[tempArray objectAtIndex:index+1]componentsSeparatedByString:@" "]objectAtIndex:2];
           //NSLog(@"m: %@  n:%@",m,n);
           if ([m caseInsensitiveCompare:n]==NSOrderedDescending)
           {
              //NSLog(@"tauschen:          m: %@  n:%@",m,n);
              tausch=YES;
              [tempArray exchangeObjectAtIndex:index+1 withObjectAtIndex:index];
           }
        }//for index
        stop++;
     }//while tausch
   //NSLog(@"sortNachNummer: derArray nach sortieren: %@",[tempArray description]);
   
   
   return tempArray;
}

- (NSString*)alleKommentareVonHeute
{
   BOOL erfolg;
   BOOL istDirectory;
   NSString* lastKommentarString=@"";//Anmerkungen in Tabelle mit 6 Kolonnen konvertieren \r";
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   
   NSMutableArray* LeserArray=[[NSMutableArray alloc]initWithCapacity:0];
   if (![Filemanager fileExistsAtPath:self.AdminProjektPfad isDirectory:&istDirectory]&&istDirectory)
   {
      NSLog(@"lastKommentarVonHeute: kein Archiv");
   }
   LeserArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:self.AdminProjektPfad error:NULL];
   if (![LeserArray count])
   {
      NSLog(@"lastKommentarVonAllen: Archiv ist leer");
   }				
   if ([[LeserArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
   {
      [LeserArray removeObjectAtIndex:0];
   }
   
   NSLog(@"lastKommentarVonHeute: LeserArray: %@",[LeserArray description]);
   NSEnumerator* enumerator =[LeserArray objectEnumerator];
   NSString* tempLeser;
   while (tempLeser = [enumerator nextObject]) 
   {
      
      /* ev Fehler*/
      lastKommentarString=[lastKommentarString stringByAppendingString:[self lastKommentarVonLeser:tempLeser anProjektPfad:self.AdminProjektPfad]];
      //NSLog(@"lastKommentarVonAllen: tempLeser: %@ ",tempLeser);
      lastKommentarString=[lastKommentarString stringByAppendingString:@"\r\r"];
   }//enumerator
   //NSLog(@"lastKommentarVonHeute:    Kommentar: %@", lastKommentarString);
   
   return lastKommentarString;
}

- (NSString*)InitialenVon:(NSString*)derName
{
   NSString* tempstring =[derName copy];
   unichar  Anfangsbuchstabe=[tempstring characterAtIndex:0];
   NSMutableString* initial=[NSMutableString stringWithCharacters:&Anfangsbuchstabe length:1];
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
        NSMutableString* s=[NSMutableString stringWithCharacters:&ZweiterBuchstabe length:1];
        initial=[[initial stringByAppendingString:s ]mutableCopy];
     }
   return initial;
}


- (void)Markierungenreset
{
   int i;
   for (i=0;i<	[self.AdminProjektNamenArray count];i++)
   {
      [self MarkierungEntfernenFuerZeile:i];
   }//for
   [self setMark:NO];
}

// AufnahmenTableController

- (void)setNamenPop:(NSArray*)derNamenArray
{
   
}

- (IBAction)reportAuswahlOption:(id)sender;
{
   //NSLog(@"reportAuswahlOption: row: %d",[sender selectedRow]);
   [self setAufnahmenVonLeser:[self.LesernamenPop titleOfSelectedItem]];
   
}

- (void)setAdminMark:(BOOL)derStatus fuerZeile:(int)dieZeile
{
   NSNumber* StatusNumber=[NSNumber numberWithBool:derStatus];
   [[self.AufnahmenDicArray objectAtIndex:dieZeile]setObject:[StatusNumber stringValue] forKey:@"adminmark"];
   [self.AufnahmenTable reloadData];
}

- (IBAction)reportDelete:(id)sender
{
   NSString* tempName=[self.LesernamenPop titleOfSelectedItem];
   NSLog(@"tempName: %@",tempName);
   [self AufnahmeLoeschen:sender];
   [self.LesernamenPop selectItemWithTitle:tempName];
   [self setAufnahmenVonLeser:tempName];
   
}

- (void)setUserMark:(BOOL)derStatus fuerZeile:(int)dieZeile
{
   NSNumber* StatusNumber=[NSNumber numberWithBool:derStatus];
   [[self.AufnahmenDicArray objectAtIndex:dieZeile]setObject:[StatusNumber stringValue] forKey:@"usermark"];
   [self.AufnahmenTable reloadData];
}






- (IBAction)setAufnahmenVonPopLeser:(id)sender
{
   [self setAufnahmenVonLeser:[sender titleOfSelectedItem]];
   
}

- (void)setAufnahmenVonLeser:(NSString*)derLeser
{
   
   [self.AufnahmenDicArray removeAllObjects];
   self.AdminAktuellerLeser=[derLeser copy];
   NSString* tempLeserPfad=[self.AdminProjektPfad stringByAppendingPathComponent:derLeser];
   //NSLog(@"tempLeserPfad: %@",tempLeserPfad);
   
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   NSMutableArray* tempAufnahmenArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempLeserPfad error:NULL]];
   if (tempAufnahmenArray)
   {
      [tempAufnahmenArray removeObject:@".DS_Store"];
      [tempAufnahmenArray removeObject:@"Anmerkungen"];
   }
   
   //NSLog(@"tempAufnahmenArray: %@",[tempAufnahmenArray description]);
   
   
   NSString* tempLeserKommentarPfad=[tempLeserPfad stringByAppendingPathComponent:@"Anmerkungen"];
   //NSLog(@"tempLeserKommentarPfad: %@",tempLeserKommentarPfad);
   NSMutableArray* tempKommentarArray=[[NSMutableArray alloc] initWithArray:[Filemanager contentsOfDirectoryAtPath:tempLeserKommentarPfad error:NULL]];
   if (tempKommentarArray)
   {
      [tempKommentarArray removeObject:@".DS_Store"];
   }
   //NSLog(@"tempKommentarArray: %@",[tempKommentarArray description]);
   
   NSMutableArray* tempAufnahmenDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
   id eineAufnahme;
   BOOL inPopOK=NO;
   while (eineAufnahme=[AufnahmenEnum nextObject])
   {
      if ([self.MarkAuswahlOption selectedRow]==0)
      {
         inPopOK=YES;
      }
      NSMutableDictionary* tempAufnahmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      [tempAufnahmenDic setObject:eineAufnahme forKey:@"aufnahme"];
      
      NSString* tempAufnahmePfad=[tempLeserPfad stringByAppendingPathComponent:eineAufnahme];
      BOOL AdminMarkOK=[self AufnahmeIstMarkiertAnPfad:tempAufnahmePfad];
      //		[MarkCheckbox setEnabled:YES];
      [self.MarkCheckbox setState:AdminMarkOK];
      
      if (([self.MarkAuswahlOption selectedRow]==1)&&AdminMarkOK)
      {
         inPopOK=YES;
         
      }
      [tempAufnahmenDic setObject:[NSNumber numberWithBool:AdminMarkOK] forKey:@"adminmark"];
      
      NSString* tempKommentarString=[self KommentarZuAufnahme:eineAufnahme
                                                     vonLeser:self.AdminAktuellerLeser
                                                anProjektPfad:self.AdminProjektPfad];
      BOOL UserMarkOK=[self UserMarkVon:tempKommentarString];
      
      if (([self.MarkAuswahlOption selectedRow]==2)&&UserMarkOK)
      {
         inPopOK=YES;
      }
      
      
      if (inPopOK)
      {
         [tempAufnahmenDic setObject:[NSNumber numberWithBool:UserMarkOK] forKey:@"usermark"];
         [tempAufnahmenDic setObject:[NSNumber numberWithInt:[self AufnahmeNummerVon:eineAufnahme]] forKey:@"sort"];
         self.AufnahmeDa=YES;
         [tempAufnahmenDicArray addObject:tempAufnahmenDic];
         inPopOK=NO;
      }
      
   }//while
   self.AufnahmeDa=[tempAufnahmenDicArray count];
   [self.PlayTaste setEnabled:self.AufnahmeDa];
   [self.DeleteTaste setEnabled:self.AufnahmeDa];
   if ([tempAufnahmenDicArray count])//es hat Aufnahmen
   {
      //	[DeleteTaste setEnabled:YES];
      //	[self.PlayTaste setEnabled:YES];
   }
   else
   {
      //[DeleteTaste setEnabled:NO];
      //[self.PlayTaste setEnabled:NO];
      NSLog(@"keine Aufnahmen für diese Einstellungen");
      NSMutableDictionary* tempAufnahmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
      
      [tempAufnahmenDic setObject:@"Keine Aufnahmen" forKey:@"aufnahme"];
      [tempAufnahmenDicArray addObject:tempAufnahmenDic];
   }
   
   NSSortDescriptor* sorter=[[NSSortDescriptor alloc]initWithKey:@"sort" ascending:NO];
   NSArray* sortDescArray=[NSArray arrayWithObjects:sorter,nil];
   self.AufnahmenDicArray =[[tempAufnahmenDicArray sortedArrayUsingDescriptors:sortDescArray]mutableCopy];
   //NSLog(@"AufnahmenDicArray: %@",[AufnahmenDicArray description]);
   self.AdminAktuelleAufnahme=[[self.AufnahmenDicArray objectAtIndex:0]objectForKey:@"aufnahme"];
   self.selektierteAufnahmenTableZeile=0;
   NSNumber* ZeilenNummer=[NSNumber numberWithInt:0];
   NSMutableDictionary* tempZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNummer forKey:@"AufnahmenZeilenNummer"];
   [tempZeilenDic setObject:@"AufnahmenTable" forKey:@"Quelle"];
   NSNotificationCenter * nc;
   nc=[NSNotificationCenter defaultCenter];
   //[nc postNotificationName:@"AdminselektierteZeile" object:tempZeilenDic];
   
   
   [self.AufnahmenTable reloadData];
   [self.AufnahmenTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
   BOOL OK;
   OK=[self setPfadFuerLeser: derLeser FuerAufnahme:self.AdminAktuelleAufnahme];
   OK=[self setKommentarFuerLeser: derLeser FuerAufnahme:self.AdminAktuelleAufnahme];
}


- (void)setAufnahmenTable:(NSArray*)derAufnahmenArray  fuerLeser:(NSString*)derLeser
{
   
   
}

#pragma mark -
#pragma mark TestTable delegate:


#pragma mark -
#pragma mark TestTable Data Source:

- (long)numberOfRowsInTableView:(NSTableView *)aTableView
{
   return [self.AufnahmenDicArray count];
}


- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(long)rowIndex
{
   //NSLog(@"objectValueForTableColumn");
   NSMutableDictionary *einAufnahmenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   if (rowIndex<[self.AufnahmenDicArray count])
   {
      einAufnahmenDic = [[self.AufnahmenDicArray objectAtIndex: rowIndex]mutableCopy];
      if ([[einAufnahmenDic objectForKey:@"adminmark"]intValue]==1)
      {
         [einAufnahmenDic setObject:[NSImage imageNamed:@"MarkOnImg.tif"] forKey:@"adminmark"];
      }
      else
      {
         [einAufnahmenDic setObject:[NSImage imageNamed:@"MarkOffImg.tif"] forKey:@"adminmark"];
      }
      
   }
   //NSLog(@"einAufnahmenDic: aktiv: %d   Testname: %@",[[einAufnahmenDic objectForKey:@"aktiv"]intValue],[einAufnahmenDic objectForKey:@"name"]);
   
   return [einAufnahmenDic objectForKey:[aTableColumn identifier]];
   
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(long)rowIndex
{
   NSLog(@"setObjectValueForTableColumn");
   
   NSMutableDictionary* einAufnahmenDic;
   if (rowIndex<[self.AufnahmenDicArray count])
   {
      NSLog(@"setObjectValueForTableColumn: anObject: %@ column: %@",[anObject description],[aTableColumn identifier]);
      einAufnahmenDic=[self.AufnahmenDicArray objectAtIndex:rowIndex];
      NSLog(@"einAufnahmenDic vor: %@",[einAufnahmenDic description]);
      [einAufnahmenDic setObject:anObject forKey:[aTableColumn identifier]];
      NSLog(@"einAufnahmenDic nach: %@",[einAufnahmenDic description]);
      NSString* tempAufnahme=[einAufnahmenDic objectForKey:@"aufnahme"];
      [self saveMarksFuerLeser:self.AdminAktuellerLeser FuerAufnahme:tempAufnahme
                  mitAdminMark:[[einAufnahmenDic objectForKey:@"adminmark"]intValue]
                   mitUserMark:[[einAufnahmenDic objectForKey:@"usermark"]intValue]];
      
      [self.AufnahmenTable reloadData];
      //NSLog(@"einAufnahmenDic: %@",[einAufnahmenDic description]);
   }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row
{
   //NSLog(@"AufnahmenTable  shouldSelectRow: %d  selektierteAufnahmenTableZeile: %d" ,row,selektierteAufnahmenTableZeile);
   int bisherSelektierteZeile=self.selektierteAufnahmenTableZeile;//bisher selektierte Zeile
   self.selektierteAufnahmenTableZeile=row;//neu selektierte Zeile
   if (bisherSelektierteZeile>=0)
   {
      
      NSNumber* ZeilenNumber=[NSNumber numberWithInt:bisherSelektierteZeile];
      
      
      NSMutableDictionary* NamenZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNumber forKey:@"zeilennummer"];
      [NamenZeilenDic setObject:@"AufnahmenTable" forKey:@"Quelle"];
      [NamenZeilenDic setObject:[self.LesernamenPop titleOfSelectedItem]forKey:@"leser"];//Leser der Aufnahmen im TableView
      NSString* tempAufnahme=[[self.AufnahmenDicArray objectAtIndex:bisherSelektierteZeile]objectForKey:@"aufnahme"];//bisher selektierte Aufnahme
      //NSLog(@"AdminAktuelleAufnahme: %@ tempAufnahme: %@", self.AdminAktuelleAufnahme,tempAufnahme);
      [NamenZeilenDic setObject:tempAufnahme forKey:@"aufnahme"];
      
      //NSLog(@"[AuswahlArray: %@",[[AuswahlArray objectAtIndex:row]description]);
      NSNotificationCenter * nc;
      nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"AdminselektierteZeile" object:NamenZeilenDic];
   }//es war eine Zeile selektiert
   
   //if (!row==selektierteAufnahmenTableZeile)//aufräumen
   
   self.AdminAktuelleAufnahme=[[self.AufnahmenDicArray objectAtIndex:row]objectForKey:@"aufnahme"];//neu selektierte Aufnahme
   
   //[self clearKommentarfelder];
   [self.PlayTaste setEnabled:YES];
   [self.zurListeTaste setEnabled:NO];
   
   
   //aktuelleZeile=row;
   
   return YES;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
   //NSLog(@"ProjektListe willDisplayCell Zeile: %d, numberOfSelectedRows:%d", row ,[tableView numberOfSelectedRows]);
   NSString* tempTestNamenString=[[self.AufnahmenDicArray objectAtIndex:row]objectForKey:@"aufnahme"];
   if([[[self.AufnahmenDicArray objectAtIndex:row]objectForKey:@"usermark"]intValue])//user hat markiert
   {
      //[cell setTextColor:[NSColor redColor]];
   }
   else//alter Name
   {
      //[cell setTextColor:[NSColor blackColor]];
   }
	  if ([[tableColumn identifier] isEqualToString:@"adminmark"])
     {
        //[cell setImagePosition:NSImageRight];
        //NSImage* MarkOnImg=[NSImage imageNamed:@"MarkOnImg.tif"];
        if ([[[self.AufnahmenDicArray objectAtIndex:row]objectForKey:@"adminmark"]intValue])
        {
           //[cell setImage:[NSImage imageNamed:@"MarkOnImg.tif"]];
        }
        else
        {
           //[cell setImage:[NSImage imageNamed:@"MarkOffImg.tif"]];
        }
     }
}//willDisplayCell


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
   //[self resetAdminPlayer];
   //if ([TestTable numberOfSelectedRows]==0)
   {
      //[OKKnopf setEnabled:NO];
      //[OKKnopf setKeyEquivalent:@""];
      //[HomeKnopf setKeyEquivalent:@"\r"];
   }
}

- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn
{
   if ([[tableColumn identifier]isEqualToString:@"usermark"])//Klick in erate Kolonne
   {
      
      BOOL status=[[tableColumn dataCellForRow:[tableView selectedRow]]isEnabled];
      NSLog(@"UserMark: status: %d",status);
      if (status)
      {
         [[tableColumn headerCell]setTextColor:[NSColor greenColor]];
         [[tableColumn headerCell]setTitle:@"X"];
      }
      else
      {
         [[tableColumn headerCell]setTextColor:[NSColor redColor]];
         [[tableColumn headerCell]setTitle:@"OK"];
      }
      [[tableColumn dataCellForRow:[tableView selectedRow]]setEnabled:!status];
      [tableView reloadData];
   }
   
}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
   //NSLog(@"tabView shouldSelectTabViewItem: %@",[[tabViewItem identifier]description]);
   //NSLog(@"shouldSelectTabViewItem: rowData: %@",[[AdminDaten rowData] description]);
   
   //[self.PlayTaste setEnabled:YES];
   [self.zurListeTaste setEnabled:NO];
   
   if ([[tabViewItem identifier]intValue]==1)//zurück zu 'alle Aufnahmen'
   {
      
      NSLog(@"zu 'alle Aufnahmen'");
      
      NSLog(@"nach Namen vor : AdminAktuelleAufnahme: %@",self.AdminAktuelleAufnahme);
      
      int Zeile=[self.AufnahmenTable selectedRow];
      self.AdminAktuelleAufnahme=[[self.AufnahmenDicArray objectAtIndex:Zeile]objectForKey:@"aufnahme"];
      NSLog(@"Tab nach Namen: Zeile: %d AdminAktuelleAufnahme: %@",Zeile,self.AdminAktuelleAufnahme);
      
      NSNumber* ZeilenNummer=[NSNumber numberWithInt:Zeile];
      NSMutableDictionary* tempZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNummer forKey:@"AufnahmenZeilenNummer"];
      [tempZeilenDic setObject:@"AufnahmenTable" forKey:@"Quelle"];
      NSNotificationCenter * nc;
      nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"AdminChangeTab" object:tempZeilenDic];
      
      [self clearKommentarfelder];
      
      if ([self.LesernamenPop indexOfSelectedItem])
      {
         NSString* Lesername=[self.LesernamenPop titleOfSelectedItem];
         int LesernamenIndex=[self.AdminDaten ZeileVonLeser:Lesername];
         //NSLog(@"Alle Namen: Lesername: %@, LesernamenIndex: %d",Lesername,LesernamenIndex);
         [self.NamenListe selectRowIndexes:[NSIndexSet indexSetWithIndex:LesernamenIndex]byExtendingSelection:NO];
         [self setLeserFuerZeile:LesernamenIndex];
         if ([self.NamenListe numberOfSelectedRows])
         {
            [self.PlayTaste setEnabled:YES];
         }
      }
      else
      {
         [self.NamenListe deselectAll:NULL];
         [self.PlayTaste setEnabled:NO];
      }
   }
   
   if ([[tabViewItem identifier]intValue]==2)//zu 'Nach Namen'
   {
      //NSLog(@"Tab zu 'nach Namen'");
      if ([self.NamenListe numberOfSelectedRows])//es ist eine zeile in der self.NamenListe selektiert
      {
         
         int  Zeile;
         Zeile=[self.NamenListe selectedRow];//selektierte Zeile in der self.NamenListe
         //NSLog(@"nach Namen: Zeile: %d AdminAktuelleAufnahme: %@",Zeile,AdminAktuelleAufnahme);
         
         
         NSNumber* ZeilenNumber=[NSNumber numberWithInt:Zeile];
         
         NSMutableDictionary* AdminZeilenDic=[NSMutableDictionary dictionaryWithObject:ZeilenNumber forKey:@"zeilennummer"];
         [AdminZeilenDic setObject:@"AdminView" forKey:@"Quelle"];
         
         NSString* Lesername=[[self.AdminDaten dataForRow:Zeile] objectForKey:@"namen"];
         //NSLog(@"Nach Namen: Lesername: %@",Lesername);
         [AdminZeilenDic setObject:[Lesername copy] forKey:@"leser"];
         
         
         NSNotificationCenter * nc;
         nc=[NSNotificationCenter defaultCenter];
         [nc postNotificationName:@"AdminChangeTab" object:AdminZeilenDic];
         
         [self.PlayTaste setEnabled:self.AufnahmeDa];
         
         
         [self.LesernamenPop selectItemWithTitle:Lesername];
         [self setAufnahmenVonLeser:Lesername];
         
//*         [[self window]makeFirstResponder:AufnahmenTable];
         NSString* KeineAufnahmenString=@"Keine Aufnahmen";
         
         //NSNotificationCenter * nc;
         //nc=[NSNotificationCenter defaultCenter];
         //[nc postNotificationName:@"AdminselektierteZeile" object:AdminZeilenDic];
         
         
      }
      else
      {
         [self.LesernamenPop selectItemAtIndex:0];
         [self.PlayTaste setEnabled:NO];
         [self clearKommentarfelder];
         return 0; // nicht umschalten
      }
   }
   
   
   return YES;
}

// CleanController

- (void)CleanOptionNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Pops des Cleanfensters
   //NSString* alle=@"alle";
   NSString* selektiertenamenzeile=@"selektiertenamenzeile";
   
   //NSLog(@"CleanNotifikationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Pop AnzahlNamen
   NSNumber* AnzahlNamenNummer=[OptionDic objectForKey:@"AnzahlNamen"];
   if (AnzahlNamenNummer)
	  {
        NSLog(@"CleanNotifikationAktion: AnzahlNamen: %d",[AnzahlNamenNummer intValue]);
     }
   
   //Pop AnzahlTitel
   NSNumber* AnzahlTitelNummer=[OptionDic objectForKey:@"AnzahlTitel"];
   if (AnzahlTitelNummer)
	  {
        NSLog(@"CleanNotifikationAktion: AnzahlTitel: %d",[AnzahlTitelNummer intValue]);
     }
   
   //Radio NamenBehaltenOption
   NSNumber* NamenBehaltenNummer=[OptionDic objectForKey:@"NamenBehalten"];
   if (NamenBehaltenNummer)
	  {
        NSLog(@"CleanNotifikationAktion: NamenBehalten: %d",[NamenBehaltenNummer intValue]);
     }
   
   //Radio TitelBehaltenOption
   NSNumber* TitelBehaltenNummer=[OptionDic objectForKey:@"TitelBehalten"];
   if (TitelBehaltenNummer)
	  {
        NSLog(@"CleanNotifikationAktion: TitelBehalten: %d",[TitelBehaltenNummer intValue]);
     }
   
   NSNumber* nurTitelZuNamenOptionNummer=[OptionDic objectForKey:@"nurTitelZuNamenOption"];
   if (nurTitelZuNamenOptionNummer)
   {
      //NSLog(@"CleanNotifikationAktion: nurTitelZuNamenOption: %d",[nurTitelZuNamenOptionNummer intValue]);
      self.nurTitelZuNamenOption=[nurTitelZuNamenOptionNummer intValue];
      //[CleanFenster clearTitelListe:NULL];
      if(self.nurTitelZuNamenOption>0)
      {
         NSDictionary* TempNamenDic=[OptionDic objectForKey:selektiertenamenzeile];
         //NSLog(@"**  nurTitelZuNamenOption: TempNamenDic: %@",[TempNamenDic description]);
         if([TempNamenDic objectForKey:name])
         {
            
            NSString* tempname=[TempNamenDic objectForKey:name];
            //NSLog(@"**  nurTitelZuNamenOption: tempname: %@",[tempname description]);
            
            [self setCleanTitelVonLeser:tempname];
         }
      }
   }
   //Alle Titel einsetzen
   NSNumber* alleTitelEinsetzenNummer=[OptionDic objectForKey:@"setalletitel"];
   if (alleTitelEinsetzenNummer)
   {
      NSLog(@"CleanNotifikationAktion: alleTitelEinsetzenNummer: %d",[alleTitelEinsetzenNummer intValue]);
      if ([alleTitelEinsetzenNummer intValue])
      {
         [self setAlleTitel];
      }
      
   }
   
   
}

- (void)CleanViewNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Views des Cleanfensters
   //NSLog(@"												CleanViewNotifikationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   //NSNumber* ViewZeilenNumber=[OptionDic objectForKey:@"ZeilenNummer"];
   //int ViewZeilennummer=[ViewZeilenNumber intValue];
   //Pop AnzahlNamen
   NSNumber* ViewTagNumber=[OptionDic objectForKey:@"Quelle"];
   if (ViewTagNumber)
	  {
        switch([ViewTagNumber intValue])
        {
           case NamenViewTag:
           {
              NSString* tempName=[OptionDic objectForKey:name];//aktueller Name
              int NamenWeg=[[OptionDic objectForKey:@"namenweg"]intValue];//sollen die Titel zum Namen entfernt weden?
              NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
              //NSLog(@"\n\n-----------------------------CleanViewNotifikationAktion: CleanTitelDicArray: \n%@\n",[CleanTitelDicArray description]);
              //Array mit schon vorhandenen TitelDics in Clean
              NSMutableArray* neueTitelArray=[[NSMutableArray alloc]initWithCapacity:0]; //Kontrollarray nur mit Titeln
              //NSLog(@"CleanTitelDicArray von: %@: \n%@\n",tempName, [CleanTitelDicArray description]);
              NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
              
              [TitelMitAnzahlArray addObjectsFromArray:[self TitelMitAnzahlArrayVon:tempName]];//Titel mit Anzahl von tempName
              //NSLog(@"*TitelMitAnzahlArrayVon: %@   %@",tempName,[TitelMitAnzahlArray description]);
              
              if (self.nurTitelZuNamenOption)
              {
                 //NSLog(@"nurTitelZuNamenOption");
                 //[CleanFenster clearTitelListe:NULL];
                 [self.CleanFenster TitelListeLeeren];
                 
                 
              }
              else
              {
                 //NSLog(@"nicht TitelZuNamenOption");
                 if (NamenWeg>0)//Die Titel von tempName sollen entfernt werden
                 {
                    //NSLog(@"NamenWeg>0");
                    [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];//vorhandene Titel mit Anzahlen
                    NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
                    id einTitel;
                    int index=0;
                    while(einTitel=[TitelDicEnum nextObject])		//neue Titel einf√ºllen
                    {
                       [neueTitelArray insertObject:[einTitel objectForKey:titel] atIndex:[neueTitelArray count]];
                       index++;
                    }
                    NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
                    id eineCleanTitelDicZeile;
                    while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
                    {
                       int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
                       
                       //int neueAnzahl=[[eineZeile objectForKey:anzahl]intValue];
                       //NSLog(@"eineZeile: %@ anzahl: %d",[eineZeile description],n);
                       NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:titel]; //Titel aus Clean
                       //NSLog(@"tempTitel: %@\n",[tempTitel description]);
                       
                       
                       if ([neueTitelArray containsObject:tempTitel])
                       {
                          //NSLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                          int TitelWegAnzahl=0;
                          
                          NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                          id eineTitelZeile;
                          int wegTitelIndex=-1;
                          BOOL NameSchonDa=NO;
                          while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                          {
                             //NSLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                             if ([[eineTitelZeile objectForKey:titel]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                             {
                                if ([[eineCleanTitelDicZeile objectForKey:leser]containsObject:tempName])
                                {
                                   //NSLog(@"Name schon in Liste 'leser': %@",tempName);
                                   wegTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                   
                                   TitelWegAnzahl=[[eineTitelZeile objectForKey:anzahl]intValue];
                                   NameSchonDa=YES;
                                   gefunden=1;
                                }
                                else
                                {
                                   //für diesen Titel hat tempLeser keinen Eintrag
                                   //NSLog(@"Name noch nicht da: %@",tempName);
                                }
                             }
                          }//while
                          if (NameSchonDa)//Einträge l√∂schen
                          {
                             
                             if (wegTitelIndex>=0)
                             {
                                [TitelMitAnzahlArray removeObjectAtIndex:wegTitelIndex];
                                [neueTitelArray removeObject:tempTitel];
                             }
                          }
                          
                          //NSLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                          if (gefunden==1)
                          {
                             
                             int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:anzahl]intValue];//Anzahl Aufnahmen zum titel in Clean
                             
                             //NSLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                             NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:alteAnzahl-TitelWegAnzahl];
                             [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:anzahl];
                             //NSLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                             
                             //neuen namen aus Liste 'leser' entfernen
                             NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:leser]mutableCopy];
                             if (tempArray)
                             {
                                //NSLog(@"tempArray: %@",[tempArray description]);
                                [tempArray removeObject:tempName];
                                //NSLog(@"tempArray neu: %@",[tempArray description]);
                             }
                             [eineCleanTitelDicZeile setObject:tempArray forKey:leser];
                             NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithInt:[tempArray count]];
                             [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:anzleser];
                             
                             //NSLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                          }//gefunden
                          
                       }//if containsObject
                    }//while (eineCleanTitelDicZeile
                    //NSLog(@"while (eineCleanTitelDicZeile) fertig");
                    BOOL nochZeilenMitNull=YES;
                    int schleifenindex=[CleanTitelDicArray count];
                    while (nochZeilenMitNull&&(schleifenindex>=0))
                    {
                       //NSLog(@"Anzahl: %d  CleanTitelDicArray: %@  schleifenindex: %d",[CleanTitelDicArray count],[CleanTitelDicArray description],schleifenindex);
                       NSEnumerator* CleanTitelWegEnum=[CleanTitelDicArray objectEnumerator];
                       //Array mit vebliebenen Dics  aus Clean
                       id eineCleanTitelWegZeile;
                       int ZeileMitNullGefunden=-1;
                       int zeilenIndex=0;
                       while ((eineCleanTitelWegZeile=[CleanTitelWegEnum nextObject])&&(ZeileMitNullGefunden<0))//Zeilen mit Anzahl=0 entfernen
                       {
                          if ([[eineCleanTitelWegZeile objectForKey:anzahl]intValue]==0)
                          {
                             ZeileMitNullGefunden=zeilenIndex;
                          }
                          zeilenIndex++;
                       }//while eineCleanTitelWegZeile
                       
                       if (ZeileMitNullGefunden<0)
                       {
                          nochZeilenMitNull=NO;
                       }
                       else
                       {//Es hat noch eine Zeile mit Anzahl 0
                          [CleanTitelDicArray removeObjectAtIndex:ZeileMitNullGefunden];
                       }
                       
                       schleifenindex--;
                    }//while nochZeilenMitNull
                    [self.CleanFenster TitelListeLeeren];
                    [self.CleanFenster deselectNamenListe];
                 }//if (NamenWeg>0)
                 else
                 {
                    //Titel zu tempName zuf√ºgen
                    [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];
                    NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
                    id einTitel;
                    int index=0;
                    while(einTitel=[TitelDicEnum nextObject])		//neue Titel einf√ºllen
                    {
                       [neueTitelArray insertObject:[einTitel objectForKey:titel] atIndex:[neueTitelArray count]];
                       index++;
                    }
                    //NSLog(@"neueTitelArray neu eingef√ºllt aus TitelMitAnzahlArray: \n%@\n",[neueTitelArray description]);
                    //NSLog(@"CleanViewNotifikationAktion: NamenView Zeilennummer:%d Name:%@",ViewZeilennummer,tempName);
                    
                    NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
                    id eineCleanTitelDicZeile;
                    while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
                    {
                       int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
                       
                       //int neueAnzahl=[[eineZeile objectForKey:anzahl]intValue];
                       //NSLog(@"eineZeile: %@ anzahl: %d",[eineZeile description],n);
                       NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:titel]; //Titel aus Clean
                       //NSLog(@"tempTitel: %@\n",[tempTitel description]);
                       
                       
                       if ([neueTitelArray containsObject:tempTitel])
                       {
                          //NSLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                          int neueAnzahl=0;
                          
                          NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                          id eineTitelZeile;
                          int neuerTitelIndex=-1;
                          BOOL NameSchonDa=NO;
                          while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                          {
                             //NSLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                             if ([[eineTitelZeile objectForKey:titel]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                             {
                                if ([[eineCleanTitelDicZeile objectForKey:leser]containsObject:tempName])
                                {
                                   //NSLog(@"Name schon da: %@",tempName);
                                   neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                   NameSchonDa=YES;
                                }
                                else
                                {
                                   //NSLog(@"Name noch nicht da: %@",tempName);
                                   neueAnzahl=[[eineTitelZeile objectForKey:anzahl]intValue];
                                   neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                   gefunden=1;
                                }
                             }
                          }//while
                          if (NameSchonDa)//Einträge l√∂schen
                          {
                             
                             
                             [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                             [neueTitelArray removeObject:tempTitel];
                          }
                          
                          //NSLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                          if (gefunden==1)
                          {
                             
                             int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:anzahl]intValue];//Anzahl Aufnahmen zum titel in Clean
                             
                             //NSLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                             NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:neueAnzahl+alteAnzahl];
                             [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:anzahl];
                             //NSLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                             
                             //neuen namen in Liste 'leser'
                             NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:leser]mutableCopy];
                             if (tempArray)
                             {
                                //NSLog(@"tempArray: %@",[tempArray description]);
                                [tempArray addObject:tempName];
                                //NSLog(@"tempArray neu: %@",[tempArray description]);
                             }
                             [eineCleanTitelDicZeile setObject:tempArray forKey:leser];
                             NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithInt:[tempArray count]];
                             [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:anzleser];
                             
                             //NSLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                             if (neuerTitelIndex>=0)
                             {
                                [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                                [neueTitelArray removeObject:tempTitel];
                             }
                          }//gefunden
                          
                          
                       }//if containsObject
                    }//while tempEnum
                    
                 }//if ! NamenWeg
                 
              }//NOT if nurTitelZuNamen
              
              if	([TitelMitAnzahlArray count]&&(NamenWeg==0)) //es hat noch Titel in TitelMitAnzahlArray
              {
                 //NSLog(@"Es hat noch %d  Titel in TitelMitAnzahlArray",[TitelMitAnzahlArray count]);
                 NSEnumerator* nochTitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
                 id einNeuerTitel;
                 while (einNeuerTitel=[nochTitelEnum nextObject])
                 {
                    NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:titel]
                                                                                    forKey:titel];
                    //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
                    [tempDic setObject:[einNeuerTitel objectForKey:anzahl]
                                forKey:anzahl];
                    //NSArray* tempNamenArray=[NSArray arrayWithObjects:tempName,nil];
                    [tempDic setObject:[NSArray arrayWithObjects:tempName,nil]
                                forKey:leser];
                    [tempDic setObject:[NSNumber numberWithInt:0]
                                forKey:auswahl];
                    [tempDic setObject:[NSNumber numberWithInt:1]
                                forKey:anzleser];
                    
                    //NSLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
                    [CleanTitelDicArray insertObject:tempDic
                                             atIndex:[CleanTitelDicArray count]];
                    
                 }
                 
                 //NSLog(@"CleanViewNotifikationAktion: 4");
                 
                 
              }
              
              
              if([CleanTitelDicArray count])
              {
                 //NSLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
                 [self.CleanFenster setTitelArray:CleanTitelDicArray];
              }//if
              else
              {
                 NSLog(@"CleanTitelDicArray null: %@",[CleanTitelDicArray description]);
                 [self.CleanFenster deselectNamenListe];
              }
              //[CleanFenster deselectself.NamenListe];
              
              
           }break;//NamenViewTag
              
           case TitelViewTag:
           {
              //NSLog(@"CleanViewNotifikationAktion: TitelView Zeilennummer:%d",ViewZeilennummer);
              
           }break;//TitelViewTag
              
              
        }//switch tag
     }
}

- (void)setCleanTitelVonLeser:(NSString*)derLeser
{
   //[CleanFenster TitelListeLeeren];
   NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
   
   NSArray* TitelMitAnzahlArray =[NSArray arrayWithArray:[self TitelMitAnzahlArrayVon:derLeser]];
   if	([TitelMitAnzahlArray count]) //es hat noch Titel in TitelMitAnzahlArray
   {
      //NSLog(@"************setCleanTitelVonLeser: %@ *******Es hat noch %d  Titel in TitelMitAnzahlArray",derLeser, [TitelMitAnzahlArray count]);
      NSEnumerator* TitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
      id einNeuerTitel;
      while (einNeuerTitel=[TitelEnum nextObject])
      {
         NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:titel]
                                                                         forKey:titel];
         //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
         [tempDic setObject:[einNeuerTitel objectForKey:anzahl]
                     forKey:anzahl];
         //NSArray* tempNamenArray=[NSArray arrayWithObjects:derLeser,nil];
         [tempDic setObject:[NSArray arrayWithObjects:derLeser,nil]
                     forKey:leser];
         [tempDic setObject:[NSNumber numberWithInt:0]
                     forKey:auswahl];
         [tempDic setObject:[NSNumber numberWithInt:1]
                     forKey:anzleser];
         
         //NSLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
         [CleanTitelDicArray insertObject:tempDic
                                  atIndex:[CleanTitelDicArray count]];
         
      }
      
      //NSLog(@"CleanViewNotifikationAktion: 4");
      
      if([CleanTitelDicArray count])
      {
         //NSLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
         [self.CleanFenster setTitelArray:CleanTitelDicArray];
      }//if
      
   }
}

- (void)setAlleTitel
{
   NSArray* tempNamenArray=[self.CleanFenster NamenArray];//Namen der Leser
   [self.CleanFenster TitelListeLeeren];
   //NSLog(@"Clean tempNamenArray: %@",[tempNamenArray description]);
   NSEnumerator* NamenResetEnum=[tempNamenArray objectEnumerator];
   id einName;
   while (einName=[NamenResetEnum nextObject])
   {
      //if ([[einName objectForKey:auswahl]intValue])//Name ist angeklickt, also einsetzen
      {
         //NSLog(@"Clean NamenResetEnum: einName objectForKey:name : %@",[[einName objectForKey:name] description]);
         NSString* tempName=[einName objectForKey:name];
         //[self setCleanTitelVonLeser:[einName objectForKey:name]];
         NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
         //						  NSLog(@"\n\n-----------------------------Clean");//leerer Array für schon vorhandenen TitelDics in Clean
         NSMutableArray* neueTitelArray=[[NSMutableArray alloc]initWithCapacity:0]; //Kontrollarray nur mit Titeln
         NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
         //Array mit den Aufnahmen in der Lesebox für den Leser tempName
         [TitelMitAnzahlArray addObjectsFromArray:[self TitelMitAnzahlArrayVon:tempName]];//Titel mit Anzahl von tempName
         {
            //Titel zu tempName zuf√ºgen
            [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];
            NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
            id einTitel;
            int index=0;
            while(einTitel=[TitelDicEnum nextObject])		//in neueTitelArray neue Titel(nur String) einf√ºllen
            {
               [neueTitelArray insertObject:[einTitel objectForKey:titel] atIndex:[neueTitelArray count]];
               index++;
            }
            //NSLog(@"neueTitelArray neu eingef√ºllt aus TitelMitAnzahlArray: \n%@\n",[neueTitelArray description]);
            
            
            NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
            id eineCleanTitelDicZeile;
            while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
            {
               int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
               
               NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:titel]; //Titel aus Clean
               //NSLog(@"tempTitel: %@\n",[tempTitel description]);
               
               if ([neueTitelArray containsObject:tempTitel])//tempTitel ist schon in neueTitelArray
               {
                  //NSLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                  int neueAnzahl=0;
                  
                  NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                  id eineTitelZeile;
                  int neuerTitelIndex=-1;
                  BOOL NameSchonDa=NO;
                  while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                  {
                     //NSLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                     if ([[eineTitelZeile objectForKey:titel]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                     {
                        if ([[eineCleanTitelDicZeile objectForKey:leser]containsObject:tempName])
                        {
                           //NSLog(@"Name schon da: %@",tempName);
                           neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                           NameSchonDa=YES;
                        }
                        else
                        {
                           //NSLog(@"Name noch nicht da: %@",tempName);
                           neueAnzahl=[[eineTitelZeile objectForKey:anzahl]intValue];
                           neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                           gefunden=1;
                        }
                     }
                  }//while
                  if (NameSchonDa)//Einträge l√∂schen
                  {
                     
                     
                     [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                     [neueTitelArray removeObject:tempTitel];
                  }
                  
                  //NSLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                  if (gefunden==1)
                  {
                     
                     int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:anzahl]intValue];//Anzahl Aufnahmen zum titel in Clean
                     
                     //NSLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                     NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:neueAnzahl+alteAnzahl];
                     [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:anzahl];
                     //NSLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                     
                     //neuen namen in Liste 'leser'
                     NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:leser]mutableCopy];
                     if (tempArray)
                     {
                        //NSLog(@"tempArray: %@",[tempArray description]);
                        [tempArray addObject:tempName];
                        //NSLog(@"tempArray neu: %@",[tempArray description]);
                     }
                     [eineCleanTitelDicZeile setObject:tempArray forKey:leser];
                     NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithInt:[tempArray count]];
                     [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:anzleser];
                     
                     //NSLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                     if (neuerTitelIndex>=0)
                     {
                        [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                        [neueTitelArray removeObject:tempTitel];
                     }
                  }//gefunden
                  
                  
               }//if containsObject
            }//while tempEnum
            
         }	//Nicht Namenweg
									//NSLog(@"*TitelMitAnzahlArrayVon: %@   %@",tempName,[TitelMitAnzahlArray description]);
         if	([TitelMitAnzahlArray count]) //es hat noch Titel in TitelMitAnzahlArray
         {
            //NSLog(@"Es hat noch %d  Titel in TitelMitAnzahlArray",[TitelMitAnzahlArray count]);
            NSEnumerator* nochTitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
            id einNeuerTitel;
            while (einNeuerTitel=[nochTitelEnum nextObject])
            {
               NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:titel]
                                                                               forKey:titel];
               //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
               [tempDic setObject:[einNeuerTitel objectForKey:anzahl]
                           forKey:anzahl];
               //NSArray* tempNamenArray=[NSArray arrayWithObjects:tempName,nil];
               [tempDic setObject:[NSArray arrayWithObjects:tempName,nil]
                           forKey:leser];
               [tempDic setObject:[NSNumber numberWithInt:0]
                           forKey:auswahl];
               [tempDic setObject:[NSNumber numberWithInt:1]
                           forKey:anzleser];
               
               //NSLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
               [CleanTitelDicArray insertObject:tempDic
                                        atIndex:[CleanTitelDicArray count]];
               
            }
            
            //NSLog(@"CleanViewNotifikationAktion: 4");
            
            
         }//if TitelArray count
         if([CleanTitelDicArray count])
         {
            //NSLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
            [self.CleanFenster setTitelArray:CleanTitelDicArray];
         }//if
         
      }//if
   }//while
}

- (void)ClearNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Pops des Cleanfensters
   //NSString* clear=@"clear";
   //NSString* selektiertenamenzeile=@"selektiertenamenzeile";
   
   //NSLog(@"CleanNotifikationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Namen
   NSMutableArray* clearNamenArray=[OptionDic objectForKey:@"clearnamen"];
   if (clearNamenArray)
   {
      //NSLog(@"ClearNotificationAktion*** clearNamenArray: %@",[clearNamenArray description]);
      
   }
   
   NSMutableArray* clearTitelArray=[OptionDic objectForKey:@"cleartitel"];
   if (clearTitelArray)
   {
      //NSLog(@"ClearNotificationAktion*** clearTitelArray: %@",[clearTitelArray description]);
   }
   [self Clean:OptionDic];
   //NSNumber* AnzahlNamenNummer=[OptionDic objectForKey:@"AnzahlNamen"];
   
}


- (void)Clean:(NSDictionary*)derCleanDic
{
   int var=[[derCleanDic objectForKey:@"clearentfernen"]intValue];
   int behalten=[[derCleanDic objectForKey:@"clearbehalten"]intValue];
   int anzahlBehalten=[[derCleanDic objectForKey:@"clearanzahl"]intValue];
   if (anzahl<0)
   {
      //NSLog(@"Anzahl nochmals überlegen");
      return;
   }
   NSNumber* FileCreatorNumber=[NSNumber numberWithUnsignedLong:'RPDF'];//Creator der markierten Aufnahmen
   //NSLog(@"Clean:  Variante: %d  behalten: %d  anzahl: %d",var, behalten, anzahl);
   NSMutableArray* clearNamenArray=[derCleanDic objectForKey:@"clearnamen"];
   if (clearNamenArray)
	  {
        //NSLog(@"ClearNotificationAktion*** clearNamenArray: %@",[clearNamenArray description]);
        
        NSMutableArray* clearTitelArray=[derCleanDic objectForKey:@"cleartitel"];//angeklickte Titel
        if (clearTitelArray)
        {
           NSLog(@"Clean*** clearTitelArray: %@",[clearTitelArray description]);
           
           NSMutableArray* DeleteTitelPfadArray=[[NSMutableArray alloc]initWithCapacity:0];//Array für zu l√∂schende Aufnahmen
           
           NSFileManager* Filemanager=[NSFileManager defaultManager];
           NSEnumerator* NamenEnum=[clearNamenArray objectEnumerator];
           id einName;
           while(einName=[NamenEnum nextObject])
           {
              
              NSString* tempNamenPfad=[self.AdminProjektPfad stringByAppendingPathComponent:einName];
              NSLog(@"Clean*** tempNamenPfad %@",tempNamenPfad);
              
              BOOL istOrdner;
              if (([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner])&&istOrdner)
              {
                 NSLog(@"Clean*** Ordner am Pfad %@ ist da",tempNamenPfad);
                 NSMutableArray* tempAufnahmenArray=[[Filemanager contentsOfDirectoryAtPath:tempNamenPfad error:NULL]mutableCopy];
                 
                 if ([tempAufnahmenArray count])
                 {
                    if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
                    {
                       [tempAufnahmenArray removeObjectAtIndex:0];
                    }
                    if ([tempAufnahmenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
                    {
                       [tempAufnahmenArray removeObject:@"Anmerkungen"];
                    }
                    //NSLog(@"Clean*** tempAufnahmenArray: %@",[tempAufnahmenArray description]);
                    //tempAufnahmenArray=(NSMutableArray*)[self sortNachNummer:tempAufnahmenArray];
                    
                    
                    tempAufnahmenArray=[[self sortNachABC:tempAufnahmenArray]mutableCopy];
                    //NSLog(@"Clean*** tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
                    
                    switch (behalten) //
                    {//
                       case 0://nur markierte behalten
                       {
                          NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                          //NSMutableArray* tempDeleteTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                          //int anz=0;
                          id eineAufnahme;
                          while(eineAufnahme=[AufnahmenEnum nextObject])
                          {
                             if ([clearTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                             {
                                NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                                if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                                {
                                   BOOL AdminMark=[self AufnahmeIstMarkiertAnPfad:tempLeserAufnahmePfad];
                                   if (AdminMark)
                                   {
                                      NSLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                   }
                                   else
                                   {
                                      NSLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                      //[DeleteTitelArray addObject:eineAufnahme];
                                      [DeleteTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                      
                                   }
                                   
                                   /*
                                    NSMutableDictionary* AufnahmeAttribute=[[[Filemanager fileAttributesAtPath:tempLeserAufnahmePfad traverseLink:YES]mutableCopy]autorelease];
                                    if (AufnahmeAttribute )
                                    {
                                    
                                    if([AufnahmeAttribute fileHFSCreatorCode]==[FileCreatorNumber intValue])
                                    {
                                    //NSLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                    }
                                    else
                                    {
                                    //NSLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                    //[DeleteTitelArray addObject:eineAufnahme];
                                    [DeleteTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                    }
                                    
                                    
                                    }//if (AufnahmeAttribute )
                                    */
                                }//if tempLeserAufnahmePfad
                             }//if in clearTitelArray
                          }//while AufnahmeEnum
                       }break;
                       case 1://alle bis auf anzahlBehalten löschen
                       {
                          NSArray* tempLeserTitelArray=[self TitelArrayVon:einName anProjektPfad:self.AdminProjektPfad];//Titel der Aufnahmen für den Leser
                          NSEnumerator* LeserTitelEnum=[tempLeserTitelArray objectEnumerator];
                          id einLeserTitel;
                          while(einLeserTitel=[LeserTitelEnum nextObject])
                          {
                             NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                             NSMutableArray* tempDeleteTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                             id eineAufnahme;
                             while(eineAufnahme=[AufnahmenEnum nextObject])
                             {
                                //NSLog(@"einLeserTitel: %@		  AufnahmeTitelVon:eineAufnahme: %@",einLeserTitel,[self AufnahmeTitelVon:eineAufnahme]);
                                if ([clearTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                                {
                                   
                                   NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                                   if ([einLeserTitel isEqualToString:tempTitel])
                                   {
                                      NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                                      NSLog(@"tempLeserAufnahmePfad: %@",tempLeserAufnahmePfad);
                                      
                                      if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                                      {
                                         NSLog(@"tempLeserAufnahmePfad: File da");
                                         [tempDeleteTitelArray addObject:eineAufnahme ];
                                         
                                      }//if tempLeserAufnahmePfad
                                   }
                                }//if in clearTitelArray
                             }//while AufnahmenEnum
                             
                             NSLog(@"einLeserTitel: %@ * tempDeleteTitelArray: %@",einLeserTitel,[tempDeleteTitelArray description]);
                             if ([tempDeleteTitelArray count])
                             {
                                tempDeleteTitelArray=[[self sortNachNummer:tempDeleteTitelArray]mutableCopy];
                                NSLog(@"			*** *** tempDeleteTitelArray nach sort: %@",[tempDeleteTitelArray description]);
                             }
                             
                             NSEnumerator* DeleteEnum=[tempDeleteTitelArray objectEnumerator];
                             id eineDeleteAufnahme;
                             int i=0;
                             while(eineDeleteAufnahme=[DeleteEnum nextObject])
                             {
                                if (i>=anzahlBehalten)//Anzahl zu behaltende Aufnahmen
                                {
                                   //[DeleteTitelArray addObject:eineDeleteAufnahme];
                                   [DeleteTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineDeleteAufnahme]];
                                   
                                }
                                i++;
                             }//while DeleteEnum
                             
                             
                             
                          }//while LeserTitelEnum
                          
                          
                       }break;//case 1
                          
                          
                    }//switch beahlten
                    
                    
                    
                 }//if ([tempTitelArray count])
                 
              }//if fileExists tempNamenPfad
              
           }//while NamenEnum
           
           //NSLog(@"Clean***				*** DeleteTitelPfadArray: %@",[DeleteTitelPfadArray description]);
           if ([DeleteTitelPfadArray count])
           {
              switch (var)
              {
                 case 0://in den Papierkorb
                 {
                    NSLog(@"Clean in Papierkorb");
                    NSEnumerator* clearEnum=[DeleteTitelPfadArray objectEnumerator];
                    id einClearAufnahmePfad;
                    while (einClearAufnahmePfad=[clearEnum nextObject])
                    {
                       [self inPapierkorbMitPfad:einClearAufnahmePfad];
                       
                    }//while clearEnum
                    
                    //
                 }break;
                    
                 case 1://ins Magazin
                 {
                    NSLog(@"Clean ins Magazin");
                    NSEnumerator* magEnum=[DeleteTitelPfadArray objectEnumerator];
                    id einMagazinAufnahmePfad;
                    while (einMagazinAufnahmePfad=[magEnum nextObject])
                    {
                       [self insMagazinMitPfad:einMagazinAufnahmePfad];
                    }//while clearEnum
                 }break;
                 case 2://ex und hopp
                 {
                    NSLog(@"Clean ex");
                    NSEnumerator* exEnum=[DeleteTitelPfadArray objectEnumerator];
                    id einExAufnahmePfad;
                    while (einExAufnahmePfad=[exEnum nextObject])
                    {
                       [self exMitPfad:einExAufnahmePfad];
                    }//while clearEnum
                 }break;
              }//switch
              [self resetAdminPlayer];
              [self setAdminPlayer:self.AdminLeseboxPfad inProjekt:[self.AdminProjektPfad lastPathComponent]];
              
              //TitelArray mit angeklickten Namen neu aufsetzen
              NSArray* tempNamenArray=[self.CleanFenster NamenArray];//Namen der Leser
              [self.CleanFenster TitelListeLeeren];
              //NSLog(@"Clean tempNamenArray: %@",[tempNamenArray description]);
              NSEnumerator* NamenResetEnum=[tempNamenArray objectEnumerator];
              id einName;
              while (einName=[NamenResetEnum nextObject])
              {
                 if ([[einName objectForKey:auswahl]intValue])//Name ist angeklickt, also einsetzen
                 {
                    //NSLog(@"Clean NamenResetEnum: einName objectForKey:name : %@",[[einName objectForKey:name] description]);
                    NSString* tempName=[einName objectForKey:name];
                    //[self setCleanTitelVonLeser:[einName objectForKey:name]];
                    NSMutableArray* CleanTitelDicArray=[[NSMutableArray alloc]initWithCapacity:0];
                    //						NSLog(@"\n\n-----------------------------Clean");//leerer Array für schon vorhandenen TitelDics in Clean
                    NSMutableArray* neueTitelArray=[[NSMutableArray alloc]initWithCapacity:0]; //Kontrollarray nur mit Titeln
                    NSMutableArray* TitelMitAnzahlArray=[[NSMutableArray alloc]initWithCapacity:0];
                    //Array mit den Aufnahmen in der Lesebox für den Leser tempName
                    [TitelMitAnzahlArray addObjectsFromArray:[self TitelMitAnzahlArrayVon:tempName]];//Titel mit Anzahl von tempName
                    {
                       //Titel zu tempName zuf√ºgen
                       [CleanTitelDicArray addObjectsFromArray:[self.CleanFenster TitelArray]];
                       NSEnumerator* TitelDicEnum=[TitelMitAnzahlArray objectEnumerator];
                       id einTitel;
                       int index=0;
                       while(einTitel=[TitelDicEnum nextObject])		//in neueTitelArray neue Titel(nur String) einf√ºllen
                       {
                          [neueTitelArray insertObject:[einTitel objectForKey:titel] atIndex:[neueTitelArray count]];
                          index++;
                       }
                       //NSLog(@"neueTitelArray neu eingef√ºllt aus TitelMitAnzahlArray: \n%@\n",[neueTitelArray description]);
                       
                       
                       NSEnumerator* CleanTitelDicEnum=[CleanTitelDicArray objectEnumerator];	//Array mit Dics  aus Clean
                       id eineCleanTitelDicZeile;
                       while (eineCleanTitelDicZeile=[CleanTitelDicEnum nextObject])//Abfrage, ob neue Title schon in Cleantitel sind
                       {
                          int gefunden=0;//Abfrage Titel in TitelMitAnzahlArray ?
                          
                          NSString* tempTitel=[eineCleanTitelDicZeile objectForKey:titel]; //Titel aus Clean
                          //NSLog(@"tempTitel: %@\n",[tempTitel description]);
                          
                          if ([neueTitelArray containsObject:tempTitel])//tempTitel ist schon in neueTitelArray
                          {
                             //NSLog(@"tempTitel ist schon in neueTitelArray: tempTitel: %@\n",[tempTitel description]);
                             int neueAnzahl=0;
                             
                             NSEnumerator*neueTitelEnum=[TitelMitAnzahlArray objectEnumerator];
                             id eineTitelZeile;
                             int neuerTitelIndex=-1;
                             BOOL NameSchonDa=NO;
                             while ((eineTitelZeile=[neueTitelEnum nextObject])&&!gefunden)
                             {
                                //NSLog(@"eineTitelZeile: %@  ",[eineTitelZeile description]);
                                if ([[eineTitelZeile objectForKey:titel]isEqualToString:tempTitel])//Zeile in titelDic mit diesem Titel
                                {
                                   if ([[eineCleanTitelDicZeile objectForKey:leser]containsObject:tempName])
                                   {
                                      //NSLog(@"Name schon da: %@",tempName);
                                      neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                      NameSchonDa=YES;
                                   }
                                   else
                                   {
                                      //NSLog(@"Name noch nicht da: %@",tempName);
                                      neueAnzahl=[[eineTitelZeile objectForKey:anzahl]intValue];
                                      neuerTitelIndex=[TitelMitAnzahlArray indexOfObject:eineTitelZeile];
                                      gefunden=1;
                                   }
                                }
                             }//while
                             if (NameSchonDa)//Einträge l√∂schen
                             {
                                
                                
                                [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                                [neueTitelArray removeObject:tempTitel];
                             }
                             
                             //NSLog(@"gefunden: %d   neueAnzahl: %d",gefunden,neueAnzahl);//Anzahl Aufnahmen zum titel des neuen Lesers
                             if (gefunden==1)
                             {
                                
                                int alteAnzahl=[[eineCleanTitelDicZeile objectForKey:anzahl]intValue];//Anzahl Aufnahmen zum titel in Clean
                                
                                //NSLog(@"alteAnzahl, %d  neueAnzahl: %d",alteAnzahl,neueAnzahl);
                                NSNumber* neueAnzahlNumber=[NSNumber numberWithInt:neueAnzahl+alteAnzahl];
                                [eineCleanTitelDicZeile setObject:neueAnzahlNumber forKey:anzahl];
                                //NSLog(@"eineCleanTitelDicZeile neu: %@",[eineCleanTitelDicZeile description]);
                                
                                //neuen namen in Liste 'leser'
                                NSMutableArray* tempArray=[[eineCleanTitelDicZeile objectForKey:leser]mutableCopy];
                                if (tempArray)
                                {
                                   //NSLog(@"tempArray: %@",[tempArray description]);
                                   [tempArray addObject:tempName];
                                   //NSLog(@"tempArray neu: %@",[tempArray description]);
                                }
                                [eineCleanTitelDicZeile setObject:tempArray forKey:leser];
                                NSNumber* neueAnzahlLeserNumber=[NSNumber numberWithInt:[tempArray count]];
                                [eineCleanTitelDicZeile setObject:neueAnzahlLeserNumber forKey:anzleser];
                                
                                //NSLog(@"----- eineCleanTitelDicZeile erweitert: %@",[eineCleanTitelDicZeile description]);
                                if (neuerTitelIndex>=0)
                                {
                                   [TitelMitAnzahlArray removeObjectAtIndex:neuerTitelIndex];
                                   [neueTitelArray removeObject:tempTitel];
                                }
                             }//gefunden
                             
                             
                          }//if containsObject
                       }//while tempEnum
                       
                    }	//Nicht Namenweg
                    //NSLog(@"*TitelMitAnzahlArrayVon: %@   %@",tempName,[TitelMitAnzahlArray description]);
                    if	([TitelMitAnzahlArray count]) //es hat noch Titel in TitelMitAnzahlArray
                    {
                       //NSLog(@"Es hat noch %d  Titel in TitelMitAnzahlArray",[TitelMitAnzahlArray count]);
                       NSEnumerator* nochTitelEnum=[TitelMitAnzahlArray objectEnumerator];//Neue Titel in CleanTitelDicArray einsetzen
                       id einNeuerTitel;	
                       while (einNeuerTitel=[nochTitelEnum nextObject])
                       {
                          NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithObject:[einNeuerTitel objectForKey:titel]
                                                                                          forKey:titel];
                          //NSNumber* tempNumber=[einNeuerTitel objectForKey:anzahl];
                          [tempDic setObject:[einNeuerTitel objectForKey:anzahl]
                                      forKey:anzahl];
                          //NSArray* tempNamenArray=[NSArray arrayWithObjects:tempName,nil];
                          [tempDic setObject:[NSArray arrayWithObjects:tempName,nil]
                                      forKey:leser];
                          [tempDic setObject:[NSNumber numberWithInt:0]
                                      forKey:auswahl];
                          [tempDic setObject:[NSNumber numberWithInt:1]
                                      forKey:anzleser];
                          
                          //NSLog(@"CleanViewNotifikationAktion: tempDic für neuen Titel: %@",[tempDic description]);
                          [CleanTitelDicArray insertObject:tempDic 
                                                   atIndex:[CleanTitelDicArray count]];
                          
                       }
                       
                       //NSLog(@"CleanViewNotifikationAktion: 4");
                       
                       
                    }//if TitelArray count
                    if([CleanTitelDicArray count])
                    {
                       //NSLog(@"CleanTitelDicArray neu: %@",[CleanTitelDicArray description]);
                       [self.CleanFenster setTitelArray:CleanTitelDicArray];
                    }//if
                    
                 }//Auswahl=1
                 
              }
           }
           //else
           //{
           //	NSLog(@"Nichts zu l√∂schen");
           //}
        }//if (clearTitelArray)
     }//if (clearNamenArray)
}

// ExportController

- (int)ExportPrefsLesen
{
   self.RPExportdaten=[[NSUserDefaults standardUserDefaults]objectForKey:@"RPExportdatenKey"];
   self.ExportFormatString=[[NSUserDefaults standardUserDefaults]objectForKey:@"RPExportformat"];
   return[self.RPExportdaten length];
}

- (int)ExportPrefsSchreiben
{
   short l=[self.RPExportdaten length];
   if(l>0)
   {
      [[NSUserDefaults standardUserDefaults]setObject:self.RPExportdaten forKey:@"RPExportdatenKey"];
   }
   [[NSUserDefaults standardUserDefaults]setObject:self.ExportFormatString forKey:@"RPExportformat"];
   [[NSUserDefaults standardUserDefaults]synchronize];
   //NSLog(@"ExportFormatString; %@",ExportFormatString);
   
   return 0;
}



- (void)ExportNotificationAktion:(NSNotification*)note
{
   //Aufgerufen nach √Ñnderungen in den Pops des Cleanfensters
   NSString* export=@"export";
   NSString* selektiertenamenzeile=@"selektiertenamenzeile";
   
   //NSLog(@"ExportNotificationAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Namen
   NSMutableArray* exportNamenArray=[OptionDic objectForKey:@"exportnamen"];
   if (exportNamenArray)
   {
      //NSLog(@"ExportNotificationAktion*** exportNamenArray: %@",[exportNamenArray description]);
   }
   
   NSMutableArray* exportTitelArray=[OptionDic objectForKey:@"exporttitel"];
   if (exportTitelArray)
   {
      //NSLog(@"ExportNotificationAktion*** exportTitelArray: %@",[exportTitelArray description]);
   }
   
   NSNumber*  exportVariantenNumber=[OptionDic objectForKey:@"exportvariante"];//markierteAufnahmen oder nach Anzahl
   if (exportVariantenNumber)
   {
      //NSLog(@"ExportNotificationAktion exportVariante: %d",[exportVariantenNumber intValue]);
   }
   
   NSNumber*  exportAnzahlNumber=[OptionDic objectForKey:@"exportanzahl"];//Anzahl zu exportierende A.
   if (exportAnzahlNumber)
   {
      //NSLog(@"ExportNotificationAktion*** exportAnzahl: %d",[exportAnzahlNumber intValue]);
   }
   
   NSString*  exportFormat=[OptionDic objectForKey:@"exportformat"];//Format aus Pop
   if (exportFormat)
   {
      //NSLog(@"ExportNotificationAktion*** exportFormat: %@",[exportFormat description]);
   }
   
   //NSLog(@"ExportNotificationAktion OptionDic: %@",[OptionDic description]);
   
   [self Export:OptionDic];
   NSNumber* AnzahlNamenNummer=[OptionDic objectForKey:@"AnzahlNamen"];
   
}

- (void)ExportFormatDialogAktion:(NSNotification*)note
{
   //Aufgerufen nach Wahl von Optionen
   //NSString* alle=@"alle";
   
   NSLog(@"ExportFormatDialogAktion note: %@",[note object]);
   NSDictionary* OptionDic=[note userInfo];
   
   //Pop AnzahlNamen
   NSNumber* DialogRequest=[OptionDic objectForKey:@"dialog"];
}

- (OSErr)getExportEinstellungenvonAufnahme:(NSString*)derAufnahmePfad
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   OSErr err=0;
   //NSLog(@"getExportEinstellungenvonAufnahme");
   
   if ([Filemanager fileExistsAtPath:derAufnahmePfad])
   {
      NSError* loadErr;
      /*
       NSURL *movieURL = [NSURL fileURLWithPath:derAufnahmePfad];
       QTMovie* tempMovie= [[QTMovie alloc]initWithURL:movieURL error:&loadErr];
       if (loadErr)
       {
       NSAlert *theAlert = [NSAlert alertWithError:loadErr];
       [theAlert runModal]; // Ignore return value.
       }
       if (!tempMovie)
       NSLog(@"Kein Movie da");
       // retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h)
       
       Movie tempExportMovie =[tempMovie quickTimeMovie];
       
       if (!tempMovie)
       {
       NSLog(@"Kein Movie da");
       NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"No movie present.",@"Es ist kein Movie da.")];
       NSAlert *Warnung = [[NSAlert alloc] init];
       [Warnung addButtonWithTitle:@"OK"];
       [Warnung setMessageText:NSLocalizedString(@"Error in export settings",@"Fehler beim Setzen der ExportEinstellungen:")];
       [Warnung setInformativeText:FehlerString];
       [Warnung setAlertStyle:NSWarningAlertStyle];
       [Warnung beginSheetModalForWindow:[self window]
       modalDelegate:nil
       didEndSelector:nil
       contextInfo:nil];
       return -1;
       }
       */
      /* retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h) */
      
      //	Movie tempExportMovie =(Movie) [tempMovie QTMovie];
      
      /*
       if ([tempMovie rate])
       {
       [tempMovie stop];
       }
       */
      /*
       Component c = 0;
       ComponentInstance derExporter = 0;
       
       
       OSType ExportFormatType=kQTFileTypeAIFF;
       
       
       if ([ExportFormatString isEqualToString:AIFF])
       {
       ExportFormatType=kQTFileTypeAIFF;
       }
       else if ([ExportFormatString isEqualToString:AIFC])
       {
       ExportFormatType=kQTFileTypeAIFC;
       }
       else if ([ExportFormatString isEqualToString:WAVE])
       {
       ExportFormatType=kQTFileTypeWave;
       }
       else if ([ExportFormatString isEqualToString:AVI])
       {
       ExportFormatType=kQTFileTypeAVI;
       }
       else if ([ExportFormatString isEqualToString:uLAW])
       {
       ExportFormatType=kQTFileTypeMuLaw;
       }
       else if ([ExportFormatString isEqualToString:AudioCDTrack])
       {
       ExportFormatType=kQTFileTypeAudioCDTrack;
       }
       
       
       else if ([ExportFormatString isEqualToString:MOV])
       {
       ExportFormatType=kQTFileTypeMovie;
       }
       
       
       
       ComponentDescription cd = { MovieExportType,
       ExportFormatType,
       StandardCompressionSubTypeSound,
       hasMovieExportUserInterface,
       hasMovieExportUserInterface };
       */
      /*
       ComponentDescription cd;
       cd.componentType=MovieExportType;
       cd.componentSubType=ExportFormatType;
       cd.componentManufacturer='appl';
       */
      Boolean ignore;
      
      /*
       c = FindNextComponent(0, &cd);
       
       if (!c)
       {
       NSLog(@"getExportEinstellungenVonAufnahme: Keine NextComponent");
       }
       //err = OpenAComponent(c, &theExporter);
       derExporter = OpenComponent(c);
       err=GetMoviesError();
       //NSLog(@"OpenAComponent err: %d",GetMoviesError());
       //NSAssert(err,@"OpenAComponent misslungen: ");
       if (err||derExporter==0)
       {
       NSLog(@"OpenAComponent misslungen: %d",err);
       
       if (derExporter)
       {
       CloseComponent(derExporter);
       }
       NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"No component could be opened.",@"Es konnte keine Komponente geöffnet werden.")];
       NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
       [Warnung addButtonWithTitle:@"OK"];
       //[Warnung addButtonWithTitle:@"Cancel"];
       [Warnung setMessageText:NSLocalizedString(@"Error While Opening Export Components",@"Fehler beim Öffnen der Exportkomponenten.")];
       [Warnung setInformativeText:FehlerString];
       [Warnung setAlertStyle:NSWarningAlertStyle];
       [Warnung beginSheetModalForWindow:[self window]
       modalDelegate:nil
       didEndSelector:nil
       contextInfo:nil];
       return err;
       
       }
       
       Track inTrack=NULL;
       err = MovieExportDoUserDialog(derExporter, tempExportMovie,
       inTrack, 0,
       GetTrackDuration(inTrack), &ignore);
       
       //NSAssert(err,@"MovieExportDoUserDialog misslungen");
       if (err)
       {
       NSLog(@"MovieExportDoUserDialog misslungen: %d  ignore: %d",err,ignore);
       if (derExporter)
       {
       CloseComponent(derExporter);
       }
       
       NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"The export settings dialog could not be opened",@"Das Einstellungenfenster konnten nicht geöffnet werden.")];
       NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
       [Warnung addButtonWithTitle:@"OK"];
       //[Warnung addButtonWithTitle:@"Cancel"];
       [Warnung setMessageText:NSLocalizedString(@"Error With Export Settings",@"Fehler beim Setzen der Exporteinstellungen.")];
       [Warnung setInformativeText:FehlerString];
       [Warnung setAlertStyle:NSWarningAlertStyle];
       [Warnung beginSheetModalForWindow:[self window]
       modalDelegate:nil
       didEndSelector:nil
       contextInfo:nil];
       return err;
       }
       //NSLog(@"getExporteinstellungen vor: RPExportdaten: %\n%@",[RPExportdaten description]);
       
       //QTAtomContainer tempExportSettings;
       err=QTNewAtomContainer(&gExportSettings);
       //QTAtomContainer *ExportSettings;
       if (err)
       {
       NSLog(@"QTNewAtomContainer misslungen: %d",err);
       }
       
       err = MovieExportGetSettingsAsAtomContainer(derExporter,
       &gExportSettings);
       //NSAssert(err,@"MovieExportGetSettingsAsAtomContainer misslungen");
       if (err)
       {
       NSLog(@"MovieExportGetSettingsAsAtomContainer misslungen: %d",err);
       if (derExporter)
       {
       CloseComponent(derExporter);
       }
       NSString* s=NSLocalizedString(@"The Settings couldn't be read.\nError: %d",@"Die Einstellungen konnten nicht gelesen werden.\nFehler: %d:");
       NSString* FehlerString=[NSString stringWithFormat:s,err];
       NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
       [Warnung addButtonWithTitle:@"OK"];
       //[Warnung addButtonWithTitle:@"Cancel"];
       [Warnung setMessageText:@"Fehler beim Lesen der Exporteinstellungen:"];
       [Warnung setInformativeText:FehlerString];
       [Warnung setAlertStyle:NSWarningAlertStyle];
       [Warnung beginSheetModalForWindow:[self window]
       modalDelegate:nil
       didEndSelector:nil
       contextInfo:nil];
       return err;
       
       }//err
       
       //UserData Exportdaten;
       HLock((Handle)gExportSettings);
       long Exportdatenlaenge=GetHandleSize(gExportSettings);
       RPExportdaten=[NSData dataWithBytes:(UInt8*)*gExportSettings length: Exportdatenlaenge];
       //NSLog(@"getExporteinstellungen nach: RPExportdaten: %\n%@",[RPExportdaten description]);
       HUnlock((Handle)gExportSettings);
       //DisposeHandle(tempExportSettings);
       //QTDisposeAtomContainer(gExportSettings);
       short l=[RPExportdaten length];
       if(l>0)
       {
       [[NSUserDefaults standardUserDefaults]setObject:RPExportdaten forKey:@"RPExportdatenKey"];
       }
       [[NSUserDefaults standardUserDefaults]setObject:ExportFormatString forKey:RPExportformatKey];
       
       [[NSUserDefaults standardUserDefaults]synchronize];
       if (derExporter)
       {
       CloseComponent(derExporter);
       
       }
       */
   }
   
   return err;
}

- (OSErr)getExportEinstellungen
{
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   OSErr err=0;
   NSLog(@"getExportEinstellungen");
   /*
    
    Component c = 0;
    ComponentInstance derExporter = 0;
    
    OSType ExportFormatType=kQTFileTypeAIFF;
    
    
    if ([ExportFormatString isEqualToString:AIFF])
    {
    ExportFormatType=kQTFileTypeAIFF;
    }
    else if ([ExportFormatString isEqualToString:AIFC])
    {
    ExportFormatType=kQTFileTypeAIFC;
    }
    else if ([ExportFormatString isEqualToString:WAVE])
    {
    ExportFormatType=kQTFileTypeWave;
    }
    else if ([ExportFormatString isEqualToString:AVI])
    {
    ExportFormatType=kQTFileTypeAVI;
    }
    else if ([ExportFormatString isEqualToString:uLAW])
    {
    ExportFormatType=kQTFileTypeMuLaw;
    }
    else if ([ExportFormatString isEqualToString:AudioCDTrack])
    {
    ExportFormatType=kQTFileTypeAudioCDTrack;
    }
    
    
    else if ([ExportFormatString isEqualToString:MOV])
    {
    ExportFormatType=kQTFileTypeMovie;
    }
    
    
    
    ComponentDescription cd = { MovieExportType,
    ExportFormatType,
    StandardCompressionSubTypeSound,
    hasMovieExportUserInterface,
    hasMovieExportUserInterface };
    
    
    ComponentDescription cd;
    cd.componentType=MovieExportType;
    cd.componentSubType=ExportFormatType;
    cd.componentManufacturer='appl';
    
    Boolean ignore;
    
    c = FindNextComponent(0, &cd);
    
    if (!c)
    {
    NSLog(@"getExportEinstellungen: Keine NextComponent");
    }
    //err = OpenAComponent(c, &theExporter);
    derExporter = OpenComponent(c);
    err=GetMoviesError();
    //NSLog(@"OpenAComponent err: %d",GetMoviesError());
    //NSAssert(err,@"OpenAComponent misslungen: ");
    if (err||derExporter==0)
    {
    NSLog(@"OpenAComponent misslungen: %d",err);
    
    if (derExporter)
    {
				CloseComponent(derExporter);
    }
    NSString* FehlerString=[NSString stringWithString:NSLocalizedString(@"No component could be opened.",@"Es konnte keine Komponente geöffnet werden.")];
    NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
    [Warnung addButtonWithTitle:@"OK"];
    //[Warnung addButtonWithTitle:@"Cancel"];
    [Warnung setMessageText:NSLocalizedString(@"Error While Opening Export Components",@"Fehler beim Öffnen der Exportkomponenten.")];
    [Warnung setInformativeText:FehlerString];
    [Warnung setAlertStyle:NSWarningAlertStyle];
    [Warnung beginSheetModalForWindow:[self window]
    modalDelegate:nil
    didEndSelector:nil
    contextInfo:nil];
    return err;
    
    }
    
    //NSLog(@"getExporteinstellungen vor: RPExportdaten: %\n%@",[RPExportdaten description]);
    
    QTAtomContainer tempExportSettings;
    err=QTNewAtomContainer(&tempExportSettings);
    //QTAtomContainer *tempExportSettings;
    if (err)
    {
    NSLog(@"QTNewAtomContainer misslungen: %d",err);
    }
    
    err = MovieExportGetSettingsAsAtomContainer(derExporter,
    &tempExportSettings);
    //NSAssert(err,@"MovieExportGetSettingsAsAtomContainer misslungen");
    if (err)
    {
    NSLog(@"MovieExportGetSettingsAsAtomContainer misslungen: %d",err);
    if (derExporter)
    {
				CloseComponent(derExporter);
    }
    NSString* s=NSLocalizedString(@"The Settings couldn't be read.\nError: %d",@"Die Einstellungen konnten nicht gelesen werden.\nFehler: %d:");
    NSString* FehlerString=[NSString stringWithFormat:s,err];
    NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
    [Warnung addButtonWithTitle:@"OK"];
    //[Warnung addButtonWithTitle:@"Cancel"];
    [Warnung setMessageText:@"Fehler beim Lesen der Exporteinstellungen:"];
    [Warnung setInformativeText:FehlerString];
    [Warnung setAlertStyle:NSWarningAlertStyle];
    [Warnung beginSheetModalForWindow:[self window]
    modalDelegate:nil
    didEndSelector:nil
    contextInfo:nil];
    return err;
    
    }//err
    
    //UserData Exportdaten;
    HLock((Handle)tempExportSettings);
    long Exportdatenlaenge=GetHandleSize(tempExportSettings);
    RPExportdaten=[NSData dataWithBytes:(UInt8*)*tempExportSettings length: Exportdatenlaenge];
    //NSLog(@"getExporteinstellungen nach: RPExportdaten: %\n%@",[RPExportdaten description]);
    HUnlock((Handle)tempExportSettings);
    //DisposeHandle(tempExportSettings);
    QTDisposeAtomContainer(tempExportSettings);
    short l=[RPExportdaten length];
    if(l>0)
    {
    [[NSUserDefaults standardUserDefaults]setObject:RPExportdaten forKey:@"RPExportdatenKey"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:ExportFormatString forKey:RPExportformatKey];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (derExporter)
    {
    CloseComponent(derExporter);
    
    }
    */
   return err;
}


- (IBAction) AufnahmeExportieren:(id)sender
{
   
   OSErr erfolg=0;
   FSSpec	tempExportFSSpec;
   FSRef tempExportordnerRef;
   short status;
   UniChar buffer[255]; // HFS+ filename max is 255
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   self.ExportOrdnerPfad=[self.AdminLeseboxPfad stringByDeletingLastPathComponent];
   NSString* s=@"LesestudioExport";
   self.ExportOrdnerPfad=[self.ExportOrdnerPfad stringByAppendingPathComponent:s];//Default, wenn keine User-Eingabe
   BOOL istOrdner=NO;
   if (!([Filemanager fileExistsAtPath:self.ExportOrdnerPfad isDirectory:&istOrdner]&& istOrdner))
	  {
        NSLog(@"RPExport nicht da");
        [Filemanager createDirectoryAtPath:self.ExportOrdnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
     }
   
   NSString* ExportAufnahmeName=[self.AdminPlayPfad lastPathComponent];
   //NSLog(@"ExportAufnahmeName: %@",ExportAufnahmeName);
   [ExportAufnahmeName getCharacters:buffer];
   
   //NSLog(@"Nach ExportPanel: ExportOrdnerPfad %@",ExportOrdnerPfad);
   NSString* removePfad=[NSString stringWithString:self.ExportOrdnerPfad];
   removePfad=[removePfad stringByAppendingPathComponent:ExportAufnahmeName];
   
   if ([Filemanager fileExistsAtPath:removePfad])
   {
      erfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:removePfad] error:nil];
      //NSLog(@"File schon da:removeFileAtPath:%d",erfolg);
   }
   
   //Ordner für Ablage ohne showUserSettingsDialog in exportFlags
   //ExportOrdnerPfad=[tempExportOrdnerPfad stringByAppendingPathComponent:@"Export"];
   
   
   status = FSPathMakeRef((UInt8*)[self.ExportOrdnerPfad fileSystemRepresentation],  &tempExportordnerRef, NULL);
   if (status)
   {
      NSLog(@"FSPathMakeRef failed: %d",status);
      return ;
   }
   status = FSCreateFileUnicode(&tempExportordnerRef, [ExportAufnahmeName length],
                                buffer, kFSCatInfoNone, NULL, NULL, &tempExportFSSpec);//SSpec der neuen Aufnahme
   if (status)
   {
      if (status==dupFNErr)
      {
         //NSLog(@"FSCreateFileUnicode doppelt: %d",status);
      }
      else
      {
         //NSLog(@"FSCreateFileUnicode failed: %d",status);
         return;
      }
   }
   
   if ([Filemanager fileExistsAtPath:self.AdminPlayPfad])
   {
      
      
      NSError* loadErr;
      NSURL *movieURL = [NSURL fileURLWithPath:self.AdminPlayPfad];
      
      /*
       QTMovie* tempMovie= [[QTMovie alloc]initWithURL:movieURL error:&loadErr];
       if (loadErr)
       {
       NSAlert *theAlert = [NSAlert alertWithError:loadErr];
       [theAlert runModal]; // Ignore return value.
       }
       if (!tempMovie)
       NSLog(@"Kein Movie da");
       // retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h)
       
       Movie tempExportMovie =[tempMovie quickTimeMovie];
       
       
       
       
       //			NSSavePanel * AdminExportDialog=[NSSavePanel savePanel];
       //			[AdminExportDialog setCanCreateDirectories:YES];
       //			[AdminExportDialog setMessage:@"Wo soll diese Aufnahme gespeichert werden?"];
       
       NSString* tempExportPfad;
       int AdminExportHit=0;
       {
       //LeseboxHit=[LeseboxDialog runModalForDirectory:DocumentsPfad file:@"Lesebox" types:nil];
       //AdminExportHit=[AdminExportDialog runModalForDirectory:NSHomeDirectory() file:@"ExportFile" types:nil];
       }
       //if (AdminExportHit==NSOKButton)
       
       {
       //tempExportPfad=[[AdminExportDialog filename]retain]; //"home"
       
       
       long exportFlags = showUserSettingsDialog |
       movieToFileOnlyExport |
       movieFileSpecValid |
       kQTFileTypeAIFF|
       createMovieFileDeleteCurFile ;
       
       long exportFlags = movieToFileOnlyExport |
       movieFileSpecValid |
       kQTFileTypeAIFF|
       createMovieFileDeleteCurFile ;
       
       
       
       
       
       // If the movie is currently playing stop it
       if (GetMovieRate(tempExportMovie))
       StopMovie(tempExportMovie);
       
       // use the default progress procedure, if any
       SetMovieProgressProc(tempExportMovie,					// the movie specifier
       (MovieProgressUPP)-1L,		// pointer to a progress function; -1 indicades default
       0);						// reference constant
       
       
       
       
       // export the movie into a file
       //NSLog(@"vor ConvertMovieToFile");
       
       OSErr err=ConvertMovieToFile(tempExportMovie,					// the movie to convert
       NULL,						// all tracks in the movie
       &tempExportFSSpec,			// the output file
       0,							// the output file type
       0,							// the output file creator
       smSystemScript,				// the script
       NULL, 						// no resource ID to be returned
       exportFlags,					// no flags
       0L);							// no specific component
       if (err)
       {
       NSLog(@"ConvertMovieToFile misslungen: %d",err);
       //if (theExporter)
       {
       //	CloseComponent(theExporter);
       }
       
       }
       
       }//NSOKButton
       */
   }//File exists
   
   if ([Filemanager fileExistsAtPath:removePfad])
   {
      erfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:removePfad] error:nil];
      //NSLog(@"Export: removeFileAtPath: erfolg: %d",erfolg);
   }
   self.Textchanged=NO;
}


- (int) AufnahmeExportierenMitPfad:(NSString*)derAufnahmePfad
                     mitUserDialog:(BOOL)userDialogOK
                 mitSettingsDialog:(BOOL)settingsDialogOK
{
   BOOL erfolg=NO;
   OSErr err=0;
   FSSpec	tempExportFSSpec;
   FSRef	tempExportFSRef;
   Handle inputDataRef = NULL;
   OSType inputDataRefType = 0;
   
   FSRef tempExportordnerRef;
   short status;
   UniChar buffer[255]; // HFS+ filename max is 255
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   //ExportFormatString=[[[NSUserDefaults standardUserDefaults]stringForKey:RPExportformatKey]mutableCopy];
   
   //RPExportdaten=[[[NSUserDefaults standardUserDefaults]dataForKey:@"RPExportdatenKey"]mutableCopy];
   //NSLog(@"AufnahmeExportierenMitPfad Anfang");
   //NSLog(@"AufnahmeExportierenMitPfad Anfang: RPExportdaten: %\n%@",[RPExportdaten description]);
   
   NSString* ExportAufnahmeName=[derAufnahmePfad lastPathComponent];
   
   /*
    if (userDialogOK)//eventuell andere Pfade
    {
    //NSLog(@"ExportOrdnerPfad: %@",ExportOrdnerPfad);
    NSSavePanel * AdminExportDialog=[NSSavePanel savePanel];
    [AdminExportDialog setCanCreateDirectories:YES];
    [AdminExportDialog setMessage:@"Wo soll die Aufnahme gespeichert werden?"];
    NSLog(@"\nAdminExportDialog: \nExportOrdnerPfad: %@  ExportAufnahmeName: %@",ExportOrdnerPfad,ExportAufnahmeName);
    //		[AdminExportDialog setRequiredFileType:@"aif"];
    //		[AdminExportDialog setRequiredFileType:@"wav"];
    [AdminExportDialog setRequiredFileType:[ExportAufnahmeName pathExtension]];
    [AdminExportDialog setCanCreateDirectories:YES];
    [AdminExportDialog setCanSelectHiddenExtension:YES];
    
    
    
    [AdminExportDialog setDirectory:ExportOrdnerPfad];
    [AdminExportDialog setPrompt:@"Sichern"];
    
    [AdminExportDialog setNameFieldLabel:@"Sichern als:"];
    [AdminExportDialog setTitle:@"Aufnahmen sichern"];
    
    //[[AdminExportDialog title]setFont:TextFont]:
    int AdminExportHit=0;
    {
    //LeseboxHit=[LeseboxDialog runModalForDirectory:DocumentsPfad file:@"Lesebox" types:nil];
    //			AdminExportHit=[AdminExportDialog runModalForDirectory:ExportOrdnerPfad file:ExportAufnahmeName ];
    }
    if (AdminExportHit==NSOKButton)
    {
    NSString* tempExportAufnahmeName=[[AdminExportDialog filename]retain]; //aus Dialog
    ExportAufnahmeName=[tempExportAufnahmeName lastPathComponent];//Neuer Aufnahmename
    ExportOrdnerPfad=[tempExportAufnahmeName stringByDeletingLastPathComponent];//Neuer ExportOrdnerPfad
    NSLog(@"ExportOrdnerPfad: %@",ExportOrdnerPfad);
    
    }
    }
    */
   
   /*
   if ([self.ExportFormatString isEqualToString:AIFF])
   {
      //ExportAufnahmeName=[ExportAufnahmeName stringByDeletingPathExtension];
      
      ExportAufnahmeName=[ExportAufnahmeName stringByAppendingPathExtension:@"aif"];
   }
   else if ([self.ExportFormatString isEqualToString:WAVE])
   {
      //ExportAufnahmeName=[ExportAufnahmeName stringByDeletingPathExtension];
      
      ExportAufnahmeName=[ExportAufnahmeName stringByAppendingPathExtension:@"wav"];
   }
   else if ([self.ExportFormatString isEqualToString:MP3])
   {
      //ExportAufnahmeName=[ExportAufnahmeName stringByDeletingPathExtension];
      
      ExportAufnahmeName=[ExportAufnahmeName stringByAppendingPathExtension:@"mp3"];
      NSLog(@"MP3");
   }
   */
   
   //NSLog(@"ExportPfad: %@ ExportAufnahmeName: %@",derAufnahmePfad,ExportAufnahmeName);
   
   NSString* removePfad=[self.ExportOrdnerPfad stringByAppendingPathComponent:ExportAufnahmeName];
   //NSLog(@"removePfad: %@",removePfad);
   if ([Filemanager fileExistsAtPath:removePfad])
   {
      erfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:removePfad] error:nil];
      //NSLog(@"File schon da: removeFileAtPath:%d",erfolg);
   }
   
   
   /*
    FSSpec testSpec;
    NSURL* AufnahmeURL=[NSURL fileURLWithPath:derAufnahmePfad];
    NSString* URLString=[NSString stringWithFormat:@"%@%@",@"file://",derAufnahmePfad];
    //HRUtilGetFSSpecFromURL([@"file:///path/to/parent/" cString], [@"filename.aiff" cString], &tempExportFSSpec);
    HRUtilGetFSSpecFromURL([URLString cString], [ExportAufnahmeName cString], &testSpec);
    */
   
   
   [ExportAufnahmeName getCharacters:buffer];
   
   //FSRef aus Pfad des Exportordners
   status = FSPathMakeRef((UInt8*)[self.ExportOrdnerPfad fileSystemRepresentation],  &tempExportordnerRef, NULL);
   if (status)
   {
      NSLog(@"FSPathMakeRef failed: %d",status);
      return status;
   }
   NSLog(@"FSPathMakeRef OK: %d",status);
   
   //File einrichten im Exportordners
   status = FSCreateFileUnicode(&tempExportordnerRef, [ExportAufnahmeName length],
                                buffer, kFSCatInfoNone, NULL, &tempExportFSRef, &tempExportFSSpec);//SSpec der neuen Aufnahme
   
   
   NSLog(@"FSCreateFileUnicode OK: %d",status);
   
   /*
    status=FSGetCatalogInfo(&tempExportFSRef,kFSCatInfoNone,NULL,NULL,&tempExportFSSpec,NULL);
    if (status)
    {
    NSLog(@"FSGetCatalogInfo failed: %d",status);
    return status;
    }
    */
   
   if (status)
   {
      if (status==dupFNErr)
      {
         NSLog(@"FSCreateFileUnicode doppelt: %d",status);
      }
      else
      {
         NSLog(@"FSCreateFileUnicode failed: %d",status);
         return status;
      }
   }
   
   if ([Filemanager fileExistsAtPath:removePfad])
   {
      erfolg=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:removePfad] error:nil];
      NSLog(@"File schon da nach FSCreateFileUnicode: removeFileAtPath:%d",erfolg);
   }
   
   
   
   //UInt8	path[1024] = "";
   //status = FSRefMakePath(&tempExportFSRef, path,1024);
   //NSString* neuerPfad=[NSString stringWithCString:(const char *)path];
   //NSLog(@"neuerPfad: %@",neuerPfad);
   
   
   if ([Filemanager fileExistsAtPath:derAufnahmePfad])
   {
      //Movie der Aufnahme einrichten
      NSLog(@"Movie der Aufnahme einrichten: derAufnahmePfad: %@",derAufnahmePfad);
      
      
      NSError* loadErr;
      NSURL *movieURL = [NSURL fileURLWithPath:derAufnahmePfad];
      /*
       QTMovie* tempMovie= [[QTMovie alloc]initWithURL:movieURL error:&loadErr];
       if (loadErr)
       {
       NSAlert *theAlert = [NSAlert alertWithError:loadErr];
       [theAlert runModal]; // Ignore return value.
       }
       if (!tempMovie)
       {
       NSLog(@"Kein Movie da");
       }
       else {
       NSLog(@"Movie da");
       }
       
       // retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h)
       
       Movie tempExportMovie =[tempMovie quickTimeMovie];
       
       // If the movie is currently playing stop it
       
       if ([tempMovie rate])
       {
       [tempMovie stop];
       }
       
       // use the default progress procedure, if any
       SetMovieProgressProc(tempExportMovie,				// the movie specifier
       (MovieProgressUPP)-1L,			// pointer to a progress function; -1 indicades default
       0);							// reference constant
       
       ComponentInstance theExporter = 0;
       OSType ExportFormatType=kQTFileTypeAIFF;//default
       
       
       if ([ExportFormatString isEqualToString:AIFF])
       {
       ExportFormatType=kQTFileTypeAIFF;
       }
       else if ([ExportFormatString isEqualToString:WAVE])
       {
       ExportFormatType=kQTFileTypeWave;
       }
       
       
       else if ([ExportFormatString isEqualToString:MOV])
       {
       ExportFormatType=kQTFileTypeMovie;
       }
       
       
       //			ExportFormatType=0L;
       //Component für Export
       Component c = 0;
       
       ComponentDescription cd = { MovieExportType,
       ExportFormatType,
       StandardCompressionSubTypeSound,
       hasMovieExportUserInterface,
       hasMovieExportUserInterface };
       
       
       OSErr err=noErr;
       Boolean ignore;
       
       c = FindNextComponent(0, &cd);
       
       if (!c)
       {
       //NSLog(@"AufnahmeExportierenMitPfad: Keine NextComponent");
       }
       //NSLog(@"AufnahmeExportierenMitPfad: NextComponent OK");
       
       err = OpenAComponent(c, &theExporter);
       //NSLog(@"AufnahmeExportierenMitPfad: OpenAComponent err: %d",err);
       
       if (err||theExporter==0)
       {
       NSLog(@"OpenAComponent misslungen: %d",err);
       if (theExporter)
       {
       CloseComponent(theExporter);
       }
       return err;
       }
       //NSLog(@"AufnahmeExportierenMitPfad: vor settingDialogOK: %d",settingsDialogOK);
       //Einstellungen neu konfigurieren
       
       if (settingsDialogOK)
       {
       NSLog(@"settingsDialogOK");
       Track inTrack=NULL;
       err = MovieExportDoUserDialog(theExporter, tempExportMovie,
       inTrack, 0,
       GetTrackDuration(inTrack), &ignore);
       
       //NSAssert(err,@"MovieExportDoUserDialog misslungen");
       if (err)
       {
       NSLog(@"MovieExportDoUserDialog misslungen: %d  ignore: %d",err,ignore);
       if (theExporter)
       {
       CloseComponent(theExporter);
       }
       
       return err;
       }
       //[self getExportEinstellungen];
       
       
       }//if settingsDialogOK
       //			else
       {
       //NSLog(@"AufnahmeExportierenMitPfad: kein SettingDialogOK");
       QTAtomContainer ExportSettings;
       err=QTNewAtomContainer(&gExportSettings);
       NSLog(@"QTNewAtomContainer err: %d",err);
       int ll=[RPExportdaten length];
       //HLock(ExportSettings);
       err=PtrToHand([RPExportdaten bytes],&gExportSettings,ll);
       NSLog(@"PtrToHand err: %d",err);
       
       //HUnlock(ExportSettings);
       
       err = MovieExportSetSettingsFromAtomContainer(theExporter,gExportSettings);
       //NSLog(@"MovieExportSetSettingsFromAtomContainer err: %d",err);
       
       //NSAssert(err,@"MovieExportGetSettingsAsAtomContainer misslungen");
       if (err)
       {
       NSLog(@"MovieExportSetSettingsFromAtomContainer misslungen: %d",err);
       if (theExporter)
       {
       CloseComponent(theExporter);
       }
       
       return err;
       }
       }
       //OSType ExportFormatType=kQTFileTypeAIFF;
       
       //return err;
       //LAME: exporter: LAMEExporterName
       
       // export the movie into a file
       NSLog(@"vor ConvertMovieToFile");
       
       long exportFlags=0;
       //theExporter=0L;
       if (userDialogOK)
       {
       //NSLog(@"mit userDialog");
       exportFlags = showUserSettingsDialog|
       ExportFormatType|
       movieToFileOnlyExport |
       movieFileSpecValid |
       createMovieFileDeleteCurFile;
       }
       else
       {
       //NSLog(@"Ohne userDialog");
       
       
       exportFlags =ExportFormatType|
       movieToFileOnlyExport |
       movieFileSpecValid |
       createMovieFileDeleteCurFile;
       exportFlags=0L;
       }
       
       //FSSpec vor=tempExportFSSpec;
       if (UserExportParID>0)
       {
       tempExportFSSpec.parID=UserExportParID;
       }
       
       
       err=ConvertMovieToFile(tempExportMovie,					// the movie to convert
       NULL,						// all tracks in the movie
       &tempExportFSSpec,					// the output file
       ExportFormatType,							// the output file type
       0,							// the output file creator
       smSystemScript,				// the script
       NULL, 						// no resource ID to be returned
       0L,//exportFlags,					// no flags
       theExporter);				// no specific component
       //theExporter als component
       
       //NSLog(@"ConvertMovieToFile  vor: %d  nach: %d",vor.parID,tempExportFSSpec.parID);
       
       if (UserExportParID==0)//Erste Aufnahme des Array
       {
       UserExportParID=tempExportFSSpec.parID;
       OSErr err=0;//[self getExportEinstellungen];
       if (err)
       {
       NSLog(@"getExportEinstellungenvonAufnahme misslungen. err: %d",err);
       return ;
       }
       
       }
       
       
       
       if (theExporter)
       {
       
       CloseComponent(theExporter);
       
       }
       // **********
       {
       
       //NSLog(@"ExportFormatString ende: %@",ExportFormatString);
       
       [[NSUserDefaults standardUserDefaults]setObject:ExportFormatString forKey:RPExportformatKey];
       
       [[NSUserDefaults standardUserDefaults]synchronize];
       
       
       
       }
       // ******
       if (err)
       {
       NSLog(@"ConvertMovieToFile misslungen: %d",err);
       if (theExporter)
       {
       CloseComponent(theExporter);
       
       }
       return err;
       }
       
       if (theExporter)
       {
       CloseComponent(theExporter);
       
       }
       */
      
   }//File exists
   
   if ([Filemanager fileExistsAtPath:removePfad])
   {
      //erfolg=[Filemanager removeFileAtPath:removePfad handler:nil];
      //NSLog(@"Export: removeFileAtPath: erfolg: %d",erfolg);
      //err=(erfolg==NO);
   }
   
   return err;
}


- (void) AufnahmenArrayExportieren:(NSArray*)derAufnahmenArray
                     mitUserDialog:(BOOL)userDialogOK
{
   OSErr err=0;
   if ([derAufnahmenArray count]==0)
      return;
   
   self.RPExportdaten=[[[NSUserDefaults standardUserDefaults]dataForKey:@"RPExportdatenKey"]mutableCopy];
   
   self.ExportOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
   //NSLog(@"AufnahmenArrayExportieren\n\n");
   //NSLog(@"AufnahmenArrayExportieren:Nach Dialog: Exportdaten: %@",[RPExportdaten length]);
   
   // 8.12.08: HomeDirectory wieder eingestellt
   //ExportOrdnerPfad=[AdminLeseboxPfad stringByDeletingLastPathComponent];//Documents
   
   NSString* s=@"LesestudioExport";
   self.ExportOrdnerPfad=[self.ExportOrdnerPfad stringByAppendingPathComponent:s];//Default, wenn keine User-Eingabe
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   BOOL istOrdner=NO;
   //	UserExportSpec.parID=0;
   self.UserExportParID=0;
   if ([Filemanager fileExistsAtPath:self.ExportOrdnerPfad isDirectory:&istOrdner]&& istOrdner)
	  {
        
        //NSLog(@"RPExport da");
     }
   else
	  {
        //NSLog(@"RPExport nicht da");
        [Filemanager createDirectoryAtPath:self.ExportOrdnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
     }
   
   NSEnumerator* ExportEnum=[derAufnahmenArray objectEnumerator];
   id einAufnahmePfad;
   int index=0;
   while (einAufnahmePfad=[ExportEnum nextObject])
   {
      //NSLog(@"AufnahmenArrayExportieren: einAufnahmePfad: %@",einAufnahmePfad);
      if (index==0)//Bei erster Aufnahme nach Speicherort fragen
      {
         NSAlert *Warnung = [[NSAlert alloc] init];
         [Warnung addButtonWithTitle:@"OK"];
         [Warnung setMessageText:@"Mehrere Aufnahmen exportieren"];
         NSString* i1= @"Es kann nur der Speicherort gewählt werden.";
         NSString* i2=@"Änderungen im Namen werden ignoriert.";
         NSString* i3=@"Einz. Aufnahmen in Admin";
         NSString* I0=[NSString stringWithFormat:@"%@\n%@\n%@",i1,i2,i3];
         [Warnung setInformativeText:I0];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         //	int Antwort=[Warnung runModal];
         
         NSString* ersteAufnahme=[[derAufnahmenArray objectAtIndex:0]lastPathComponent];
         
         
         NSSavePanel * ExportPanel = [NSSavePanel savePanel];
         [ExportPanel setAllowedFileTypes:[NSArray arrayWithObject:@"aif"]];
         //	[ExportPanel setRequiredFileType:@"wav"];
         [ExportPanel setCanCreateDirectories:YES];
         [ExportPanel setCanSelectHiddenExtension:YES];
         NSString* ExportPanelPfad = [NSHomeDirectory()stringByAppendingPathComponent:@"Desktop"];
         NSLog(@"ExportPanelPfad: %@",ExportPanelPfad);
         [ExportPanel setDirectoryURL:[NSURL fileURLWithPath:ExportPanelPfad]];
         [ExportPanel setNameFieldStringValue:ersteAufnahme];
         NSString* labelString=@"Erste Aufnahme, die im Ordner gesichert wird:";
         [ExportPanel setNameFieldLabel:labelString];
         NSString* titleString=@"Aufnahmen exportieren";
         [ExportPanel setTitle:titleString];
         //ExportOrdnerPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
         
         
         int modalAntwort=[ExportPanel runModal] ;//ForDirectory:ExportOrdnerPfad file:ersteAufnahme];
         //NSLog(@"ExportPanel: modalAntwort: %d",modalAntwort);
         //NSLog(@"AufnahmenArrayExportieren:Nach Dialog: Expotdaten: %@",[RPExportdaten length]);
         switch (modalAntwort)
         {
            case NSFileHandlingPanelOKButton:
            {
               //NSLog(@"ExportPanel: filename: %@ ExportOrdnerPfad: %@",[ExportPanel filename],ExportOrdnerPfad);
               NSString* 	tempExportFilePfad=[[[ExportPanel URL]path]copy];
               //NSLog(@"ExportPanel: filename: %@ tempExportFilePfad: %@",[ExportPanel filename],tempExportFilePfad);
               self.ExportOrdnerPfad=[tempExportFilePfad stringByDeletingLastPathComponent];
               //NSLog(@"ExportPanel: filename: %@ ExportOrdnerPfad: %@",[ExportPanel filename],ExportOrdnerPfad);
               
            }break;
            case NSFileHandlingPanelCancelButton:
            {
               NSLog(@"ExportPanel: keine Eingabe ExportOrdnerPfad: %@",self.ExportOrdnerPfad);
               return;
            }break;
         }//switch
         
         //NSLog(@"AufnahmenArrayExportieren:Nach Dialog: Expotdaten: %d",[RPExportdaten length]);
         
         if ([self.RPExportdaten length]==0)//Noch keine Daten aus Defaults
         {
            NSLog(@"keine RPExportdaten");
            err=[self getExportEinstellungenvonAufnahme:einAufnahmePfad];
            if (err)
            {
               NSLog(@"getExportEinstellungenvonAufnahme: err: %d",err);
               return ;
            }
         }
         else
         {
            NSLog(@"RPExportdaten DA");
            
         }
         //[self setThreadKontroller];
         
         //NSLog(@"AufnahmenarrayExport userDialogOK: %d",userDialogOK);
         [self AufnahmeExportierenMitPfad:einAufnahmePfad
                            mitUserDialog:YES
                        mitSettingsDialog:NO];
         
      }
      else
      {
         //
         //NSLog(@"AufnahmenarrayExport ohne userDialogOK");
         [self AufnahmeExportierenMitPfad:einAufnahmePfad
                            mitUserDialog:NO
                        mitSettingsDialog:NO];
         //
      }
      index++;
   }//ExportEnum
   //NSLog(@"AufnahmenArrayExportieren:2");
   
}//AufnahmenArrayExportieren

- (void)Export:(NSDictionary*)derExportDic
{
   NSLog(@"Export: derExportDic: %@",[derExportDic description]);
   NSFileManager *Filemanager=[NSFileManager defaultManager];
   
   int exportvariante=[[derExportDic objectForKey:@"exportvariante"]intValue];
   int exportformatvariante=[[derExportDic objectForKey:@"exportformatvariante"]intValue];
   NSString* exportformatString=[derExportDic objectForKey:@"exportformat"];
   int anzahlExportieren=[[derExportDic objectForKey:@"exportanzahl"]intValue];
   if (anzahl<0)
   {
      //NSLog(@"Anzahl nochmals überlegen");
      return;
   }
   
   self.ExportFormatString=[NSString stringWithString: exportformatString];
   NSLog(@"Export: ExportFormatString: %@",[self.ExportFormatString description]);
   
   [self ExportPrefsSchreiben];
   
   NSNumber* FileCreatorNumber=[NSNumber numberWithUnsignedLong:'RPDF'];//Creator der markierten Aufnahmen
   //NSLog(@"Clean:  Variante: %d  behalten: %d  anzahl: %d",var, behalten, anzahl);
   NSMutableArray* exportNamenArray=[derExportDic objectForKey:@"exportnamen"];
   
   NSLog(@"Export	exportNamenArray: %@",[exportNamenArray description]);
   
   if (exportNamenArray)
   {
      //NSLog(@"ClearNotificationAktion*** exportNamenArray: %@",[exportNamenArray description]);
      
      NSMutableArray* exportTitelArray=[derExportDic objectForKey:@"exporttitel"];
      NSLog(@"Export	exportTitelArray: %@",[exportTitelArray description]);
      
      if (exportTitelArray)
      {
         //NSLog(@"Export*** exportTitelArray: %@",[exportTitelArray description]);
         //Array für zu l√∂schende Aufnahmen
         NSMutableArray* ExportTitelPfadArray=[[NSMutableArray alloc]initWithCapacity:0];
         
         NSFileManager* Filemanager=[NSFileManager defaultManager];
         NSEnumerator* NamenEnum=[exportNamenArray objectEnumerator];
         id einName;
         while(einName=[NamenEnum nextObject])
         {
            
            NSString* tempNamenPfad=[self.AdminProjektPfad stringByAppendingPathComponent:einName];
            //NSLog(@"Export*** tempNamenPfad %@",tempNamenPfad);
            
            BOOL istOrdner;
            if (([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istOrdner])&&istOrdner)
            {
               //NSLog(@"Export*** Ordner am Pfad %@ ist da",tempNamenPfad);
               NSMutableArray* tempAufnahmenArray=[[Filemanager contentsOfDirectoryAtPath:tempNamenPfad error:NULL]mutableCopy];
               int index=0;
               if ([tempAufnahmenArray count])
               {
                  if ([[tempAufnahmenArray objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner entfernen
                  {
                     [tempAufnahmenArray removeObjectAtIndex:0];
                  }
                  if ([tempAufnahmenArray containsObject:@"Anmerkungen"]) // Ordner Kommentar entfernen
                  {
                     [tempAufnahmenArray removeObject:@"Anmerkungen"];
                  }
                  //NSLog(@"Clean*** tempAufnahmenArray: %@",[tempAufnahmenArray description]);
                  //tempAufnahmenArray=(NSMutableArray*)[self sortNachNummer:tempAufnahmenArray];
                  
                  
                  tempAufnahmenArray=[[self sortNachABC:tempAufnahmenArray]mutableCopy];
                  //NSLog(@"Export*** tempAufnahmenArray nach sort: %@",[tempAufnahmenArray description]);
                  
                  switch (exportvariante) //
                  {//
                     case 0://nur markierte exportieren
                     {
                        NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                        NSMutableArray* tempExportTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                        int anz=0;
                        id eineAufnahme;
                        while(eineAufnahme=[AufnahmenEnum nextObject])
                        {
                           if ([exportTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                           {
                              NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                              if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                              {
                                 BOOL AdminMark=[self AufnahmeIstMarkiertAnPfad:tempLeserAufnahmePfad];
                                 if (AdminMark)
                                 {
                                    NSLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                    [ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                    
                                 }
                                 else
                                 {
                                    NSLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                    //[DeleteTitelArray addObject:eineAufnahme];
                                    
                                 }
                                 /*
                                  NSMutableDictionary* AufnahmeAttribute=[[[Filemanager fileAttributesAtPath:tempLeserAufnahmePfad traverseLink:YES]mutableCopy]autorelease];
                                  if (AufnahmeAttribute )
                                  {
                                  
                                  if([AufnahmeAttribute fileHFSCreatorCode]==[FileCreatorNumber intValue])
                                  {
                                  //NSLog(@"Aufnahme %@ ist markiert",eineAufnahme);
                                  [ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineAufnahme]];
                                  }
                                  else
                                  {
                                  NSLog(@"Aufnahme %@ ist nicht markiert",eineAufnahme);
                                  }
                                  }//if (AufnahmeAttribute )
                                  */
                              }//if tempLeserAufnahmePfad
                           }//if in exportTitelArray
                        }//while AufnahmeEnum
                     }break;
                        
                     case 1://Anzahl: anzahlExportieren exportierenn
                     {
                        NSArray* tempLeserTitelArray=[self TitelArrayVon:einName anProjektPfad:self.AdminProjektPfad];
                        NSEnumerator* LeserTitelEnum=[tempLeserTitelArray objectEnumerator];
                        id einLeserTitel;
                        while(einLeserTitel=[LeserTitelEnum nextObject])
                        {
                           NSEnumerator* AufnahmenEnum=[tempAufnahmenArray objectEnumerator];
                           NSMutableArray* tempExportTitelArray=[[NSMutableArray alloc]initWithCapacity:0];
                           int anz=0;
                           id eineAufnahme;
                           while(eineAufnahme=[AufnahmenEnum nextObject])
                           {
                              if ([exportTitelArray containsObject:[self AufnahmeTitelVon:eineAufnahme]])
                              {
                                 
                                 NSString* tempTitel=[self AufnahmeTitelVon:eineAufnahme];
                                 if ([einLeserTitel isEqualToString:tempTitel])
                                 {
                                    NSString* tempLeserAufnahmePfad=[tempNamenPfad stringByAppendingPathComponent:eineAufnahme];
                                    if ([Filemanager fileExistsAtPath:tempLeserAufnahmePfad])
                                    {
                                       [tempExportTitelArray addObject:eineAufnahme ];
                                       
                                    }//if tempLeserAufnahmePfad
                                 }
                              }//if in exportTitelArray
                           }//while AufnahmenEnum
                           
                           //NSLog(@"einLeserTitel: %@ * tempExportTitelArray: %@",einLeserTitel,[tempExportTitelArray description]);
                           if ([tempExportTitelArray count])
                           {
                              tempExportTitelArray=[[self sortNachNummer:tempExportTitelArray]mutableCopy];
                              //NSLog(@"			*** *** tempExportTitelArray nach sort: %@",[tempExportTitelArray description]);
                           }
                           
                           NSEnumerator* ExportEnum=[tempExportTitelArray objectEnumerator];
                           id eineExportAufnahme;
                           int i=0;
                           while(eineExportAufnahme=[ExportEnum nextObject])
                           {
                              if (i<anzahlExportieren)//Anzahl zu exportierende Aufnahmen
                              {
                                 //[ExportTitelPfadArray addObject:eineExportAufnahme];
                                 [ExportTitelPfadArray addObject:[tempNamenPfad stringByAppendingPathComponent:eineExportAufnahme]];
                                 
                              }
                              i++;
                           }//while ExportEnum
                           
                           
                           
                        }//while LeserTitelEnum
                        
                        
                     }break;//case 1
                        
                        
                  }//switch beahlten
                  
                  
                  
               }//if ([tempTitelArray count])
               
            }//if fileExists tempNamenPfad
            
         }//while NamenEnum
         
         //NSLog(@"Export Ergebnis*** ExportTitelPfadArray: %@",[ExportTitelPfadArray description]);
         if ([ExportTitelPfadArray count])
         {
            
            
            int status=0;
            switch (exportformatvariante)
            {
               case 0://letztes Format
               {
                  NSLog(@"Export mit bisherigem Format");
                  
                  [self AufnahmenArrayExportieren: ExportTitelPfadArray mitUserDialog:NO];
                  
                  
               }break;
                  
               case 1://anderes Format
               {
                  //NSLog(@"Export mit anderem Format");
                  NSEnumerator* exportEnum=[ExportTitelPfadArray objectEnumerator];
                  id einAufnahmePfad;
                  BOOL suchen=YES;
                  OSErr err=0;
                  while ((einAufnahmePfad=[exportEnum nextObject])&&(suchen))
                  {
                     if ([Filemanager fileExistsAtPath:einAufnahmePfad])
                     {
                        OSErr err=[self getExportEinstellungenvonAufnahme:einAufnahmePfad];
                        if (err)
                        {
                           NSLog(@"getExportEinstellungenvonAufnahme misslungen. err: %d",err);
                           return ;
                        }
                        suchen=NO;
                     }
                  }//while exportEnum
                  [self AufnahmenArrayExportieren: ExportTitelPfadArray mitUserDialog:YES];
                  
               }break;
                  
            }//switch
            
            
            
         }
         else
         {
            NSAlert *Warnung = [[NSAlert alloc] init];
            [Warnung addButtonWithTitle:@"OK"];
            [Warnung setMessageText:@"Keine markierten Aufnahmen"];
            [Warnung setAlertStyle:NSWarningAlertStyle];
            
            //[Warnung setIcon:RPImage];
            int antwort=[Warnung runModal];
            
            NSLog(@"Nichts zu exportieren");
         }
      }//if (exportTitelArray)
   }//if (exportNamenArray)
   
}
// KommentarController



- (void)SelectionDidChangeAktion:(NSNotification*)note
{
   //NSLog(@"SelectionDidChangeAktion note: %d",[[note object]numberOfSelectedRows]);
   //[PlayTaste setEnabled:[[note object]numberOfSelectedRows]];
   if ([[note object]numberOfSelectedRows])
   {
      [self.PlayTaste setEnabled:YES];
      
   }
   else
   {
      //NSLog(@"rAdminPlayer: SelectionDidChangeAktion textchanged YES");
      [self backZurListe:NULL];
      [self.PlayTaste setEnabled:NO];
      self.Textchanged=YES;
   }
}

- (void)ButtonWillPopUpAktion:(NSNotification*)note
{
   //NSLog(@"ButtonWillPopUpAktion note: %d",[[note object]tag]);
   
   switch([[note object]tag])
   {
      case 11:
      case 12:
      {
         NSLog(@"rAdminPlayer: ButtonWillPopUpAktion textchanged YES");
         self.Textchanged=YES;
      }break;
         
   }//switch tag
   
   
}

- (void)ComboBoxAktion:(NSNotification*)note
{
   //NSLog(@"ComboBoxAktion note: %d",[[note object]stringValue]);
   NSLog(@"rAdminPlayer: ComboBoxAktion textchanged YES");
   self.Textchanged=YES;
   
}






@end
