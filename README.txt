Documentation Author: Niko Procopi 2019

This tutorial was designed for Visual Studio 2017 / 2019
If the solution does not compile, retarget the solution
to a different version of the Windows SDK. If you do not
have any version of the Windows SDK, it can be installed
from the Visual Studio Installer Tool

Welcome to the Mipmapping Tutorial!
Prerequesites: Draw a texture on a polygon

Disclaimer:
This tutorial builds off the tutorial with normal mapping.
An understanding of this topic is not required 
for Mipmapping

Comparison1 Screenshot:
Left:   texture
Middle: texture + normal map
Right:  texture + normal map + mipmapping

Comparison2 Screenshot:
Left:   texture + normal map
Middle: texture + normal map + mipmapping
Right:  texture + normal map + anisotropy

This tutorial is so easy
It only takes 2 lines of code to do, and it makes a big visual difference
To see a comparison of before-and-after mipmapping, run the Normal Mapping tutorial
Mipmapping does not require, nor does it replace, normal mapping

What is a mipmap:
A mipmap is an array of textures that OpenGL can generate for us.
If you have a 1024x1024 texture, then your mipmap is a series of textures
that all look like the original texture, except they are downscaled to
512x512, 256x256, 128x128 ... all the way down to ... 4x4, 2x2, 1x1

If you have a 4096x4096 texture, the same pattern applies, it generates
textures that are downscaled to 2048x2048, 1024x1024, 512x512 ... 1x1

Why we should use mipmapping:
If a high-res image is applied to a surface with a small amount of pixels
on the screen, then the texture starts to look grainy and pixelated
Mipmapping swaps the high-res texture for the low-res texture when the 
polygon fills less pixels on the screen, and therefore looks smoother

When we should not use mipmapping:
If you have anisotropic filtering, that works better than mipmapping
Mipmapping should not be used on screen-space objects (HUD, menu, options).
If you dont have anisotropic filtering, always use mipmapping on world-space objects

Mipmaps can be applied to any tutorial
All you need to do is go to Texture.cpp:

Step 1:
Replace this: glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
With this:    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

Step 2:
Add this line: glGenerateMipmap(GL_TEXTURE_2D);

And you're done!
This enables mipmap filtering, and generates the mipmap

How to improve:
Anisotropic Filtering is a technique that uses mipmaps, 
but applies them differently, for much higher quality
