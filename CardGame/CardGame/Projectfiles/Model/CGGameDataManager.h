//
//  CGGameDataManager.h
//  CardGame
//
//  Created by adamgliea on 13-1-16.
//
//

#import <Foundation/Foundation.h>

@interface CGGameDataManager : NSObject

+ (CGGameDataManager *)sharedManager;

- (void)loadGameData;

@end
