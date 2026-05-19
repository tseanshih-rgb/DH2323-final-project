varying vec3 vNormal;
varying vec3 vPosition;
varying vec4 vColor;
uniform float useLighting;

void main() {
    vec3 L = normalize(vec3(0.3, -1.0, 0.3));
    vec3 N = normalize(vNormal);
  vec3 L1 = normalize(vec3(1.0, -1.0, 1.0));
  vec3 L2 = normalize(vec3(0.0, 1.0, 0.0));
  float diff = max(0.0, dot(N, L1)) + max(0.0, dot(N, L2)) * 0.3;
      vec3 V = normalize(-vPosition);
      vec3 R = reflect(-L1, N);
      float spec = pow(max(0.0, dot(R, V)), 64.0) * 0.15;
  float ambient = 0.5;
    if(useLighting > 0.5) {
       // 有光照的版本
        vec3 color = vColor.rgb * ambient + vColor.rgb * diff * 2.0 + vec3(1.0) * spec;
       gl_FragColor = vec4(color, vColor.a);
     } else {
       gl_FragColor = vec4(vColor.rgb, vColor.a);
     }

}
