//
//  Stroke.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 17/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef Stroke_h
#define Stroke_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface StrokePoint : NSObject

/** Initialize stroke point with position and size
 *\param p Position of the point in world space
 *\param s Size of the point
 */
-(id) initWithPosition:(GLKVector3)p andSize:(float)s;

/** Sets position of the point
 *\param p Position of the point in world space
 */
-(void) setPosition:(GLKVector3)p;

/** Sets size of the point
 *\param s Size of the point
 */
-(void) setSize:(float)s;

/** Sets normal for the stroke point
 *\param n Normal vector of the stroke-plane
 */
-(void) setNormal:(GLKVector3)n;

/** Returns position of the point in world space
 */
-(GLKVector3) position;

/** Returns size of the point
 */
-(float) size;

/** Returns normal of the point
 */
-(GLKVector3) normal;

@end

@interface Stroke : NSObject

@property NSMutableArray *strokePoints;

-(id) init;

/** Initialize stroke with color
 *\param c Stroke color in RGB format
 */
-(id) initWithColor:(GLKVector3)c;

/** Adds stroke point to the stroke
 *\param point StrokePoint to add
 */
-(void) addStrokePoint:(StrokePoint*)point;

/** Returns stroke color
 */
-(GLKVector3) color;

@end

#endif
