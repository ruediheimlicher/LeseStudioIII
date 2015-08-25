//
//  AppDelegate.m
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 14.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import "AppDelegate.h"



const int StartmitRecPlay=0;
const int StartmitAdmin=1;
const int StartmitDialog=2;

const short kAdminUmgebung=1;
//const short 0=0;



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



@interface AppDelegate ()

- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
   
   NSImage* ProgrammImage = [NSImage imageNamed: @"MicroIcon"];
   [NSApp setApplicationIconImage: ProgrammImage];
   [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];

   /*
[[self AblaufMenu]setDelegate:self];
[[self RecorderMenu] setDelegate:self];

   [[self ModusMenu]setDelegate:self];

   [[[self ModusMenu] itemWithTag:kRecPlayTag] setTarget:self];//Recorder
   [[[self ModusMenu] itemWithTag:kAdminTag] setTarget:self];//Admin
   [[[self ModusMenu] itemWithTag:kKommentarTag] setTarget:self];//Kommentar
   [[[self ModusMenu] itemWithTag:kEinstellungenTag] setTarget:self];//Kommentar

   [[[self AblaufMenu] itemWithTag:kAndereLeseboxTag] setTarget:self];//neue Lesebox
   [[[self AblaufMenu] itemWithTag:kListeAktualisierenTag] setTarget:self];//Lesebox aktualisieren
   [[[self AblaufMenu] itemWithTag:kLeseboxNeuOrdnenTag] setTarget:self];//Lesebox neu ordnen
   [[[self AblaufMenu] itemWithTag:kAufnahmenLoschenTag] setTarget:self];//Aufnahmen loeschen
   [[[self AblaufMenu] itemWithTag:kAufnahmenExportierenTag] setTarget:self];//Aufnahmen exportieren
   [[[self AblaufMenu] itemWithTag:kSettingsTag] setTarget:self];//Settings
   [[[self AblaufMenu] itemWithTag:kMarkierungenLoschenTag] setTarget:self];//
   [[[self AblaufMenu] itemWithTag:kAlleMarkierungenLoschenTag] setTarget:self];//
   [[[self AblaufMenu] itemWithTag:kTitelListeBearbeitenTag] setTarget:self];//

   
   [[[self RecorderMenu] itemWithTag:kRecorderProjektWahlenTag] setTarget:self];//
   [[[self RecorderMenu] itemWithTag:kRecorderPasswortAndernTag] setTarget:self];//
   [[[self RecorderMenu] itemWithTag:kRecorderSettingsTag] setTarget:self];//

   
   [[self AblaufMenu] setDelegate:self];
   [[self ModusMenu] setDelegate:self];
   [[self RecorderMenu] setDelegate:self];
*/
   // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
   // Insert code here to tear down your application
   NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
   NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
   [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];
}

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "RH.Lesestudio" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
   NSLog(@"applicationDocumentsDirectory: %@",appSupportURL);
    return [appSupportURL URLByAppendingPathComponent:@"RH.Lesestudio"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lesestudio" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support


- (void)windowWillClose:(NSNotification *)notification
{
   NSLog(@"windowWillClose: %@",notification);
}


- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication
{
   NSMutableDictionary* BeendenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [BeendenDic setObject:[NSNumber numberWithInt:1] forKey:@"beenden"];
   NSNotificationCenter* beendennc=[NSNotificationCenter defaultCenter];
   [beendennc postNotificationName:@"externbeenden" object:self userInfo:BeendenDic];

   return NO;
}


@end
