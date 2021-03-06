
//
//  rUtils.m
//  RecPlayII
//
//  Created by sysadmin on 26.06.05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "rUtils.h"
/*
extern NSString* projekt;//=@"projekt";
extern NSString* projektpfad;//=@"projektpfad";
extern NSString* archivpfad;//=@"archivpfad";
extern NSString* leseboxpfad;//=@"leseboxpfad";
extern NSString* projektarray;//=@"projektarray";
extern NSString* OK;//=@"OK";
*/
@implementation rUtils


- (id)init
{
  if (self=[super init])
	{
	ULeseboxPfad=[[NSMutableString alloc]initWithCapacity:0];
	UArchivPfad=[[NSMutableString alloc]initWithCapacity:0];
	UProjektPfad=[[NSMutableString alloc]initWithCapacity:0];
	UProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
	UProjektNamenArray=[[NSMutableArray alloc]initWithCapacity:0];

	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(UtilsNotificationAktion:)
			   name:@"Utils"
			 object:nil];
	
	[nc addObserver:self
			   selector:@selector(UKopierOrdnerWahlAktion:)
				   name:@"KopierOrdnerWahl"
				 object:nil];

	[nc addObserver:self
			   selector:@selector(UNamenEntfernenAktion:)
				   name:@"NamenEntfernen"
				 object:nil];

	[nc addObserver:self
			   selector:@selector(UNamenEinsetzenAktion:)
				   name:@"NamenEinsetzen"
				 object:nil];


	[nc addObserver:self
			   selector:@selector(UNamenAusListeAktion:)
				   name:@"NamenAusListe"
				 object:nil];



	}
	TimeoutCount=0;
  return self;
}
- (NSString*)ULeseboxPfad
{
  return  ULeseboxPfad;
}

- (void)setULeseboxPfad:(NSString*)derPfad
{
  ULeseboxPfad=[derPfad mutableCopy];
 
  

}

- (NSString*)UArchivPfad
{
  return UArchivPfad;
}

- (void)setUArchivPfad:(NSString*)derPfad
{
  UArchivPfad=[derPfad mutableCopy];
}

- (NSString*)UProjektPfad
{
  return UProjektPfad;
}

- (void)setUProjektPfad:(NSString*)derPfad
{
  UProjektPfad =[derPfad mutableCopy];

  
}

- (NSString*)UaktuellesProjekt
{
  return UaktuellesProjekt;
}

- (void)setUaktuellesProjekt:(NSString*)dasProjekt
{
  UaktuellesProjekt =[dasProjekt mutableCopy];
  
}

- (NSArray*)UProjektArray
{
  return UProjektArray;
}

- (void)setUProjektArray:(NSArray*)derArray
{
  UProjektArray =[derArray mutableCopy];
  

}




- (void)UtilsNotificationAktion:(NSNotification*)note
{
/*
Setzt die Variablen in Utils.m nach den Vorgaben der PList bei beginn des Programms
*/

 //NSLog(@"\n\n\n*UtilsNotificationAktion start: %@",[[note userInfo]description]);
//NSLog(@"*UtilsNotificationAktion projektwahl: %@",[[note userInfo]objectForKey:@"projektwahl"]);
  //NSLog(@"*UtilsNotificationAktion Umgebung: %d",[[note userInfo]objectForKey:@"umgebung"]);
  
   
 //NSLog(@"*UtilsNotificationAktion projektarray: %@",[[note userInfo]objectForKey:@"projektarray"]);
 if ([[note userInfo] objectForKey:@"projektpfad"])
	{
	NSString* tempProjektPfad=[NSString stringWithString:[[note userInfo] objectForKey:@"projektpfad"]];
	//NSLog(@"*UtilsNotificationAktion tempProjektPfad: %@ ",tempProjektPfad);
	[self setUProjektPfad:tempProjektPfad];
	[self setUaktuellesProjekt:[tempProjektPfad lastPathComponent]];
	//NSLog(@"*UtilsNotificationAktion UProjektPfad: %@ ",UProjektPfad);
	}
  //NSLog(@"*UtilsNotificationAktion 1");
  if ([[note userInfo] objectForKey:@"leseboxpfad"])
  {
	  NSString* tempLeseboxPfad=[NSString stringWithString:[[note userInfo] objectForKey:@"leseboxpfad"]];
	  //NSLog(@"*UtilsNotificationAktion tempLeseboxPfad: %@ ",tempLeseboxPfad);
	  [self setULeseboxPfad:tempLeseboxPfad];
  }
  //NSLog(@"*UtilsNotificationAktion 2");
    if ([[note userInfo] objectForKey:@"archivpfad"])
	{

	NSString* tempArchivPfad=[NSString stringWithString:[[note userInfo] objectForKey:@"archivpfad"]];
	//NSLog(@"*UtilsNotificationAktion note: %@ tempArchivPfad:%@",[[note userInfo]objectForKey:@"archivpfad"],tempArchivPfad);

	[self setUArchivPfad:tempArchivPfad];
	//NSLog(@"*UtilsNotificationAktion  UArchivPfad:%@",UArchivPfad);
	}
  //NSLog(@"*UtilsNotificationAktion 3");
 
  if ([[note userInfo] objectForKey:@"projektarray"])
	{
	 NSArray* tempProjektArray=[NSArray arrayWithArray:[[note userInfo] objectForKey:@"projektarray"]];
	[self setUProjektArray:tempProjektArray];
	//NSLog(@"Utils ende: UProjektArray: \n%@",UProjektArray);
	}
//NSLog(@"Utils ende");
 // NSFileManager *Filemanager=[NSFileManager defaultManager];
  
}
//*******************************
#pragma mark -

- (NSString*)checkHomeLesebox
{
/*
Gibt den Pfad der Lesebox auf home zurück
*/

  BOOL HomeLeseboxDa=NO;
  BOOL istOrdner;
  NSFileManager *Filemanager = [NSFileManager defaultManager];
  NSString* HomeLeseboxPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/Lesebox"];
  HomeLeseboxDa= ([Filemanager fileExistsAtPath:HomeLeseboxPfad isDirectory:&istOrdner]&&istOrdner);
  //NSLog(@"mountedVolume:    HomeLeseboxVolume: %@",[HomeLeseboxPfad description]);	
  if (HomeLeseboxDa)
	return HomeLeseboxPfad;
  else
	return [NSString string];
  
}


- (NSArray*) checkUsersMitLesebox
{
/*
Prüft home und die eingeloggten Benutzer, ob eine Lesebox vorhanden ist. Gibt einen Array mit Dics zurück, 
die in den Userarray des Startfensters eingesetzt werden
Die Dics enthalten den Pfad und eine Anzeige für die Lesebox
*/
	BOOL UserMitLeseboxDa=NO;
	BOOL istOrdner;
	NSString* HomeVolumeString=@"Auf diesem Computer hier";
	NSFileManager *Filemanager = [NSFileManager defaultManager];

	NSString* lb=NSLocalizedString(@"Lesebox",@"Lesebox");
   //NSString* lb=@"Lesebox";
	NSString* cb=NSLocalizedString(@"Anmerkungen",@"Anmerkungen");
	
	NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
	NSMutableArray * UserMitLeseboxArray=[NSMutableArray arrayWithCapacity:0];
	NSMutableDictionary* HomeDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic für Volume
	[HomeDic setObject:HomeVolumeString forKey:@"netzvolumepfad"];
	[HomeDic setObject:[NSHomeDirectory() lastPathComponent] forKey:@"username"];
	
	NSString*HomeLeseboxPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents/",lb];
	[HomeDic setObject:HomeLeseboxPfad forKey:@"userleseboxpfad"];
	[HomeDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
//HomeLeseboxPfad = @"/Users/ruediheimlicher/Documents/Lesebox";
	//NSLog(@"cb: %@  Lesebox: %@ HomeLeseboxPfad: %@",cb,lb,HomeLeseboxPfad);
	
	int HomeLeseboxOK=0;
	if ([Filemanager fileExistsAtPath:HomeLeseboxPfad isDirectory:&istOrdner]&&istOrdner)//Lesebox vorhaanden auf home
		{
			NSLog(@"Utils HomeLeseboxPfad: %@",HomeLeseboxPfad);
			HomeLeseboxOK=2;//Lesebox ist da
			NSDictionary *HomeAttrs = [Filemanager attributesOfItemAtPath:HomeLeseboxPfad error:NULL];
			  if (HomeAttrs) 
				{
               NSString* AccountName = [HomeAttrs objectForKey:NSFileOwnerAccountName];
               //NSLog(@"Utils HomeLeseboxPfad: AccountName: %@",AccountName);
				//NSLog(@"HomeLeseboxPfad: HomeAttrs: %@",[HomeAttrs description]);
				  
				}

		}
	[HomeDic setObject:[NSNumber numberWithBool:HomeLeseboxOK] forKey:@"userleseboxOK"];
	
	[HomeDic setObject:[NSNumber numberWithInt:HomeLeseboxOK] forKey:@"leseboxort"];
	[HomeDic setObject:@"Home" forKey:@"host"];
	[UserMitLeseboxArray addObject:HomeDic];//Dic für das Volume anfügen;
   
			
	//Eingeloggte Volumes mit Lesebox suchen
	NSMutableArray * volumesArray=[NSMutableArray arrayWithArray:[workspace mountedLocalVolumePaths]];
	//NSLog(@"mountedLocalVolumePaths:\nvolumesArray raw: %@   Anzahl Volumes: %d",[volumesArray description],[volumesArray count]);
	
	[volumesArray removeObject:@"/"];
	[volumesArray removeObject:@"/Network"];
	[volumesArray removeObject:@"/Volumes/Untitled"];
	[volumesArray removeObject:@"/net"];
	[volumesArray removeObject:@".TemporaryItems"];
   [volumesArray removeObject:@"/Volumes/MobileBackups"];

	//NSLog(@"mountedLocalVolumePaths:\nvolumesArray sauber: %@   Anzahl Volumes: %d",[volumesArray description],[volumesArray count]);
	int volumesIndex;
	if ([volumesArray count]) //Es sind Volumes eingeloggt
	{
		for (volumesIndex=0;volumesIndex<(int)[volumesArray count];volumesIndex++)
		{		
			
			NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic für Volume
			NSString* NetzVolumePfad=[NSString stringWithString:[volumesArray objectAtIndex:volumesIndex] ];
			//**
			//NSArray* PfadArray = NSSearchPathForDirectoriesInDomains(NSAdminApplicationDirectory,  NSAllDomainsMask, YES);
			//NSLog(@"PfadArray: %@",[PfadArray description]);
			//**
			if ([[NetzVolumePfad lastPathComponent] isEqualToString:@"Schueler"]) // Server
			{
				BOOL UserLeseboxOK =0;
				NSLog(@"Server: NetzVolumePfad: %@",NetzVolumePfad);
				NSMutableArray* KlassenordnerArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:NetzVolumePfad error:NULL];
				[KlassenordnerArray removeObject:@".DS_Store"];
				[KlassenordnerArray removeObject:@"Lerndaten"];
				[KlassenordnerArray removeObject:@"Lesebox"];
				[KlassenordnerArray removeObject:@"SndCalcDaten"];
				[KlassenordnerArray removeObject:@".TemporaryItems"];


				NSLog(@"KlassenordnerArray: %@",[KlassenordnerArray description]);
				
				int KlassenordnerIndex=0;
				for (KlassenordnerIndex=0;KlassenordnerIndex<[KlassenordnerArray count];KlassenordnerIndex++)
				{
					
					
					NSMutableDictionary* tempUserDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic fuer Volume
					NSString* tempVolumeName=[KlassenordnerArray objectAtIndex:KlassenordnerIndex];
					NSLog(@"tempVolumeName: %@",tempVolumeName);
					
					
					NSString* tempNetzVolumePfad=[NetzVolumePfad stringByAppendingPathComponent:[KlassenordnerArray objectAtIndex:KlassenordnerIndex]];
					
					
					//NSLog(@"index: %d tempNetzVolumePfad: %@",KlassenordnerIndex,tempNetzVolumePfad);
					[tempUserDic setObject:[KlassenordnerArray objectAtIndex:KlassenordnerIndex] forKey:@"username"];		//Name des Users oder Volumes
					[tempUserDic setObject:[KlassenordnerArray objectAtIndex:KlassenordnerIndex] forKey:@"host"];
					[tempUserDic setObject:tempNetzVolumePfad forKey:@"netzvolumepfad"];//Pfad des Volumes
					[tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
					
					
					
					//Pruefen, ob auf 'NetzVolumePfad' ein 'Documents'-Ordner mit einer Lesebox vorhanden ist
					
					//Pfad fuer Lesebox in 'Documents'
					NSString*tempNetzUserSndCalcDatenPfad=[tempNetzVolumePfad stringByAppendingFormat:@"%@",lb];	
					//NSLog(@"tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
					BOOL UserSndCalcDatenOK=NO;	//Wird YES wenn SndCalcDaten in Documents des users ist
					
					//Pfad fuer SndCalcDaten auf Volume
					NSString*tempNetzVolumeLeseboxPfad=[tempNetzVolumePfad stringByAppendingPathComponent:lb]; 
					//NSLog(@"tempNetzVolumeLeseboxPfad: %@",tempNetzVolumeLeseboxPfad);
					BOOL VolumeLeseboxOK=NO;	//Wird YES, wenn Lesebox auf Volume ist
					
					int LeseboxOrt=0;		//wird 1 wenn SndCalcDaten auf Volume ist, 2 wenn in 'Documents'
					
					//leere Strings einsetzen
					[tempUserDic setObject:[NSString string] forKey:@"userleseboxdatenpfad"];
					[tempUserDic setObject:[NSString string] forKey:@"volumeleseboxpfad"];//leerer String
				
					/*	
					if ([Filemanager fileExistsAtPath:tempNetzUserSndCalcDatenPfad isDirectory:&istOrdner]&&istOrdner)
					{
						NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzUserSndCalcDatenPfad error:NULL];
						[tempArray removeObject:@".DS_Store"];
						if ([tempArray count])
						{
							//SndCalcDaten in 'Documents'
							//NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDatenPfad: %@",tempNetzUserSndCalcDatenPfad);
							//NSLog(@"SndCalcDaten in 'Documents':	tempNetzUserSndCalcDaten: %@",[[Filemanager directoryContentsAtPath:tempNetzUserSndCalcDatenPfad]description]);
							UserSndCalcDatenOK=YES;//SndCalcDaten ist da
							LeseboxOrt=2;		//in 'Documents'
							UserMitSndCalcDatenDa=YES;
							[tempUserDic setObject:tempNetzUserSndCalcDatenPfad forKey:@"volumeleseboxpfad"];
						}
						
					}
					*/
					
					//Pruefen, ob auf 'tempNetzVolumeLeseboxPfad' eine ordner Lesebox vorhanden ist
					if ([Filemanager fileExistsAtPath:tempNetzVolumeLeseboxPfad isDirectory:&istOrdner]&&istOrdner)
					{
						NSMutableArray* tempArray=(NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:tempNetzVolumeLeseboxPfad error:NULL];
						[tempArray removeObject:@".DS_Store"];
						
						if ([tempArray count])
						{
							//SndCalcDaten auf Volume
							//NSLog(@"SndCalcDaten auf Volume:		tempNetzVolumeLeseboxPfad: %@",tempNetzVolumeLeseboxPfad);
							//NSLog(@"SndCalcDaten auf Volume:	tempNetzVolumeLeseboxPfad: %@",[[Filemanager contentsOfDirectoryAtPath:tempNetzVolumeLeseboxPfad error:NULL]description]);
							VolumeLeseboxOK=YES;//SndCalcDaten ist da
							UserLeseboxOK=YES;
							LeseboxOrt=1;	//auf Volume
							[tempUserDic setObject:tempNetzVolumeLeseboxPfad forKey:@"volumeleseboxpfad"];
						}
						
					}
					
					[tempUserDic setObject:[NSNumber numberWithBool:UserLeseboxOK] forKey:@"userleseboxOK"];
					[tempUserDic setObject:[NSNumber numberWithBool:VolumeLeseboxOK] forKey:@"volumeleseboxOK"];
					[tempUserDic setObject:[NSNumber numberWithInt:LeseboxOrt] forKey:@"leseboxort"];
					
					[UserMitLeseboxArray addObject:tempUserDic];//Dic fuerr das Volume anfuegen;
					
				} // for KlassenordnerIndex
			}
			
			else if (!([[NetzVolumePfad lastPathComponent]isEqualToString:@"Untitled"] ))
			{
				[tempUserDic setObject:[NetzVolumePfad lastPathComponent] forKey:@"username"];		//Name des Users oder Volumes
				[tempUserDic setObject:[NetzVolumePfad lastPathComponent] forKey:@"host"];
				[tempUserDic setObject:NetzVolumePfad forKey:@"netzvolumepfad"];//Pfad des Volumes
				[tempUserDic setObject:[NSNumber numberWithBool:YES] forKey:@"loginOK"];
				
				//Pruefen, ob auf 'NetzVolumePfad' ein 'Documents'-Ordner mit einer Lesebox vorhanden ist
				
				//Pfad fuer Lesebox in 'Documents'
				NSString*tempNetzUserLeseboxPfad=[NetzVolumePfad stringByAppendingFormat:@"%@%@",@"/Documents/",lb];	
				//NSLog(@"tempNetzUserLeseboxPfad: %@",tempNetzUserLeseboxPfad);
				BOOL UserLeseboxOK=NO;	//Wird YES wenn Lesebox in Documents des users ist
				
				//Pfad fuer Lesebox auf Volume
				NSString*tempNetzVolumeLeseboxPfad=[NetzVolumePfad stringByAppendingPathComponent:lb]; 
				//NSLog(@"tempNetzVolumeLeseboxPfad: %@",tempNetzVolumeLeseboxPfad);
				BOOL VolumeLeseboxOK=NO;	//Wird YES, wenn Lesebox auf Volume ist
				
				int LeseboxOrt=0;		//wird 1 wenn Lesebox auf Volume ist, 2 wenn in 'Documents'
				
				if ([Filemanager fileExistsAtPath:tempNetzUserLeseboxPfad isDirectory:&istOrdner]&&istOrdner)
				{
					//Lesebox in 'Documents'
					NSLog(@"Lesebox in 'Documents':	tempNetzUserLeseboxPfad: %@",tempNetzUserLeseboxPfad);
					UserLeseboxOK=YES;//Lesebox ist da
					LeseboxOrt=2;		//in 'Documents'
					UserMitLeseboxDa=YES;
					[tempUserDic setObject:tempNetzUserLeseboxPfad forKey:@"volumeleseboxpfad"];
					
				}
				
				//Pruefen, ob auf 'tempNetzVolumeLeseboxPfad' eine Lesebox vorhanden ist
				else if ([Filemanager fileExistsAtPath:tempNetzVolumeLeseboxPfad isDirectory:&istOrdner]&&istOrdner)
				{
					//Lesebox auf Volume
					//NSLog(@"Lesebox auf Volume:		tempNetzVolumeLeseboxPfad: %@",tempNetzVolumeLeseboxPfad);
					VolumeLeseboxOK=YES;//Lesebox ist da
					UserMitLeseboxDa=YES;
					LeseboxOrt=1;	//auf Volume
					[tempUserDic setObject:tempNetzVolumeLeseboxPfad forKey:@"volumeleseboxpfad"];
				}
				[tempUserDic setObject:[NSNumber numberWithBool:UserLeseboxOK] forKey:@"userleseboxOK"];
				[tempUserDic setObject:[NSNumber numberWithBool:VolumeLeseboxOK] forKey:@"volumeleseboxOK"];
				[tempUserDic setObject:[NSNumber numberWithInt:LeseboxOrt] forKey:@"leseboxort"];
				
				[UserMitLeseboxArray addObject:tempUserDic];//Dic für das Volume anfügen;
			}
		}//for volumesIndex
      
		
		//NSLog(@"UserMitLeseboxArray: %@",[UserMitLeseboxArray description]);
		
		if ([UserMitLeseboxArray count])//Volumes mit Lesebox vorhanden
		{
			
		}
		
	}//volumesArray count
		else
		{
			
			//kein mountedVolume: OpenPanel
			
		}
		
		//NSLog(@"Utils: UserMitLeseboxArray: %@",[UserMitLeseboxArray description]);
	
	
	/*
	
	NSString* scriptString=@"property a: \"Hallo\"\n"
	@"tell application \"System Events\"\n"
	@"set a to name of every disk whose local volume = false as list\n"
	@"end tell\n";
	*/
	
	//NSString* scriptString=@"tell application \"Finder\" to return computer name of (system info)";
	NSString* scriptString=@"tell application \"System Events\" to return  item 1 of  ((name of every disk whose local volume = false) as list)";
		/*
		NSString* AppString=	@"tell application System Events"
									@"set a to name of every disk whose local volume = false as list\n"
									@"end tell\n";
		*/							
		//NSString* AppString=@"tell application System Events get name of every disk whose local volume = false end tell";
		
		NSDictionary *errorDict;
	NSAppleScript *volumeInfoScpt = [[NSAppleScript alloc] initWithSource:scriptString];

// do error processing
NSDictionary *dict = nil;

NSAppleEventDescriptor *netDiskNames = [volumeInfoScpt executeAndReturnError:&dict];

        if (([netDiskNames data]) && (dict==nil)) 
		  {
           //NSLog(@"netDiskNames Data: %@",[netDiskNames stringValue]);
				NSString* aStr;
				aStr = [[NSString alloc] initWithData:[netDiskNames data] encoding:NSASCIIStringEncoding];
                //NSLog(@"netDiskNames: String: %@",aStr);
        } else 
		  {
				//NSLog(@"ERROR: %@",[errorDict objectForKey:@"NSAppleScriptErrorMessage"]);
				NSLog(@"Error: %@ netDiskNames: %@",[dict description],[netDiskNames description]);
			}
		
	//
	
	/*
	   NSString* theScript = @"tell application \"Finder\"\n"
    @"try\n"
    @"set pp to \"/Users/mattneub/Desktop/BrahmsHandel2.mus\"\n"
    @"comment of file (pp as POSIX file)\n"
    @"on error\n"
    @"return \"Error\"\n"
    @"end try\n"
    @"end tell\n";
    //NSDictionary *errorDict= nil;
    NSAppleScript *appleScriptObject = [[NSAppleScript alloc]initWithSource:theScript];
    NSAppleEventDescriptor *eventDescriptor = [appleScriptObject executeAndReturnError: &errorDict];
    [appleScriptObject release];
    if (([eventDescriptor descriptorType]) && (errorDict==nil)) {
        NSLog(@"%@", [eventDescriptor stringValue]);
    } else {
        NSLog(@"%@",[errorDict objectForKey:@"NSAppleScriptErrorMessage"]);
    }	
	*/		
				
	//
		
		
		return UserMitLeseboxArray;
}

- (NSArray*) checkNetzwerkVolumes
{
/*
Gibt die Volumes im Ordner 'Network' zurück
*/

	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* NetzPfad=@"/Network";
		
		NSMutableArray* NetzobjekteArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		NetzobjekteArray=[[Filemanager contentsOfDirectoryAtPath:NetzPfad error:NULL]mutableCopy];
		//NSLog(@"NetzobjekteArray roh: %@",[NetzobjekteArray description]);
		if ([NetzobjekteArray containsObject:@"Library"])
		{
			[NetzobjekteArray removeObject:@"Library"];
		}
		if ([NetzobjekteArray containsObject:@"Servers"])
		{
			[NetzobjekteArray removeObject:@"Servers"];
		}
		if ([NetzobjekteArray containsObject:@".localized"])
		{
			[NetzobjekteArray removeObject:@".localized"];
		}
		[NetzobjekteArray removeObject:@"Users"];
		[NetzobjekteArray removeObject:@"net"];
		[NetzobjekteArray removeObject:@".TemporaryItems"];
		[NetzobjekteArray removeObject:@"Applications"];
		//NSLog(@"NetzobjekteArray sauber: %@",[NetzobjekteArray description]);

		NSMutableArray* NetzobjekteDicArray=[[NSMutableArray alloc]initWithCapacity:0];
	
		if ([NetzobjekteArray count])
		{
			NSEnumerator* NetzObjektEnum=[NetzobjekteArray objectEnumerator];
			id einNetzObjekt;
			while (einNetzObjekt=[NetzObjektEnum nextObject])
			{
			NSString* NetzVolumePfad=@"/Volumes";
			NSMutableDictionary* tempNetworkDic=[[NSMutableDictionary alloc]initWithCapacity:0];//Dic für Volume
			[tempNetworkDic setObject:einNetzObjekt forKey:@"networkname"];
			NSString* LoginCheckPfad=[NetzVolumePfad stringByAppendingPathComponent:einNetzObjekt];
			NSMutableArray* LoginCheckArray=[[NSMutableArray alloc]initWithCapacity:0];
			LoginCheckArray=[[Filemanager contentsOfDirectoryAtPath:NetzVolumePfad error:NULL]mutableCopy];
			//NSLog(@"LoginCheckPfad: %@\nLoginCheckArray roh: %@",LoginCheckPfad,[LoginCheckArray description]);
			if (LoginCheckArray)
			{
				[LoginCheckArray removeObject:@".DS_Store"];
			}
			
			[tempNetworkDic setObject:[NSNumber numberWithBool:NO] forKey:@"networkloginOK"];//Objekt nicht login
				
			[NetzobjekteDicArray addObject:tempNetworkDic];
			}//while einNetzObjekt
			
			int index=0;
			for (index=0;index<[NetzobjekteArray count];index++)
			{
				
			}//for index
				
				//NSLog(@"NetzobjekteArray: \n%@\n",[NetzobjekteArray description]);
		}//if ([NetzobjekteArray count])
		
		//CFStringRef MaschinenName=CSCopyMachineName();
		
		//NSLog(@"MaschinenName: %@    Host names: %@ ",MaschinenName,[[NSHost currentHost] names]);
		//NSLog(@"Host names: %@", [[NSHost currentHost] names]);

		
		//NSLog(@"NetzobjekteDicArray: \n%@\n",[NetzobjekteDicArray description]);
		return NetzobjekteDicArray;
}

- (BOOL)istSystemVolumeAnPfad:(NSString*)derLeseboxPfad		//unused
{
BOOL istSystemVolume=NO;
NSString* UserPfad=[[[derLeseboxPfad copy]stringByDeletingLastPathComponent]stringByDeletingLastPathComponent];
NSString* LibraryPfad=[UserPfad stringByAppendingPathComponent:@"Library"];
NSFileManager *Filemanager=[NSFileManager defaultManager];
if ([Filemanager fileExistsAtPath:LibraryPfad])
{
 istSystemVolume=YES;
 }
 NSLog(@"LibraryPfad: %@  istSystemVolume: %d",LibraryPfad,istSystemVolume);
return istSystemVolume;
}

- (BOOL)setVersion
{
	BOOL versionOK=YES;
	//NSLog(@"resourcePath: %@",[[NSBundle mainBundle]resourcePath]);

	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSCalendarDate* Heute=[NSCalendarDate date];
	int HeuteTag=[Heute dayOfMonth];
	int HeuteMonat=[Heute monthOfYear];
	int HeuteJahr=[Heute yearOfCommonEra];
	//NSLog(@"Heute: %d %d %d",HeuteTag,HeuteMonat,HeuteJahr);
	[Heute setCalendarFormat:@"%d.%m.%Y"];
	//NSLog(@"Heute: %@",[Heute description]);
	NSString* RPVersionString=[NSString stringWithFormat:@"%d.%d",HeuteJahr%2000,HeuteMonat];
	//NSLog(@"RPVersionString: %@",RPVersionString);
//	NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
	NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents"];
	//NSLog(@"ResourcenPfad: %@ Inhalt: %@",ResourcenPfad,[Filemanager contentsOfDirectoryAtPath:ResourcenPfad error:NULL]);
	NSString* InfoPlistPfad=[ResourcenPfad stringByAppendingPathComponent:@"Info.plist"];
	//NSLog(@"Info.plist: %@",[NSString stringWithContentsOfFile:InfoPlistPfad encoding:NSMacOSRomanStringEncoding error:NULL]);
	
	//Aboutfenster: Version setzen
	if ([Filemanager fileExistsAtPath:InfoPlistPfad])
	{
		//NSLog(@"InfoPlistPfad: %@ Inhalt: %@",InfoPlistPfad,[[Filemanager contentsOfDirectoryAtPath:InfoPlistPfad error:NULL]description]);
		NSMutableDictionary* InfoDic=[NSMutableDictionary dictionaryWithContentsOfFile:InfoPlistPfad];
		//NSLog(@"InfoDic: %@",[InfoDic description]);
		
		NSString* RPDictionaryVersionString=[NSString stringWithFormat:@"%d.%d",HeuteJahr%2000,HeuteMonat];
		[InfoDic setObject:RPDictionaryVersionString forKey:@"CFBundleInfoDictionaryVersion"];
		
		NSString* RPShortVersionString=[NSString stringWithFormat:@"%d.%d",HeuteMonat,HeuteTag];
		[InfoDic setObject:RPShortVersionString forKey:@"CFBundleVersion"];
		[InfoDic writeToFile:InfoPlistPfad atomically:YES];
		
	}
	
	//Informationsfenster: Version und Copyright setzen
//	NSString* InfoPlistStringPfad=[ResourcenPfad stringByAppendingPathComponent:@"Resources/German.lproj/InfoPlist.strings"];	
	NSString* InfoPlistStringPfad=[ResourcenPfad stringByAppendingPathComponent:@"Resources/InfoPlist.strings"];	
	if ([Filemanager fileExistsAtPath:InfoPlistStringPfad])
	{
		NSString* InfString=[NSString stringWithContentsOfFile:InfoPlistStringPfad encoding:NSMacOSRomanStringEncoding error:NULL];
		//NSLog(@"InfString: %@",InfString);
		NSMutableDictionary* InfoStringDic=[NSMutableDictionary dictionaryWithContentsOfFile:InfoPlistStringPfad];
		//NSLog(@"InfoStringDic: %@",[InfoStringDic description]);
		[InfoStringDic setObject:RPVersionString forKey:@"CFBundleShortVersionString"];
		
		NSString* SCCopyrightString=[NSString stringWithFormat:@"Lesestudio Version %@, Copyright %d Ruedi Heimlicher.",RPVersionString,HeuteJahr];
		[InfoStringDic setObject:SCCopyrightString forKey:@"CFBundleGetInfoString"];
		
		[InfoStringDic writeToFile:InfoPlistStringPfad atomically:YES];
		
		
	}
	
return versionOK;
}

- (BOOL)LeseboxValidAnPfad:(NSString*)derLeseboxPfad aufSystemVolume:(BOOL)istSystemVolume
{
  BOOL LeseboxValid=NO;
  BOOL ArchivValid=NO;
  BOOL erfolg;
  NSString* BeendenString=NSLocalizedString(@"Beenden",@"Beenden");
  NSFileManager *Filemanager=[NSFileManager defaultManager];
  if ([Filemanager fileExistsAtPath:derLeseboxPfad ])
	{
	LeseboxValid=YES;
	NSLog(@"LeseboxValidAnPfad Lesebox da: derLeseboxPfad: %@",derLeseboxPfad);
	}//exists at LeseboxPfad
  else
  {
	  
	  NSLog(@"Keine Lesebox da LeseboxValidAnPfad: %@",derLeseboxPfad);
	  //PList löschen
	  BOOL DeleteOK=[self deletePListAnPfad:derLeseboxPfad aufSystemVolume:istSystemVolume];
	  NSLog(@"Keine Lesebox da: %@  DeleteOK: %d",derLeseboxPfad,DeleteOK);

	  NSString* LString1=NSLocalizedString(@"The folder 'Lecturebox' can be created on the choosen computer",@"Lesebox kann anlegt werden");
	  NSString* LString2=NSLocalizedString(@"\nA list of names in format .doc, .rtf, or .txt is needed",@"rtf-Klassenliste muss vorhanden sein");
	  NSLog(@"LString1: %@ LString2: %@",LString1,LString2);
	  NSString* LeseboxString=[LString1 stringByAppendingString:LString2];
	  
	  int Antwort=NSRunAlertPanel(@"Neue Lesebox einrichten:", LeseboxString,@"Anlegen",@"Beenden",nil);
	  NSLog(@"Neue  Lesebox: Antwort: %d",Antwort);
	  switch (Antwort)
	  {
		  case 1:
		  {			
			  LeseboxValid=[Filemanager createDirectoryAtPath:derLeseboxPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
			  //NSLog(@"LeseBoxVorhandenAnPfad: LeseboxVorhanden: %d",LeseboxValid);
			  
			  if (!LeseboxValid)
			  {
				  NSString* c1= NSLocalizedString(@"The folder 'Lecturebox' cannot be created on the choosen computer",@"Keine Lesebox auf Computer");
				  NSString* c2= NSLocalizedString(@"Perhaps the user permissions do not allow this",@"Benutzungsrechte fraglich");
				  NSString* WarnString=[NSString stringWithFormat:@"%@\r%@",c1,c2];
				  NSString* TitelStringLB=NSLocalizedString(@"Create Lecturebox:",@"Lesebox einrichten:");
				  
				  
				  
				  int Antwort=NSRunAlertPanel(TitelStringLB,WarnString,BeendenString, nil,nil);
			  //Beenden
				NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
				NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
				[beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
				  
			  }
		  }break;
			  
		  case 0:
		  {
			  NSString* WarnString=NSLocalizedString(@"The lecturebox must be created manually on the choosen computer",@"LB manuelleinrichten");
			  WarnString=[WarnString stringByAppendingString:NSLocalizedString(@"The applicatin will terminate",@"Programm beenden")];
			  NSString* TitelStringNeueLB=NSLocalizedString(@"Create New Lecturebox:",@"Neue Lesebox einrichten:");
			  
			  int Antwort=NSRunAlertPanel(TitelStringNeueLB, WarnString,BeendenString, nil,nil);
			  
			  //Beenden
				NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
				NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
				[beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
		  }break;
	  }
	  
  }//exists not at LeseboxPfad
   
  return LeseboxValid;
}

- (BOOL)ArchivValidAnPfad:(NSString*)derLeseboxPfad
{
  BOOL ArchivValid=0;	
   NSString* TitelStringArchiv=@"Archiv einrichten:";
   //NSString* TitelStringArchiv=NSLocalizedString(@"Creating The Archive:",@"Archiv einrichten:");
  //NSString* BeendenString=NSLocalizedString(@"Quit",@"Beenden");
   NSString* BeendenString=@"Beenden";

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
	  NSString* WarnString=NSLocalizedString(@"The folder 'Archive' cannot be created on the choosen computer",@"Auf dem Computer kein Archiv eingerichtet");
	  int Antwort=NSRunAlertPanel(TitelStringArchiv, WarnString,BeendenString, nil,nil);
  //Beenden
	NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
	NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
	[beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
	  }
	
	}
  return ArchivValid;
}

- (NSString*)stringSauberVon:(NSString*)derString
{
	NSMutableString* tempString=[[NSMutableString alloc]initWithCapacity:0];
	//[derString release];
	tempString=[derString mutableCopy];
	BOOL LeerschlagAmAnfang=YES;
	BOOL LeerschlagAmEnde=YES;
	int index=[tempString length];
	while ((LeerschlagAmAnfang || (LeerschlagAmEnde &&[tempString length]))&&index)
	{
		if ([tempString characterAtIndex:0]==' ')
		{
			[tempString deleteCharactersInRange:NSMakeRange(0,1)];
		}
		else
		{
			LeerschlagAmAnfang=NO;
		}
		if ([tempString characterAtIndex:[tempString length]-1]==' ')
		{
			[tempString deleteCharactersInRange:NSMakeRange([tempString length]-1,1)];
		}
		else
		{
			LeerschlagAmEnde=NO;
		}
		index --;
	}//while
	//NSLog(@"stringSauber: resultString: *%@*",tempString);
	return tempString;
}

- (NSArray*)NamenArrayAusString:(NSString*)derNamenString
{
	NSMutableArray* NamenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	NSMutableString* tempNamenViewString =[derNamenString mutableCopy];
	//NSLog(@"tempNamenViewString: %@",[tempNamenViewString description]);
	int anzCR=[tempNamenViewString replaceOccurrencesOfString:@"\n" 
												   withString:@"\r" 
													  options:NSCaseInsensitiveSearch
														range:NSMakeRange(0, [tempNamenViewString length])];
	//NSLog(@"anzCR: %d",anzCR);
	
	int nochDoppelteCR=YES;
	while (nochDoppelteCR)//Doppelte CR entfernen
	{
		int anzCR=[tempNamenViewString replaceOccurrencesOfString:@"\r\r" 
													   withString:@"\r" 
														  options:NSCaseInsensitiveSearch
															range:NSMakeRange(0, [tempNamenViewString length])];
		//NSLog(@"anzCR: %d",anzCR);
		if (anzCR==0)
		{
			nochDoppelteCR=0;
		}
	}//while
	
	NSMutableCharacterSet* Zeichensatz=[[NSCharacterSet alphanumericCharacterSet]mutableCopy];
	[Zeichensatz addCharactersInString:@" "];
	
	NSArray* tempNamenViewArray=[tempNamenViewString componentsSeparatedByString:@"\r"];
	//	NSArray* tempNamenViewArray=[NSArray arrayWithObjects:@"Hans Meier",@"Fritz Huber",nil];
	//NSLog(@"tempNamenViewArray: %@  %d",[tempNamenViewArray description],[tempNamenViewArray count]);
	NSEnumerator* NamenEnum=[tempNamenViewArray  objectEnumerator];
	
	//NSLog(@"NamenViewArrayEnum: %@",[[NamenEnum allObjects]description]);
	//id eineZeile;
	//while (eineZeile=[NamenEnum nextObject]);
	int i;
	for (i=0;i<[tempNamenViewArray count];i++)
	{
		NSMutableString* tempZeilenstring=[[tempNamenViewArray objectAtIndex:i]mutableCopy];//Namen auf Zeile i
		if ([tempZeilenstring length])
		{
			//NSLog(@"tempZeilenstring  Anfang: %@",tempZeilenstring);
			
			//NSMutableString* tempZeilenstring=(NSMutableString*)eineZeile;
			//NSLog(@"tempZeilenstring: %@  tempZeilenstring Anfang: %@",tempZeilenstring,tempZeilenstring);
			int nochTabs=YES;
			while (nochTabs)//Tabs ersetzen durch Leerschlag
			{
				int anzTabs=[tempZeilenstring replaceOccurrencesOfString:@"\t" 
															  withString:@" " 
																 options:NSCaseInsensitiveSearch
																   range:NSMakeRange(0, [tempZeilenstring length])];
				//NSLog(@"anzTabs: %d",anzTabs);
				if (anzTabs==0)
				{
					nochTabs=0;
				}
			}//while
			int nochDoppelterLeerschlag=YES;
			while (nochDoppelterLeerschlag)//doppelte Leehrschläge entfernen
			{
				int anzLeerschlag=[tempZeilenstring replaceOccurrencesOfString:@"  " 
																	withString:@" " 
																	   options:NSCaseInsensitiveSearch
																		 range:NSMakeRange(0, [tempZeilenstring length])];
				//NSLog(@"anzLeerschlag: %d",anzLeerschlag);
				if (anzLeerschlag==0)
				{
					nochDoppelterLeerschlag=0;
				}
			}//while
			//NSLog(@"tempZeilenstring sauber: %@",tempZeilenstring);
			int illegalesZeichen=0;
			int n;
			for (n=0;n<[tempZeilenstring length];n++)
			{
				//NSLog(@"Zeichen: %c",[tempZeilenstring characterAtIndex:n]);
				if (!([Zeichensatz characterIsMember:[tempZeilenstring characterAtIndex:n]]))
				{
					illegalesZeichen=1;
					//NSLog(@"illegalesZeichen: %c",[tempZeilenstring characterAtIndex:n]);
				}
			}
			//NSLog(@"Nach illegalesZeichen: %d",illegalesZeichen);
			if (illegalesZeichen==0)
			{
				NSArray* tempArray=[tempZeilenstring componentsSeparatedByString:@" "];
				NSMutableArray* tempNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
				int k;
				for (k=0;k<[tempArray count];k++)
				{
					if ([[tempArray objectAtIndex:k]length])
					{
						[tempNamenArray addObject:[tempArray objectAtIndex:k]];
					}
				}
				//NSLog(@"tempNamenArray : %@",[tempNamenArray description]);
				[tempNamenArray removeObjectIdenticalTo:@" "];
				//NSLog(@"tempNamenArray sauber: %@",[tempNamenArray description]);
				NSString* VornamenString;
				NSString* NamenString;
				if ([tempNamenArray count]>1)
				{
					VornamenString=[self stringSauberVon:[tempNamenArray objectAtIndex:0]];
					NamenString=[self stringSauberVon:[tempNamenArray objectAtIndex:[tempNamenArray count]-1]];
					NSString* VornameNamenString=[NSString stringWithFormat:@"%@ %@",VornamenString,NamenString];
					//NSLog(@"VornameNamenString: %@",VornameNamenString);
					NSMutableDictionary* neuerNameDic=[NSMutableDictionary dictionaryWithObject:VornameNamenString forKey:@"namen"];
					[NamenArray addObject: VornameNamenString];
					
				}//if count
				else
				{
					VornamenString=[self stringSauberVon:[tempNamenArray objectAtIndex:0]];
					NSMutableDictionary* neuerNameDic=[NSMutableDictionary dictionaryWithObject:VornamenString forKey:@"namen"];
					[NamenArray addObject: VornamenString];
					
				}
			}
			else
			{
				//Falsches Zeichen
				NSAlert *Warnung = [[NSAlert alloc] init];
				[Warnung addButtonWithTitle:@"OK"];
				//[Warnung addButtonWithTitle:@""];
				//[Warnung addButtonWithTitle:@""];
				//[Warnung addButtonWithTitle:@"Abbrechen"];
				[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Falsches Zeichen"]];
				
				NSString* s1=@"Im Namen ";
				
				NSString* s2=@"hat es ein falsches Zeichen.";
				NSString* s3=@"Der Name wird nicht importiert.";
				NSString* InformationString=[NSString stringWithFormat:@"%@ %@\n%@\n%@",s1,tempZeilenstring,s2,s3];
				[Warnung setInformativeText:InformationString];
				[Warnung setAlertStyle:NSWarningAlertStyle];
				
				int antwort=[Warnung runModal];
				switch (antwort)
				{
					case NSAlertFirstButtonReturn://
					{ 
						NSLog(@"NSAlertFirstButtonReturn");
						
					}break;
						
					case NSAlertSecondButtonReturn://
					{
						NSLog(@"NSAlertSecondButtonReturn");
						
					}break;
					case NSAlertThirdButtonReturn://		
					{
						NSLog(@"NSAlertThirdButtonReturn");
						
					}break;
						
				}//switch
			}
		}//if length
	}//while enumerator
	
	//NSLog(@"NamenArray sauber: %@",[NamenArray description]);
	return NamenArray;
}



- (NSArray*)UOrdnernamenArrayVonKlassenliste
{
	BOOL erfolg;
	NSString* NamenPfad;
	NSMutableArray* KlassenArray=[[NSMutableArray alloc] initWithCapacity:0];
	
	NSOpenPanel * NamenDialog=[NSOpenPanel openPanel];
	[NamenDialog setCanChooseDirectories:NO];
	[NamenDialog setCanChooseFiles:YES];
	[NamenDialog setAllowsMultipleSelection:NO];
	[NamenDialog setMessage:NSLocalizedString(@"Where is the list of names? It must have the format 'doc', 'txt', or 'rtf'", @"Wo ist self.NamenListe?")];
	[NamenDialog 	setCanCreateDirectories:NO];
   [NamenDialog 	setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
	
   int NamenHit=0;
	{
		NSArray* TypesArray=[NSArray arrayWithObjects:@"doc",@"rtf",@"txt",nil];
		//LeseboxHit=[LeseboxDialog runModalForDirectory:DocumentsPfad file:@"Lesebox" types:nil];
		[NamenDialog 	setAllowedFileTypes:TypesArray];
      NamenHit=[NamenDialog runModal];//ForDirectory:NSHomeDirectory() file:@"Documents" types:TypesArray];
	
   }
	if (NamenHit==NSOKButton)
	{
		NamenPfad=[[NamenDialog URL]path]; //"home"
	}		
	else
	{
		return KlassenArray;
	}
	//NSLog(@"NamenPfad: %@",NamenPfad);
	
	NSRect r=NSMakeRect(1,1,1,1);
	NSTextView* KlassenlisteText=[[NSTextView alloc]initWithFrame:r];
	erfolg=[KlassenlisteText readRTFDFromFile:NamenPfad];
	
	NSMutableString* KlassenListeString=[[KlassenlisteText string]mutableCopy];
	NSArray* neuerKlassenArray=[self NamenArrayAusString:KlassenListeString];
	return neuerKlassenArray;
	//NSLog(@"TextViewString: %@",KlassenlisteText );
	
	
	//NSString* Klassenliste=[NSString stringWithContentsOfFile:NamenPfad];
	//NSLog(@"Klassenliste: %@",Klassenliste);
	//NSArray* KlassenlisteArray=[Klassenliste componentsSeparatedByString:@"\r"];
	//NSArray* KlassenlisteArray=[Klassenliste componentsSeparatedByString:@"\n"];
	//NSLog(@"Klassenliste: %@",[KlassenArray description]);
	
	if ([KlassenListeString length])
	{
		if(([[NamenPfad pathExtension]isEqualToString:@"rtf"])||([[NamenPfad pathExtension]isEqualToString:@"doc"]))
		{
			KlassenArray=[[KlassenListeString componentsSeparatedByString:@"\n"]mutableCopy];
		}
		else
		{
			KlassenArray=[[KlassenListeString componentsSeparatedByString:@"\r"]mutableCopy];
		}
		//NSLog(@"KlassenArray: %@",[KlassenArray description]);
		unsigned int Trennstelle=0;
		if([KlassenArray count])
		{
			
			int n=0;
			if (![KlassenArray indexOfObjectIdenticalTo:@""]==NSNotFound)
			{
				int leer=[KlassenArray indexOfObjectIdenticalTo:@""];
				NSLog(@"leer: %d",leer);
			}
			for(n=0;n<[KlassenArray count];n++)
			{
				
			}
			NSCharacterSet* tab=[NSCharacterSet characterSetWithCharactersInString:@"\t"];
			NSCharacterSet* leer=[NSCharacterSet characterSetWithCharactersInString:@" "];
			NSCharacterSet* GROSS=[NSCharacterSet uppercaseLetterCharacterSet];
			NSLog(@"KlassenArray count %d",[KlassenArray count]);
			for(n=0;n<[KlassenArray count];n++)
			{
				NSString* tempOrdnername;
				NSString* tempName=[KlassenArray objectAtIndex:n];
				NSRange Tabulator =[tempName rangeOfCharacterFromSet:tab];
				//NSLog(@"KlassenArray pos: %d  tempName: %@   Tabulator: %d",n,tempName,Tabulator.location);
				NSRange Leerschlag;
				if (Tabulator.location<=[tempName length])
				{
					Trennstelle=Tabulator.location;
				}
				else
				{
					Leerschlag=[tempName rangeOfCharacterFromSet:leer];
					//NSLog(@"KlassenArray tempName: %@   Leerschlag: %d",tempName,Leerschlag.location);
					if (Leerschlag.location<=[tempName length])
					{
						Trennstelle=Leerschlag.location;
					}
					else
					{						
						Trennstelle=[tempName length];
					}
					
				}
				NSRange tempNamenRange=NSMakeRange(0,Trennstelle);
				tempOrdnername=[NSString stringWithString:[tempName substringWithRange:tempNamenRange]];
				//NSLog(@"			KlassenArray tempOrdnername: %@   Trennstelle: %d",tempOrdnername,Trennstelle);
				if (Trennstelle<[tempName length])
				{
					tempOrdnername=[tempOrdnername stringByAppendingString:@" "];
					tempNamenRange=NSMakeRange(Trennstelle+1,[tempName length]-Trennstelle-1);
					NSString* tempNachnamestring=[tempName substringWithRange:tempNamenRange];
					//NSLog(@"tempNachnamestring: %@",tempNachnamestring);
					tempOrdnername=[tempOrdnername stringByAppendingString:[tempName substringWithRange:tempNamenRange]];
				}
				//NSLog(@"KlassenArray def: tempOrdnername: %@",[tempOrdnername description]);
				
				[KlassenArray replaceObjectAtIndex:n withObject:tempOrdnername];
			}//for n
		}
		//NSLog(@"KlassenArray def: %@",[KlassenArray description]);
		if ([KlassenArray containsObject:@""])
		{
			[KlassenArray removeObject:@""];
		}
	}//Klassenliste length
	
	
	return KlassenArray;
}


- (NSDictionary*)UOrdnernamenDicVonKlassenliste
{
  BOOL erfolg;
  NSString* NamenPfad;
	NSMutableDictionary* tempNamenDic=[[NSMutableDictionary alloc]initWithCapacity:0];

  NSMutableArray* KlassenArray=[[NSMutableArray alloc] initWithCapacity:0];
  
  NSOpenPanel * NamenDialog=[NSOpenPanel openPanel];
  [NamenDialog setCanChooseDirectories:NO];
  [NamenDialog setCanChooseFiles:YES];
  [NamenDialog setAllowsMultipleSelection:NO];
  [NamenDialog setMessage:NSLocalizedString(@"Where is the List of Names?",@"Wo ist die self.NamenListe?")];
  [NamenDialog 	setCanCreateDirectories:NO];
  int NamenHit=0;
  {
	//LeseboxHit=[LeseboxDialog runModalForDirectory:DocumentsPfad file:@"Lesebox" types:nil];
     NamenHit=[NamenDialog runModal];// file:@"Documents" types:nil];
     [NamenDialog setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
     
  }
  if (NamenHit==NSOKButton)
	{
	NamenPfad=[[NamenDialog URL]path]; //"home"
	}		
  else
	{
	return tempNamenDic;
	}
  //NSLog(@"NamenPfad: %@",NamenPfad);
  [tempNamenDic setObject:NamenPfad forKey:@"NamenPfad"];

  NSRect r=NSMakeRect(1,1,1,1);
  NSTextView* KlassenlisteText=[[NSTextView alloc]initWithFrame:r];
  erfolg=[KlassenlisteText readRTFDFromFile:NamenPfad];
  NSString* Klassenliste=[NSString stringWithString:[KlassenlisteText string]];
  
  //NSLog(@"TextViewString: %@",KlassenlisteText );
  
  
  //NSString* Klassenliste=[NSString stringWithContentsOfFile:NamenPfad];
  //NSLog(@"Klassenliste: %@",Klassenliste);
  //NSArray* KlassenlisteArray=[Klassenliste componentsSeparatedByString:@"\r"];
  //NSArray* KlassenlisteArray=[Klassenliste componentsSeparatedByString:@"\n"];
  //NSLog(@"Klassenliste: %@",[KlassenArray description]);
  if ([Klassenliste length])
	{
	if(([[NamenPfad pathExtension]isEqualToString:@"rtf"])||([[NamenPfad pathExtension]isEqualToString:@"doc"]))
	  {
	  KlassenArray=[[Klassenliste componentsSeparatedByString:@"\n"]mutableCopy];
	  }
	else
	  {
	  KlassenArray=[[Klassenliste componentsSeparatedByString:@"\r"]mutableCopy];
	  }
	//NSLog(@"KlassenArray: %@",[KlassenArray description]);
	unsigned int Trennstelle=0;
	if([KlassenArray count])
	  {
	  
	  int n=0;
	  if (![KlassenArray indexOfObjectIdenticalTo:@""]==NSNotFound)
		{
		int leer=[KlassenArray indexOfObjectIdenticalTo:@""];
		NSLog(@"leer: %d",leer);
		}
	  for(n=0;n<[KlassenArray count];n++)
		{
		
		}
	  NSCharacterSet* tab=[NSCharacterSet characterSetWithCharactersInString:@"\t"];
	  NSCharacterSet* leer=[NSCharacterSet characterSetWithCharactersInString:@" "];
	  NSCharacterSet* GROSS=[NSCharacterSet uppercaseLetterCharacterSet];
	  NSLog(@"KlassenArray count %d",[KlassenArray count]);
	  for(n=0;n<[KlassenArray count];n++)
		{
		NSString* tempOrdnername;
		NSString* tempName=[KlassenArray objectAtIndex:n];
		NSRange Tabulator =[tempName rangeOfCharacterFromSet:tab];
		//NSLog(@"KlassenArray pos: %d  tempName: %@   Tabulator: %d",n,tempName,Tabulator.location);
		NSRange Leerschlag;
		if (Tabulator.location<=[tempName length])
		  {
		  Trennstelle=Tabulator.location;
		  }
		else
		  {
		  Leerschlag=[tempName rangeOfCharacterFromSet:leer];
		  //NSLog(@"KlassenArray tempName: %@   Leerschlag: %d",tempName,Leerschlag.location);
		  if (Leerschlag.location<=[tempName length])
			{
			Trennstelle=Leerschlag.location;
			}
		  else
			{						
			Trennstelle=[tempName length];
			}
		  
		  }
		NSRange tempNamenRange=NSMakeRange(0,Trennstelle);
		tempOrdnername=[NSString stringWithString:[tempName substringWithRange:tempNamenRange]];
		//NSLog(@"			KlassenArray tempOrdnername: %@   Trennstelle: %d",tempOrdnername,Trennstelle);
		if (Trennstelle<[tempName length])
		  {
		  tempOrdnername=[tempOrdnername stringByAppendingString:@" "];
		  tempNamenRange=NSMakeRange(Trennstelle+1,[tempName length]-Trennstelle-1);
		  NSString* tempNachnamestring=[tempName substringWithRange:tempNamenRange];
		  //NSLog(@"tempNachnamestring: %@",tempNachnamestring);
		  tempOrdnername=[tempOrdnername stringByAppendingString:[tempName substringWithRange:tempNamenRange]];
		  }
		//NSLog(@"KlassenArray def: tempOrdnername: %@",[tempOrdnername description]);
		
		[KlassenArray replaceObjectAtIndex:n withObject:tempOrdnername];
		}//for n
	  }
	NSLog(@"KlassenArray def: %@",[KlassenArray description]);
	if ([KlassenArray containsObject:@""])
	  {
	  [KlassenArray removeObject:@""];
	  }
	}//Klassenliste length
  [tempNamenDic setObject:KlassenArray forKey:@"KlassenArray"];
  
  
  return tempNamenDic;
}



- (NSArray*)ProjektArrayAusPListAnPfad:(NSString*)derLeseboxPfad
{
	//	Array der Projekte laut PList
	NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSString* tempDataPfad=[derLeseboxPfad stringByAppendingPathComponent:@"Data"];
	NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
	NSString* tempPListPfad=[tempDataPfad stringByAppendingPathComponent:PListName];

	NSFileManager *Filemanager=[NSFileManager defaultManager];
	if ([Filemanager fileExistsAtPath:tempPListPfad])
	{
		NSMutableDictionary*  tempPListDic=[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
		if ([tempPListDic objectForKey:@"projektarray"])
		{
			return [tempPListDic objectForKey:@"projektarray"];
		}
	}//if PListPfad
	
	return tempProjektArray;
}


- (int)ProjektArrayInPList:(NSArray*)derProjektArray  anPfad:(NSString*)derLeseboxPfad
{
	//	Array der Projekte in PList einsetzen
	NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSString* tempDataPfad=[derLeseboxPfad stringByAppendingPathComponent:@"Data"];
	NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
	NSString* tempPListPfad=[tempDataPfad stringByAppendingPathComponent:PListName];
	int saveOK=NO;
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	if ([Filemanager fileExistsAtPath:tempPListPfad])
	{
		NSMutableDictionary*  tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
		[tempPListDic setObject:derProjektArray forKey:@"projektarray"];
		saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES ];
		return saveOK;
	}
   return 0;
}

- (NSArray*)ProjektNamenArrayVon:(NSString*)derArchivPfad
{
	//	Array der Projekte laut Archiv
  NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
  NSMutableArray* tempProjektNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
  NSFileManager *Filemanager=[NSFileManager defaultManager];
  BOOL istOrdner=NO;
   //NSLog(@"ProjektNamenArrayVon derArchivPfad: %@",derArchivPfad);
  if ([Filemanager fileExistsAtPath:derArchivPfad isDirectory:&istOrdner]&&istOrdner)
	{
	tempArray=[[Filemanager contentsOfDirectoryAtPath:derArchivPfad error:NULL]mutableCopy];
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

- (BOOL)deletePListAnPfad:(NSString*)derLeseboxPfad aufSystemVolume:(BOOL)istSysVol
{
	BOOL DeleteOK=NO;
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSString* tempUserPfad=[derLeseboxPfad copy];
	NSString* PListPfad;
	NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Name Lesebox.plist");
	NSLog(@"deletePListAnPfad: tempUserPfad start: %@",tempUserPfad);
	if (istSysVol)
	{
		while(![[tempUserPfad lastPathComponent] isEqualToString:@"Documents"])//Pfad von User finden
		{
			tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
			//NSLog(@"tempUserPfad: %@",tempUserPfad);
		}
		tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];//"Documents" entfernen
																	  //NSLog(@"tempUserPfad: %@",tempUserPfad);
		tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Library"];
		tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Preferences"];
		
		PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];//Pfad der PList in der Library auf dem Vol der LB
	}
	else
	{
		PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];//Pfad der PList auf dem Vol der LB

	}
	
	if([Filemanager fileExistsAtPath:PListPfad])
	{
		DeleteOK=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:PListPfad] error:nil];
	}
	return DeleteOK;
}


- (NSDictionary*)PListDicVon:(NSString*)derLeseboxPfad aufSystemVolume:(BOOL)istSysVol
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSMutableArray* tempProjektArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSMutableDictionary* tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];

	NSString* tempUserPfad=[derLeseboxPfad copy];
	//NSLog(@"PListDicVon:	tempUserPfad start: %@",tempUserPfad);
	NSString* tempLibraryPfad=[tempUserPfad stringByAppendingPathComponent:@"Library"];
	//NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
   NSString* PListName=@"Lesebox.plist";

	NSString* PListPfad;
	
	
/*	
	if (istSysVol)//Volume hat ein System
	{
		while(![[tempUserPfad lastPathComponent] isEqualToString:@"Documents"])//Pfad von User finden
		{
			tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];
			//NSLog(@"tempUserPfad: %@",tempUserPfad);
		}
		tempUserPfad=[tempUserPfad stringByDeletingLastPathComponent];//"Documents" entfernen
		NSLog(@"istSysVol	fertig: tempUserPfad: %@",tempUserPfad);
		
		tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Library"];
		tempUserPfad=[tempUserPfad stringByAppendingPathComponent:@"Preferences"];
		PListPfad=[tempUserPfad stringByAppendingPathComponent:PListName];//Pfad der PList auf dem Vol der LB
		//NSLog(@"PListPfad in Library: %@",PListPfad);
	}
	else
*/
	
	{
		
		NSString* DataPfad=[derLeseboxPfad stringByAppendingPathComponent:@"Data"];
		//NSLog(@"PList aus Data: tempUserPfad: %@",DataPfad);
		PListPfad=[DataPfad stringByAppendingPathComponent:PListName];//Pfad der PList auf dem Vol der LB
		//NSLog(@"PListPfad in Lesebox: %@",PListPfad);

	}
	
	//PList lesen
	
	if ([Filemanager fileExistsAtPath:PListPfad])
	{
		tempPListDic=[[NSDictionary dictionaryWithContentsOfFile:PListPfad]mutableCopy];
		if ([[[tempPListDic objectForKey:@"adminpw"]objectForKey:@"pw"]length]==0)
		{
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];			
			[Warnung setMessageText:@"PList lesen: Kein PList-Eintrag fuer 'pw'"];
			[Warnung setAlertStyle:NSWarningAlertStyle];
//			int antwort=[Warnung runModal];
		}
		
		if (![tempPListDic objectForKey:@"adminpw"])
		{	
			NSLog(@"tempPListDic start leeres pw: %@",[tempPListDic description]);
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];			
			[Warnung setMessageText:@"PList lesen: Kein PList-Eintrag fuer 'adminpw'"];
			[Warnung setAlertStyle:NSWarningAlertStyle];
//			int antwort=[Warnung runModal];
			
			NSMutableDictionary* tempPWDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempPWDictionary setObject:@"Admin" forKey:@"name"];
			[tempPWDictionary setObject:[NSData data] forKey:@"pw"];
			[tempPListDic setObject:tempPWDictionary forKey:@"adminpw"];//AdminPasswort muss vorhanden sein
		}
		
		
		if (![[tempPListDic objectForKey:@"adminpw"]objectForKey:@"name"])
		{
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];			
			[Warnung setMessageText:@"PList lesen: Kein PList-Eintrag fuer 'name'"];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			int antwort=[Warnung runModal];
			
			NSMutableDictionary* tempPWDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempPWDictionary setObject:@"Admin" forKey:@"name"];
			[tempPWDictionary setObject:[NSData data] forKey:@"pw"];
			[tempPListDic setObject:tempPWDictionary forKey:@"adminpw"];//AdminPasswort muss vorhanden sein
		}
		
		
		
		
		if (![tempPListDic objectForKey:@"projektarray"])
		{
			[tempPListDic setObject:[NSArray array] forKey:@"projektarray"];
		}
	}
	else
	{
		tempPListDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	}
	
	if (![tempPListDic objectForKey:@"mituserpasswort"])
	{
		// ??[tempPListDic setObject:[tempPListDic objectForKey:@"mituserpasswort"] forKey:@"mituserpasswort"];
		[tempPListDic setObject:[NSNumber numberWithBool:YES] forKey:@"mituserpasswort"];
	}
	

	
	//NSLog(@"Utils tempPListDic end: %@",[tempPListDic description]);
	return tempPListDic;
}




- (IBAction)showProjektNamenListe:(NSArray*)derArray
{
  NSFileManager *Filemanager=[NSFileManager defaultManager];

  NSMutableArray* tempNamenArray=[NSMutableArray arrayWithArray:derArray];
  //NSLog(@"showProjektself.NamenListe start");
  if (!UProjektNamenPanel)
	{
	UProjektNamenPanel=[[rProjektNamen alloc]init];
	}
 // NSLog(@"Utils                      showProjektself.NamenListe nach init:UProjektArray: %@",[UProjektArray description]);
  
  //[ProjektPanel showWindow:self];
  NSModalSession ProjektSession=[NSApp beginModalSessionForWindow:[UProjektNamenPanel window]];
  
  if ([derArray count])
	{
	[UProjektNamenPanel  setOrdnerNamenArray:tempNamenArray];
	}
  int modalAntwort = [NSApp runModalForWindow:[UProjektNamenPanel window]];
  
  //Rückgabe wird von UKopierOrdnerWahlAktion gesetzt: -> UProjektName 
  //int modalAntwort = [NSApp runModalSession:ProjektSession];
  //NSLog(@"showProjektself.NamenListe Antwort: %d",modalAntwort);
  [NSApp endModalSession:ProjektSession];
  //[[ProjektPanel window] orderOut:NULL];   
  
}



- (BOOL)ProjektOrdnerEinrichtenAnPfad:(NSString *)derProjektPfad
{
	NSLog(@"ProjektordnerEinrichten: %@",derProjektPfad);
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	
	NSString* BeendenString=NSLocalizedString(@"Beenden",@"Beenden");
	NSString* tempArchivPfad=[derProjektPfad stringByDeletingLastPathComponent];
	NSString* tempProjektName=[derProjektPfad lastPathComponent];
	BOOL OrdnereinrichtenOK=YES;
	
	int erfolg=[Filemanager createDirectoryAtPath:derProjektPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
	if (!erfolg)//Kein Ordner für das Projekt
	{
		NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:NSLocalizedString(@"Skip",@"Taste: Überspringen")];
		[Warnung addButtonWithTitle:NSLocalizedString(@"Create manually",@"Taste: Manuell einrichten")];
		[Warnung setMessageText:NSLocalizedString(@"No Project in Archiv",@"Kein Projekt")];
		NSString* InfoString1=NSLocalizedString(@"Creation of folder for %@ failed",@"Der Ordner für %@ konnte nicht eingerichtet werden");
		NSString* InfoString2=NSLocalizedString(@"Maybe the name already exists",@"Name ev schon vorhanden");
		NSString* InformationString=[NSString stringWithFormat:InfoString1,InfoString2,tempProjektName];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		//[Warnung setIcon:RPImage];
		int antwort=[Warnung runModal];
		switch (antwort)
		{
			case NSAlertSecondButtonReturn:
			{
				NSLog(@"manuell");
				//Beenden
				NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
				NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
				[beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
			}break;
			case NSAlertFirstButtonReturn://skip
			{
				NSLog(@"skip");
				OrdnereinrichtenOK=NO;
			}//switch
		}
	}//! erfolg
   
	if (OrdnereinrichtenOK)//alles OK
	{
		NSLog(@"Utils           ProjektordnerEinrichtenanPfad OK Pfad: %@  UProjektArray: %@ ",derProjektPfad,[UProjektArray description]);
		
		NSMutableArray* tempProjektNamenListe=[[NSMutableArray alloc]initWithCapacity:0];
		NSAlert *Warnung = [[NSAlert alloc] init];
		BOOL Archivleer=YES;
		if ([UProjektArray count])//es gibt Namen zu kopieren
		{
			[Warnung addButtonWithTitle:NSLocalizedString(@"Copy Folder",@"Taste:Ordner kopieren")];
			Archivleer=NO;
		}
		//else//Archiv ist noch leer: neues Projekt mit einz. Namen eingeben
		{
			//[Warnung addButtonWithTitle:NSLocalizedString(@"Particular Names",@"Taste: Einzelne Namen")];
		}
		
		[Warnung addButtonWithTitle:NSLocalizedString(@"List of Names",@"Taste: Aus self.NamenListe")];
		[Warnung addButtonWithTitle:NSLocalizedString(@"Particular Names",@"Taste: Einzelne Namen")];
		
		NSString* TitelString=NSLocalizedString(@"Project Folder %@ is empty",@"Projektordner %@ ist leer");
		[Warnung setMessageText:[NSString stringWithFormat:TitelString,tempProjektName]];
		
		NSString* s1=NSLocalizedString(@"The names can be copied from another folder, read in from a list of names, or be typed manually.",@"Namen aus Ordner oder Liste kopieren");
		NSString* s2=NSLocalizedString(@"The list of names must be in the format 'doc', 'text', or 'rtf'",@"Format self.NamenListe doc, txt oder rtf");
		NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		NSImage* RecPlayImage = [NSImage imageNamed: @"MicroIcon"];
		
		[Warnung setIcon:RecPlayImage];
		int antwort=[Warnung runModal];
		if (Archivleer)	//Start mit Lesebox, noch kein Ordner da
		{
			switch (antwort)
			{
				case NSAlertFirstButtonReturn://Namen aus self.NamenListe
				{ 
					//NSLog(@"Archiv leer: Aus self.NamenListe");
					tempProjektNamenListe=[[self UOrdnernamenArrayVonKlassenliste]mutableCopy];
					//tempProjektself.NamenListe=[[self OrdnernamenArrayVonKlassenliste]mutableCopy];
					//NSLog(@"OrdnernamenArrayVonKlassenliste: %@",[tempProjektself.NamenListe description]);
					
				}break;
					
				case NSAlertSecondButtonReturn://einzelne Namen eingeben
				{
					//NSLog(@"Archiv leer: einzelne Namen");
					//[self showEinzelNamen:NULL];
					tempProjektNamenListe=[[self EinzelNamenArray]mutableCopy];
				}break;
			}
		}
		else
		{
			switch (antwort)
			{
				case NSAlertFirstButtonReturn://Namen aus einem vorhandenen Projektordner kopieren
				{ 
					NSLog(@"Kopieren");
					NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
					
					tempArray=[[self ProjektNamenArrayVon:[derProjektPfad stringByDeletingLastPathComponent]]mutableCopy];
					//NSLog(@"ProjektnamenArray von Archiv: %@",[tempArray description]);
					if ([tempArray count])
					{
						UProjektNamenArray=[tempArray mutableCopy];
					}
					if ([tempArray containsObject:tempProjektName])
					{
						[tempArray removeObject:tempProjektName];
					}
					
					//leere Projektordnernamen entfernen
					//BOOL istOrdner=NO;
					
					NSEnumerator* NamenEnum=[tempArray objectEnumerator];
					id einProjektName;
					while (einProjektName=[NamenEnum nextObject])
					{
						NSString* tempPfad=[tempArchivPfad stringByAppendingPathComponent:einProjektName];
						//NSLog(@"tempPfad: %@",tempPfad );
						NSMutableArray* tempInhaltArray=[[Filemanager contentsOfDirectoryAtPath:tempPfad error:NULL]mutableCopy];
						//NSLog(@"tempInhaltArray roh: %@",[tempInhaltArray description]);
						if (tempInhaltArray)
						{
							[tempInhaltArray removeObject:@".DS_Store"];
							if ([tempInhaltArray count])//es hat Namen zu kopieren
							{
								[tempProjektNamenListe addObject:einProjektName];
							}
						}
					} 
					
					//NSLog(@"tempProjektself.NamenListe: %@",[tempProjektself.NamenListe description]);
					//ProjektName wird von Notifikation von showProjektself.NamenListe für den Kopiernamen gebraucht
					[self showProjektNamenListe:tempProjektNamenListe];
					
					//NSLog(@"Direkt: KopierOrdnerName: %@",[UProjektNamenPanel KopierOrdnerName]);//zum kopieren ausgew. Name im Panel
					
					BOOL istOrdner=0;
					//NSLog(@"Aus UKopierOrdnerWahlAktion: UProjektName: %@",UProjektName);
					
					if ([UProjektName length])
					{
						//alte Version			NSString* tempKopierOrdnerPfad=[tempArchivPfad stringByAppendingPathComponent:[UProjektNamenPanel KopierOrdnerName]];
						NSString* tempKopierOrdnerPfad=[tempArchivPfad stringByAppendingPathComponent:UProjektName];
						
						//NSLog(@"tempKopierOrdnerPfad: %@",tempKopierOrdnerPfad);
						
						if ([Filemanager fileExistsAtPath:tempKopierOrdnerPfad isDirectory:&istOrdner])
						{
							tempProjektNamenListe=[[Filemanager contentsOfDirectoryAtPath:tempKopierOrdnerPfad error:NULL]mutableCopy];
							if (tempProjektNamenListe &&[tempProjektNamenListe count])
							{
								if ([[tempProjektNamenListe objectAtIndex:0] hasPrefix:@".DS"]) //Unsichtbare Ordner
								{
									[tempProjektNamenListe removeObjectAtIndex:0];
								}
								//NSLog(@"tempProjektself.NamenListe: %@",[tempProjektself.NamenListe description]);
							}//if
						}
						//NSLog(@"tempKopierOrdnerPfad: %@",tempKopierOrdnerPfad);
						UProjektName=tempProjektName;//Projektnamen aus der while-Schlaufe 
					}//if length
					else
					{
						[tempProjektNamenListe removeAllObjects];
					}
				}break;
					
				case NSAlertSecondButtonReturn://Namen aus Nammenliste lesen
				{
					NSLog(@"self.NamenListe");
					tempProjektNamenListe=[[self UOrdnernamenArrayVonKlassenliste]mutableCopy];
					//tempProjektself.NamenListe=[[self OrdnernamenArrayVonKlassenliste]mutableCopy];
					//NSLog(@"OrdnernamenArrayVonKlassenliste: %@",[tempProjektself.NamenListe description]);
					
					
					
				}break;
					
				case NSAlertThirdButtonReturn://Namen aus Nammenliste lesen
				{
					//NSLog(@"Archiv leer: einzelne Namen");
					tempProjektNamenListe=[[self EinzelNamenArray]mutableCopy];
					
				}break;
			}//switch
			
			
		}//Archiv ist nicht leer
		
		if ([tempProjektNamenListe count])//Die self.NamenListe ist nicht leer
		{
			//NSLog(@"Nach Archiv ist nicht leer: tempProjektself.NamenListe: %@",[tempProjektself.NamenListe description]);
			NSEnumerator *enumerator = [tempProjektNamenListe objectEnumerator];
			id tempNamenObjekt;
			int erfolg=1;
			int anzOrdner=0;
			int anzZeilen=0;
			NSString* fehlendeOrdner=[NSString string];
			while((tempNamenObjekt=[enumerator nextObject]))
			{
				NSString* tempName=[tempNamenObjekt description];
				//NSLog(@"neueself.NamenListe: %@ ",tempName);
				if ([tempName length])
				{
					anzZeilen++;
					NSString* tempNamenordnerPfad=[derProjektPfad stringByAppendingPathComponent:tempName];
					//erfolg=[Filemanager createDirectoryAtPath:[derProjektPfad stringByAppendingPathComponent:tempName]  withIntermediateDirectories:NO attributes:NULL error:NULL];
					
					erfolg=[Filemanager createDirectoryAtPath:tempNamenordnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
					//NSLog(@"tempNamenordnerPfad: %@ erfolg: %d",tempNamenordnerPfad, erfolg);
					if (erfolg)
					{
						NSString* tempAnmerkungenOrdnerPfad= [tempNamenordnerPfad stringByAppendingPathComponent:NSLocalizedString(@"Anmerkungen",@"Anmerkungen")];
						erfolg=[Filemanager createDirectoryAtPath:tempAnmerkungenOrdnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
						//NSLog(@"tempAnmerkungenOrdnerPfad: %@ erfolg: %d",tempNamenordnerPfad, erfolg);
					
						anzOrdner++;
					}
					else
					{
						fehlendeOrdner=[fehlendeOrdner stringByAppendingString: tempName];
						fehlendeOrdner=[fehlendeOrdner stringByAppendingString: @", "];
					}
				}
			}//while
			
			//NSLog(@"anzOrdner: %d [tempProjektself.NamenListe count]: %d",anzOrdner,[tempProjektself.NamenListe count]);
			if (anzOrdner<anzZeilen)
			{
				//NSLog(@"vor alert");
				NSString* InformationString=NSLocalizedString(@"The Folders for \n%@ could not be created",@"Keine Projektordner für %@");
				NSAlert* Warnung=[NSAlert alertWithMessageText:NSLocalizedString(@"Missing folders","Fehlende Ordner")
												 defaultButton:NSLocalizedString(@"Continue",@"Weiterfahren")
											   alternateButton:BeendenString
												   otherButton:nil
									 informativeTextWithFormat:InformationString,fehlendeOrdner];
				int antwort=[Warnung runModal];
				switch (antwort)
				{
					case NSAlertDefaultReturn:
					{
						
					}break;
					case NSAlertAlternateReturn:
					{
						//Beenden
						NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
						[BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
						NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
						[beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
					}break;
						
				}//switch antwort
			}//if anz<
		}//tempProjektself.NamenListe count>0
		else
		{
			NSAlert *Warnung = [[NSAlert alloc] init];
			[Warnung addButtonWithTitle:@"OK"];
			//[Warnung addButtonWithTitle:@""];
			//[Warnung addButtonWithTitle:@""];
			//[Warnung addButtonWithTitle:@"Abbrechen"];
			[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Leere self.NamenListe"]];
			NSString* s1=NSLocalizedString(@"The project","Das Projekt");
			NSString* s2=NSLocalizedString(@"No valid Names","Keine gültigen Namen.");
			
			NSString* s3=@"Das Projekt wird nicht angelegt.";
			
			NSString* InformationString=[NSString stringWithFormat:@"%@ %@ %@\n%@",s1,tempProjektName,s2,s3];
			[Warnung setInformativeText:InformationString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
			
			int antwort=[Warnung runModal];
			switch (antwort)
			{
				case NSAlertFirstButtonReturn://
				{ 
					NSLog(@"NSAlertFirstButtonReturn");
					
				}break;
					
				case NSAlertSecondButtonReturn://
				{
					NSLog(@"NSAlertSecondButtonReturn");
					
				}break;
				case NSAlertThirdButtonReturn://		
				{
					NSLog(@"NSAlertThirdButtonReturn");
					
				}break;
					
			}//switch
			
			//NSLog(@"Keine Namen, remove Projektordner");
			[Filemanager removeItemAtURL:[NSURL fileURLWithPath:derProjektPfad] error:nil];
			OrdnereinrichtenOK=NO;
			//tempProjektself.NamenListe leer
			
		}
	}//OrdnereinrichtenOK
	NSLog(@"ProjektordnerEinrichten end");
	return OrdnereinrichtenOK;
}
  
  - (void)UKopierOrdnerWahlAktion:(NSNotification*)note
{
	//return;
	//NSLog(@"*** KopierOrdnerWahlAktion: %@",[[[note userInfo] objectForKey:@"ordnername"]description]);
	NSString* tempString=[[[note userInfo] objectForKey:@"ordnername"]description];
	if ([tempString length])
	  {
		UProjektName=[NSString stringWithString:tempString];
	  }
	  else
	  {
		UProjektName=[NSString string];
  
	  }
	
}


- (IBAction)showNamenListe:(id)sender
{
	//NSLog(@"\n\nshowProjektListe start");
	if (!UNamenListePanel)
	  {
		UNamenListePanel=[[rNamenListe alloc]init];
	  }
	//NSLog(@"showself.NamenListe nach init:ProjektArray: %@  ",[ProjektArray description]);
	//NSLog(@"showself.NamenListe nach init:ProjektArray: %@  \nProjektPfad: %@",[UProjektArray description],UProjektPfad);
	//NSLog(@"showself.NamenListe nach init:ProjektPfad: %@",UProjektPfad);

	//[ProjektPanel showWindow:self];
	NSModalSession NamenSession=[NSApp beginModalSessionForWindow:[UNamenListePanel window]];

	if ([UProjektArray count])
	  {
	  	NSFileManager *Filemanager=[NSFileManager defaultManager];

	  	NSMutableArray* tempNamenListeArray=[[NSMutableArray alloc]initWithCapacity:0];
		
		NSArray* tempNamenArray=[Filemanager contentsOfDirectoryAtPath:UProjektPfad error:NULL];
		//NSLog(@"showself.NamenListe tempNamenArray: %@  ",[tempNamenArray description]);
	  if (tempNamenArray&&[tempNamenArray count])
	  {
	  NSEnumerator* NamenEnum=[tempNamenArray objectEnumerator];
	  id einName;
	  while(einName=[NamenEnum nextObject])
	  {
	  if ([einName length])
	  {
	  [tempNamenListeArray addObject: einName];
	  }//if 
	  }//while
	  }
	  
	  [UNamenListePanel  setNamenListeArray:tempNamenListeArray  vonProjekt:[UProjektPfad lastPathComponent]];
	  }
	int modalAntwort = [NSApp runModalForWindow:[UNamenListePanel window]];
	//int modalAntwort = [NSApp runModalSession:ProjektSession];
	//NSLog(@"showProjektliste Antwort: %d",modalAntwort);
	[NSApp endModalSession:NamenSession];
	//[[ProjektPanel window] orderOut:NULL];   
	
}

- (IBAction)showEinzelNamen:(id)sender
{
NSLog(@"showEinzelNamen");
NSArray* a=[self EinzelNamenArray];
NSLog(@"EinzelNamenArray>: %@",[a description]);

}
- (NSArray*)EinzelNamenArray
{
	//NSLog(@"\n\nshowProjektListe start");
	if (!UEinzelNamenPanel)
	  {
		UEinzelNamenPanel=[[rEinzelNamen alloc]init];
	  }
	//NSLog(@"showself.NamenListe nach init:ProjektArray: %@  ",[ProjektArray description]);
	//NSLog(@"showself.NamenListe nach init:ProjektArray: %@  \nProjektPfad: %@",[UProjektArray description],UProjektPfad);
	//NSLog(@"showself.NamenListe nach init:ProjektPfad: %@",UProjektPfad);

	//[ProjektPanel showWindow:self];
	NSModalSession NamenSession=[NSApp beginModalSessionForWindow:[UEinzelNamenPanel window]];
	NSFileManager *Filemanager=[NSFileManager defaultManager];

	  
	int modalAntwort = [NSApp runModalForWindow:[UEinzelNamenPanel window]];
	//int modalAntwort = [NSApp runModalSession:ProjektSession];
	//NSLog(@"showProjektliste Antwort: %d",modalAntwort);
	[NSApp endModalSession:NamenSession];
	//[[ProjektPanel window] orderOut:NULL]; 
	NSArray* tempNamenArray=[NSArray array];  
	if (modalAntwort==1)
	{
	tempNamenArray=[UEinzelNamenPanel NamenArray];
	}
	return tempNamenArray;
}

- (void)UNamenEntfernenAktion:(NSNotification*)note
{
	//NSLog(@"\n\n\n*UNamenEntfernenAktion start: %@",[[note userInfo]description]);
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	int ausAllenProjekten=0;
	if ([[note userInfo]objectForKey:@"ausallenprojekten"])
	{
		ausAllenProjekten=[[[note userInfo]objectForKey:@"ausallenprojekten"]intValue];
	}
	
	if ([[note userInfo]objectForKey:@"namen"])
	{
		NSString* tempEntfernenName=[[note userInfo]objectForKey:@"namen"];
		
		int fehler=1;
		int var=[[[note userInfo]objectForKey:@"wohin"]intValue];
		NSMutableArray* EntfernenPfadArray=[[NSMutableArray alloc]initWithCapacity:0];
		if (ausAllenProjekten)
		{
			NSArray* tempProjektArray=[self ProjektNamenArrayVon:UArchivPfad];
			NSEnumerator* ProjektEnum=[tempProjektArray objectEnumerator];
			id einObjekt;
			BOOL istOrdner=NO;
			while(einObjekt=[ProjektEnum nextObject])
			{
				NSString* tempProjektPfad=[UArchivPfad stringByAppendingPathComponent:einObjekt];//Pfad des Proj.Ordners
				//NSLog(@"tempProjektPfad: %@",tempProjektPfad);
				if ([Filemanager fileExistsAtPath:tempProjektPfad isDirectory:&istOrdner]&&istOrdner)
				{
					NSArray* tempNamenArray=[Filemanager contentsOfDirectoryAtPath:tempProjektPfad error:NULL];
					if ([tempNamenArray containsObject:tempEntfernenName])//Projektordner enthält deinen Ordner mite dem Namen
					{
						NSString* tempEntfernenOrdnerPfad=[tempProjektPfad stringByAppendingPathComponent:tempEntfernenName];
						[EntfernenPfadArray addObject:tempEntfernenOrdnerPfad];
					}
				}//exists
			}//while
		}
		else
		{
			NSString* EntfernenOrdnerPfad=[UProjektPfad stringByAppendingPathComponent:tempEntfernenName];
			NSLog(@"UNamenEntfernenAktion:			EntfernenOrdnerPfad: %@  var: %d",EntfernenOrdnerPfad,var);
			[EntfernenPfadArray addObject:EntfernenOrdnerPfad];
		}//!ausAllenProjekten
		
		//NSLog(@"UNanenentfernenAktion EntfernenPfadArray: %@ ",[EntfernenPfadArray description]);
		int tempNamenFehler=-1;
		NSEnumerator* PfadEnum=[EntfernenPfadArray objectEnumerator];
		id einPfad;
		while(einPfad=[PfadEnum nextObject])
		{
			switch (var)
			{
				case 0://in den Papierkorb
				{
					//NSLog(@"UNamenEntfernenAktion in den Papierkorb");
				fehler=[self inPapierkorbMitPfad:einPfad];
				}break;
				case 1://ins Magazin
				{
					fehler=[self insMagazinMitPfad:einPfad];
				}break;
				case 2://ex und hopp
				{
					fehler=[self exMitPfad:einPfad];
				}break;
			}//switch
			if ([[einPfad lastPathComponent] isEqualToString:tempEntfernenName])
			{
			tempNamenFehler=fehler;//ist der Ordner im Projektordner entfernt?
			}
		}//while

		
			//NSLog(@"UNamenEntfernen: tempNamenFehler: %d",tempNamenFehler);
			if (tempNamenFehler==0)
			{
				NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
				[NotificationDic setObject:tempEntfernenName forKey:@"namen"];
				[NotificationDic setObject:[NSNumber numberWithInt:fehler] forKey:@"entfernenOK"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"NameIstEntfernt" object:self userInfo:NotificationDic];
			}
		
	}//Name ist valid
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
				
            if (![mgr moveItemAtURL:[NSURL fileURLWithPath:filePath]  toURL:[NSURL fileURLWithPath:[(__bridge NSString*)trashPath stringByAppendingPathComponent:[filePath lastPathComponent]]] error:nil])	
            {
            NSLog(@"Move operation did not succeed!");
            }
        
        }
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
		int removeIt=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:sourceDir ] error:nil];
		//NSLog(@"removePath: removeIt: %d",removeIt);
		return 0;

	  }
}
 
 
 - (int)inPapierkorbMitPfad:(NSString*)derNamenPfad
{
	BOOL istDirectory;
	//[derProjektPfad release];
	int fehler=0;
	NSString* tempNamenPfad=[derNamenPfad copy];//Pfad akt. Aufn.
		NSFileManager* Filemanager=[NSFileManager defaultManager];
		//NSLog(@"inPapierkorbmitPfad: %@",derNamenPfad);
		if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istDirectory]&&istDirectory)
		{
			//[self moveFileToUserTrash:tempAufnahmePfad];	
			fehler=[self fileInPapierkorb:tempNamenPfad];//0 ist OK
														 //NSLog(@"inPapierkorb result von Aufnahme: %d",result);
		}
		return fehler;
}
		
- (int)insMagazinMitPfad:(NSString*)derNamenPfad
{
	NSLog(@"insMagazinMitPfad: %@",derNamenPfad);
	NSString* tempNamenPfad=[derNamenPfad copy];//Pfad akt. Aufn.
	int fehler=0;
	BOOL istDirectory;
	NSFileManager* Filemanager=[NSFileManager defaultManager];
	NSString* tempMagazinPfad=[[UArchivPfad stringByDeletingLastPathComponent]stringByAppendingPathComponent:@"Magazin"]; 
	NSLog(@"tempMagazinPfad: %@",tempMagazinPfad);
	BOOL magazinOK=YES;
	if (![Filemanager fileExistsAtPath:tempMagazinPfad])
	{
		magazinOK=[Filemanager createDirectoryAtPath:tempMagazinPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
		if (!magazinOK)
		{
			NSString* s1=NSLocalizedString(@"The folder 'Magazin' could not be created in folder 'Lecturebox'",@"Ordner 'Magazin' im Ordner 'Lesebox' nicht eingerichtet");
			NSString* s2=NSLocalizedString(@"Folder %@ not moved",@"Ordner von %@ nicht verschoben");
			NSString* MagazinString=[NSString stringWithFormat:@"%@%@%@%@",s1,@"\r",s2,[tempNamenPfad lastPathComponent]];
			//NSLog(@"MagazinString: %@",MagazinString);
			NSString* TitelString=NSLocalizedString(@"Creating Magazin",@"Magazin einrichten");
			fehler=NSRunAlertPanel(TitelString, MagazinString,@"OK", NULL,NULL);
			
		}
	}
	if (magazinOK)//Ordner 'Magazin' ist da
	{
		NSString* tempMagazinNamenPfad=[[tempNamenPfad lastPathComponent]stringByAppendingPathExtension:@"old"];
		NSString* tempZielPfad=[tempMagazinPfad stringByAppendingPathComponent:tempMagazinNamenPfad];
		[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempZielPfad] error:NULL];//Eventuell schon vorhandenen Ordner löschen
		//[Filemanager movePath:tempNamenPfad toPath:tempZielPfad handler:NULL];
      BOOL MagazinOK=[Filemanager moveItemAtURL:[NSURL fileURLWithPath:tempNamenPfad]  toURL:[NSURL fileURLWithPath:tempZielPfad] error:nil];

   }
	
	return fehler;  
	
}

- (int)exMitPfad:(NSString*)derNamenPfad
{
	NSString* tempNamenPfad=[derNamenPfad copy];//Pfad akt. Aufn.
	BOOL istDirectory;
	int fehler=0;
	NSFileManager* Filemanager=[NSFileManager defaultManager];
	NSLog(@"exMitPfad: %@",tempNamenPfad);
	BOOL ExOK=NO;
		if ([Filemanager fileExistsAtPath:tempNamenPfad isDirectory:&istDirectory]&&istDirectory)
		  {
				ExOK=[Filemanager removeItemAtURL:[NSURL fileURLWithPath:tempNamenPfad]error:nil];
				NSLog(@"ex: result von ex: %d",fehler);
		  }
		if (!ExOK)
		{
		fehler=1;
		}
		return fehler;
}
				
		
- (void)UNamenEinsetzenAktion:(NSNotification*)note
{
	//NSLog(@"\n\n*UNamenEinsetzenAktion	UProjektArray: %@\n",[UProjektArray description]);
	//NSLog(@"\n\n*UNamenEinsetzenAktion userInfo: %@",[[note userInfo] description]);
	//NSLog(@"*UNamenEinsetzenAktion  UArchivPfad:%@",UArchivPfad);
	NSMutableArray* tempPfadArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSMutableArray* doppelteNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSMutableArray* tempNeueNamenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	if ([[note userInfo] objectForKey:@"neueNamenArray"])//Array mit neuen Namen(>=1)
	{
		[tempNeueNamenArray setArray:[[[note userInfo] objectForKey:@"neueNamenArray"]mutableCopy]];
		NSLog(@"*\n                      ****	UNamenEinsetzenAktion  neueNamenArray: %@",[tempNeueNamenArray description]);
		int einsetzenVariante=-1;
		int erfolg=0;
		
		NSMutableDictionary* tempDictionary=[[NSMutableDictionary alloc]initWithCapacity:0];
		if ([[note userInfo] objectForKey:@"einsetzenVariante"])
		{
			einsetzenVariante=[[[note userInfo] objectForKey:@"einsetzenVariante"]intValue];
		}
		
		switch (einsetzenVariante)
		{
			case 0://nur in diesem Projekt
			{
				
				NSEnumerator* NamenEnum=[tempNeueNamenArray objectEnumerator];
				id einName;
				while (einName=[NamenEnum nextObject])
				{
					
					NSString* tempPfad=[UProjektPfad stringByAppendingPathComponent:einName];
					if ([Filemanager fileExistsAtPath:tempPfad])//Der Ordner für einName existiert
					{
						[doppelteNamenArray addObject:tempPfad];
					}
					else	//Der Ordner für einName existiert noch nicht
					{
						[tempPfadArray addObject:tempPfad];
					}
					
				}//while einPfad
				
			}break;
				
			case 1://nur in aktivierte Projekte  	Key in ProjektArray: ok
			{
				//NSArray* tempProjektNamenArray=[self ProjektNamenArrayVon:UArchivPfad];
				NSEnumerator* ProjektEnum=[UProjektArray objectEnumerator];
				id einProjekt;
				while (einProjekt=[ProjektEnum nextObject])
				{
					if ([[einProjekt objectForKey:@"OK"]intValue]==1)
					{
						NSString* tempProjektPfad=[UArchivPfad stringByAppendingPathComponent:[einProjekt objectForKey:@"projekt"]];
						NSEnumerator* NamenEnum=[tempNeueNamenArray objectEnumerator];
						id einName;
						while (einName=[NamenEnum nextObject])
						{
							
							NSString* tempPfad=[tempProjektPfad stringByAppendingPathComponent:einName];
							if ([Filemanager fileExistsAtPath:tempPfad])//Der Ordner für einName existiert
							{
								[doppelteNamenArray addObject:tempPfad];
							}
							else	//Der Ordner für einName existiert noch nicht
							{
								[tempPfadArray addObject:tempPfad];
							}
							
						}//while einPfad
						
					}//if ok
				}//while ProjektEnum
			}break;
				
			case 2://alle Projekte
			{
				{
					//NSArray* tempProjektNamenArray=[self ProjektNamenArrayVon:UArchivPfad];
					NSEnumerator* ProjektEnum=[UProjektArray objectEnumerator];
					id einProjekt;
					while (einProjekt=[ProjektEnum nextObject])
					{
						//if ([[einProjekt objectForKey:@"OK"]intValue]==1)
						{
							NSString* tempProjektPfad=[UArchivPfad stringByAppendingPathComponent:[einProjekt objectForKey:@"projekt"]];
							NSEnumerator* NamenEnum=[tempNeueNamenArray objectEnumerator];
							id einName;
							while (einName=[NamenEnum nextObject])
							{
								
								NSString* tempPfad=[tempProjektPfad stringByAppendingPathComponent:einName];
								if ([Filemanager fileExistsAtPath:tempPfad])//Der Ordner für einName existiert 								{
								{
									[doppelteNamenArray addObject:tempPfad];
								}
								else	//Der Ordner für einName existiert noch nicht
								{
									[tempPfadArray addObject:tempPfad];
								}
								
							}//while einPfad
							
						}//if ok
					}//while ProjektEnum
				}//case 2
			}break;
		}//switch 		einsetzenVariante
		
	}
	NSLog(@"*UNamenEinsetzenAktion  tempPfadArray:\n%@",[tempPfadArray description]);
	NSLog(@"*UNamenEinsetzenAktion  doppelteNamenArray:\n%@",[doppelteNamenArray description]);
	
	NSMutableArray* fehlendeOrdnerArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	NSEnumerator* NamenEnum=[tempPfadArray objectEnumerator];
	id einPfad;
	int erfolg=-1;
	while (einPfad=[NamenEnum nextObject])
	{
		erfolg=[Filemanager createDirectoryAtPath:einPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
		if (!erfolg)
		{
			[fehlendeOrdnerArray addObject:[[einPfad stringByDeletingLastPathComponent]lastPathComponent]];
		}
	}//while
	//NSLog(@"*UNamenEinsetzenAktion  fehlendeOrdnerArray:%@",[fehlendeOrdnerArray description]);
	
	if ([fehlendeOrdnerArray count])
	{
		NSAlert *Warnung = [[NSAlert alloc] init];
		[Warnung addButtonWithTitle:@"OK"];
		NSString* s1=NSLocalizedString(@"The folder %@ couldn't be created for some projects:",@"Kein Ordner für einige Projekte");
		//[Warnung setMessageText:[NSString stringWithFormat:@"Der Ordner für  %@ konnte in einigen Projekten nicht eingerichtet werden:",tempNeuerName]];
		[Warnung setMessageText:[NSString stringWithFormat:s1,fehlendeOrdnerArray]];
		
		
		NSString* s2=@"";
		NSString* InformationString=[NSString stringWithFormat:@"%@",[fehlendeOrdnerArray description]];
		[Warnung setInformativeText:InformationString];
		[Warnung setAlertStyle:NSWarningAlertStyle];
		
		//[Warnung setIcon:RPImage];
		int antwort=[Warnung runModal];
	}
	NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[NotificationDic setObject:[NSNumber numberWithBool:erfolg] forKey:@"einsetzenOK"];
	if ([[note userInfo] objectForKey:@"neuerName"])//nur ein neuer Name
	{
		NSString* tempNeuerName=[[note userInfo] objectForKey:@"neuerName"];
		[NotificationDic setObject:tempNeuerName forKey:@"neuerName"];
	}
	[NotificationDic setObject:tempNeueNamenArray forKey:@"neueNamenArray"];
	//NSLog(@"UNamenEinsetzenAktion: NotificationDic: %@",[NotificationDic description]);
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"NameIstEingesetzt" object:self userInfo:NotificationDic];
	
	return;
	
	//nur ein Name
	
}

- (void)UNamenAusListeAktion:(NSNotification*)note
{
	//NSLog(@"UNamenAusListeAktion: Notification: %@",[note description]);
	NSDictionary* tempNamenDic=[self UOrdnernamenDicVonKlassenliste];
	NSArray* tempNamenArray=[tempNamenDic objectForKey:@"KlassenArray"];
	
			
		NSMutableDictionary* NotificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		[NotificationDic setObject:tempNamenDic forKey:@"NamenDicAusKlassenliste"];
		//NSLog(@"UNamenEinsetzenAktion: NotificationDic: %@",[NotificationDic description]);
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"NamenAusKlassenliste" object:self userInfo:NotificationDic];

	

}


- (BOOL)confirmPasswort:(NSDictionary*)derNamenDic
{
	BOOL confirmOK=NO;
	//NSLog(@"confirmPasswort start");
	NSString* tempName=[derNamenDic objectForKey:@"name"];
	NSData* PWData=[derNamenDic objectForKey:@"pw"];
	if (!UPasswortRequestPanel)
	{
		UPasswortRequestPanel=[[rPasswortRequest alloc]init];
	}
	
	NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[UPasswortRequestPanel window]];
	[UPasswortRequestPanel setName:tempName mitPasswort: PWData];
	
	int modalAntwort = [NSApp runModalForWindow:[UPasswortRequestPanel window]];
	//NSLog(@"Utils confirmPasswort: modalAntwort: %d",modalAntwort);
	[NSApp endModalSession:PasswortSession];
	confirmOK=(modalAntwort==1);
	return confirmOK;
}


- (NSDictionary*)changePasswort:(NSDictionary*)derNamenDic
{
	BOOL confirmOK=NO;
	NSLog(@"changePasswort start");
	NSString* tempName=[derNamenDic objectForKey:@"name"];
	NSData* PWData=[derNamenDic objectForKey:@"pw"];
	
	if (!UPasswortDialogPanel)
	{
		UPasswortDialogPanel=[[rPasswortDialog alloc]init];
	}
	
	NSModalSession PasswortSession=[NSApp beginModalSessionForWindow:[UPasswortDialogPanel window]];
	[UPasswortDialogPanel setName:tempName mitPasswort: PWData];
	
	int modalAntwort = [NSApp runModalForWindow:[UPasswortDialogPanel window]];
	
	//NSLog(@"changePasswort Antwort: %d",modalAntwort);
	
	
	[NSApp endModalSession:PasswortSession];
	if (modalAntwort==0)//Cancel
	{
	return [derNamenDic copy];
	}
	
	NSDictionary* returnDic=[UPasswortDialogPanel neuerPasswortDic];
	//NSLog(@"changePasswort:\nderNamenDic: %@\n returnDic: %@\n\n",[derNamenDic description],[returnDic description]);
	return [returnDic copy];
}


- (void)showTimeoutDialog:(id)sender
{
NSLog(@"showTimeoutDialog");
	//if (!UTimeoutDialogPanel)
	  {
		UTimeoutDialogPanel=[[rTimeoutDialog alloc]init];
	  }
	  	int Zeit=10;
	[UTimeoutDialogPanel showWindow:NULL];

//	NSModalSession TimeoutSession=[NSApp beginModalSessionForWindow:[UTimeoutDialogPanel window]];
	[UTimeoutDialogPanel setZeit:10];
	NSString* string1=NSLocalizedString(@"There was no activity for the given time",@"Keine Altivität");
	NSString* string2=[NSString stringWithFormat:NSLocalizedString(@"Logout will occur in %d seconds",@"Timeout in xx secconds"),Zeit];
	//NSLog(@"string2: %@",string2);
	NSString* TimeoutString=[NSString stringWithFormat:@"%@\n%@",string1,string2];
	//NSLog(@"TimeoutString: %@",TimeoutString);
	[UTimeoutDialogPanel setText:TimeoutString];
	
//	int modalAntwort = [NSApp runModalForWindow:[UTimeoutDialogPanel window]];
	
	//NSLog(@"showTitelListe Antwort: %d",modalAntwort);
//	[NSApp endModalSession:TimeoutSession];

	
}


- (void)startTimeout:(NSTimeInterval)derTimeout
{
	NSDictionary* timeoutDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:derTimeout] forKey:@"timeout"];
	if ([TimeoutDialogTimer isValid])
	{
		[TimeoutDialogTimer invalidate];
	}
	if ([TimeoutTimer isValid])
	{
		[TimeoutTimer invalidate];
	}
	
	TimeoutTimer=[NSTimer scheduledTimerWithTimeInterval:derTimeout
												   target:self 
												 selector:@selector(TimeoutFunktion:) 
												 userInfo:timeoutDic
												  repeats:NO];
	//NSLog(@" userInfo:%@",[[TimeoutTimer userInfo] description]);
	
}

- (void)TimeoutFunktion:(NSTimer*)timer
{
	int Zeit=[[[timer userInfo]objectForKey:@"timeout"]intValue];
	//NSLog(@"Zeit: %@, num: %d, Zeit: %d",[[timer userInfo]description],[[[timer userInfo]objectForKey:@"timeout"]intValue],Zeit);
	[TimeoutTimer invalidate];
		if (!UTimeoutDialogPanel)
	  {
		UTimeoutDialogPanel=[[rTimeoutDialog alloc]init];
	  }

	[self showTimeoutDialog:NULL];
	[UTimeoutDialogPanel setDialogTimer:20];
}


- (void)delayTimeout:(NSTimeInterval)derDelay
{
	NSDate* delay=[NSDate dateWithTimeIntervalSinceNow:derDelay];
	if ([TimeoutTimer isValid])
	{
		[TimeoutTimer setFireDate: delay];
	}
}

- (void)stopTimeout
{
if (UTimeoutDialogPanel)
{
[UTimeoutDialogPanel stopTimeoutDialogTimer:NULL];

}

	if ([TimeoutTimer isValid])
	{
		[TimeoutTimer invalidate];
	}
	
}


- (BOOL)createKommentarFuerLeser:(NSString*)derLeser FuerAufnahmePfad:(NSString*)derAufnahmePfad
{
	//NSLog(@"Utils createKommentarFuerLeser Leser: %@ Pfad: %@",derLeser, derAufnahmePfad);
	
	BOOL erfolg;
	BOOL istDirectory; 
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	
	NSString* tempLeser=[derLeser copy];
	//[tempLeser retain];
	if ([tempLeser length]==0)
	{
		NSLog(@"saveKommentarFuerLeser: Kein Leser");
		return NO;
	}
	NSString* tempAufnahme=[derAufnahmePfad lastPathComponent];	//Name der Aufnahme
	NSString* tempLeserOrdnerPfad=[derAufnahmePfad stringByDeletingLastPathComponent];	//Leserordnerpfad
	NSString* KommentarOrdnerString=NSLocalizedString(@"Anmerkungen",@"Anmerkungen");
	NSString* tempKommentarOrdnerPfad=[tempLeserOrdnerPfad stringByAppendingPathComponent:KommentarOrdnerString];
				//Pfad des Anmerkungen-Ordners
	if (![Filemanager fileExistsAtPath:tempKommentarOrdnerPfad isDirectory:&istDirectory])//noch kein Kommentarordner des Lesers ist da
	{
		erfolg=[Filemanager createDirectoryAtPath:tempKommentarOrdnerPfad  withIntermediateDirectories:NO attributes:NULL error:NULL];
		if (!erfolg)
		{
			NSLog(@"Kommentarordner einrichten misslungen");
			return erfolg;
		}
		
	}
	//NSLog(@"in saveKommentarFuerLeser: Kommentarordner da");
	
				
				
				
				
	NSString* tempKommentarPfad=[tempKommentarOrdnerPfad stringByAppendingPathComponent:tempAufnahme];
	NSString* tempKommentarString;
	NSString* tempKopfString;
//	NSLog(@"in createKommentarFuerLeser: tempKommentarOrdnerPfad %@",tempKommentarOrdnerPfad);
	
	
	//Kopfstring aufbauen
	tempKopfString=[NSString stringWithString:derLeser];
	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
	if ([tempAufnahme length]>1)
	{
		tempKopfString=[tempKopfString stringByAppendingString:tempAufnahme];
	}
	else
	{
		tempKopfString=[tempKopfString stringByAppendingString:@"Kein Titel"];
	}
//	NSLog(@"in createKommentarFuerLeser tempKopfString mit titel: %@",tempKopfString);

	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
	
	NSNumber *AufnahmeSize;
	
	
	//Heutiges Datum einsetzen		  
	NSCalendarDate* tempDatum=[[NSCalendarDate calendarDate]dateWithCalendarFormat:@"%d.%m.%Y %H:%M:%S" timeZone:nil];
	
//	NSLog(@"tempDatum: %@",[tempDatum description]);
	tempKopfString=[tempKopfString stringByAppendingString:[tempDatum description]];
	
//	NSLog(@"in createKommentarFuerLeser tempKopfString mit Datum: %@",tempKopfString);
	
	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
	
	NSString* BewertungString=@" ";
	tempKopfString=[tempKopfString stringByAppendingString:BewertungString];
	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
	//NSLog(@"saveKommentar	tempKopfString mit Bewertungstring: %@",tempKopfString);
	
	NSString* NotenString=@"-";
	tempKopfString=[tempKopfString stringByAppendingString:NotenString];
	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
//	NSLog(@"saveKommentar	tempKopfString mit Notenstring: %@",tempKopfString);
	
	NSString* UserMarkString=@"0";
	tempKopfString=[tempKopfString stringByAppendingString:UserMarkString];
	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];
	
	NSString* AdminMarkString=@"0";
	tempKopfString=[tempKopfString stringByAppendingString:AdminMarkString];
	tempKopfString=[tempKopfString stringByAppendingString:@"\r"];


//	NSLog(@"createKommentar	tempKopfString mit UserMarkString: %@",tempKopfString);
	
	
	// Dummy-Anmerkung einfügen
	NSString* tempKommentarViewString=  tempKommentarString=[tempKopfString stringByAppendingString:@"--"];
//	NSLog(@"createKommentar	tempKommentarViewString : %@",tempKommentarViewString);
			 
	NSData* tempData=[tempKommentarViewString dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:NO];
	NSMutableDictionary* AufnahmeAttribute=[[NSMutableDictionary alloc]initWithCapacity:0];
	  
	NSNumber* POSIXNumber=[NSNumber numberWithInt:438];
	  
	[AufnahmeAttribute setObject:POSIXNumber forKey:NSFilePosixPermissions];
	  
	erfolg=[Filemanager createFileAtPath:tempKommentarPfad contents:tempData attributes:AufnahmeAttribute]; 
	
	
//	NSLog(@"createKommentar: erfolg: %d",erfolg);
		  
		  return erfolg;
		  
}


- (BOOL)setKommentar:(NSString*)derKommentarString inAufnahmeAnPfad:(NSString*)derAufnahmePfad
{
	//UserData					AufnahmeUserData = NULL;
	Handle						AufnahmeHandle = NULL;
	short						AufnahmeIndex = 0;
	
	OSErr						AufnahmeErr = noErr;
	const char* CKommentarString=[[derKommentarString copy] UTF8String];
	long						AufnahmeLength = strlen(CKommentarString);
	
	//Movie finden
	NSURL *movieURL = [NSURL fileURLWithPath:derAufnahmePfad];
	
   /*
	NSError* loadErr;
	QTMovie* tempMovie= [[QTMovie alloc]initWithURL:movieURL error:&loadErr];
	if (loadErr)
	{
		NSAlert *theAlert = [NSAlert alertWithError:loadErr];
		[theAlert runModal]; // Ignore return value.
	}
	if (!tempMovie)
	{
		NSLog(@"Kein Movie da");
	// retrieve the QuickTime-style movie (type "Movie" from QuickTime/Movies.h) 
	}
	Movie tempAufnahmeMovie =[tempMovie quickTimeMovie];
	
	
	AufnahmeUserData = GetMovieUserData(tempAufnahmeMovie);
	if (AufnahmeUserData == NULL)
	{
		return(paramErr);
	}
	
	// copy the specified text into a new handle
	AufnahmeHandle = NewHandleClear(AufnahmeLength);
	if (AufnahmeHandle == NULL)
		return(MemError()==0);
	
	BlockMoveData(CKommentarString, *AufnahmeHandle, AufnahmeLength);
	
	// add the data to the movie's user data
	//AufnahmeErr = AddUserDataText(AufnahmeUserData, AufnahmeHandle, kUserDataTextInformation,  1, smSystemScript);
	AufnahmeErr = AddUserData(AufnahmeUserData, AufnahmeHandle, kUserDataTextInformation);
	OSErr MemErr=GetMoviesError();
	// clean up
	DisposeHandle(AufnahmeHandle);
	*///
	return(AufnahmeErr==0);
}

// Nicht benutzt. Holt C-String aus MovieUserData. Diese werden jedoch nicht auf externe Volumes uebertragen.
- (NSString*)KommentarStringVonAufnahmeAnPfad:(NSString*)derAufnahmePfad
{
	//UserData					AufnahmeUserData = NULL;
	Handle						AufnahmeHandle = NULL;
	short						AufnahmeIndex = 0;
	
	OSErr						AufnahmeErr = noErr;
	char*						CKommentarString=NULL;
	long						AufnahmeLength = 0;
	Handle					KommentarHandle=NewHandleClear(0);
	
	//Movie finden
	NSError* loadErr;
   NSString* tempKommentarString;
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
	
	Movie tempAufnahmeMovie =[tempMovie quickTimeMovie];
	
	
	AufnahmeUserData = GetMovieUserData(tempAufnahmeMovie);
	if (AufnahmeUserData == NULL)
	{
		return @"Fehler";//(paramErr);
	}
	
	AufnahmeErr=GetUserData(AufnahmeUserData, KommentarHandle, kUserDataTextInformation, 1);
	if (AufnahmeErr==noErr)
	{
		AufnahmeLength = GetHandleSize(KommentarHandle);
		
		if (AufnahmeLength > 0) 
		{
			CKommentarString = (char *)malloc(AufnahmeLength + 1);
			if (CKommentarString != NULL) 
			{
				memcpy(CKommentarString, *AufnahmeHandle, AufnahmeLength);
				CKommentarString[AufnahmeLength] = '\0';
			}
		}			
	}	
	
	DisposeHandle(KommentarHandle);
	
	
	
	// clean up
	DisposeHandle(AufnahmeHandle);
	NSString* tempKommentarString=[NSString stringWithCString:CKommentarString
                                                    encoding:NSMacOSRomanStringEncoding];
	[tempKommentarString retain];
    */
	return tempKommentarString;
}
/*
OSErr rUtils_AddUserDataTextToMovie (Movie theMovie, char *theText, OSType theType)
{
	UserData					myUserData = NULL;
	Handle						myHandle = NULL;
	short						myIndex = 0;
	long						myLength = strlen(theText);
	OSErr						myErr = noErr;

	// get the movie's user data list
	myUserData = GetMovieUserData(theMovie);
	if (myUserData == NULL)
		return(paramErr);
	
	// copy the specified text into a new handle
	myHandle = NewHandleClear(myLength);
	if (myHandle == NULL)
		return(MemError());

	BlockMoveData(theText, *myHandle, myLength);

	// for simplicity, we assume that we want only one user data item of the specified type in the movie;
	// as a result, we won't worry about overwriting any existing item of that type....
	//
	// if you need multiple user data items of a given type (for example, a copyright notice
	// in several different languages), you would need to modify this code; this is left as an exercise
	// for the reader....

	// add the data to the movie's user data
	myErr = AddUserDataText(myUserData, myHandle, theType, myIndex + 1, smSystemScript);

	// clean up
	DisposeHandle(myHandle);
	return(myErr);
}
*/

- (BOOL) setPListBusy:(BOOL)derStatus anPfad:(NSString*)derPfad
{
	NSFileManager *Filemanager=[NSFileManager defaultManager];
	NSString* PListName=NSLocalizedString(@"Lecturebox.plist",@"Lesebox.plist");
	NSString* PListPfad;
	NSString* DataPfad=[derPfad stringByAppendingPathComponent:@"Data"];
//	NSLog(@"PList aus Data: tempUserPfad: %@",DataPfad);
//	PListPfad=[DataPfad stringByAppendingPathComponent:PListName];//Pfad der PList auf dem Vol der LB
	//NSLog(@"PListPfad in Lesebox: %@",PListPfad);

	BOOL istOrdner=NO;
	BOOL saveOK=NO;
	if ([Filemanager fileExistsAtPath:DataPfad isDirectory:&istOrdner]&&istOrdner)//LeseboxDaten sind da
	{
		NSString* tempPListPfad=[DataPfad stringByAppendingPathComponent:PListName];
		NSMutableDictionary* tempPListDic=(NSMutableDictionary*)[NSDictionary dictionaryWithContentsOfFile:tempPListPfad];
		
		if (tempPListDic)
		{
			[tempPListDic setObject:[NSNumber numberWithBool:derStatus] forKey:@"busy"];
			saveOK=[tempPListDic writeToFile:tempPListPfad atomically:YES];
		}//if temPListDic
	}
	return saveOK;
}

@end
