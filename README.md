# 🎵 DAS Remix Toolkit

A complete remix pipeline for searching, downloading, analyzing, stem-splitting, and scaffolding Ableton Live projects — all from the command line.

Built for the DAS collective by Jake's AI (Clawdbot) and George's AI.

## Quick Start

```bash
# Clone and setup
git clone <repo-url> ~/projects/das-remix-toolkit
cd ~/projects/das-remix-toolkit
./setup.sh

# Run the full pipeline
remix-pipeline "Dirty AF1s Alexander 23" --name "Dirty AF1s Remix"
```

## Prerequisites

| Tool | Install | Required? |
|------|---------|-----------|
| Python 3.10+ | `brew install python` | ✅ Yes |
| librosa | `pip install librosa` | ✅ Yes |
| tidalapi | `pip install tidalapi` | ✅ Yes |
| tidal-dl-ng | `pip install tidal-dl-ng` | ✅ For downloads |
| demucs | `pip install demucs` | ✅ For stem splitting |
| songsee | `pip install songsee` | ⬜ Optional (visualizations) |

## Installation

```bash
# 1. Clone the repo
git clone <repo-url> ~/projects/das-remix-toolkit
cd ~/projects/das-remix-toolkit

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Run setup (installs deps, adds to PATH, checks tools)
chmod +x setup.sh
./setup.sh

# 4. Authenticate with Tidal (if not already done)
tidal-dl-ng
# Follow OAuth flow — token saved to ~/.config/tidal_dl_ng/token.json
```

## Tools

### `track-info` — BPM & Key Detection

Detects BPM, musical key (major/minor via Krumhansl-Schmuckler algorithm), and duration.

```bash
# Basic usage
track-info song.mp3
# BPM: 128.0
# Key: A Minor
# Duration: 3:42

# JSON output
track-info song.mp3 --json
# {"bpm": 128.0, "key": "A Minor", "duration_sec": 222.4}
```

### `tidal-search` — Search Tidal

Search Tidal for tracks and get URLs (for use with tidal-dl-ng).

```bash
# Search and show top 3 results
tidal-search "Dirty AF1s Alexander 23"
# 1. Dirty AF1s — Alexander 23 [2:58]
#    https://tidal.com/browse/track/123456

# Get just the first result URL
tidal-search --first "Dirty AF1s Alexander 23"
# https://tidal.com/browse/track/123456

# More results
tidal-search --limit 10 "some query"
```

**Note:** Requires Tidal authentication via tidal-dl-ng. Token is read from `~/.config/tidal_dl_ng/token.json`.

### `scaffold-remix` — Ableton Project Scaffolder

Creates a complete Ableton Live 11 project from stem files.

```bash
# Basic: auto-detect BPM, create project, open in Ableton
scaffold-remix /path/to/stems/

# With options
scaffold-remix /path/to/stems/ \
  --name "My Remix" \
  --bpm 128 \
  --output-dir ~/Desktop/my-remix \
  --no-open
```

**What it creates:**
```
~/Documents/das/remix-projects/<name>/
├── <name>.als              # Ableton Live project file
└── Samples/
    └── Imported/
        ├── vocals.mp3      # Blue track (color 14)
        ├── drums.mp3       # Red track (color 0)
        ├── bass.mp3        # Yellow track (color 4)
        └── other.mp3       # Green track (color 10)
```

**Features:**
- Valid gzip-compressed XML (.als format)
- One audio track per stem with clips loaded in arrangement view
- Color-coded tracks (drums=red, bass=yellow, vocals=blue, other=green)
- Auto-detected or manual BPM
- Auto-opens in Ableton Live on macOS

### `remix-pipeline` — Full Orchestrator

Runs the complete remix pipeline end-to-end:

```bash
remix-pipeline "Dirty AF1s Alexander 23" --name "Dirty AF1s Remix"
```

**Pipeline steps:**
1. **Search Tidal** → find track URL
2. **Download** → HQ audio via tidal-dl-ng
3. **Analyze** → BPM + key detection
4. **Split stems** → demucs htdemucs (vocals, drums, bass, other)
5. **Scaffold** → Ableton Live project with all stems
6. **Visualize** → spectrograms via songsee (optional)

**Flags:**
- `--name "Name"` — Custom project name
- `--no-open` — Don't auto-open Ableton
- `--skip-viz` — Skip songsee visualizations

## Output Locations

| Output | Location |
|--------|----------|
| Downloaded audio | `~/Music/tidal-dl/` |
| Separated stems | `~/Music/tidal-dl/separated/htdemucs/<track>/` |
| Ableton projects | `~/Documents/das/remix-projects/<name>/` |
| Visualizations | Next to the source audio file |

## Repo Structure

```
das-remix-toolkit/
├── README.md               # This file
├── requirements.txt        # Python dependencies
├── setup.sh                # One-shot setup script
├── bin/
│   ├── track-info          # BPM + key detection
│   ├── scaffold-remix      # Ableton project scaffolder
│   ├── tidal-search        # Tidal track search
│   └── remix-pipeline      # Full pipeline orchestrator
└── templates/              # (reserved for future templates)
```

## Troubleshooting

**"Token file not found"** — Run `tidal-dl-ng` once to authenticate with Tidal.

**"No stems found"** — `scaffold-remix` expects files named `vocals.mp3`, `drums.mp3`, `bass.mp3`, `other.mp3` (the default demucs output names).

**BPM detection seems wrong** — Use `--bpm` flag to override: `scaffold-remix stems/ --bpm 140`

**Ableton won't open the .als file** — The generated .als is a minimal valid project. If Ableton complains, try opening it and clicking "OK" on any warnings — it should still load the tracks.

## License

Internal DAS collective tool. Share freely within the crew.
