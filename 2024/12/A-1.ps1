$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map.add($_.trim().Tochararray())}

$MaxX = $Map.count-1
$MaxY = $Map[0].count-1

$Watcher = [hashtable]::Synchronized(@{})
$global:RegionCounter = 1
$Regions = New-Object System.Collections.Generic.List[System.Object]

function Get-Region {
  param(
    [int]$x,
    [int]$y
  )

  $CurrentValue = $Map[$x][$y]
  #write-host $($CurrentValue + ': ' + $x + ',' + $y)
  if ($watcher[$([string]$x + ',' + $y)] -ne $true) {
    $watcher[$([string]$x + ',' + $y)] = $true
    $ToReturn = new-object -type PSCustomObject -property @{'Shape'=$CurrentValue;'loc'=$([string]$x + ',' + $y)}
  } else {
    $ToReturn = $null
  }
  #Up
  if ($y+1 -le $MaxY) {
    if ($Map[$x][$y+1] -eq $CurrentValue -and $watcher[$([string]$x + ',' + ($y+1))] -ne $True) { get-region -x $x -y ($y+1)}
  }
  #Down
  if ($y-1 -ge 0) {
    if ($Map[$x][$y-1] -eq $CurrentValue -and $watcher[$([string]$x + ',' + ($y-1))] -ne $True) { get-region -x $x -y ($y-1)}
  }
  #Left
  if ($x-1 -ge 0) {
    if ($Map[$x-1][$y] -eq $CurrentValue -and $watcher[$([string]($x-1) + ',' + $y)] -ne $True) { get-region -x ($x-1) -y $y}
  }
  #Right
  if ($x+1 -le $MaxX) {
    if ($Map[$x+1][$y] -eq $CurrentValue -and $watcher[$([string]($x+1) + ',' + $y)] -ne $True) { get-region -x ($x+1) -y $y}
  }
  Return $ToReturn
}

function Get-Boundary {
  param(
    [int]$x,
    [int]$y
  )
  $CurrentValue = $Map[$x][$y]
  $Boundary = 0
  #Up
  if ($y+1 -le $MaxY) {
    if ($Map[$x][$y+1] -ne $CurrentValue) { $Boundary++ }
  } else {
    $Boundary++
  }
  #Down
  if ($y-1 -ge 0) {
    if ($Map[$x][$y-1] -ne $CurrentValue) { $Boundary++ }
  } else {
    $Boundary++
  }
  #Left
  if ($x-1 -ge 0) {
    if ($Map[$x-1][$y] -ne $CurrentValue) { $Boundary++ }
  } else {
    $Boundary++
  }
  #Right
  if ($x+1 -le $MaxX) {
    if ($Map[$x+1][$y] -ne $CurrentValue) { $Boundary++ }
  } else {
    $Boundary++
  }

  Return $Boundary
}

0..$MaxX | foreach {
    $x = $_; 0..$MaxY | foreach { 
        $y = $_; if ($watcher[$([string]$x + ',' + $y)] -ne $True) { 
            $GetRegion = Get-Region -x $x -y $y
            if ($GetRegion -is [object]) { $Regions.add($GetRegion) | out-null }
        }
    }
}

#$regions | foreach {$_.count}

#$global:RegionCount = 0; $Regions | Select-Object -Property @{N='RegionID';E={$RegionCount; $global:regionCount++}},@{N='Locs';E={$_}},@{N='Area';E={@($_.Locs).count}}

$global:RegionCount = 0
$Summary = $Regions | Select-Object -Property @{N='RegionID';E={$RegionCount; $global:regionCount++}},@{N='Locs';E={$_}},@{N='Area';E={@($_.Locs).count}} | select-object -Property *,@{N='BoundaryCount';E={$allLocs = $_.locs; [int]($AllLocs | foreach {$locSplit = $_.loc.split(','); Get-Boundary -x $LocSplit[0] -y $LocSplit[1]} | Measure-Object -sum).sum}}
$Summary = $Summary | select-object -Property *,@{N='Cost';E={$_.area * $_.BoundaryCount}}
($Summary | Measure-Object -Property Cost -sum).sum

#Answer
#1486324