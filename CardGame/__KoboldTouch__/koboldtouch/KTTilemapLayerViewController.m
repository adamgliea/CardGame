//
//  KTTilemapLayerViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 20.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapLayerViewController.h"
#import "KTTilemapModel.h"

// temporary
#import "KKInput.h"

#import "CCDirector.h"
#import "CCNode.h"
#import "CCSpriteBatchNode.h"
#import "CCSprite.h"
#import "CCActionInterval.h"
#import "CGPointExtension.h"

@interface KTTilemapLayerViewController ()
// declare private methods here
@end


@implementation KTTilemapLayerViewController

-(id) initWithTileLayer:(KTTilemapLayer*)tileLayer
{
	self = [super init];
	if (self)
	{
		self.tileLayer = tileLayer;
	}
	return self;
}


-(void) loadView
{
	CGSize winSize = [CCDirector sharedDirector].winSize;

	self.rootNode = [CCNode node];
	_rootNodePreviousPosition = CGPointMake(INT_MAX, INT_MAX);

	id move = [CCMoveBy actionWithDuration:5*4 position:CGPointMake(-80*10, -60*10)];
	id move2 = [CCMoveBy actionWithDuration:8*4 position:CGPointMake(1200, 1200)];
	id seq = [CCSequence actions:move, move2, nil];
	[self.rootNode runAction:seq];

	_batchNode = [CCSpriteBatchNode batchNodeWithTexture:_tileLayer.tiles.tileset.texture];
	_batchNode.visible = _tileLayer.visible;
	[self.rootNode addChild:_batchNode];
	[_batchNode.texture setAliasTexParameters];
	
	// create initial tiles to fill screen
	CCTexture2D* texture = _batchNode.texture;
	CGSize gridSize = _tileLayer.tilemap.gridSize;
	
	_tilesOnScreen = CGSizeMake(winSize.width / gridSize.width + 1, winSize.height / gridSize.height + 1);
	
	CCSprite* tile = nil;
	for (int tilePosY = 0; tilePosY < _tilesOnScreen.height; tilePosY++)
	{
		for (int tilePosX = 0; tilePosX < _tilesOnScreen.width; tilePosX++)
		{
			tile = [CCSprite spriteWithTexture:texture];
			tile.visible = NO;
			[_batchNode addChild:tile];
		}
	}
}


#pragma mark Step

-(void) beforeStep:(KTStepInfo *)stepInfo
{
	KKInput* input = [KKInput sharedInput];
	
	if ([input isAnyMouseButtonDownThisFrame])
	{
		CGPoint loc = ccpMult(ccpAdd(self.rootNode.position, input.mouseLocation), -1.0f);
		
		id move = [CCMoveTo actionWithDuration:5 position:loc];
		[self.rootNode stopAllActions];
		[self.rootNode runAction:move];
	}
}

-(void) afterStep:(KTStepInfo *)stepInfo
{
	//_batchNode.scale = 0.9f;
	
	CGPoint rootNodePosition = self.rootNode.position;
	if (rootNodePosition.x > 0.0f)
	{
		rootNodePosition.x = 0.0f;
		self.rootNode.position = CGPointMake(0.0f, rootNodePosition.y);
	}
	if (rootNodePosition.y > 0.0f)
	{
		rootNodePosition.y = 0.0f;
		self.rootNode.position = CGPointMake(rootNodePosition.x, 0.0f);
	}
	
	if (CGPointEqualToPoint(rootNodePosition, _rootNodePreviousPosition) == NO)
	{
		// create initial tiles to fill screen
		KTTilemapLayerTiles* tiles = _tileLayer.tiles;
		KTTilemapTileset* tileset = tiles.tileset;
		CGSize gridSize = _tileLayer.tilemap.gridSize;
		CGSize mapSize = _tileLayer.tilemap.mapSize;
		CGSize halfTileSize = CGSizeMake(tileset.tileSize.width * 0.5f, tileset.tileSize.height * 0.5f);

		CGPoint rootNodeAbsPosition = CGPointMake(fabsf(rootNodePosition.x), fabsf(rootNodePosition.y));
		CGPoint tileOffset = CGPointMake((int)(rootNodeAbsPosition.x / gridSize.width), (int)(rootNodeAbsPosition.y / gridSize.height));
		CGPoint pointOffset = CGPointMake((int)(tileOffset.x * gridSize.width) + 0.5f, (int)(tileOffset.y * gridSize.height) + 0.5f);
		
		//CGSize winSize = [CCDirector sharedDirector].winSize;
		//CGPoint focusPosition = CGPointMake(self.rootNode.position.x * 2, self.rootNode.position.y * 2);
		//CGPoint focusViewCenter = CGPointMake(winSize.width / 2, winSize.height / 2);
		
		// focus pos is world position in tilemap
		// start tile coord is half screen size minus focus
		// end tile coord is half screen size plus focus
		// view center: start coord is: focus pos minus view center
		// view center: end coord is: focus pos plus (screen size minus view center)
		
		NSUInteger i = 0;
		CCSprite* tile = nil;
		for (NSUInteger tilePosY = 0; tilePosY < _tilesOnScreen.height; tilePosY++)
		{
			for (NSUInteger tilePosX = 0; tilePosX < _tilesOnScreen.width; tilePosX++)
			{
				NSAssert(_batchNode.children.count > i, @"Tile layer index out of bounds! Perhaps due to window resize?");
				tile = [_batchNode.children objectAtIndex:i++];
				tile.visible = NO;
				
				// no tile?
				unsigned int gid = [_tileLayer tileWithFlagsAt:CGPointMake(tilePosX + tileOffset.x, (mapSize.height - 1 - tilePosY) - tileOffset.y)];
				if (gid == 0)
					continue;
				
				// rect will be empty if tile is from a different tileset
				CGRect textureRect = [tileset textureRectForGid:gid];
				if (CGRectIsEmpty(textureRect))
					continue;
				
				tile.textureRect = textureRect;
				tile.position = CGPointMake(tilePosX * gridSize.width + halfTileSize.width + pointOffset.x,
											tilePosY * gridSize.height + halfTileSize.height + pointOffset.y);
				
				// TRYFIX: black/weird lines (texel stretch: bad fix, flicker, subpixel off: bad fix, no alias texparams: bad fix, filter artifacts)
				// it's better now but still lines can be seen if looked at closely, or tilemap scrolling stops at unfortunate position
				tile.position = CGPointMake((int)(tile.position.x) + (0.5f / CC_CONTENT_SCALE_FACTOR()),
											(int)(tile.position.y) + (0.5f / CC_CONTENT_SCALE_FACTOR()));

				// reset defaults
				tile.visible = YES;
				tile.rotation = 0.0f;
				tile.flipX = NO;
				tile.flipY = NO;

				if (gid & KTTilemapTileDiagonalFlip)
				{
					// handle the 4 diagonally flipped states.
					uint32_t flag = gid & (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip);
					if (flag == KTTilemapTileHorizontalFlip)
					{
						tile.rotation = 90;
					}
					else if (flag == KTTilemapTileVerticalFlip)
					{
						tile.rotation = 270;
					}
					else if (flag == (KTTilemapTileHorizontalFlip | KTTilemapTileVerticalFlip))
					{
						tile.rotation = 90;
						tile.flipX = YES;
					}
					else
					{
						tile.rotation = 270;
						tile.flipX = YES;
					}
				}
				else
				{
					tile.flipX = (gid & KTTilemapTileHorizontalFlip) == KTTilemapTileHorizontalFlip;
					tile.flipY = (gid & KTTilemapTileVerticalFlip) == KTTilemapTileVerticalFlip;
				}
			}
		}
		
	}

	_rootNodePreviousPosition = rootNodePosition;
}

@end
