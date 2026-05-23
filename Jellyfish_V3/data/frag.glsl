varying vec3 vNormal;
varying vec3 vPosition;
varying vec4 vColor;

void main(){
  vec3 N = normalize(vNormal);
  vec3 V = normalize(-vPosition);
  float fresnel = pow(1.0 - dot(N, V), 3.0);
  
  gl_FragColor = vec4(vColor.rgb, vColor.a);
}
