//
//  CGMainMenuViewController.m
//  CardGame
//
//  Created by ZHANG YE on 12-12-31.
//
//

#import "CGMainMenuViewController.h"

@interface CGMainMenuViewController()

- (void)showAutoMatchView;

- (void)clickAutoMatchButton:(id)sender;

@end

@implementation CGMainMenuViewController

- (id)initWithSceneModel:(KTSceneModel *)sceneModel {
    self = [super initWithSceneModel:sceneModel];
    if (self != nil) {
    }
    
    return self;
}

#pragma mark -- Public Functions

- (void)authGameCenter {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            UIAlertView *authErrorAlertView = [[UIAlertView alloc] initWithTitle:@"GameCenter认证错误"
                                                                         message:[error debugDescription]
                                                                        delegate:nil
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"确定", nil];
            [authErrorAlertView show];
        }
        else {
            [self showAutoMatchView];
        }
    }];
}

#pragma mark -- Private Functions

- (void)showAutoMatchView {
    CCDirector *director = [CCDirector sharedDirector];
    
    UIButton *automatchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    automatchButton.frame = CGRectMake(0, 0, 100, 30);
    [automatchButton setTitle:@"开始自动匹配" forState:UIControlStateNormal];
    [automatchButton addTarget:self action:@selector(clickAutoMatchButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect screenBound = [UIScreen mainScreen].bounds;
    automatchButton.center = CGPointMake(screenBound.size.width * 0.5,
                                         screenBound.size.height * 0.5);
    
    [director.view addSubview:automatchButton];
}

#pragma mark -- UI Actions

- (void)clickAutoMatchButton:(id)sender {
    int i = 0;
}

@end
