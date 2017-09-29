//
//  APAppDelegate.h
//  EconluxApp
//
//  Created by Michael Müller on 10.04.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
