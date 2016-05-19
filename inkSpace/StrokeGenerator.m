//
//  StrokeGenerator.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 17/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "StrokeGenerator.h"

@implementation StrokeGenerator

+(StrokeGenerator*) getInstance{
    StrokeGenerator *instance;
    if (nil == instance){
        instance = [[StrokeGenerator alloc] init];
    }
    return instance;
}

-(void) generatorMeshFromStroke:(Stroke *)stroke outputMesh:(NSMutableArray *)meshData startingAt:(int)start{
    // number of points in stroke
    int numPoints = (int)[[stroke strokePoints] count];
    
    // loop through all the points and generate mesh
    for (int i = start; i < numPoints; i++){
        StrokePoint *currentPoint = [[stroke strokePoints] objectAtIndex:i], *nextPoint = nil;
        
        // check if there is next point available
        if (i < numPoints - 1){
            nextPoint = [[stroke strokePoints] objectAtIndex:(i + 1)];
            
            // variables to determine polygon mesh vertices
            GLKVector3 normal = [currentPoint normal];
            GLKVector3 tangent = GLKVector3Normalize(GLKVector3Subtract([nextPoint position], [currentPoint position]));
            GLKVector3 perpendicular = GLKVector3CrossProduct(tangent, normal);
            
            // size of current point
            float size0 = [currentPoint size];
            // size of next point
            float size1 = [nextPoint size];
            
            GLKVector3 p0, p1;
            
            // create new mesh points
            if (i == 0){
                p0 = GLKVector3Subtract([currentPoint position], GLKVector3MultiplyScalar(perpendicular, -size0 / 2.f));
                p1 = GLKVector3Subtract([currentPoint position], GLKVector3MultiplyScalar(perpendicular, size0 / 2.f));
            }
            // use previous mesh points if available (for continuous lines)
            else {
                // pop out mesh points
                int meshDataSize = (int)[meshData count] - 4;
                p1.z = [[meshData objectAtIndex:(meshDataSize--)] floatValue];
                p1.y = [[meshData objectAtIndex:(meshDataSize--)] floatValue];
                p1.x = [[meshData objectAtIndex:(meshDataSize--)] floatValue];
                
                meshDataSize -= 9;
                
                p0.z = [[meshData objectAtIndex:(meshDataSize--)] floatValue];
                p0.y = [[meshData objectAtIndex:(meshDataSize--)] floatValue];
                p0.x = [[meshData objectAtIndex:(meshDataSize)] floatValue];
            }
            
            GLKVector3 p2 = GLKVector3Subtract([nextPoint position], GLKVector3MultiplyScalar(perpendicular, -size1 / 2.f));
            GLKVector3 p3 = GLKVector3Subtract([nextPoint position], GLKVector3MultiplyScalar(perpendicular, size1 / 2.f));
            
            // stroke color
            float colorR = [stroke color].x;
            float colorG = [stroke color].y;
            float colorB = [stroke color].z;
            
            /* Add vertex data to outputMesh array
             
             L -> line vertex (given line)
             P -> polygon vertices (generated polygon)
             
             Vertex Order          = {P0 P1 P2}, {P2 P1 P3}
             Draw using RenderMode = GL_TRIANGLES
             
             P1-------------------------P3
             |                           |
             L0-------------------------L1
             |                           |
             P0-------------------------P2
             
             format: (for all the vertices)
                Position.x  Position.y  Position.z
                Color.r     Color.g     Color.b
             */
            
            [meshData addObject:[NSNumber numberWithFloat:p0.x]];
            [meshData addObject:[NSNumber numberWithFloat:p0.y]];
            [meshData addObject:[NSNumber numberWithFloat:p0.z]];
            
            [meshData addObject:[NSNumber numberWithFloat:colorR]];
            [meshData addObject:[NSNumber numberWithFloat:colorG]];
            [meshData addObject:[NSNumber numberWithFloat:colorB]];
             
            [meshData addObject:[NSNumber numberWithFloat:p1.x]];
            [meshData addObject:[NSNumber numberWithFloat:p1.y]];
            [meshData addObject:[NSNumber numberWithFloat:p1.z]];

            [meshData addObject:[NSNumber numberWithFloat:colorR]];
            [meshData addObject:[NSNumber numberWithFloat:colorG]];
            [meshData addObject:[NSNumber numberWithFloat:colorB]];
            
            [meshData addObject:[NSNumber numberWithFloat:p2.x]];
            [meshData addObject:[NSNumber numberWithFloat:p2.y]];
            [meshData addObject:[NSNumber numberWithFloat:p2.z]];

            [meshData addObject:[NSNumber numberWithFloat:colorR]];
            [meshData addObject:[NSNumber numberWithFloat:colorG]];
            [meshData addObject:[NSNumber numberWithFloat:colorB]];

            [meshData addObject:[NSNumber numberWithFloat:p2.x]];
            [meshData addObject:[NSNumber numberWithFloat:p2.y]];
            [meshData addObject:[NSNumber numberWithFloat:p2.z]];

            [meshData addObject:[NSNumber numberWithFloat:colorR]];
            [meshData addObject:[NSNumber numberWithFloat:colorG]];
            [meshData addObject:[NSNumber numberWithFloat:colorB]];

            [meshData addObject:[NSNumber numberWithFloat:p1.x]];
            [meshData addObject:[NSNumber numberWithFloat:p1.y]];
            [meshData addObject:[NSNumber numberWithFloat:p1.z]];
            
            [meshData addObject:[NSNumber numberWithFloat:colorR]];
            [meshData addObject:[NSNumber numberWithFloat:colorG]];
            [meshData addObject:[NSNumber numberWithFloat:colorB]];

            [meshData addObject:[NSNumber numberWithFloat:p3.x]];
            [meshData addObject:[NSNumber numberWithFloat:p3.y]];
            [meshData addObject:[NSNumber numberWithFloat:p3.z]];
  
            [meshData addObject:[NSNumber numberWithFloat:colorR]];
            [meshData addObject:[NSNumber numberWithFloat:colorG]];
            [meshData addObject:[NSNumber numberWithFloat:colorB]];

        }
    }
    
}

@end