# Lazarus2YTDL
a minimalistic GUI to the yt-dlp commandline tool.

![alt text](doc/Lazarus2YTDL.png)

Usage:
1. Paste a download address into the first Edit component.

2. Define a template for the filename in the second Edit
   component. If you have never done so, you should read
   the Readme of yt-dlp first. Start here:
       https://github.com/yt-dlp/yt-dlp#output-template
   You may define either relative paths to the install position
   of this tool, or, absolute paths. Your choice.
   The last template used is restored after restart.

_Optional: Select an Output Format in the ComboBox above the Memo:_
* default (nothing is selected, let yt-dlp choose)
* merge best video, best audio
* best video with smallest resolution
* smallest video available
* best video no better than 480p
* best audio only
* best mp3 or aac audio

3. Start download using the Button. All messages from
   yt-dlp should appear in the Memo component.

Hints:
- You may also download a sequence of addresses.
  To do so, use the 'Add to List' button to add them to the queue.
  Once you have all addresses added, start the downloads using the
  'Start List' button.

- The yt-dlp tool may often require updates. This tool asks every
  seven days, if you wish to update it. You can also use the
  'update yt-dlp' Button to trigger an update. 



Installation:
- copy all binaries into one folder and create a shortcut for
  this GUI. Thats it. At least yt-dlp.exe and this GUI.
  ffmpeg and ffplay are both optional.
- the install dir needs write permissions.
  
NOTE: the binaries from ffmpeg, ffplay, yt-dlp have their own
      copyrights. You may want to choose the very latest version
      you can find. yt-dlp has it own commandline update.

      Latest yt-dlp release files:
      https://github.com/yt-dlp/yt-dlp#release-files


Compiling Lazarus2YTDL:
1. Install the Lazarus IDE, together with the fpc (at least Lazarus-2.0.6 + fpc-3.0.4)

2. open Lazarus2YTDL.lpr from the Lazarus IDE and press F9.

3. wasn't that easy ? Everything done, continue with Installation.

