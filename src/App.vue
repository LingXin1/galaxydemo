<script setup>
import { ref, onMounted } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import GUI from "lil-gui";

import vertexShader from "./glsl/vertexShader.glsl";
import fragmentShader from "./glsl/fragmentShader.glsl";

let scene, camera, renderer, controls, galaxy, gui;
const canvas = ref(null);

// todo 场景
scene = new THREE.Scene();
gui = new GUI({
  title: "星系控制器",
});
scene.add(new THREE.AxesHelper(1));

// todo 相机
camera = new THREE.PerspectiveCamera(
  45,
  window.innerWidth / window.innerHeight,
  0.1,
  1000
);
camera.position.set(2, 2, 2);
camera.lookAt(0, 0, 0);

// todo 星系参数
const parameters = {
  num: 15000,
  size: 0.1,
  radius: 10,
  branch: 3,
  spin: 0.8,
  randomness: 1.5,
  randomnessPower: 5,
  insidecolor: "#ff6030",
  outsidecolor: "#1b3984",
};

// todo 星系初始化
const initgalaxy = () => {
  const positionarr = [];
  const colorarr = [];
  const scalearr = [];
  const insidecolor = new THREE.Color(parameters.insidecolor);
  const outsidecolor = new THREE.Color(parameters.outsidecolor);

  const galaxygeometry = new THREE.BufferGeometry();
  const galaxymaterial = new THREE.ShaderMaterial({
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    vertexColors: true,
    vertexShader,
    fragmentShader,
    uniforms: {
      vsize: { value: 5 * renderer.getPixelRatio() },
      vtime: { value: 0 },
    },
  });

  for (let i = 0; i < parameters.num; i++) {
    let index = i * 3;

    const radius = Math.random() * parameters.radius;
    const spinAngel = radius * parameters.spin;
    const angle = ((i % parameters.branch) / parameters.branch) * Math.PI * 2;

    const randomx =
      Math.pow(Math.random(), parameters.randomnessPower) *
      (Math.random() < 0.5 ? 1 : -1);
    const randomy =
      Math.pow(Math.random(), parameters.randomnessPower) *
      (Math.random() < 0.5 ? 1 : -1);
    const randomz =
      Math.pow(Math.random(), parameters.randomnessPower) *
      (Math.random() < 0.5 ? 1 : -1);

    positionarr[index] = radius * Math.sin(angle) + randomx;
    positionarr[index + 1] = randomy;
    positionarr[index + 2] = radius * Math.cos(angle) + randomz;

    scalearr[i] = Math.random();

    const newcolor = insidecolor.clone();
    newcolor.lerp(outsidecolor, radius / parameters.radius);

    colorarr[index] = newcolor.r;
    colorarr[index + 1] = newcolor.g;
    colorarr[index + 2] = newcolor.b;
  }
  galaxygeometry.setAttribute(
    "position",
    new THREE.Float32BufferAttribute(positionarr, 3)
  );
  galaxygeometry.setAttribute(
    "color",
    new THREE.Float32BufferAttribute(colorarr, 3)
  );
  galaxygeometry.setAttribute(
    "vscale",
    new THREE.Float32BufferAttribute(scalearr, 1)
  );
  galaxy = new THREE.Points(galaxygeometry, galaxymaterial);
  console.log(galaxy);

  scene.add(galaxy);
};

// todo Gui
gui
  .add(parameters, "num")
  .min(100)
  .max(20000)
  .step(3)
  .name("星系数量")
  .onFinishChange(() => {
    scene.remove(galaxy);
    console.log(scene);
    initgalaxy();
  });
gui
  .add(parameters, "size")
  .min(0.1)
  .max(1)
  .step(0.1)
  .name("星系大小")
  .onFinishChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .add(parameters, "radius")
  .min(0.1)
  .max(10)
  .step(0.1)
  .name("星系半径")
  .onFinishChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .add(parameters, "branch")
  .min(3)
  .max(12)
  .step(1)
  .name("星系分支")
  .onFinishChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .add(parameters, "spin")
  .min(0.2)
  .max(2)
  .step(0.1)
  .name("星系弯曲度")
  .onFinishChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .add(parameters, "randomness")
  .min(0.2)
  .max(2)
  .step(0.1)
  .name("星系弯曲度")
  .onFinishChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .add(parameters, "randomnessPower")
  .min(5)
  .max(10)
  .step(1)
  .name("星系弯曲度")
  .onFinishChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .addColor(parameters, "insidecolor")
  .name("内部颜色")
  .onChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });
gui
  .addColor(parameters, "outsidecolor")
  .name("外部颜色")
  .onChange(() => {
    scene.remove(galaxy);
    initgalaxy();
  });

// ! 动画
const clock = new THREE.Clock();
const tick = () => {
  const elapsed = clock.getElapsedTime();
  requestAnimationFrame(tick);
  galaxy.material.uniforms.vtime.value = elapsed;

  renderer.render(scene, camera);
  controls.update();
};

onMounted(() => {
  // todo 渲染器
  controls = new OrbitControls(camera, canvas.value);
  renderer = new THREE.WebGLRenderer({
    canvas: canvas.value,
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.render(scene, camera);

  initgalaxy();
  // todo 执行动画
  tick();
});
</script>

<template>
  <canvas id="canvas" ref="canvas"></canvas>
</template>

<style scoped>
#canvas {
  position: absolute;
}
</style>
