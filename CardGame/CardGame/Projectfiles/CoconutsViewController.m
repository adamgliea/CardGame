//
//  CoconutsViewController.m
//  _KoboldTouch-Template_
//
//  Created by Steffen Itterheim on 26.09.12.
//
//

#import "CoconutsViewController.h"

@implementation CoconutsViewController

-(void) step:(KTStepInfo *)stepInfo
{
	KKInput* input = [KKInput sharedInput];
	if (input.touchesAvailable)
	{
		self.entityModel.position = [input anyTouchLocation];
	}
	else if ([input isMouseButtonDown:KKMouseButtonLeft])
	{
		self.entityModel.position = input.mouseLocation;
	}
	
	previousSpritesPosition = ccp(-1, -1);
	CCArray* children = self.rootNode.children;
	for (int i = (int)children.count - 1; i >= 0; i--)
	{
		CCSprite* sprite = (CCSprite*)[children objectAtIndex:i];
		
		if (sprite.tag <= 0)
		{
			if (previousSpritesPosition.x < 0)
			{
				previousSpritesPosition = sprite.position;
				sprite.position = self.entityModel.position;
			}
			else
			{
				CGPoint currentPos = sprite.position;
				sprite.position = previousSpritesPosition;
				previousSpritesPosition = currentPos;
			}
		}
	}
}


@end
