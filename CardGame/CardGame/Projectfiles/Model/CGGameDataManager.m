//
//  CGGameDataManager.m
//  CardGame
//
//  Created by adamgliea on 13-1-16.
//
//

#import "CGGameDataManager.h"
#import "CSVParser.h"

typedef void(^loadDataCompleteBlock_t)(NSArray* parseRet);

@interface CGGameDataManager() {
    dispatch_queue_t m_dataOpQueue;
}

@property (strong) NSArray *heroData;
@property (strong) NSArray *stratagemData;
@property (strong) NSArray *trapData;
@property (strong) NSArray *triggeredEffectData;

- (void)loadHeroCardData;
- (void)loadStratagemCardData;
- (void)loadTrapCardData;
- (void)loadTriggeredEffectData;

- (void)loadCsvDataWithName:(NSString *)name completeBlock:(loadDataCompleteBlock_t)completeBlock;

@end

@implementation CGGameDataManager

+ (CGGameDataManager *)sharedManager {
    static CGGameDataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        m_dataOpQueue = dispatch_queue_create("GameDataOpQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)dealloc {
    dispatch_release(m_dataOpQueue);
    m_dataOpQueue = NULL;
}

- (void)loadGameData {
    [self loadHeroCardData];
    [self loadStratagemCardData];
    [self loadTrapCardData];
    [self loadTriggeredEffectData];
}

#pragma mark -- Private Functions

- (void)loadHeroCardData {
    [self loadCsvDataWithName:@"HeroCard" completeBlock:^(NSArray *parseRet) {
        self.heroData = parseRet;
    }];
}

- (void)loadStratagemCardData {
    [self loadCsvDataWithName:@"StratagemCard" completeBlock:^(NSArray *parseRet) {
        self.stratagemData = parseRet;
    }];
}

- (void)loadTrapCardData {
    [self loadCsvDataWithName:@"TrapCard" completeBlock:^(NSArray *parseRet) {
        self.trapData = parseRet;
    }];
}

- (void)loadTriggeredEffectData {
    [self loadCsvDataWithName:@"TriggeredEffect" completeBlock:^(NSArray *parseRet) {
        self.triggeredEffectData = parseRet;
    }];
}

- (void)loadCsvDataWithName:(NSString *)name completeBlock:(loadDataCompleteBlock_t)completeBlock {
    dispatch_async(m_dataOpQueue, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"csv"];
        NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        CSVParser *parser = [[CSVParser alloc] initWithString:fileContent
                                                    separator:@","
                                                    hasHeader:YES
                                                   fieldNames:nil];
        NSArray *parseRet = [parser arrayOfParsedRows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completeBlock(parseRet);
        });
    });
}

@end
