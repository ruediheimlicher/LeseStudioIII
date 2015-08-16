//
//  AppDelegate.h
//  Lesestudio
//
//  Created by Ruedi Heimlicher on 14.08.2015.
//  Copyright (c) 2015 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,  NSMenuDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;



@end

