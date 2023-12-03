#Example:
$i = @'
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
'@

#$i = Get-Content .\I.txt -raw
$Actions = 'Direction Steps' + "`n" + $i | ConvertFrom-Csv -Delimiter ' '


function Move-Head {
  param (
    $Direction,
    $Steps,
    $Location
  )
  1..$Steps | foreach {
    switch ($Direction) {
     'U' { $Location.y++  }
     'D' { $Location.y-- }
     'L' { $Location.x--}
     'R' { $Location.x++ }
    }
    new-object -type PSCustomObject -Property $([ordered]@{ H = $Location; T = $(Move-Tail -headLocation $Location)})
    $global:HeadLocation = $Location
  }
}

function Move-Tail {
  param (
    $headLocation
  )
  write-host $('H: ' + $headLocation.x + ',' + $headLocation.y)
  write-host $('T: ' + $global:tailLocation.x + ',' + $global:tailLocation.y)
  if (($headLocation.x - $global:tailLocation.x) -gt 1 -and ($headLocation.y -eq $global:tailLocation.y) ) { $global:tailLocation.x++; $Global:moved++; write-host $("Right: " + $global:tailLocation.x + ',' + $global:tailLocation.y)  } #Right
  if (($global:tailLocation.x - $headLocation.x) -gt 1 -and ($headLocation.y -eq $global:tailLocation.y) ) { $global:tailLocation.x--; $Global:moved++; write-host $("Left: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #Left
  if (($headLocation.y - $global:tailLocation.y) -gt 1 -and ($headLocation.x -eq $global:tailLocation.x) ) { $global:tailLocation.y++; $Global:moved++; write-host $("Up: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #Up
  if (($global:tailLocation.y - $headLocation.y) -gt 1 -and ($headLocation.x -eq $global:tailLocation.x) ) { $global:tailLocation.y--; $Global:moved++; write-host $("Down: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #Down
  if (($headLocation.x - $global:tailLocation.x) -eq 1 -and ($headLocation.y - $global:tailLocation.y) -gt 1 ) { $global:tailLocation.x++;$global:tailLocation.y++; $Global:moved++; write-host $("DiagUpRight: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagUpRight
  if (($headLocation.x - $global:tailLocation.x) -gt 1 -and ($headLocation.y - $global:tailLocation.y) -eq 1 ) { $global:tailLocation.x++;$global:tailLocation.y++; $Global:moved++; write-host $("DiagUpRight: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagUpRight
  if (($global:tailLocation.x - $headLocation.x) -gt 1 -and ($headLocation.y - $global:tailLocation.y ) -eq 1 ) { $global:tailLocation.x--;$global:tailLocation.y++; $Global:moved++; write-host $("DiagUpLeft: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagUpLeft
  if (($global:tailLocation.x - $headLocation.x) -eq 1 -and ($headLocation.y - $global:tailLocation.y ) -gt 1 ) { $global:tailLocation.x--;$global:tailLocation.y++; $Global:moved++; write-host $("DiagUpLeft: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagUpLeft
  if (($headLocation.x - $global:tailLocation.x) -gt 1 -and ($global:tailLocation.y - $headLocation.y ) -eq 1 ) { $global:tailLocation.x++;$global:tailLocation.y--; $Global:moved++; write-host $("DiagDownRight: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagDownRight
  if (($headLocation.x - $global:tailLocation.x) -eq 1 -and ($global:tailLocation.y - $headLocation.y ) -gt 1 ) { $global:tailLocation.x++;$global:tailLocation.y--; $Global:moved++; write-host $("DiagDownRight: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagDownRight
  if (($global:tailLocation.x - $headLocation.x) -gt 1 -and ($global:tailLocation.y - $headLocation.y) -eq 1 ) { $global:tailLocation.x--;$global:tailLocation.y--; $Global:moved++; write-host $("DiagDownLeft: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagDownLeft
  if (($global:tailLocation.x - $headLocation.x) -eq 1 -and ($global:tailLocation.y - $headLocation.y) -gt 1 ) { $global:tailLocation.x--;$global:tailLocation.y--; $Global:moved++; write-host $("DiagDownLeft: " + $global:tailLocation.x + ',' + $global:tailLocation.y) } #DiagDownLeft

  $global:tailLocation
  $global:tracker += [string]$Global:tailLocation.x + ',' + $Global:tailLocation.y
}

<#
$global:tailLocation = $(new-object -type PSCustomObject -Property $([ordered]@{X=0;Y=0}) )

Move-Head -Direction R -Steps 4 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=0;Y=0}) )
Move-Head -Direction U -Steps 4 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=4;Y=0}) )
Move-Head -Direction L -Steps 3 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=4;Y=4}) )
Move-Head -Direction D -Steps 1 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=1;Y=4}) )
Move-Head -Direction R -Steps 4 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=1;Y=3}) )
Move-Head -Direction D -Steps 1 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=5;Y=3}) )
Move-Head -Direction L -Steps 5 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=5;Y=2}) )
Move-Head -Direction R -Steps 2 -Location $(new-object -type PSCustomObject -Property $([ordered]@{X=0;Y=2}) )
#>

$Global:moved =0
$global:tracker = @()
$global:tailLocation = $(new-object -type PSCustomObject -Property $([ordered]@{X=0;Y=0}) )
$global:HeadLocation = $(new-object -type PSCustomObject -Property $([ordered]@{X=0;Y=0}) )
for ($t=0;$t -lt $Actions.count;$t++) {
  $Result = Move-Head -Direction $ACtions[$t].direction -Steps $Actions[$t].steps -Location $global:HeadLocation
  #$t
  #$Result
}

($global:tracker | Select-Object -Unique).count
