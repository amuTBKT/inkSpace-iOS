//
//  Shader.m
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

#import "Shader.h"

@implementation Shader{
    // opengl shader program id
    GLuint programId;
    
    // opengl shader uniform locations
    GLuint modelMatrixLocation, cameraMatrixLocation;
    
    // opengl shader attribute locations
    GLuint positionAttribLocation, texcoordAttribLocation;
}

-(void) initShaderVariables{
    modelMatrixLocation = glGetUniformLocation(programId, "u_modelMatrix");
    cameraMatrixLocation = glGetUniformLocation(programId, "u_cameraMatrix");
    
    positionAttribLocation = glGetAttribLocation(programId, "a_position");
    texcoordAttribLocation = glGetAttribLocation(programId, "a_texcoord");
}

-(void) begin{
    //  bind current shader to opengl context
    glUseProgram(programId);
}

-(void) end{
    // unbind shader from opengl context
    glUseProgram(0);
}

-(void) setUniformMatrix:(float*)m atLocation:(GLuint)i{
    glUniformMatrix4fv(i, 1, 0, m);
}

-(void) setProgramId:(GLuint)pId{
    programId = pId;
}

-(GLuint) getProgramId{
    return programId;
}

-(GLuint) modelMatrixLocation{
    return modelMatrixLocation;
}

-(GLuint) cameraMatrixLocation{
    return cameraMatrixLocation;
}

-(GLuint) posAttribLocation{
    return positionAttribLocation;
}

-(GLuint) texcoordAttribLocation{
    return texcoordAttribLocation;
}

-(void) dealloc{
    // delete opengl shader program
    glDeleteShader(programId);
    programId = 0;
}

@end