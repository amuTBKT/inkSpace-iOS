//
//  Shader.vsh
//  Canvas3d
//
//  Created by Amit Kumar Mehar on 14/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

attribute vec3 a_position;
attribute vec3 a_texcoord;

varying lowp vec4 colorVarying;

uniform mat4 u_modelMatrix;
uniform mat4 u_cameraMatrix;

void main()
{
    colorVarying = vec4(a_texcoord, 1.0);
    gl_Position = u_cameraMatrix * vec4(a_position, 1.0);
}
