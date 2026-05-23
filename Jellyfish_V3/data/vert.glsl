uniform mat4 transform;
uniform mat4 modelview;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec3 normal;
attribute vec4 color;

varying vec3 vNormal;
varying vec3 vPosition;
varying vec4 vColor;

void main(){
  vNormal = normalize(normalMatrix * normal);
  vPosition = vec3(modelview * position);
  vColor = color;
  gl_Position = transform * position;
}
