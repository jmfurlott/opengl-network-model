//
//  Shader.fsh
//  Retinopathy Model
//
//  Created by Joseph Furlott on 1/6/13.
//  Copyright (c) 2013 Joseph Furlott. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
