param(
    [Parameter(Mandatory=$true,
    HelpMessage="The URL with iTerm colours.")]
    [ValidateScript({ $_ -match '^http.*itermcolors$' })]
    [string]$colorFileURL
)

# $colorFileURL = "https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Ubuntu.itermcolors"

# function that takes as input a string with the iTerm color and outputs the Windows Terminal Color
function ConvertTerm2Terminals {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$iTermColor
    )

    $colorMappings = @{
        "Ansi 0 Color" = "black"
        "Ansi 1 Color" = "red"
        "Ansi 2 Color" = "green"
        "Ansi 3 Color" = "yellow"
        "Ansi 4 Color" = "blue"
        "Ansi 5 Color" = "purple" # I can't find magenta in the VSCode colors, so I go with purple
        "Ansi 6 Color" = "cyan"
        "Ansi 7 Color" = "white"
        "Ansi 8 Color" = "brightBlack"
        "Ansi 9 Color" = "brightRed"
        "Ansi 10 Color" = "brightGreen"
        "Ansi 11 Color" = "brightYellow"
        "Ansi 12 Color" = "brightBlue"
        "Ansi 13 Color" = "brightPurple"
        "Ansi 14 Color" = "brightCyan"
        "Ansi 15 Color" = "brightWhite"
        "Cursor Color" = "cursorColor"
        "Cursor Text Color" = "!cursorTextColor" # I made this up. Ignore it. 
        "Bold Color" = "!boldColor" # I made this up. Ignore it. 
        "Selected Text Color" = "!selectionForeground" # I made this up. Ignore it. 
        "Selection Color" = "selectionBackground"
        "Background Color" = "background"
        "Foreground Color" = "foreground"
    }

    $colorMappings.$iTermColor
}

# function that takes as input an array of floating point numbers
# it expects the first element to be the Blue, second to be Green, and last to be Red
function ConvertReal2Hex {
    [CmdletBinding()]
    param(
        [Parameter()]
        [float[]]$Real
    )

    # I take each decimal, multiply by 255, and cast to integer. This is because the -f operator is expecting an integer. 
    # Learnt this through trial and error. 
    [int]$Blue = $Real[0] * 255
    [int]$Green = $Real[1] * 255
    [int]$Red = $Real[2] * 255

    "#{0:X2}{1:X2}{2:X2}" -f $Red,$Green,$Blue
    # The 0, 1, 2 stand for the place holder. The right side of the -f operator is an array, so 0, 1, 2 refer to the objects of this array. 
    # Basically, one can mix up the array elements on the output (left side). The "X" tells the format operator to convert to a hex. 
    # The 2 after the X tells it to do 2 places. I realized this when some of the output didn't have 2 places. 
}

try {
    [xml]$xmlObj = $(Invoke-WebRequest $colorFileURL).Content
} catch {
    throw "$colorFileURL is invalid!"
}

$keysArray = @($xmlObj.plist.dict.key)
$valuesArray = @($xmlObj.plist.dict.dict)

$hexColorsArray = foreach ($value in $valuesArray) { ConvertReal2Hex $value.real }
$winColorNamesArray = foreach ($key in $keysArray) { ConvertTerm2Terminals $key }

$finalOutput = @{}
$finalOutput["name"] = $(Split-Path $colorFileURL -LeafBase)
for ($i = 0; $i -lt $winColorNamesArray.Length; $i++) {
    if ($winColorNamesArray[$i] -notmatch "^!") { $finalOutput[$winColorNamesArray["$i"]] = $hexColorsArray[$i] }
}

$finalOutput | ConvertTo-Json