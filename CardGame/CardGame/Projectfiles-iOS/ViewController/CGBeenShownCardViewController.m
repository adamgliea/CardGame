//
//  CGBeenShownCardViewController.m
//  CardGame
//
//  Created by adamgliea on 13-1-16.
//
//

#import "CGBeenShownCardViewController.h"

static NSUInteger kCardSlotMaxCount = 6;

@interface CGBeenShownCardViewController()

- (void)initCardSlots;

@end

@implementation CGBeenShownCardViewController

- (id)init {
    self = [super init];
    if (self != nil) {
        KTEntityModel *layerModel = [KTEntityModel model];
        layerModel.contentSize = CGSizeMake(300, 200);
        self.model = layerModel;
        
        CCLayer *containerNode = [CCLayer node];
        self.rootNode = containerNode;
    }
    
    return self;
}

- (void)load {
    [super load];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CardGame.plist"];
    
    [self initCardSlots];
}

#pragma mark -- Private Functions

- (void)initCardSlots {
    NSUInteger i = 0;
    for (; i < kCardSlotMaxCount; ++i) {
        KTSpriteViewController *b = [KTSpriteViewController spriteControllerWithSpriteFrameName:@"CardSlot.png"];
        [self addSubController:b];
    }
}

@end
