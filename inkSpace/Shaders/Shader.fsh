//
//  Shader.fsh
//  inkSpace
//
//  Created by Amit Kumar Mehar on 19/05/16.
//  Copyright (c) 2016 Amit Kumar Mehar. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
