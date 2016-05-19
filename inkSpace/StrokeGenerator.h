//
//  StrokeGenerator.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 17/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef StrokeGenerator_h
#define StrokeGenerator_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Stroke.h"

@interface StrokeGenerator : NSObject

+(StrokeGenerator*) getInstance;

/** Converts opengl line vertex data to opengl polygon data
 *\param stroke     Stroke to convert to polygon mesh
 *\param meshData   Array to add mesh data to
 *\param start      Starting index to use (required to draw generate polygon data along with drawing)
 */
-(void) generatorMeshFromStroke:(Stroke*)stroke outputMesh:(NSMutableArray*)meshData startingAt:(int)start;

@end

#endif