/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"
#import "CGMainMenuViewController.h"
//#import "PhysicNutsViewController.h"
//#import "MyFirstSceneViewController.h"

@implementation AppDelegate

-(void) initializationComplete
{
	CGMainMenuViewController* mainMenuVC = [CGMainMenuViewController controller];
	[self.gameController presentSceneViewController:mainMenuVC];
    
//	NSLog(@"%@", [self.gameController.debugController objectGraph]);
//	NSLog(@"-------");
    
}

- (void)tryToRunFirstScene {
    [super tryToRunFirstScene];
    
    CGMainMenuViewController *mainMenuVC = (CGMainMenuViewController *)self.gameController.presentedSceneViewController;
    [mainMenuVC authGameCenter];
}

-(id) alternateView
{
	return nil;
}

@end
