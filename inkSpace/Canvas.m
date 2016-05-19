//
//  CanvasManager.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "Canvas.h"

#define clamp(min, max, value) MAX(min, MIN(max, value))
#define ANGLE_LIMIT_X 85.f
#define MIN_POINT_SIZE 2.f
#define MAX_POINT_SIZE 5.f

@implementation Canvas{
    int canvasWidth, canvasHeight;
    float canvasRotX, canvasRotY;
    
    float cameraOrbitRadius;
    Camera *camera;
    Shader *shader;
    
    GLKVector3 strokeColor;
    Stroke *currentStroke;
    int currentStrokeIndex;
    GLKVector3 prevTouchPosition;
    
    Plane *plane;
}

-(id)initWithWidth:(int)width andHeight:(int)height{
    shader = [[ShaderManager getInstance] loadShaderWithVertex:"Shader" andFragment:"Shader"];
    
    canvasWidth = width;
    canvasHeight = height;
    
    canvasRotX = canvasRotY = 0;
    
    // initialize camera object
    camera = [[Camera alloc] initWithWidth:canvasWidth height:canvasHeight nearPlane:0.1f farPlane:1000.0f];
    cameraOrbitRadius = 500.f;
    
    self.meshData = [[NSMutableArray alloc] init];
    self.pointSizes = [[NSMutableArray alloc] init];
    currentStroke = nil;
    currentStrokeIndex = 0;
    
    plane = [[Plane alloc] init];
    
    // initialize scene
    [self rotateCanvas:CGPointMake(0, 0)];
    
    // set stroke color to white
    [self setStrokeColor:1 :1 :1];
    
    return self;
}

-(void) update:(float)deltaTime{
}

-(void)render{
    // bind shader to opengl context
    [shader begin];
    
    // update shader camera matrix
    [shader setUniformMatrix:[camera cameraMatrix].m atLocation:[shader cameraMatrixLocation]];
    
    // number of draw calls
    int draws = (int)[self.meshData count] / 6;
    
    // auto release resources from this block
    @autoreleasepool {
        // create float array to pass data to gpu
        float *array = (float*) malloc(sizeof(float) * draws * 6);
        for (int i = 0; i < draws * 6; i++){
            array[i] = [[self.meshData objectAtIndex:i] floatValue];
        }
        
        // enable a_position attribute array
        glEnableVertexAttribArray([shader posAttribLocation]);
        // enable a_texcoord attribute array
        glEnableVertexAttribArray([shader texcoordAttribLocation]);
        
        // set a_position attribute array
        glVertexAttribPointer([shader posAttribLocation], 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), &array[0]);
        // set a_texcoord attribute array
        glVertexAttribPointer([shader texcoordAttribLocation], 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), &array[3]);
        
        // send draw calls to gpu
        glDrawArrays(GL_TRIANGLES, 0, draws);
        
        // disable a_position attribute array
        glDisableVertexAttribArray([shader posAttribLocation]);
        // disable a_texcoord attribute array
        glDisableVertexAttribArray([shader texcoordAttribLocation]);
    }
    
    // unbind shader from opengl context
    [shader end];
}

-(void) clear{
    // clear srokes
    [self.meshData removeAllObjects];
    [self.pointSizes removeAllObjects];
    currentStrokeIndex = 0;
    
    // reset orientation
    [self rotateCanvas:CGPointMake(-canvasRotX, -canvasRotY)];
}

-(void)rotateCanvas:(CGPoint)angle{
    canvasRotX += angle.x;
    canvasRotY += angle.y;
    
    // clamp rotation
    canvasRotX = clamp(-ANGLE_LIMIT_X, ANGLE_LIMIT_X, canvasRotX);

    // convert rotation from degrees to radians
    float rotationX = GLKMathDegreesToRadians(canvasRotX);
    float rotationY = GLKMathDegreesToRadians(canvasRotY);
    
    // calculate rotation
    GLKQuaternion rotation = GLKQuaternionNormalize(GLKQuaternionMultiply(GLKQuaternionMakeWithAngleAndAxis(rotationY, 0, 1, 0), GLKQuaternionMakeWithAngleAndAxis(rotationX, 1, 0, 0)));
    
    // set plane rotation
    [plane setRotation:rotation];
    
    // calculate camera position (orbit position)
    GLKVector3 cameraPosition = GLKVector3Normalize(GLKQuaternionRotateVector3(rotation, GLKVector3Make(0, 0, 1)));
    cameraPosition = GLKVector3MultiplyScalar(cameraPosition, cameraOrbitRadius);
    
    // set camera position
    [[camera transform] setPosition:cameraPosition];
    // make camera to face plane
    [[camera transform] lookAt:GLKVector3Make(0, 0, 0)];
    // update camera view projection
    [camera updateViewMatrix];
}

-(void)onTouchBegan:(CGPoint)touchLocation{
    GLKVector3 v = [camera screenPointToRay:GLKVector2Make(touchLocation.x, canvasHeight - touchLocation.y)];
    GLKVector3 s = [camera screenPointToWorld:GLKVector3Make(touchLocation.x, touchLocation.y, 0)];
    GLKVector3 position = [plane intersectionWithLine:v passingThrough:s];
    
    // default point size = 1.f
    [self.pointSizes addObject:[NSNumber numberWithFloat:MIN_POINT_SIZE]];
    
    // create new stroke
    currentStroke = [[Stroke alloc] initWithColor:strokeColor];
    currentStrokeIndex = 0;
    
    StrokePoint *point = [[StrokePoint alloc] initWithPosition:position andSize:MIN_POINT_SIZE];
    [point setNormal:[plane normal]];
    [currentStroke addStrokePoint:point];
}

-(void)onTouchMove:(CGPoint)touchLocation touchVelocity:(CGPoint)touchVelocity{
    GLKVector3 v = [camera screenPointToRay:GLKVector2Make(touchLocation.x, canvasHeight - touchLocation.y)];
    GLKVector3 s = [camera screenPointToWorld:GLKVector3Make(touchLocation.x, touchLocation.y, 0)];
    GLKVector3 position = [plane intersectionWithLine:v passingThrough:s];
    
    // calculate point size
    float speed = GLKVector2Length(GLKVector2Make(touchVelocity.x, touchVelocity.y));
    float size = 1000.f / speed;
    size = clamp(MIN_POINT_SIZE, MAX_POINT_SIZE, size);
    
    // smooth transition between previous point size and current point size
    if ([self.pointSizes count] > 0) {
        size = (size + [[self.pointSizes objectAtIndex:[self.pointSizes count] - 1] floatValue] * 0.75f) / 2.f;
    }
    [self.pointSizes addObject:[NSNumber numberWithFloat:size]];

    if (GLKVector3Length(GLKVector3Subtract(position, prevTouchPosition)) > 1.0f){
        StrokePoint *point = [[StrokePoint alloc] initWithPosition:position andSize:size];
        [point setNormal:[plane normal]];
        [currentStroke addStrokePoint:point];
        
        // generate mesh data
        [[StrokeGenerator getInstance] generatorMeshFromStroke:currentStroke outputMesh:self.meshData startingAt:currentStrokeIndex++];
        
        prevTouchPosition = position;
    }
}

-(void)onTouchEnd:(CGPoint)touchLocation{
    GLKVector3 v = [camera screenPointToRay:GLKVector2Make(touchLocation.x, canvasHeight - touchLocation.y)];
    GLKVector3 s = [camera screenPointToWorld:GLKVector3Make(touchLocation.x, touchLocation.y, 0)];
    GLKVector3 position = [plane intersectionWithLine:v passingThrough:s];
    
    // default point size = 1.f
    [self.pointSizes addObject:[NSNumber numberWithFloat:MIN_POINT_SIZE]];
    
    StrokePoint *point = [[StrokePoint alloc] initWithPosition:position andSize:MIN_POINT_SIZE];
    [point setNormal:[plane normal]];
    [currentStroke addStrokePoint:point];
    
    // generate mesh data
    [[StrokeGenerator getInstance] generatorMeshFromStroke:currentStroke outputMesh:self.meshData startingAt:currentStrokeIndex++];
    
    // delete stroke
    currentStroke = nil;
}

-(void) setStrokeColor:(float)r :(float)g :(float)b{
    strokeColor.x = r;
    strokeColor.y = g;
    strokeColor.z = b;
}

-(void) setStrokeColor:(GLKVector3)color{
    strokeColor = color;
}

@end