# Third-party notices

Elattar's own work is MIT-licensed — see [`LICENSE`](LICENSE). **That license
covers Elattar's code and nothing else.** This repository also redistributes
material written by other people, under their licenses, and this file is the
record of what that material is, where it came from, and what permits shipping
it.

Nothing on this page is a summary. Every license text named below is
reproduced verbatim under [`third_party/`](third_party/), and
`test/license_distribution_test.dart` fails the build if any of them stops
matching the hash recorded here, if a redistributed file loses its provenance
row, or if the `elattar` CLI would install one of these files into a consumer
project without the notice beside it.

Hashes are sha256 over the file's bytes as checked out. `.gitattributes` pins
every path in this table to LF endings on every platform, because a hash that
is only correct on one operating system is not a record of anything.

## What a consumer receives

Installing components with the `elattar` CLI copies source into your project,
where it becomes your code. The license notices come with it. `elattar init`
writes Elattar's MIT notice, and each item that redistributes third-party
material carries its own notice as part of the item:

| You install | You receive, in `LICENSES/` |
| --- | --- |
| anything (`elattar init`) | `ELATTAR-MIT.txt` |
| `source-foundation` (any component depends on it) | `Inter-OFL-1.1.txt`, `Geist-Mono-OFL-1.1.txt`, `Redaction-OFL-1.1.txt` |
| `icon` (and therefore `button`, and most of the set) | `Lucide-ISC.txt` |
| `voice-orb` | `ElevenLabs-UI-MIT.txt` |

Keep those files. MIT, ISC and the OFL all make carrying the notice the
condition of the grant; none of them asks for a visible credit in your
application's UI.

## Fonts

Three faces are redistributed as binaries, in the package's own asset bundle
and again inside the registry's `source-foundation` payload. All three declare
the **SIL Open Font License, Version 1.1** in their own `name` tables, which is
the designers' own statement of terms, embedded in the file being
redistributed.

### Inter

| | |
| --- | --- |
| Redistributed file | [`assets/fonts/InterVariable.ttf`](assets/fonts/InterVariable.ttf) |
| Binary sha256 | `5f27757f43f9e9d371851c372ee2e70c5ac5c65fb915d603667c253de8d3f65a` |
| Version, from the binary | `Version 4.001;git-9221beed3` |
| Copyright, from the binary | `Copyright 2016 The Inter Project Authors` |
| Designer | Rasmus Andersson (rsms) |
| License | SIL Open Font License 1.1 |
| Notice file | [`third_party/fonts/inter/OFL.txt`](third_party/fonts/inter/OFL.txt) |
| Notice sha256 | `262481e844521b326f5ecd053e59b98c8b2da78c8ee1bdbb6e8174305e54935a` |
| Notice retrieved from | `https://raw.githubusercontent.com/rsms/inter/master/LICENSE.txt` |
| Retrieved | 2026-08-24 |

The notice file is upstream's own `LICENSE.txt`, byte for byte: its copyright
line followed by the full OFL 1.1 text.

### Geist Mono

| | |
| --- | --- |
| Redistributed file | [`assets/fonts/GeistMono-Variable.ttf`](assets/fonts/GeistMono-Variable.ttf) |
| Binary sha256 | `0e1af3f507a1c8dfbb03d13ffad585834cd45ed7ccb78c756c7ce7873d180d30` |
| Version, from the binary | `Version 1.700` |
| Copyright, from the binary | `Copyright 2024 The Geist Project Authors (https://github.com/vercel/geist-font.git)` |
| Designer | Basement.studio, Vercel, Andrés Briganti, Guido Ferreyra, Mateo Zaragoza |
| License | SIL Open Font License 1.1 |
| Notice file | [`third_party/fonts/geist-mono/OFL.txt`](third_party/fonts/geist-mono/OFL.txt) |
| Notice sha256 | `c683bfbcc7e087f5d37a54ef628f10387c451a83ddc459b151403a164ac46c90` |
| Notice retrieved from | `https://raw.githubusercontent.com/vercel/geist-font/main/OFL.txt` |
| Retrieved | 2026-08-24 |

The notice file is upstream's own `OFL.txt`, byte for byte.

### Redaction 35

| | |
| --- | --- |
| Redistributed file | [`assets/fonts/Redaction35-Italic.ttf`](assets/fonts/Redaction35-Italic.ttf) |
| Binary sha256 | `a87aea4af107f393edf6fe198c4f961ec4ff955407fa62a70563ce403e1499d3` |
| Version, from the binary | `Version 2.001; Redaction 35 Italic` |
| Copyright, from the binary | `(c) 2019 MCKL. All Rights Reserved.` |
| Designer | Jeremy Mickel / Forest Young, MCKL |
| Publisher | `https://www.redaction.us/` |
| License | Dual: SIL Open Font License 1.1 **and** LGPL 2.1, per the publisher. Elattar redistributes under the OFL 1.1 arm. |
| Notice file | [`third_party/fonts/redaction/OFL.txt`](third_party/fonts/redaction/OFL.txt) |
| Notice sha256 | `8c13186f0201838de84a9254fb79265e9a6441e2352e1fdc245ae031cbb5848d` |
| Retrieved | 2026-08-24 |

**This one notice is assembled, not copied, and the file says so in its own
first paragraph.** MCKL publishes the license as a page on `redaction.us`
rather than as a file in a repository, so there is no upstream `OFL.txt` to
reproduce. The assembled file quotes the binary's own copyright and license
declarations verbatim, quotes the publisher's dual-license sentence verbatim,
and then reproduces SIL's canonical OFL 1.1 plain text — retrieved 2026-08-24
from `https://openfontlicense.org/documents/OFL.txt`, sha256
`1d361a8f8e8ce6e68457dcd93fb56e162e6baa3bbb7e7573a290d44399f6b57e` — from its
separator line onward, byte for byte.

Two discrepancies are recorded rather than smoothed over. The publisher's page
grants OFL **and** LGPL 2.1; the binary's own metadata names only the OFL. And
the binary's copyright field reads "All Rights Reserved", which is not the
OFL's own recommended copyright-line form. Neither affects the OFL grant both
sources make, and neither is something this repository may rewrite.

## Icon geometry

| | |
| --- | --- |
| Redistributed file | [`lib/src/components/icon_paths.g.dart`](lib/src/components/icon_paths.g.dart) (763,019 bytes, 1756 glyphs) |
| Also | [`lib/src/components/icon_paths.g.index.dart`](lib/src/components/icon_paths.g.index.dart) |
| Upstream | `lucide-react` 1.28.0 |
| License | ISC, plus MIT (Cole Bemis) for the glyphs inherited from Feather |
| Notice file | [`third_party/lucide/LICENSE`](third_party/lucide/LICENSE) |
| Notice sha256 | `b495047bd93a9b06913511076f504daba17d5bbeb3e0650f3bb53a4220329c57` |
| Notice retrieved from | the installed package's own `LICENSE`, cross-checked against `https://raw.githubusercontent.com/lucide-icons/lucide/main/LICENSE` and `https://unpkg.com/lucide-react@1.28.0/LICENSE` |
| Retrieved | 2026-08-24 |

All three sources returned identical bytes, which is why the hash above is
recorded once rather than three times.

The generated Dart file embeds this notice verbatim in its own header.
`tool/generate_icons.mjs` reads it out of the installed package on every run
rather than carrying a copy, so a lucide upgrade cannot leave a stale notice
behind. Note that lucide's `LICENSE` is **not** ISC alone: roughly 110 glyphs
descend from Feather and carry a separate MIT notice from Cole Bemis in the
same file. Reproducing "the ISC part" would have dropped it, which is the
second reason the generator embeds the whole file.

## Shader

| | |
| --- | --- |
| Redistributed file | [`shaders/orb.frag`](shaders/orb.frag), and its byte copy [`example/shaders/orb.frag`](example/shaders/orb.frag) |
| sha256 | `95a0050d596eda3b0cd9fe8f61bd4a7b152a5eed66bc7532b997518ef04a92fe` |
| Upstream | `elevenlabs/ui` — the Orb, `https://ui.elevenlabs.io/r/orb.json` |
| License | MIT, `Copyright (c) 2025 Eleven Labs Inc.` |
| Notice file | [`third_party/elevenlabs-ui/LICENSE`](third_party/elevenlabs-ui/LICENSE) |
| Notice sha256 | `ad3f66b8568970d067e3bd47b690ad013945a61f972559743946a3a6558dc828` |
| Notice retrieved from | `https://raw.githubusercontent.com/elevenlabs/ui/main/LICENSE.md` |
| Retrieved | 2026-08-24 |

The shader is a port, not a verbatim copy: its own header lists the five edits
made to the upstream GLSL and why each was unavoidable. It is still a
substantial portion of the Software, so the full MIT notice is reproduced at
the top of the file as well as in `third_party/`.

## Generated texture — no third-party claim

[`assets/textures/perlin-noise.png`](assets/textures/perlin-noise.png) is
listed here to record that it is **not** third-party material, because it used
to be. Until this release it was a byte copy of a file whose original this
repository could not name. It is now generated from a checked-in seed by
[`tool/generate_perlin_texture/`](tool/generate_perlin_texture/):

| | |
| --- | --- |
| Generator | `dart run tool/generate_perlin_texture/bin/generate.dart .` |
| Seed | `0x1EA77A12` |
| Dimensions | 256 x 256, 8-bit RGBA — identical to the file it replaces |
| Algorithm | tileable Perlin gradient noise, 4 octaves from a 4-cell lattice, persistence 0.5, contrast 0.83 |
| Pixel-field sha256 | `53a048aa5a339ee3c52a55133e138db3de86921af704e5f2e7c0bc6ae775a230` |
| File sha256 | `3fa8bdce594fad7586bfe3be10be04bcf77eca38ef85d2ab811c5e0445ce0785` |

The pixel-field hash is the one the generator's tests pin. The file hash
additionally depends on the SDK's zlib, which may re-encode identical pixels
differently on an SDK bump, so it is recorded here as a fact rather than
asserted as a contract.

Measured against the file it replaces: mean 127.5 against 127.5, value span
151 against 151, worst neighbouring-pixel step 8 against 13. The replacement
occupies the same range and is slightly smoother.

## Development-only dependencies

`tool/verify/node_modules/` contains an npm tree used by the local visual
verification rig. It is development tooling, is not redistributed by this
repository, and is not part of any published artifact. Its packages carry
their own licenses in place.
