//
//  Shader.h
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#ifndef Shader_h
#define Shader_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Shader : NSObject

/** Cache shader attribut and uniform locations to member variables
 */
-(void) initShaderVariables;

/** OpenGL shader program location for model matrix uniform
 */
-(GLuint) modelMatrixLocation;

/** OpenGL shader program location for camera matrix uniform
 */
-(GLuint) cameraMatrixLocation;

/** OpenGL shader program location for vertex position attribute
 */
-(GLuint) posAttribLocation;

/** OpenGL shader program location for texture coordinate attribute
 */
-(GLuint) texcoordAttribLocation;

/** Bind shader to OpenGL context
 */
-(void) begin;

/** Unbind shader from OpenGL context
 */
-(void) end;

/** Set uniform matrix with location
 *\param m Float array storing matrix data
 *\param i OpenGL shader location of the uniform
 */
-(void) setUniformMatrix:(float*)m atLocation:(GLuint)i;

/** Set OpenGL shader program id for the shader
 *\param pId OpenGL shader id
 */
-(void) setProgramId:(GLuint)pId;

/** OpenGL shader program id of the shader
 */
-(GLuint) getProgramId;

-(void) dealloc;

@end

#endif
