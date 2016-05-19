//
//  Camera.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef Camera_h
#define Camera_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Transform.h"

@interface Camera : NSObject

/** Initialize perspective camera with width, height, near plane and far plane
 *\param w      Width for camera vierport
 *\param h      Height for camera viewport
 *\param near   Near plane for camera frustom
 *\param far    Far plane for camera frustum
 */
-(id)initWithWidth:(float)w height:(float)h nearPlane:(float)near farPlane:(float)far;

/** Project screen point to world space
 *\param point Location of point in screen space (point.z = 0 for near plane and point.z = 1 for far plane)
 */
-(GLKVector3) screenPointToWorld: (GLKVector3)screenPoint;

/** Ray from screen point in direction of camera
 *\param screenPoint Location of point in screen space
 */
-(GLKVector3) screenPointToRay: (GLKVector2)screenPoint;

/** Update projection matrix
 */
-(void) updateProjectionMatrix;

/** Update view matrix (call after transforming camera)
 */
-(void) updateViewMatrix;

/** Camera viewport width
 */
-(const float) width;

/** Camera viewport height
 */
-(const float) height;

/** Camera frustum near plane
 */
-(const float) nearPlane;

/** Camera frustum far plane
 */
-(const float) farPlane;

/** Set camera viewport width (call updateProjectionMatrix after changing width)
 *\param w Width for the camera viewport
 */
-(void) setWidth:(float)w;

/** Set camera viewport height (call updateProjectionMatrix after changing width)
 *\param h Height for the camera viewport
 */
-(void) setHeight:(float)h;

/** Set camera viewport width and height (call updateProjectionMatrix after changing width)
 *\param w Width for the camera viewport
 *\param h Height for the camera viewport
 */
-(void) setWidth:(float)w andHeight:(float)h;

/** Set near plane for camera frustum (call updateProjectionMatrix after changing width)
 *\param near Near plane for camera frustum
 */
-(void) setNearPlane:(float)near;

/** Set far plane for camera frustum (call updateProjectionMatrix after changing width)
 *\param far Far plane for camera frustum
 */
-(void) setFarPlane:(float)far;

/** Transform node of the camera
 */
-(Transform *) transform;

/** Proection matrix of camera
 */
-(const GLKMatrix4) projectionMatrix;

/** View matrix of camera
 */
-(const GLKMatrix4) viewMatrix;

/** Cambined camera matrix (projectionMatrix * viewMatrix) of camera
 */
-(const GLKMatrix4) cameraMatrix;

@end

#endif
