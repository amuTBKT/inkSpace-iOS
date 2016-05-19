//
//  Transform.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "Transform.h"

@implementation Transform{
    GLKVector3 position, scale;
    GLKQuaternion rotation;
    GLKMatrix4 transformMatrix;
}

-(id) init{
    position.x = position.y = position.z = 0;
    scale.x = scale.y = scale.z = 1;
    rotation = GLKQuaternionIdentity;
    
    return self;
}

-(void) setPosition:(GLKVector3)p{
    position = p;
}

-(void) setPosition:(float)px :(float)py :(float)pz{
    position.x = px;
    position.y = py;
    position.z = pz;
}

-(void) translate:(GLKVector3)dp{
    position = GLKVector3Add(position, dp);
}

-(void) translate:(float)dx :(float)dy :(float)dz{
    position.x += dx;
    position.y += dy;
    position.z += dz;
}

-(void) setScale:(GLKVector3)s{
    scale = s;
}

-(void) setScale:(float)sx :(float)sy :(float)sz{
    scale.x = sx;
    scale.y = sy;
    scale.z = sz;
}

-(void) scale:(GLKVector3)ds{
    scale = GLKVector3Multiply(scale, ds);
}

-(void) scale:(float)dx :(float)dy :(float)dz{
    scale.x *= dx;
    scale.y *= dy;
    scale.z *= dz;
}

-(void) setRotation:(GLKQuaternion)q{
    rotation = q;
    rotation = GLKQuaternionNormalize(rotation);
}

-(void) setRotation:(float)qx :(float)qy :(float)qz :(float)qw{
    rotation = GLKQuaternionMake(qx, qy, qz, qw);
    rotation = GLKQuaternionNormalize(rotation);
}

-(void) setRotation:(float)ex :(float)ey :(float)ez{
    GLKMathDegreesToRadians(ex);
    GLKMathDegreesToRadians(ey);
    GLKMathDegreesToRadians(ez);
    
    rotation = GLKQuaternionNormalize(rotation);
}

-(void) rotate:(GLKQuaternion)dq{
    rotation = GLKQuaternionMultiply(dq, rotation);
    rotation = GLKQuaternionNormalize(rotation);
}

-(void) rotate:(float)qx :(float)qy :(float)qz :(float)qw{
    rotation = GLKQuaternionMultiply(GLKQuaternionMake(qx, qy, qz, qw), rotation);
    rotation = GLKQuaternionNormalize(rotation);
}

-(void) rotate:(float)ex :(float)ey :(float)ez{
    rotation = GLKQuaternionNormalize(rotation);
}

-(void) lookAt:(GLKVector3)target{
    /*
     source : http://mmmovania.blogspot.in/2014/03/making-opengl-object-look-at-another.html
    */
    
    GLKVector3 delta = GLKVector3Subtract(target, position);
    GLKVector3 up;
    GLKVector3 direction = GLKVector3Normalize(delta);
    if (ABS(direction.x) < 0.00001 && ABS(direction.z) < 0.00001){
        if (direction.y > 0)
            up = GLKVector3Make(0.0, 0.0, -1.0); // if direction points in +y
        else
            up = GLKVector3Make(0.0, 0.0, 1.0); // if direction points in -y
    }
    else {
        up = GLKVector3Make(0.0, 1.0, 0.0); //y - axis is the general up
    }
    up = GLKVector3Normalize(up);
    GLKVector3 right = GLKVector3Normalize(GLKVector3CrossProduct(up, direction));
    up = GLKVector3Normalize(GLKVector3CrossProduct(direction, right));
    
    GLKMatrix4 rotMat = GLKMatrix4Make(right.x, right.y, right.z, 0.0f,
                                       up.x, up.y, up.z, 0.0f,
                                       direction.x, direction.y, direction.z, 0.0f,
                                       position.x, position.y, position.z, 1.0f);
    
    [self setRotation:(GLKQuaternionMakeWithMatrix4(rotMat))];
}

-(const GLKVector3) position{
    return position;
}

-(const GLKVector3) scale{
    return scale;
}

-(const GLKQuaternion) rotation{
    return rotation;
}

-(const GLKMatrix4) transformMatrix{
    transformMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    transformMatrix = GLKMatrix4Multiply(transformMatrix,  GLKMatrix4MakeWithQuaternion(rotation));
    transformMatrix = GLKMatrix4Scale(transformMatrix, scale.x, scale.y, scale.z);
    
    return transformMatrix;
}

@end