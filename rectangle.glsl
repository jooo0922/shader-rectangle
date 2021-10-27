#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// 사각형을 그려주는 사용자 정의 함수
// 리턴값이 vec3인 이유는, 최종적으로 색상데이터 col에 값을 리턴해줘야 하므로, vec3로 리턴해주는 게 맞겠지
// 이 함수에 넣어주는 매개변수는 1. 각 픽셀 좌표값 2. 사각형 vec2 위치 좌표값(loc) 3. 사각형 vec2 크기값(size)
// 어떤 매개변수를 넣어줘야 하는지 고민될 때에는 논리에 맞게 뭘 넣어야 할지 대충 생각해보면서 넣어볼 것.
// '사각형이니까, 사각형을 어디에 그릴 지(위치), 얼만큼 크게 그릴지(크기) 이런 인자들이 필요하겠군!' 하는 식으로 
vec3 rect(vec2 coord, vec2 loc, vec2 size) {
  /*
    사각형을 그릴 때에는, 2개의 점이 필요함.

    1. SW(SouthWest, 사각형 좌하단 꼭지점)
    2. NE(NorthEast, 사각형 우상단 꼭지점)

    이 때, loc 값은 사각형 가운데 좌표값, 
    size.x, y 는 각각 사각형의 width, height 으로 계산하게 된다면,
    아래 코드와 같이 sw, ne의 좌표값을 구할 수 있음. 
  */
  vec2 sw = loc - size / 2.;
  vec2 ne = loc + size / 2.;

  /*
    step(sw, coord); 의 리턴값은 'step_영역별_리턴값.png' 참고할 것.
    빨간색 좌표값이 step(sw, coord); 의 각 영역별 픽셀들에 대한 vec2 리턴값이고,
    파란색 좌표값이 step(ne, coord); 의 각 영역별 픽셀들에 대한 vec2 리턴값으로 보면 됨.

    각 픽셀별로 두 개의 step 리턴값을 계산하고 난 뒤,
    step(sw, coord) 리턴값 vec2에서 step(ne, coord) 리턴값 vec2를 빼줌.
    
    즉, 각 픽셀들 영역별로 빨간색 좌표값에서 파란색 좌표값을 빼준 값이 pct에 할당된다는 뜻!
    그 결과값이 'pct_영역별_결과값.png'를 보면 알 수 있음.
    사각형 안쪽 영역 픽셀들은 pct가 (1, 1)인데, 
    나머지 영역은 적어도 하나의 성분은 0을 포함한 vec2 값을 갖는다는 점에서 구분점이 생김!
  */
  vec2 pct = step(sw, coord);
  pct -= step(ne, coord);

  // 사각형 안쪽 영역은 pct.x,y 둘다 1이므로 서로 곱하면 1이 되지만,
  // 그외 영역은 pct.xy 최소 둘 중 하나는 0이므로, 서로 곱하면 0이 됨.
  // 따라서, 사각형 안쪽 영역의 픽셀에 대해서만 vec3(1., 1., 1.)을 리턴하고,
  // 나머지 영역은 vec3(0., 0., 0.)을 리턴하게 되겠지! -> 사각형은 흰색 영역으로 칠해질거임!
  return vec3(pct.x * pct.y);
}

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution; // 각 픽셀들의 좌표값 normalize

  // 위치는 (.5, .5) 즉, 캔버스의 가운데에 위치하고, 사이즈는 (.5, .5)즉, 캔버스의 절반 수준의 width, height의 사각형을 그려주겠군.
  vec3 col = rect(coord, vec2(.5), vec2(.5));

  // 사각형 안쪽 영역은 vec3(1., 1., 1.)이 col에 리턴될테니, white 컬러로 찍히겠군
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

/*
  step(vec2 edge, vec2 x);

  이전 예제에서는 step의 인자로 float값을 사용했지.
  그래서 edge < x 면 1, edge > x 면 0을 리턴하는 식이었음.

  그렇다면, vec2 같은 vecN 타입 데이터가 들어가면 어떻게 리턴되는걸까?
  만약 vec2값들이 들어갔다고 가정하면,
  vec2의 각 성분끼리 비교해서 0 또는 1을 리턴해줘서
  각 성분마다 0 또는 1이 지정된 vec2 값을 리턴해 줌!

  예를 들어, edge.x > x.x 라면, 리턴되는 vec2의 x자리에는 0이 지정되고,
  edge.y < x.y 라면, 리턴되는 vec2의 y자리에는 1이 지정되어서
  최종적으로 vec2(0, 1) 이런 식으로 리턴되는거지!
*/