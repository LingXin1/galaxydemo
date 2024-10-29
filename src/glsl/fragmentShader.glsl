varying vec3 vcolor;

void main(){
  float strength = distance(gl_PointCoord, vec2(0.5));
  strength = 1.0 - strength;
  strength = pow(strength, 5.0);

  vec3 color = mix(vec3(0.0), vcolor, strength * 10.0);

  gl_FragColor = vec4(vec3(color), 1.0);
}