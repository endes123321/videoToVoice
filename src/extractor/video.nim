import os, osproc,
        private
from times import cpuTime

proc toImages*(video_path: string): string =
    result = getTempDir() & "/vtv/imgs/" & $cpuTime().toInt() & "/"
    createDir(result)
    exec "ffmpeg i \"" & video_path & "\" -vf fps=30 \"" & result & "%d.png\""

proc donwload_from_platforms*(video_url: string, lang = "en"): string =
    result = getTempDir() & "/vtv/download/" & $cpuTime().toInt() & "."
    exec "youtube-dl --write-auto-sub --all-subs --sub-lang " & lang & " -o " & result & "%(ext)s \"" & video_url & "\""