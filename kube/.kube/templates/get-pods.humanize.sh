#!/usr/bin/env bash
# Transforms ISO 8601 timestamps into human-readable durations matching
# kubectl's format: "Xs" / "Xm" / "Xh" / "XdYh"
#
# Handles two fields:
#   RESTARTS  — "N#ISO_TIMESTAMP" → "N (Xh ago)"  (embedded by get-pods.gotemplate)
#   AGE       — ISO_TIMESTAMP at end of line → human-readable duration
#
# Usage:
#   kubectl get pods -o go-template-file=get-pods.gotemplate | ./fmt-age.sh

# TZ=UTC so that awk's mktime() treats parsed timestamps as UTC
TZ=UTC awk '
function human_duration(s,    d, h) {
    if (s < 60)     return s "s"
    if (s < 3600)   return int(s / 60) "m"
    if (s < 172800) return int(s / 3600) "h"   # < 48h — plain hours like kubectl
    d = int(s / 86400)
    h = int((s % 86400) / 3600)
    return h ? d "d" h "h" : d "d"
}

function iso_elapsed(iso,    dt, d, t, epoch) {
    split(iso, dt, "T")
    split(dt[1], d, "-")
    split(dt[2], t, ":")
    epoch = mktime(d[1] " " d[2] " " d[3] " " t[1] " " t[2] " " substr(t[3], 1, 2))
    return systime() - epoch
}

{
    # ── RESTARTS: replace "N#ISO" with "N (Xh ago)", preserving column width ──
    if (match($0, /[0-9]+#[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z/)) {
        orig    = substr($0, RSTART, RLENGTH)
        split(orig, parts, "#")
        elapsed = iso_elapsed(parts[2])
        if (elapsed < 0) elapsed = 0
        repl    = parts[1] " (" human_duration(elapsed) " ago)"
        # Pad replacement to same width as original to keep subsequent columns aligned
        if (RLENGTH > length(repl)) repl = sprintf("%-" RLENGTH "s", repl)
        $0 = substr($0, 1, RSTART - 1) repl substr($0, RSTART + RLENGTH)
    }

    # ── NODE: replace ".compute.internal" with spaces to preserve column width ──
    gsub(/\.compute\.internal/, "                 ")  # 17 spaces, same length as suffix

    # ── AGE: replace ISO timestamp at end of line with human-readable duration ──
    if (match($NF, /^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$/)) {
        elapsed = iso_elapsed($NF)
        if (elapsed < 0) elapsed = 0
        print substr($0, 1, length($0) - length($NF)) human_duration(elapsed)
        next
    }

    print
}
'
