//
//  AppDelegate.h
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Const.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    int row;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int col;

-(int) currentBlock:(NSMutableArray*)blockModel:(int)i;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

