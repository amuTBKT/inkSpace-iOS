//
//  Plane.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 18/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "Plane.h"

@implementation Plane{
    GLKQuaternion rotation;
}

-(id) init{
    rotation = GLKQuaternionIdentity;
    
    return self;
}

-(void) setRotation:(GLKQuaternion)r{
    rotation = r;
}

-(void) rotate:(GLKQuaternion)r{
    rotation = GLKQuaternionNormalize(GLKQuaternionMultiply(r, rotation));
}

-(GLKVector3) intersectionWithLine:(GLKVector3)direction passingThrough:(GLKVector3)point{
    GLKVector3 normal = [self normal];
    
    float t = -GLKVector3DotProduct(normal, point);
    t /= GLKVector3DotProduct(normal, direction);
    
    return GLKVector3Add(point, GLKVector3MultiplyScalar(direction, t));
}

-(GLKVector3) normal{
    return GLKVector3Normalize(GLKQuaternionRotateVector3(rotation, GLKVector3Make(0, 0, 1)));
 }

-(GLKQuaternion) rotation{
    return rotation;
}

@end