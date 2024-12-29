// based on the following Shader Toy entry
//
// [SH17A] Matrix rain. Created by Reinder Nijhoff 2017
// Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
// @reindernijhoff
//
// https://www.shadertoy.com/view/ldjBW1
//

#define SPEED_MULTIPLIER 1.
#define GREEN_ALPHA .33

#define R fract(1e2 * sin(p.x * 8. + p.y))

void mainImage(out vec4 fragColor, vec2 fragCoord) {
    vec3 v = vec3(fragCoord, 1) / iResolution - .5;
    // vec3 s = .5 / abs(v);
    // scale?
    vec3 s = .9 / abs(v);
    s.z = min(s.y, s.x);
    vec3 i = ceil( 8e2 * s.z * ( s.y < s.x ? v.xzz : v.zyz ) ) * .1;
    vec3 j = fract(i);
    i -= j;
    vec3 p = vec3(9, int(iTime * SPEED_MULTIPLIER * (9. + 8. * sin(i).x)), 0) + i;
    vec3 col = fragColor.rgb;
    col.g = R / s.z;
    p *= j;
    col *= (R >.5 && j.x < .6 && j.y < .8) ? GREEN_ALPHA : 0.;

  	// Sample the terminal screen texture including alpha channel
    vec2 uv = fragCoord.xy / iResolution.xy;
  	vec4 terminalColor = texture(iChannel0, uv);

    // Make a mask that is 1.0 where the terminal content is not black
    float mask = 1.2 - step(0.5, dot(terminalColor.rgb, vec3(1.0)));
    vec3 blendedColor = mix(terminalColor.rgb * 1.2, col, mask);

    fragColor = vec4(blendedColor, terminalColor.a);
}
