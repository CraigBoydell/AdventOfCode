$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`r`n")

function get-Canvas {

    param ($Current)
    $Map = New-Object System.Collections.Generic.List[System.Object]
    1..$GridSizeX | foreach {
      $x = $_
      $Map.Add($(New-Object System.Collections.Generic.List[System.Object])) | out-null
      1..$GridSizeY | foreach { $Map[$x-1].add('.') } | out-null
    }
  
    $Current | foreach {$Map[$_.final.x][$_.Final.y] = 'O'}
  
    $Map | foreach {$_ -join ''}
  }

  function get-OnGridPosition {
    param (
        [long]$x,
        [long]$y
    )
<#
if ge y then -y
if le 0 then +y

if ge x then -x
if le 0 then +x
#>
  while ($y -ge $GridSizeY) {$y = $y - $GridSizeY}
  while ($y -lt 0) {$y = $y + $GridSizeY}
  while ($x -ge $GridSizeX) {$x = $x - $GridSizeX}
  while ($x -lt 0) {$x = $x + $GridSizeX}

  new-object -typename PSCustomObject -Property @{x=$x;y=$y}
}

$TotalSeconds = 100
$TotalSeconds = 7861

$GridSizeX = 101
$GridSizeY = 103

$GridHalfX = [math]::Ceiling($GridSizeX /2) -1
$GridHalfY = [math]::Ceiling($GridSizeY /2) -1

$BotVelocity = $SourceSplit | Select-Object -Property @{N='P';E= { new-object -typename PSCustomObject -Property @{x=$_.split(" ")[0].replace('p=','').split(',')[0]; y=$_.split(" ")[0].replace('p=','').split(',')[1]}}},@{N='V';E={new-object -typename PSCustomObject -Property @{x=$_.split(" ")[1].replace('v=','').split(',')[0]; y=$_.split(" ")[1].replace('v=','').split(',')[1]}}}
$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='AfterSeconds';E={new-object -TypeName PSCustomObject -Property @{x=[int]$_.V.x * $TotalSeconds; y=[int]$_.V.y * $TotalSeconds}}}
#$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='Final';E={ new-object -typename PSCustomObject -Property @{x=$_.AfterSeconds.x + $_.P.x; y=$_.AfterSeconds.y + $_.P.y}  }}
$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='Final';E={ get-OnGridPosition -x $($_.AfterSeconds.x + $_.P.x) -y $($_.AfterSeconds.y + $_.P.y)  }}

$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='Quad';E={if ($_.Final.x -lt $GridHalfX -and $_.Final.y -lt $GridHalfY) {1};if ($_.Final.x -gt $GridHalfX -and $_.Final.y -lt $GridHalfY) {2};if ($_.Final.x -lt $GridHalfX -and $_.Final.y -gt $GridHalfY) {3}; if ($_.Final.x -gt $GridHalfX -and $_.Final.y -gt $GridHalfY) {4}}}



while (($BotVelocity | Group-Object -Property {([string]$_.FInal.x + ',' + $_.Final.y)} ).count -ne 500) {
Write-Progress -Activity $([string]$TotalSeconds + ': ' + ($BotVelocity | Group-Object -Property {([string]$_.FInal.x + ',' + $_.Final.y)} ).count)

$BotVelocity = $SourceSplit | Select-Object -Property @{N='P';E= { new-object -typename PSCustomObject -Property @{x=$_.split(" ")[0].replace('p=','').split(',')[0]; y=$_.split(" ")[0].replace('p=','').split(',')[1]}}},@{N='V';E={new-object -typename PSCustomObject -Property @{x=$_.split(" ")[1].replace('v=','').split(',')[0]; y=$_.split(" ")[1].replace('v=','').split(',')[1]}}}
$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='AfterSeconds';E={new-object -TypeName PSCustomObject -Property @{x=[int]$_.V.x * $TotalSeconds; y=[int]$_.V.y * $TotalSeconds}}}
#$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='Final';E={ new-object -typename PSCustomObject -Property @{x=$_.AfterSeconds.x + $_.P.x; y=$_.AfterSeconds.y + $_.P.y}  }}
$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='Final';E={ get-OnGridPosition -x $($_.AfterSeconds.x + $_.P.x) -y $($_.AfterSeconds.y + $_.P.y)  }}

$BotVelocity = $BotVelocity | Select-Object -Property *,@{N='Quad';E={if ($_.Final.x -lt $GridHalfX -and $_.Final.y -lt $GridHalfY) {1};if ($_.Final.x -gt $GridHalfX -and $_.Final.y -lt $GridHalfY) {2};if ($_.Final.x -lt $GridHalfX -and $_.Final.y -gt $GridHalfY) {3}; if ($_.Final.x -gt $GridHalfX -and $_.Final.y -gt $GridHalfY) {4}}}

#get-canvas -Current $BotVelocity
#start-sleep -Milliseconds 100
$TotalSeconds++

}

#invoke-expression $(($BotVelocity | group-object -Property Quad | where {$_.Name -ne ''} | select-object -ExpandProperty Count) -join '*')


#Answer
#7861