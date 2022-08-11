# Settings File

The settings file stores the settings of this tool on the local computer. The file format is human readable and editable in classic INI file format.

It's path depends on the OS, ie.
* C:\users\__YOUR_USER_NAME__\AppData\Local\Lazarus2YTDL\settings.ini
* /home/__YOUR_USER_NAME__/.config/Lazarus2YTDL\settings.ini
* (..)


## Section _File_
* __Template__ _stores the file name and path template (RW)_
* __Last__ _stores the URL of the last download (RW)_

## Section _Format_
* __Selection__ _zerobased ItemIndex of the video format ComboBox (RW)_
* __Description__ _human readable comment for the ItemIndex (Readonly)_

## Section _Update_
* __yt-dlp__ _date and time of the last yt-dlp update check; format depends on local language settings (RW)_
* __CheckInterval__ _check interval for update in days as floating point number. format depends on local language settings (RW)_
