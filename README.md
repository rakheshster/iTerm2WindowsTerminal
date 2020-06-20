# iTerm2 Colors to Windows Terminal colors

The `ConvertFrom-iTerm2.ps1` script takes a URL to an iTerm2 color scheme and outputs JSON you can put into a Windows Terminal color scheme. 

You can find iTerm2 color schemes [here](https://iterm2colorschemes.com) for instance. The script expect an http URL to an `itermcolors` file which it will download and output JSON.

Example:

![Running the Script](Screenshot.png)

The above pulls the Ubuntu colour theme, which I can input into Windows Terminal to get something like this:

![Ubuntu colors in Windows Terminal](Screenshot2.png)

See [this blog post](https://rakhesh.com/powershell/converting-iterm2-colours-to-windows-terminal-colors/) for the background on this. 

