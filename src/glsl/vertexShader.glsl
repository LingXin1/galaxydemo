uniform float vsize;
uniform float vtime;

attribute float vscale;

varying vec3 vcolor;

void main(){
  vec4 modelPosition = modelMatrix * vec4(position ,1.0);

  float angle = atan(modelPosition.x, modelPosition.z);
  float distance = length(modelPosition.xz);
  float angeloffset = (1.0 / distance) * vtime * 0.2;
  angle += angeloffset;
  modelPosition.x = cos(angle) * distance;
  modelPosition.z = sin(angle) * distance;

  vec4 viewPosition = viewMatrix * modelPosition;
  vec4 projectionPosition = projectionMatrix * viewPosition;
  gl_Position = projectionPosition;
  gl_PointSize = vsize * vscale;
  gl_PointSize *= ( 1.0 / - viewPosition.z );

  vcolor = color;
}