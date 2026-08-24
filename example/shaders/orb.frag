#version 460 core

// ElevenLabs UI — Orb. Vendored, not written here.
//
// Source: https://ui.elevenlabs.io/r/orb.json (elevenlabs/ui, MIT), reached
// through the reference's own vendored copy at
// `components/agent/voice/orb-vendor.tsx` L327–532. That file states the three
// edits it made to upstream and asks that re-pulling stay a diff rather than an
// archaeology exercise; this port keeps the same discipline, so the changes
// below are the complete list and nothing else moved:
//
//   1. `#version 460 core` + `flutter/runtime_effect.glsl`, `varying`→ a
//      computed `vUv`, `gl_FragColor` → `fragColor`. Flutter runs the fragment
//      stage only: there is no vertex shader to interpolate a varying, so `vUv`
//      is derived from `FlutterFragCoord()` and `uSize`. `uv.y` is negated
//      because Flutter's y axis points down and GL's points up — without it the
//      whole field is mirrored.
//   2. **Uniform arrays are not available**, so `uniform float uOffsets[7]`
//      becomes `uOffsetsA` (vec4) + `uOffsetsB` (vec3) read through
//      `offsetAt()`, and the two local `float[7]`s are folded into the loop
//      that consumed them. `originalCenters[i]` was `i * 0.5 * PI` written out;
//      it is computed as that now. No value changed.
//   3. **Repeat wrapping is done in the shader.** Upstream sets
//      `THREE.RepeatWrapping` on the texture; a Flutter image sampler clamps, so
//      every `texture()` call takes `fract()` of its coordinate. Same sampling,
//      one op earlier.
//   4. The disc. Upstream draws onto a `circleGeometry(3.5, 64)` mesh, so the
//      geometry itself is what clips the field to a circle — measured on the
//      live reference as **102px across a 112px canvas** (0.9122604, which is
//      `7 / (2 · 5 · tan 37.5°)`: the r3f default camera's frustum). Flutter
//      draws a rect, so the clip is stated here instead.
//   5. Flutter composites **premultiplied**, so `fragColor.rgb` is multiplied
//      by the alpha upstream leaves straight.
//
// Everything else — `drawOval`, `colorRamp`, `hash2`, `noise2D`, `sharpRing`,
// `smoothRing`, `flow` and `main` — is upstream's, character for character.
//
// COLOUR SPACE, measured: `Orb.tsx` hands THREE two `getComputedStyle` colours
// and `THREE.ColorManagement` (on by default since r152) converts them from
// sRGB into the linear working space, while this shader writes straight to an
// sRGB framebuffer with no encoding step. The orb therefore renders *darker*
// than its own tokens, and that is what the reference shows: probed
// 2026-08-16, the four live orbs average rgb(45.9, 59.4, 144.5) inside the
// disc against rgb(31.3, 45.4, 135.1) for linear uniforms and
// rgb(48.7, 91.3, 184.4) for raw sRGB ones — the green channel settles it.
// `ElVoiceOrb` linearises before it calls `setFloat`, so `uColor1`/`uColor2`
// arrive here exactly as linear as they do upstream.

#include <flutter/runtime_effect.glsl>

precision highp float;

uniform vec2 uSize;
uniform float uTime;
uniform float uAnimation;
uniform float uInverted;
uniform vec4 uOffsetsA;
uniform vec3 uOffsetsB;
uniform vec3 uColor1;
uniform vec3 uColor2;
uniform float uInputVolume;
uniform float uOutputVolume;
uniform float uOpacity;
uniform sampler2D uPerlinTexture;

out vec4 fragColor;

const float PI = 3.14159265358979323846;

// Edit 2: the seven random phase offsets, unpacked.
float offsetAt(int i) {
    if (i == 0) return uOffsetsA.x;
    if (i == 1) return uOffsetsA.y;
    if (i == 2) return uOffsetsA.z;
    if (i == 3) return uOffsetsA.w;
    if (i == 4) return uOffsetsB.x;
    if (i == 5) return uOffsetsB.y;
    return uOffsetsB.z;
}

// Edit 3: upstream's RepeatWrapping, done here.
vec4 sampleNoise(vec2 uv) {
    return texture(uPerlinTexture, fract(uv));
}

// Draw a single oval with soft edges and calculate its gradient color
bool drawOval(vec2 polarUv, vec2 polarCenter, float a, float b, bool reverseGradient, float softness, out vec4 color) {
    vec2 p = polarUv - polarCenter;
    float oval = (p.x * p.x) / (a * a) + (p.y * p.y) / (b * b);

    float edge = smoothstep(1.0, 1.0 - softness, oval);

    if (edge > 0.0) {
        float gradient = reverseGradient ? (1.0 - (p.x / a + 1.0) / 2.0) : ((p.x / a + 1.0) / 2.0);
        // Flatten gradient toward middle value for more uniform appearance
        gradient = mix(0.5, gradient, 0.1);
        color = vec4(vec3(gradient), 0.85 * edge);
        return true;
    }
    return false;
}

// Map grayscale value to a 4-color ramp (color1, color2, color3, color4)
vec3 colorRamp(float grayscale, vec3 color1, vec3 color2, vec3 color3, vec3 color4) {
    if (grayscale < 0.33) {
        return mix(color1, color2, grayscale * 3.0);
    } else if (grayscale < 0.66) {
        return mix(color2, color3, (grayscale - 0.33) * 3.0);
    } else {
        return mix(color3, color4, (grayscale - 0.66) * 3.0);
    }
}

vec2 hash2(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

// 2D noise for the ring
float noise2D(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = f * f * (3.0 - 2.0 * f);
    float n = mix(
        mix(dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
            dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
        mix(dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
            dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x),
        u.y
    );

    return 0.5 + 0.5 * n;
}

float sharpRing(vec3 decomposed, float time) {
    float ringStart = 1.0;
    float ringWidth = 0.3;
    float noiseScale = 5.0;

    float noise = mix(
        noise2D(vec2(decomposed.x, time) * noiseScale),
        noise2D(vec2(decomposed.y, time) * noiseScale),
        decomposed.z
    );

    noise = (noise - 0.5) * 2.5;

    return ringStart + noise * ringWidth * 1.5;
}

float smoothRing(vec3 decomposed, float time) {
    float ringStart = 0.9;
    float ringWidth = 0.2;
    float noiseScale = 6.0;

    float noise = mix(
        noise2D(vec2(decomposed.x, time) * noiseScale),
        noise2D(vec2(decomposed.y, time) * noiseScale),
        decomposed.z
    );

    noise = (noise - 0.5) * 5.0;

    return ringStart + noise * ringWidth;
}

float flow(vec3 decomposed, float time) {
    return mix(
        sampleNoise(vec2(time, decomposed.x / 2.0)).r,
        sampleNoise(vec2(time, decomposed.y / 2.0)).r,
        decomposed.z
    );
}

void main() {
    // Edit 1: the varying, computed. GL's y points up.
    vec2 vUv = FlutterFragCoord().xy / uSize;
    vUv.y = 1.0 - vUv.y;

    // Normalize vUv to be centered around (0.0, 0.0)
    vec2 uv = vUv * 2.0 - 1.0;

    // Convert uv to polar coordinates
    float radius = length(uv);
    float theta = atan(uv.y, uv.x);
    if (theta < 0.0) theta += 2.0 * PI; // Normalize theta to [0, 2*PI]

    // Edit 4: the mesh upstream draws onto is a disc, so nothing exists outside
    // it. Flutter draws a rect, so the geometry's own clip is stated.
    if (radius > 1.0) {
        fragColor = vec4(0.0);
        return;
    }

    // Decomposed angle is used for sampling noise textures without seams:
    // float noise = mix(sample(decomposed.x), sample(decomposed.y), decomposed.z);
    vec3 decomposed = vec3(
        // angle in the range [0, 1]
        theta / (2.0 * PI),
        // angle offset by 180 degrees in the range [1, 2]
        mod(theta / (2.0 * PI) + 0.5, 1.0) + 1.0,
        // mixing factor between two noises
        abs(theta / PI - 1.0)
    );

    // Add noise to the angle for a flow-like distortion (reduced for flatter look)
    float noise = flow(decomposed, radius * 0.03 - uAnimation * 0.2) - 0.5;
    theta += noise * mix(0.08, 0.25, uOutputVolume);

    // Initialize the base color to white
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);

    float a, b;
    vec4 ovalColor;

    // Check if the pixel is inside any of the ovals
    for (int i = 0; i < 7; i++) {
        // Edit 2: `originalCenters[i]` was `float[7](0.0, 0.5 * PI, … 3.0 * PI)`
        // and `centers[i]` its animated form. Both are computed in place.
        float center = float(i) * 0.5 * PI + 0.5 * sin(uTime / 20.0 + offsetAt(i));

        float noise = sampleNoise(vec2(mod(center + uTime * 0.05, 1.0), 0.5)).r;
        a = 0.5 + noise * 0.3; // Increased for more coverage
        b = noise * mix(3.5, 2.5, uInputVolume); // Increased height for fuller appearance
        // Edit 6: `(i % 2 == 1)` upstream. SkSL rejects `%` outright — the
        // Impeller/Vulkan backend accepts it and the web (CanvasKit/SkSL) one
        // does not, so this only surfaces on a web build. Integer division
        // truncates in both, so this is the same parity test.
        bool reverseGradient = ((i / 2) * 2 != i); // Reverse gradient for every second oval

        // Calculate the distance in polar coordinates
        float distTheta = min(
            abs(theta - center),
            min(
                abs(theta + 2.0 * PI - center),
                abs(theta - 2.0 * PI - center)
            )
        );
        float distRadius = radius;

        float softness = 0.6; // Increased softness for flatter, less pronounced edges

        // Check if the pixel is inside the oval in polar coordinates
        if (drawOval(vec2(distTheta, distRadius), vec2(0.0, 0.0), a, b, reverseGradient, softness, ovalColor)) {
            // Blend the oval color with the existing color
            color.rgb = mix(color.rgb, ovalColor.rgb, ovalColor.a);
            color.a = max(color.a, ovalColor.a); // Max alpha
        }
    }

    // Calculate both noisy rings
    float ringRadius1 = sharpRing(decomposed, uTime * 0.1);
    float ringRadius2 = smoothRing(decomposed, uTime * 0.1);

    // Adjust rings based on input volume (reduced for flatter appearance)
    float inputRadius1 = radius + uInputVolume * 0.2;
    float inputRadius2 = radius + uInputVolume * 0.15;
    float opacity1 = mix(0.2, 0.6, uInputVolume);
    float opacity2 = mix(0.15, 0.45, uInputVolume);

    // Blend both rings
    float ringAlpha1 = (inputRadius2 >= ringRadius1) ? opacity1 : 0.0;
    float ringAlpha2 = smoothstep(ringRadius2 - 0.05, ringRadius2 + 0.05, inputRadius1) * opacity2;

    float totalRingAlpha = max(ringAlpha1, ringAlpha2);

    // Apply screen blend mode for combined rings
    vec3 ringColor = vec3(1.0); // White ring color
    color.rgb = 1.0 - (1.0 - color.rgb) * (1.0 - ringColor * totalRingAlpha);

    // Define colours to ramp against greyscale (could increase the amount of colours in the ramp)
    vec3 color1 = vec3(0.0, 0.0, 0.0); // Black
    vec3 color2 = uColor1; // Darker Color
    vec3 color3 = uColor2; // Lighter Color
    vec3 color4 = vec3(1.0, 1.0, 1.0); // White

    // Convert grayscale color to the color ramp
    float luminance = mix(color.r, 1.0 - color.r, uInverted);
    color.rgb = colorRamp(luminance, color1, color2, color3, color4); // Apply the color ramp

    // Apply fade-in opacity
    color.a *= uOpacity;

    // Edit 5: Flutter composites premultiplied.
    fragColor = vec4(color.rgb * color.a, color.a);
}
