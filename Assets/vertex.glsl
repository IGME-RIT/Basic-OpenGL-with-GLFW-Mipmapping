/*
Title: Normal Maps
File Name: vertex.glsl
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

// Vertex attribute for position
layout(location = 0) in vec3 in_position;
layout(location = 1) in vec2 in_uv;
layout(location = 2) in vec3 in_normal;
layout(location = 3) in vec3 in_tangent;

// uniform will contain the world matrix.

uniform mat4 worldMatrix;
uniform mat4 cameraView;

out vec2 uv;
out vec3 normal;
out vec3 tangent;
out vec3 bitangent;

void main(void)
{
	// Transform position from model-space to world-space.
	// In other words, move model to where it should be in the world
	vec4 worldPosition = worldMatrix * vec4(in_position, 1);

	// convert world-space to screen-space
	// In other words, where on the screen should each polygon be?
	// Remember: cameraView is projection Matrix * view Matrix
	vec4 screenPosition = cameraView * worldPosition;

	// output the transformed vector
	gl_Position = screenPosition;

	// We have a little extra work here.
	// Not only do we have to multiply the normal by the world matrix, we also have to multiply the tangent
	normal = mat3(worldMatrix) * in_normal;
	tangent = mat3(worldMatrix) * in_tangent;

	// The third vector we need is a bitangent, or a vector perpendicular to both the normal and tangent.
	// This can be easily accomplished with a cross product.
	bitangent = normalize(cross(tangent, normal));

	// send UV to fragment shader
	uv = in_uv;
}