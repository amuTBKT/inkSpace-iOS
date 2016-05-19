//
//  ShaderManager.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef ShaderManager_h
#define ShaderManager_h

#import <Foundation/Foundation.h>
#import "Shader.h"

@interface ShaderManager : NSObject

@property NSMutableArray *loadedShaders;

+(ShaderManager*) getInstance;

-(Shader*) loadShaderWithVertex: (char*)vertFile andFragment: (char*)fragFile;

-(BOOL)loadShaders:(NSString*)vertFile :(NSString*)fragFile  :(GLuint*)programId;
-(BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
-(BOOL)linkProgram: (GLuint)prog;

-(void) dispose;

@end


#endif
