//
//  MyFirstSceneViewController.m
//  _KoboldTouch-Template_
//
//  Created by Steffen Itterheim on 10.10.12.
//
//

#import "MyFirstSceneViewController.h"
#import "MySecondSceneViewController.h"
#import "CoconutsViewController.h"
#import "PhysicNutsViewController.h"

@implementation MyFirstSceneViewController

-(void) initWithDefaults
{
	glClearColor(1, 0, 1, 1);

	KTTilemapViewController* tilemapController = [KTTilemapViewController tilemapControllerWithTMXFile:@"orthogonal.tmx"];
	[self addSubController:tilemapController];

	//KTLegacyTilemapViewController* legacyTilemapController = [KTLegacyTilemapViewController legacyTilemapControllerWithTMXFile:@"orthogonal.tmx"];
	//[self addSubController:legacyTilemapController];

	KTPhysicsController* physicsController = [KTPhysicsController physicsControllerWithBox2D];
	[self addSubController:physicsController];
	CGSize winSize = [CCDirector sharedDirector].winSize;
	[physicsController constrainWorldToRect:CGRectMake(0, 0, winSize.width * 0.5f, winSize.height * 0.7f)];
	self.physicsController.gravity = CGPointMake(3.33f, 5.9f);
	
	KTTextMenuItem* item1 = [KTTextMenuItem itemWithText:@"Hello #1" executionBlock:^(id sender)
	{
		NSLog(@"Hello1 sender: %@ - view controller: %@", sender, self);
		KTSceneViewController* controller = [KTSceneViewController controller];
		controller.loadViewBlock = ^(CCNode* rootNode)
		{
			// new scene with just a sprite in the background
			CCSprite* sprite = [CCSprite spriteWithFile:@"Default.png"];
			sprite.position = ccp(160, 240);
			sprite.color = ccGREEN;
			[rootNode addChild:sprite];
		};
		
		[self.gameController presentSceneViewController:controller];
	}];
	KTTextMenuItem* item2 = [KTTextMenuItem itemWithText:@"Hello #2" executionBlock:^(id sender)
	{
		NSLog(@"Hello2 sender: %@ - view controller: %@", sender, self);
		// creates just an empty scene, nothing in it
		[self.gameController presentSceneViewController:[KTSceneViewController controller]];
	}];
	
	// set menu options
	KTTextMenu* textMenu = [KTTextMenu menuWithTextMenuItems:[NSArray arrayWithObjects:item1, item2, nil]];
	textMenu.fontName = @"Courier";
	textMenu.fontSize = 40;
	textMenu.padding = 12;
	
	KTMenuViewController* menuViewController = [KTMenuViewController menuControllerWithTextMenu:textMenu];
	[self addSubController:menuViewController];
	
	CoconutsViewController* coconutsVC = [CoconutsViewController spriteBatchControllerWithImageFile:@"Icon.png"];
	coconutsVC.loadViewBlock = ^(CCNode *rootNode)
	{
		CCSpriteBatchNode* batchNode = (CCSpriteBatchNode*)rootNode;
		batchNode.zOrder = 0;
		for (int i = 0; i < 75; i++)
		{
			CCSprite* sprite = [CCSprite spriteWithTexture:batchNode.texture];
			sprite.position = ccp(-500, -500);
			sprite.rotation = CCRANDOM_0_1() * 360.0f;
			sprite.color = ccc3(CCRANDOM_0_1() * 200 + 55, CCRANDOM_0_1() * 200 + 55, CCRANDOM_0_1() * 200 + 55);
			//[batchNode addChild:sprite];
		}
	};
	[self addSubController:coconutsVC];
	
	KTSpriteViewController* spriteVC = [KTSpriteViewController spriteControllerWithImageFile:@"Icon.png"];
	spriteVC.loadViewBlock = ^(CCNode *rootNode)
	{
		CCSprite* sprite = (CCSprite*)rootNode;
		sprite.scale = 0.75f;
		sprite.opacity = 120;
		sprite.color = ccGREEN;
	};
	[coconutsVC addSubController:spriteVC];
	
//	for (int i = 0; i < 1; i++)
//	{
//		PhysicNutsViewController* physicsVC = [PhysicNutsViewController spriteControllerWithImageFile:@"Icon.png"];
//		physicsVC.loadViewBlock = ^(CCNode *rootNode)
//		{
//			rootNode.tag = i;
//		};
//		[coconutsVC addSubController:physicsVC];
//	}
//	
//	KTPhysicsDebugViewController* physicsDebugVC = [KTPhysicsDebugViewController physicsDebugViewControllerWithPhysicsController:physicsController];
//	[self addSubController:physicsDebugVC];
	
	KTTrueTypeFontLabel* fontLabel = [KTTrueTypeFontLabel trueTypeFontLabelWithText:@"Halo World!"];
	fontLabel.color = ccYELLOW;
	KTLabelViewController* labelVC = [KTLabelViewController labelControllerWithFontLabel:fontLabel];
	labelVC.loadViewBlock = ^(CCNode* rootNode)
	{
		rootNode.position = CGPointMake(150, 20);
	};
	[self addSubController:labelVC];

	KTParticleBatchViewController* particleBatchVC = [KTParticleBatchViewController particleBatchControllerWithImageFile:@"particlefx.png"];
	[labelVC addSubController:particleBatchVC];

	for (int i = 0; i < 3; i++)
	{
		KTParticleEmitterViewController* particleVC = [[KTParticleEmitterViewController alloc] initWithEmitterFile:@"particlefx.plist"];
		particleVC.loadViewBlock = ^(CCNode* rootNode)
		{
			rootNode.position = CGPointMake(CCRANDOM_MINUS1_1() * 100, CCRANDOM_MINUS1_1() * 100);
		};
		[particleBatchVC addSubController:particleVC];
	}
	
	{
		KTColorGradient* colorGradient = [[KTColorGradient alloc] init];
		colorGradient.solidColor = ccc4(255, 100, 10, 200);
		colorGradient.frame = CGRectMake(400, 20, 70, 60);
		KTColorGradientViewController* colorVC = [[KTColorGradientViewController alloc] initWithColorGradient:colorGradient];
		[self addSubController:colorVC];
	}
	{
		KTColorGradient* colorGradient = [[KTColorGradient alloc] init];
		colorGradient.startColor = ccc4(0, 255, 255, 255);
		colorGradient.endColor = ccc4(255, 0, 255, 222);
		colorGradient.direction = CGPointMake(0.5f, -0.9f);
		colorGradient.frame = CGRectMake(300, 20, 70, 60);
		KTColorGradientViewController* colorVC = [[KTColorGradientViewController alloc] initWithColorGradient:colorGradient];
		[self addSubController:colorVC];
	}
	
	[self.multiTouchController addDelegate:self];
	self.multiTouchController.multipleTouchEnabled = YES;

	[self.motionController addDelegate:self];
	self.motionController.enabled = YES;
	
	
	
	// Register controller on scene view controller (self)
	[self registerController:labelVC withName:@"HelloLabel"];
}

-(void) load
{
	// Get controller by name
	{
		KTController* labelVC = [self.sceneViewController registeredControllerByName:@"HelloLabel"];
		((KTLabelViewController*)labelVC).text = @"this is awesome text";
	}

	// Get controller by class
	{
		Class labelClass = [KTLabelViewController class];
		KTController* labelVC = [self.sceneViewController registeredControllerByClass:labelClass];
		((KTLabelViewController*)labelVC).text = @"insanely great text";
	}
	
	
	// Weak Typing DEMO
	NSString* yesSir = @"Yes, Sir!";
	NSLog(@"Answer: %u", [self.model boolForKey:yesSir]);
	
	[self.model setBool:YES forKey:yesSir];
	NSLog(@"Answer: %u", [self.model boolForKey:yesSir]);
	
	[self.model setBool:NO forKey:yesSir];
	NSLog(@"Answer: %u", [self.model boolForKey:yesSir]);
	
	[self.model setFloat:12.3435f forKey:yesSir];
	NSLog(@"Answer: %f", [self.model floatForKey:yesSir]);
}

-(void) touchesBeganWithEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	LOG_EXPR(multiTouchEvent);
}
-(void) touchesMovedWithEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	LOG_EXPR(multiTouchEvent);
}
-(void) touchesEndedWithEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	LOG_EXPR(multiTouchEvent);
}
-(void) touchesCancelledWithEvent:(KTMultiTouchEvent*)multiTouchEvent
{
	LOG_EXPR(multiTouchEvent);
}

-(void) touchBeganWithEvent:(KTTouchEvent*)touchEvent
{
	LOG_EXPR(touchEvent);
}
-(void) touchMovedWithEvent:(KTTouchEvent*)touchEvent
{
	LOG_EXPR(touchEvent);
}
-(void) touchEndedWithEvent:(KTTouchEvent*)touchEvent
{
	LOG_EXPR(touchEvent);
}
-(void) touchCancelledWithEvent:(KTTouchEvent*)touchEvent
{
	LOG_EXPR(touchEvent);
}

-(void) accelerometerDidAccelerate:(KTAccelerometerData *)accelerometerData
{
	//LOG_EXPR(accelerometerData);
}


-(void) viewDidLoad
{
	CCSprite* sprite = [CCSprite spriteWithFile:@"Icon.png"];
	sprite.position = ccp(200, 200);
	sprite.rotation = CCRANDOM_0_1() * 60;
	sprite.scale = 7;
	sprite.opacity = 50;
	sprite.color = ccc3(0, 0, 250);
	[self.rootNode addChild:sprite];
}

-(void) step:(KTStepInfo *)stepInfo
{
	self.nextStep = stepInfo.currentStep + 7777;
	
	if (stepInfo.currentStep == 7777)
	{
		[self.gameController.archiveController writeToFile:@"firstscene.data" controller:self];
		[self.gameController presentSceneViewController:[MySecondSceneViewController controller]
										 transitionType:KTSceneTransitionTypeSlideInFromRight
									 transitionDuration:1.3f];
	}
}

@end
