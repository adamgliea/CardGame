//
//  KTTilemapViewController.m
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTTilemapViewController.h"
#import "KTTilemapLayerViewController.h"
#import "KTTilemapModel.h"

#import "CCNode.h"

@interface KTTilemapViewController ()
// declare private methods here
@end


@implementation KTTilemapViewController

+(id) tilemapControllerWithTMXFile:(NSString*)tmxFile
{
	return [[self alloc] initWithTMXFile:tmxFile];
}

-(id) initWithTMXFile:(NSString*)tmxFile
{
	self = [super init];
	if (self)
	{
		self.tmxFile = tmxFile;
	}
	return self;
}

#pragma mark Controller Callbacks

-(void) initWithDefaults
{
	self.createModelBlock = ^{
		return [KTTilemapModel model];
	};
}

-(void) load
{
	KTTilemapModel* tilemapModel = (KTTilemapModel*)self.model;
	NSAssert1([tilemapModel isKindOfClass:[KTTilemapModel class]], @"tilemapModel (%@) is not a KTTilemapModel class", tilemapModel);

	for (KTTilemapLayer* layer in tilemapModel.tilemap.layers)
	{
		if (layer.isObjectLayer == NO)
		{
			KTTilemapLayerViewController* layerViewController = [[KTTilemapLayerViewController alloc] initWithTileLayer:layer];
			[self addSubController:layerViewController];
		}
		else
		{
			KTTilemapLayerViewController* layerViewController = [self.subControllers lastObject];
			layerViewController.objectLayer = layer;
		}
	}
}

-(void) loadView
{
	self.rootNode = [CCNode node];
	
	/*
	CGSize winSize = [CCDirector sharedDirector].winSize;
	int i = 0;
	
	for (KTTilemapLayer* layer in _tilemapModel.tilemap.layers)
	{
		if (layer.isObjectLayer == NO)
		{
		
			CCSpriteBatchNode* batchNode = [CCSpriteBatchNode batchNodeWithTexture:layer.tiles.tileset.texture];
			batchNode.tag = i++;
			batchNode.visible = layer.visible;
			[self.rootNode addChild:batchNode];
			
			//batchNode.scale = 0.9f;
			[batchNode.texture setAliasTexParameters];
			
			// create initial tiles to fill screen
			KTTilemapLayerTiles* tiles = layer.tiles;
			KTTilemapTileset* tileset = tiles.tileset;
			CCTexture2D* texture = batchNode.texture;
			CGSize gridSize = _tilemapModel.tilemap.gridSize;
			CGSize mapSize = _tilemapModel.tilemap.mapSize;
			CGSize halfTileSize = CGSizeMake(tileset.tileSize.width * 0.5f, tileset.tileSize.height * 0.5f);
			
			CGSize tilesOnScreen = CGSizeMake(winSize.width / gridSize.width + 1, winSize.height / gridSize.height + 1);
			CGPoint focusPosition = CGPointMake(winSize.width / 3, winSize.height / 3);
			CGPoint focusViewCenter = CGPointMake(winSize.width / 2, winSize.height / 2);

			// focus pos is world position in tilemap
			// start tile coord is half screen size minus focus
			// end tile coord is half screen size plus focus
			// view center: start coord is: focus pos minus view center
			// view center: end coord is: focus pos plus (screen size minus view center)
			
			int tilePosXStart = (focusViewCenter.x - focusPosition.x) / (int)gridSize.width;
			int tilePosYStart = (focusViewCenter.y - focusPosition.y) / (int)gridSize.height;
			LOG_EXPR(tilePosXStart);
			LOG_EXPR(tilePosYStart);
			
			CCSprite* tile = nil;
			for (int tilePosY = tilePosYStart; tilePosY < tilesOnScreen.height; tilePosY++)
			{
				for (int tilePosX = tilePosXStart; tilePosX < tilesOnScreen.width; tilePosX++)
				{
					// no tile?
					unsigned int gid = [layer tileWithFlagsAt:CGPointMake(tilePosX, (mapSize.height - 1) - tilePosY)];
					if (gid == 0)
						continue;

					// rect may be empty if tile is from a different tileset
					CGRect textureRect = [tileset textureRectForGid:gid];
					if (CGRectIsEmpty(textureRect))
						continue;
					
					tile = [CCSprite spriteWithTexture:texture rect:textureRect];
					tile.position = CGPointMake(tilePosX * gridSize.width + halfTileSize.width,
												tilePosY * gridSize.height + halfTileSize.height);
					[batchNode addChild:tile];
					
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
	}
	 */
}

@end
