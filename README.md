# 趣味でOSSをやっている者だ

![](static/images/artwork.png)

## このリポジトリについて
このリポジトリは、ポッドキャスト番組「趣味でOSSをやっている者だ(<https://oss4.fun>)」のソースリポジトリです。

## ポッドキャストとPodbard

このポッドキャストサイトは、[Podbard](https://github.com/Songmu/podbard)を使って作成しています。Podbardをご利用の際には是非このリポジトリを参考にしてみてください。

## Audio storage

Audio files are hosted separately at `https://files.oss4.fun/audio/` in the
`oss4fun` R2 bucket. Only Podbard metadata files such as `audio/.1.mp3.json`
are tracked here. These contain the title, file size, duration, and embedded
chapters, not the audio itself. Podbard v0.0.19 or newer can build the site
from these files without local MP3s. Keep episode references such as `audio: 1.mp3`
unchanged; `audio_bucket_url` supplies the playback URL.

The deployment workflow uses Podbard v0.0.19, which includes the metadata-loading
fix. Install the same version locally:

```sh
go install github.com/Songmu/podbard/cmd/podbard@v0.0.19
```

Ensure this binary takes precedence over any release installation in `PATH`.

For a new episode, place the MP3 in `audio/` and create its episode Markdown.
Install and authenticate the Cloudflare `cf` CLI before syncing audio.
Run `podbard build` manually to finalize embedded chapters, then sync:

```sh
podbard episode --no-edit audio/105.mp3
podbard build
make sync-audio
```

`make sync-audio` runs `scripts/sync-audio.sh` without arguments. For each local
`audio/*.mp3` without `audio/.<filename>.json` and with a matching
`episode/<name>.md`, it uploads only the MP3 to `r2://oss4fun/audio` using `cf`,
then saves metadata using `podbard episode --no-edit --save-meta`.
Saving metadata after uploading allows failed uploads to be retried on the
next run. Files starting with `_` (such as `_outro.mp3`), files with metadata,
and files without a matching episode are skipped.
Both the MP3 and JSON remain in `audio/`; no temporary directory is used.
The script stops on errors and does not run a build, delete files, or commit.
To resync changed audio, remove its metadata JSON before running the target.

Commit `audio/.105.mp3.json` and `episode/105.md`, not the ignored MP3.
Finalize embedded chapters with `podbard build` before syncing; editing chapter
front matter alone cannot update an externally hosted MP3.

The deployment workflow only builds and deploys the site; it does not upload
audio or metadata to R2. Do not sync this metadata-only `audio/` directory to
R2 or delete existing R2 audio objects when removing local recordings.
This keeps future commits small but does not remove MP3s from Git history.

## Copyright

Copyright 2024 Songmu

The documentation is made available under the Creative Commons 4.0 International License. See the [LICENSE](https://github.com/mackerelio/documents/blob/master/LICENSE) file.

Any code within this repository (e.g., sample code) is made available under an MIT License. See the [LICENSE-CODE](https://github.com/mackerelio/documents/blob/master/LICENSE-CODE) file.
