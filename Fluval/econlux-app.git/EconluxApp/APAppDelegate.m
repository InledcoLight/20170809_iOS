//
//  APAppDelegate.m
//  EconluxApp
//
//  Created by Michael Müller on 10.04.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//
#import "APAppDelegate.h"
#import "APChannelRootViewController.h"
#import "APConnectionManager.h"
#import "APPhase.h"
#import "APChannel.h"
#import "APGatewayConnector.h"
#import "APConnectionViewController.h"
#import "APLightConfiguration.h"


@interface APAppDelegate()

@property (nonatomic, strong) APGatewayConnector *connector;
@property (nonatomic, strong) NSTimer *keepAliveTimer;

@end

@implementation APAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

// #####################################################

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// MODIFY APPEARANCES
	[[UINavigationBar appearance] setBarTintColor:DARK_COLOR];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TITLE_COLOR}];
	[[UINavigationBar appearance] setTintColor:FOREGROUND_COLOR];
	
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.071 green:0.489 blue:0.901 alpha:1.000]];

	[Crashlytics startWithAPIKey:@"aa49d46872fb30cf24dbcee132964b1578e4f2df"];

	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [APLightConfiguration getConfigurations];
	return YES;
}

// ################################################

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // KEEP ALIVE TIMER
    self.keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(keepAlive) userInfo:nil repeats:YES];
    
}

// #####################################################


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // SHOW LOGIN SCREEN ON INITIAL START
	[[APGatewayConnector sharedInstance] disconnect];
	APConnectionViewController *ctl = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    [self.window.rootViewController presentViewController:ctl animated:NO completion:nil];
    
}

// #####################################################

- (void) keepAlive {
    
    if([[APGatewayConnector sharedInstance] isConnected]) {
        [[APConnectionManager sharedInstance] requestGatewayType:^(APGateway *gateway) {
            NSLog(@"Keep alive answer...");
        }];
    }
}

// #####################################################

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.keepAliveTimer invalidate];
}

// #####################################################

- (void) createDummies {
	
	
	NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[APChannel entityName]];
	NSArray *arr = [MOC executeFetchRequest:req error:nil];
	
	if (!arr.count)
	{
		APChannel *channelOne = [APChannel insertInManagedObjectContext:self.managedObjectContext];
		channelOne.name = NSLocalizedString(@"DUMMY_CHANNEL_1", nil);
		
		APChannel *channelTwo = [APChannel insertInManagedObjectContext:self.managedObjectContext];
		channelTwo.name = NSLocalizedString(@"DUMMY_CHANNEL_2", nil);
		
		APChannel *channelThree = [APChannel insertInManagedObjectContext:self.managedObjectContext];
		channelThree.name = NSLocalizedString(@"DUMMY_CHANNEL_3", nil);
		
		APChannel *channelFour = [APChannel insertInManagedObjectContext:self.managedObjectContext];
		channelFour.name = NSLocalizedString(@"DUMMY_CHANNEL_4", nil);
	}
	
}

// #####################################################

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

// #####################################################

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

// #####################################################



#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EconluxApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EconluxApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
