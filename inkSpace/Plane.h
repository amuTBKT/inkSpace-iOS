//
//  Plane.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 18/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef Plane_h
#define Plane_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Plane : NSObject

-(id) init;

/** Set rotation of the plane
 *\param r Quaternion rotation
 */
-(void) setRotation:(GLKQuaternion)r;

/** Rotate the plane
 *\param r Quaternion delta rotation
 */
-(void) rotate:(GLKQuaternion)r;

/** Calculate intersection point with a line 'direction' passing through 'point'
 *\param direction  Direction of the line
 *\param point      Any point through which given line passes
 */
-(GLKVector3) intersectionWithLine:(GLKVector3)direction passingThrough:(GLKVector3)point;

/** Normal of the plane
 */
-(GLKVector3) normal;

/** Rotation of the plane
 */
-(GLKQuaternion) rotation;

@end

#endif
