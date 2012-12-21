//
//  PhysicNutsViewController.m
//  _KoboldTouch-Template_
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "PhysicNutsViewController.h"
#import "KTModel.h"

@implementation PhysicNutsViewController

-(void) initWithDefaults
{
	self.createModelBlock = ^{
		return [KTPhysicsEntityModel model];
	};
}


@end
