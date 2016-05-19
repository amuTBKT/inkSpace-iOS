//
//  Transform.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef Transform_h
#define Transform_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Transform : NSObject

-(id) init;

-(void) setPosition:(GLKVector3)p;
-(void) setPosition:(float)px :(float)py :(float)pz;
-(void) translate:(GLKVector3)dp;
-(void) translate:(float)dx :(float)dy :(float)dz;

-(void) setScale:(GLKVector3)s;
-(void) setScale:(float)sx :(float)sy :(float)sz;
-(void) scale:(GLKVector3)ds;
-(void) scale:(float)dx :(float)dy :(float)dz;

-(void) setRotation:(GLKQuaternion)q;
-(void) setRotation:(float)qx :(float)qy :(float)qz :(float)qw;
-(void) setRotation:(float)ex :(float)ey :(float)ez;
-(void) rotate:(GLKQuaternion)dq;
-(void) rotate:(float)qx :(float)qy :(float)qz :(float)qw;
-(void) rotate:(float)ex :(float)ey :(float)ez;

-(void) lookAt:(GLKVector3)target;

-(const GLKVector3) position;
-(const GLKVector3) scale;
-(const GLKQuaternion) rotation;
-(const GLKMatrix4) transformMatrix;

@end

#endif
