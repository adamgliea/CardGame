//
//  CGGamePlayViewController.m
//  CardGame
//
//  Created by adamgliea on 13-1-16.
//
//

#import "CGGamePlayViewController.h"
#import "CGBeenShownCardViewController.h"

@implementation CGGamePlayViewController

- (id)initWithSceneModel:(KTSceneModel *)sceneModel {
    self = [super initWithSceneModel:sceneModel];
    if (self != nil) {
    }
    
    return self;
}

- (void)viewDidLoad {
    CGBeenShownCardViewController *bscVC = [[CGBeenShownCardViewController alloc] init];
    [self addSubController:bscVC];
}

@end
