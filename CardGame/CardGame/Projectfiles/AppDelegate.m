/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"
//#import "CoconutsViewController.h"
//#import "PhysicNutsViewController.h"
//#import "MyFirstSceneViewController.h"

@implementation AppDelegate

-(void) initializationComplete
{
//	MyFirstSceneViewController* myFirstSceneViewController = [MyFirstSceneViewController controller];
//	[self.gameController presentSceneViewController:myFirstSceneViewController];
	
	NSLog(@"%@", [self.gameController.debugController objectGraph]);
	NSLog(@"-------");
}

-(id) alternateView
{
	return nil;
}

@end
