//
//  KTTilemapLayerViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTViewController.h"

@class KTTilemapLayer;
@class CCSpriteBatchNode;

@interface KTTilemapLayerViewController : KTViewController
{
@protected
@private
	CCSpriteBatchNode* _batchNode;
	CGPoint _rootNodePreviousPosition;
	CGSize _tilesOnScreen;
}

@property (nonatomic, weak) KTTilemapLayer* tileLayer;
@property (nonatomic, weak) KTTilemapLayer* objectLayer;

-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer;

@end
