shader_type canvas_item;

void fragment() {
    float aspect = (1.0 / SCREEN_PIXEL_SIZE).y / (1.0 / SCREEN_PIXEL_SIZE).x;
    float value;
    vec2 uv = FRAGCOORD.xy.xy / (1.0 / SCREEN_PIXEL_SIZE).x;
    uv -= vec2(0.5, 0.5 * aspect);

    float rot = radians(45.0);
    float s = sin(rot);
    float c = cos(rot);

    float newX = uv.x * c - uv.y * s;
    float newY = uv.x * s + uv.y * c;

    uv = vec2(newX, newY);

    uv += vec2(0.5, 0.5 * aspect);
    uv.y += 0.5 * (1.0 - aspect);

    vec2 pos = 10.0 * uv;
    vec2 rep = fract(pos);
    float dist = 2.0 * min(min(rep.x, 1.0 - rep.x), min(rep.y, 1.0 - rep.y));
    float squareDist = length((floor(pos) + vec2(0.5)) - vec2(5.0));

    float edge = sin(TIME - squareDist * 0.5) * 0.5 + 0.5;
    edge = (TIME - squareDist * 0.5) * 0.5;
    edge = 2.0 * fract(edge * 0.5);

    value = fract(dist * 2.0);
    value = mix(value, 1.0 - value, step(1.0, edge));
    edge = pow(abs(1.0 - edge), 2.0);
    value = smoothstep(edge - 0.05, edge, 0.95 * value);
    value += squareDist * 0.1;

    COLOR = mix(vec4(0.20, 0.20, 0.20, 1.0), vec4(0.3, 0.5, 0.3, 1.0), value);
    //COLOR.a = 0.75 * clamp(value, 0.0, 1.0);
}