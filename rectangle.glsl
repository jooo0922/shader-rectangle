#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// 사각형을 그려주는 사용자 정의 함수
// 리턴값이 vec3인 이유는, 최종적으로 색상데이터 col에 값을 리턴해줘야 하므로, vec3로 리턴해주는 게 맞겠지
vec3 rect() {

}

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution; // 각 픽셀들의 좌표값 normalize

  vec3 col = rect();

  gl_FragColor = vec4(col, 1.);
}

/*
  void main() {
    vec2 coord = gl_FragCoord.xy / u_resolution;

    vec3 col;

    gl_FragColor = vec4(col, 1.);
  }

  이 코드는 앞으로 셰이더 코드를 작성할 때마다
  기본적으로 항상 사용하게 될 코드임.
  좌표값 정규화하고, 할당할 vec3 색상값 만들고, gl_FragColor에 할당하고...

  이후에 Ray Marching 같은 3D 셰이딩에서도 사용하는 코딩이고
  야구선수 몸풀기처럼 기본적인 준비 루틴이라고 보면 됨.

  이 루틴을 짜고 나서 그 다음 어떻게 할 지 생각해볼 것.
*/