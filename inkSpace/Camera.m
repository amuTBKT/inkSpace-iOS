//
//  Camera.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "Camera.h"

// camera field of view = 45 degrees
#define CAMERA_FOV M_PI / 4.f

@implementation Camera{
    float width, height, nearPlane, farPlane;
    int viewport[4];
    GLKMatrix4 projectionMatrix, viewMatrix, cameraMatrix;
    Transform *transform;
}

-(id) initWithWidth:(float)w height:(float)h nearPlane:(float)near farPlane:(float)far{
    width = w;
    height = h;
    nearPlane = near;
    farPlane = far;
    
    viewport[0] = 0;
    viewport[1] = 0;
    viewport[2] = width;
    viewport[3] = height;
    
    [self updateProjectionMatrix];
    [self updateViewMatrix];
    
    transform = [[Transform alloc] init];
    
    return self;
}

-(GLKVector3) screenPointToWorld: (GLKVector3)screenPoint{
    return GLKMathUnproject(screenPoint, viewMatrix, projectionMatrix, viewport, 0);
}

-(GLKVector3) screenPointToRay: (GLKVector2)screenPoint{
    return GLKVector3Normalize(
                               GLKVector3Subtract(
                                                  // far
                                                  GLKMathUnproject(GLKVector3Make(screenPoint.x, screenPoint.y, 1), viewMatrix, projectionMatrix, viewport, 0),
                                                  // near
                                                  GLKMathUnproject(GLKVector3Make(screenPoint.x, screenPoint.y, 0), viewMatrix, projectionMatrix, viewport, 0)
                                                  )
                               );
}

-(void) updateProjectionMatrix{
    projectionMatrix = GLKMatrix4MakePerspective(CAMERA_FOV, width / height, nearPlane, farPlane);
    
    cameraMatrix = GLKMatrix4Multiply(projectionMatrix, viewMatrix);
}

-(void) updateViewMatrix{
    viewMatrix = GLKMatrix4Multiply(GLKMatrix4MakeLookAt(0, 0, 0, 0, 0, 1, 0, 1, 0), GLKMatrix4Invert([transform transformMatrix], 0));
    
    cameraMatrix = GLKMatrix4Multiply(projectionMatrix, viewMatrix);
}

-(void) setWidth:(float)w{
    width = w;
    viewport[2] = w;
    [self updateProjectionMatrix];
}

-(void) setHeight:(float)h{
    height = h;
    viewport[3] = h;
    [self updateProjectionMatrix];
}

-(void) setWidth:(float)w andHeight:(float)h{
    width = w;
    height = h;
    viewport[2] = w;
    viewport[3] = h;
    [self updateProjectionMatrix];
}

-(void) setNearPlane:(float)near{
    nearPlane = near;
    [self updateProjectionMatrix];
}

-(void) setFarPlane:(float)far{
    farPlane = far;
    [self updateProjectionMatrix];
}

-(Transform *) transform{
    return transform;
}

-(const GLKMatrix4) projectionMatrix{
    return projectionMatrix;
}

-(const GLKMatrix4) viewMatrix{
    return viewMatrix;
}

-(const GLKMatrix4) cameraMatrix{
    return cameraMatrix;
}

-(const float) width{
    return width;
}

-(const float) height{
    return height;
}

-(const float) nearPlane{
    return nearPlane;
}

-(const float) farPlane{
    return farPlane;
}

@end