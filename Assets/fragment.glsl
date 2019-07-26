/*
Title: Normal Maps
File Name: fragment.glsl
Copyright ? 2016, 2019
Author: David Erbelding, Niko Procopi
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#version 400 core

in vec2 uv;
in vec3 normal;
in vec3 tangent;
in vec3 bitangent;

uniform sampler2D tex;
uniform sampler2D tex2;



void main(void)
{
	vec4 ambientLight = vec4(.1, .1, .3, 1);
	vec4 lightColor = vec4(1, .8, .3, 1);
	vec3 lightDir = vec3(-1, -1, -2);
	
	// Get the color, just the same way as usual
	vec4 color = texture(tex, uv);

	// The normal from our texture is stored from (0 to 1), because that's how RGB works
	// In other words, our normal map does not hold raw normals, it holds compressed normals
	vec4 normalFromTex = texture(tex2, uv);

	// To decompress normals, we need to convert (0 to 1) to (-1 to 1)
	// (0 to 1) * 2 = (0 to 2)
	// (0 to 2) - 1 = (-1 to 1)
	// This is our per-pixel normal that points out of the plane
	vec3 decompNormalFromTex = normalize(vec3(normalFromTex)) * 2.0 - 1.0;

	// The problem with decompNormalFromTex is that it only works when
	// a plane perfectly faces the camera.
	// To fix this, we have to rotate decompNormalFromTex, depending on the orientation
	// of the polygon it is on

	// We combine tangent, bitangent, and Vertex Normal into a matrix.
	// This takes into UV mapping and polygon orientation into consideration
	// Think about how Scale, Translation, and Rotation are all different types of matrices
	// TBN is a rotation matrix that rotates our per-pixel normal to its final orientation
	mat3 tbn = mat3(tangent, bitangent, normal);

	// Just like how we rotate our object by multiplying rotation matrices,
	// we multiply our per-pixel normal by the rotation matrix
	// Now we have our final per-pixel normal that is ready for use
	vec3 finalPerPixelNormal = tbn * decompNormalFromTex;

	// After that, everything else is the same...
	// We replace the per-vertex normal with the per-pixel normal

	// calculate diffuse lighting and clamp between 0 and 1
	float ndotl = clamp(-dot(normalize(lightDir), normalize(finalPerPixelNormal)), 0, 1);

	// add diffuse lighting to ambient lighting and clamp a second time
	vec4 lightValue = clamp(lightColor * ndotl + ambientLight, 0, 1);

	// finally, sample from the texuture and multiply in the light.
	gl_FragColor = color * lightValue;
}