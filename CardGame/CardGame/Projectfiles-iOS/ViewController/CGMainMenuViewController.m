//
//  CGMainMenuViewController.m
//  CardGame
//
//  Created by ZHANG YE on 12-12-31.
//
//

#import "CGMainMenuViewController.h"
#import "CSVParser.h"

@interface CGMainMenuViewController()

- (void)showAutoMatchView;

- (void)clickAutoMatchButton:(id)sender;

@end

@implementation CGMainMenuViewController

- (id)initWithSceneModel:(KTSceneModel *)sceneModel {
    self = [super initWithSceneModel:sceneModel];
    if (self != nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroCard" ofType:@"csv"];
        NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
//        NSArray *aaa = @[@"id", @"Name", @"Faction", @"Unique", @"CostType[1]", @"CostUnit[1]", @"CostNum[1]",
//                         @"CostType[2]", @"CostUnit[1]", @"CostNum[1]", @"Stars", @"ATK", @"DEF", @"BackgroundDescription",
//                         @"Image", @"SkillName[1]", @"SkillDescription[1]", @"TriggeredEffect[1]", @"SkillName[2]", @"SkillDescription[2]",
//                         @"TriggeredEffect[2]"];
        CSVParser *p = [[CSVParser alloc] initWithString:fileContent
                                               separator:@","
                                               hasHeader:YES
                                              fieldNames:nil];
        NSArray *b = [p arrayOfParsedRows];
        
        int i = 0;
    }
    
    return self;
}

#pragma mark -- Public Functions

- (void)authGameCenter {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        UIAlertView *authErrorAlertView = nil;
        
        if (error != nil) {
            authErrorAlertView = [[UIAlertView alloc] initWithTitle:@"GameCenter认证错误"
                                                            message:[error debugDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [authErrorAlertView show];
        }
        else {
            if (localPlayer.isAuthenticated) {
                [self showAutoMatchView];
            }
            else {
                authErrorAlertView = [[UIAlertView alloc] initWithTitle:@"必须登陆GameCenter才能玩哦"
                                                                message:[error debugDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
                [authErrorAlertView show];
            }
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
    GKMatchRequest *matchRequest = [[GKMatchRequest alloc] init];
    matchRequest.minPlayers = 2;
    matchRequest.maxPlayers = 2;
    matchRequest.defaultNumberOfPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:matchRequest];
    mmvc.matchmakerDelegate = self;
    
    CCDirector *director = [CCDirector sharedDirector];
    [director presentViewController:mmvc animated:YES completion:nil];
}

#pragma mark -- GKMatchmakerViewControllerDelegate

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    CCDirector *director = [CCDirector sharedDirector];
    [director dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    if (error != nil) {
        UIAlertView *authErrorAlertView = [[UIAlertView alloc] initWithTitle:@"GameCenter匹配错误"
                                                        message:[error debugDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        
        [authErrorAlertView show];
    }
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match {
    CCDirector *director = [CCDirector sharedDirector];
    [director dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
