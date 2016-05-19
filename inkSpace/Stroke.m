//
//  Stroke.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 17/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "Stroke.h"

@implementation StrokePoint{
    float size;             // size of the point
    GLKVector3 position;    // position of the point in world space
    
    GLKVector3 normal;      // stroke-plane normal
}

-(id)initWithPosition:(GLKVector3)p andSize:(float)s{
    position = p;
    size = s;
    return self;
}

-(void) setPosition:(GLKVector3)p{
    position = p;
}

-(void) setSize:(float)s{
    size = s;
}

-(void) setNormal:(GLKVector3)n{
    normal = n;
}

-(GLKVector3) position{
    return position;
}

-(float) size{
    return size;
}

-(GLKVector3) normal{
    return normal;
}

@end

@implementation Stroke{
    GLKVector3 color;
}

@synthesize strokePoints;

-(id)init{
    // initialize array
    strokePoints = [[NSMutableArray alloc] init];
    
    // default color to use = white
    color = GLKVector3Make(1, 1, 1);
    
    return self;
}

-(id)initWithColor:(GLKVector3)c{
    // initialize array
    strokePoints = [[NSMutableArray alloc] init];

    // set color
    color = c;
    
    return self;
}

-(void) addStrokePoint:(StrokePoint *)point{
    [strokePoints addObject:point];
}

-(GLKVector3) color{
    return color;
}

@end