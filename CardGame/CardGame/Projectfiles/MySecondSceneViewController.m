//
//  MySecondSceneViewController.m
//  _KoboldTouch-Template_
//
//  Created by Steffen Itterheim on 10.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MySecondSceneViewController.h"
#import "MyFirstSceneViewController.h"

@interface MySecondSceneViewController ()
// declare private methods here
@end


@implementation MySecondSceneViewController

-(void) viewDidLoad
{
	CCSprite* sprite = [CCSprite spriteWithFile:@"Icon.png"];
	sprite.position = ccp(200, 200);
	sprite.scale = 4.0f;
	[self.rootNode addChild:sprite];

	id rotate = [CCRotateBy actionWithDuration:2 angle:360];
	id forever = [CCRepeatForever actionWithAction:rotate];
	[sprite runAction:forever];
}

-(void) beforeStep:(KTStepInfo *)stepInfo
{
	//self.rootNode.rotation = CCRANDOM_0_1() * 360.0f;
}

-(void) step:(KTStepInfo *)stepInfo
{
	if (stepInfo.currentStep == 330)
	{
		KTSceneViewController* firstSceneVC = [MyFirstSceneViewController controller];
		[self.gameController.archiveController loadFromFile:@"firstscene.data" controller:firstSceneVC];
		[self.gameController presentSceneViewController:firstSceneVC
										 transitionType:KTSceneTransitionTypeMoveInFromTop
									 transitionDuration:2.5f];
	}
}

@end
