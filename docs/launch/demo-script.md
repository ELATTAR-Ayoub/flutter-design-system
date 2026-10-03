# 45-second Elattar demo

The README motion piece at `docs/assets/launch/elattar-quickstart.mp4` and
`docs/assets/launch/elattar-quickstart.webp` is a 15-second loop rendered from
`tool/readme_motion/scene.html` by `node tool/readme_motion/render.mjs`. Use
this shot list for a separate live cursor-and-terminal recording for the homepage, pub.dev,
GitHub release, and launch posts. Record at 1440×900 with a clean Flutter
starter project and a readable terminal; export one MP4 and one compressed
animated WebP.

| Time | Picture | Caption |
| --- | --- | --- |
| 0–4s | Plain Flutter starter screen | Start with a Flutter app |
| 4–10s | Run `dart install elattar_cli` | Install one small CLI |
| 10–18s | Run `elattar init --foundation source` | Add the native foundation |
| 18–25s | Run `elattar add button` | Copy only what you need |
| 25–32s | Open `lib/components/ui/button.dart` | The source is yours |
| 32–40s | Replace the starter control with `Button` and hot reload | Accessible behavior included |
| 40–45s | Finished screen beside the local source tree | Own your Flutter interface |

Keep the pointer still unless it performs the action. Crop out personal paths,
tokens, notifications, and unrelated browser tabs. Captions carry the story so
the demo remains understandable without audio.
