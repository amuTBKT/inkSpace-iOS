//
//  CanvasManager.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef Canvas_h
#define Canvas_h

#import <Foundation/Foundation.h>
#import "Camera.h"
#import "ShaderManager.h"
#import "StrokeGenerator.h"
#import "Plane.h"

@interface Canvas : NSObject

// to store polygon mesh data
@property (strong, nonatomic) NSMutableArray *meshData;

// to calculate smooth size for stroke points
@property (strong, nonatomic) NSMutableArray *pointSizes;

/** Initialize canvas with width and height
 *\param width Canvas width
 *\param height Canvas height
 */
-(id) initWithWidth:(int)width andHeight:(int)height;

/** Update canvas
 */
-(void) update:(float)deltaTime;

/** Render canvas
 */
-(void) render;

/** Clear canvas
 */
-(void) clear;

/** Rotate canvas by given angle. Bind this method with acceletator event
 *\param angle Delta angle
 */
-(void) rotateCanvas:(CGPoint)angle;

// To handle touch events
-(void) onTouchBegan:(CGPoint) touchLocation;
-(void) onTouchMove:(CGPoint)touchLocation touchVelocity:(CGPoint)touchVelocity;
-(void) onTouchEnd:(CGPoint) touchLocation;

/** Set stroke color
 *\param r Red component of the color [0-1]
 *\param g Green component of the color [0-1]
 *\param b Blue component of the color [0-1]
 */
-(void) setStrokeColor:(float)r :(float)g :(float)b;

/** Set stroke color
 *\param color Stroke color
 */
-(void) setStrokeColor:(GLKVector3)color;

@end

#endif
