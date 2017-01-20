#!/bin/sh

find . -name '*.wav' | while read i ; do
    BASE="$(dirname "$i")/$(basename "$i" .wav)"
    TITLE="$(basename "$i")"

    [ "$i" -nt "$BASE.mp3" ] && lame -b 32 -V 5 -q 5 -m j "$i" "$BASE.mp3" --tt "$TITLE" --ta "j. shagam @ metronomic.tk" --tl "Global Game Jam 2016" --ty 2016
    [ "$i" -nt "$BASE.ogg" ] && oggenc "$i" -o "$BASE.ogg" -t "$TITLE" -a "j. shagam @ metronomic.tk"
    [ "$i" -nt "$BASE.flac" ] && flac "$i" -fo "$BASE.flac"
done

(
cat << EOF
<!DOCTYPE html>
<html>
<head>
<title>Global Game Jam 2017 music</title>

<style>
table {border-collapse: collapse; border: solid black 3px; }
table td { border: solid black 1px; padding: 0px 1ex; }
table th { border: solid black 3px; background: #ccc; }

div.pad { height: 5em; }
</style>

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

<!-- jPlayer Jukebox add-on -->
<link type="text/css" href="//gyrocode.github.io/jplayer-jukebox/0.6.0/skin/uno/jplayer.uno.min.css" rel="stylesheet" />
<script type="text/javascript" src="//gyrocode.github.io/jplayer-jukebox/0.6.0/jplayer.jukebox.bundle.min.js"></script>

<script type="text/javascript">
   \$(document).ready(function(){
      // Initialize jPlayerJukebox
      var jpjb = new jPlayerJukebox({
         'jukeboxOptions': {
            autoAdvance: false,
            position: "fixed-b"
         }
      });
   });
</script>

</head>

<body>
    <p>Here is the music I've made for this year's Global Game Jam (2017), most recent first. Please see <a href="https://github.com/plaidfluff/ggj2017-music">my GitHub repo</a> for more information.</p>
    <p>Or you can listen to <a href="/2016/">last year's stuff</a> if you want!</p>
<table>
<tr><th>Folder</th><th>Name</th><th>Duration</th><th>mp3</th><th>ogg</th><th>flac</th><th>Updated</th></tr>
EOF

find . -type f -name '*.wav' | while read wav ; do
    printf '%d %s\n' $(stat -f %m "$wav") "$wav"
done | sort -nr | while read mtime wav ; do
    echo mtime=$mtime wav=$wav 1>&2
    dir="$(dirname "$wav" | cut -f2- -d/)"
    basename="$(basename "$wav" .wav)"
    pathpart="$(dirname "$wav")/$basename"
    fmtime="$(stat -t "%Y-%m-%d %H:%M" -f %Sm "$wav")"
    printf '<tr>
    <td><a href="%s">%s</a></td>
    <td>%s</td>
    <td>%s</td>
    <td><a href="%s.mp3">mp3</a></td>
    <td><a href="%s.ogg">ogg</a></td>
    <td><a href="%s.flac">flac</a></td>
    <td>%s</td>
    </tr>' "$dir" "$dir" "$basename" "$(soxi -d "$wav")" "$pathpart" "$pathpart" "$pathpart" "$fmtime"
done
printf '</table>'

cat << EOF
</ul>

<div class="pad">&nbsp;</div>

</body></html>
EOF
) > index.html