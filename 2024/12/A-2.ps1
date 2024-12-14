$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
#$Source = Get-Content .\ex3.txt -Raw
#$Source = Get-Content .\ex4.txt -Raw
#$Source = Get-Content .\ex5.txt -Raw
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
  #Down
  if ($y+1 -le $MaxY) {
    if ($Map[$x][$y+1] -ne $CurrentValue) { $Boundary++ }
  } else {
    $Boundary++
  }
  #Up
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

function Get-Corner {
    param(
      [int]$x,
      [int]$y,
      $Regionlocs
    )
    $CurrentValue = $Map[$x][$y]
    $Corner = 0
    #BoardCorners
    <#
    if ($x -eq 0 -and $y -eq 0) {$Corner++}
    if ($x -eq 0 -and $y -eq $MaxY) {$Corner++}
    if ($x -eq $MaxX -and $y -eq 0) {$Corner++}
    if ($x -eq $MaxX -and $y -eq $MaxY) {$Corner++}
    #>

    $neighbours = New-Object System.Collections.Generic.List[System.Object]
    $neighboursd = New-Object System.Collections.Generic.List[System.Object]

    #Left
    if ($y-1 -ge 0) {
      if ($Map[$x][$y-1] -eq $CurrentValue) { $neighbours.add('L') | out-null }
    }
    #Right
    if ($y+1 -le $MaxY) {
      if ($Map[$x][$y+1] -eq $CurrentValue) { $neighbours.add('R') | out-null }
    }
    #Up
    if ($x-1 -ge 0) {
      if ($Map[$x-1][$y] -eq $CurrentValue) { $neighbours.add('U') | out-null }
    }
    #Down
    if ($x+1 -le $MaxX) {
      if ($Map[$x+1][$y] -eq $CurrentValue) { $neighbours.add('D') | out-null }
    }
    #UpLeft
    if ($y-1 -ge 0 -and $x-1 -ge 0 -and @($RegionLocs | where {$_.Loc -eq $([string]($x-1) + ',' + ($y-1))}).count -gt 0) {
      if ($Map[$x-1][$y-1] -eq $CurrentValue) { $neighboursd.add('UL') | out-null }
    }
    #DownLeft
    if ($x+1 -le $MaxX -and $y-1 -ge 0 -and @($RegionLocs | where {$_.Loc -eq $([string]($x+1) + ',' + ($y-1))}).count -gt 0) {
      if ($Map[$x+1][$y-1] -eq $CurrentValue) { $neighboursd.add('DL') | out-null }
    }
    #UpRight
    if ($y+1 -le $MaxY -and $x-1 -ge 0 -and @($RegionLocs | where {$_.Loc -eq $([string]($x-1) + ',' + ($y+1))}).count -gt 0) {
      if ($Map[$x-1][$y+1] -eq $CurrentValue) { $neighboursd.add('UR') | out-null }
    }
    #DownRight
    if ($y+1 -le $MaxX -and $x+1 -le $MaxX -and @($RegionLocs | where {$_.Loc -eq $([string]($x+1) + ',' + ($y+1))}).count -gt 0) {
      if ($Map[$x+1][$y+1] -eq $CurrentValue) { $neighboursd.add('DR') | out-null }
    }
  
    #Return $neighbours
    #write-host $neighbours
    #write-host $neighboursd


    if ($neighbours.count -eq 0) {$Corner = 4}
    if ($neighbours.count -eq 1) {$Corner = 2}
    if ($Neighbours.count -eq 2) {
      if (@(Compare-Object -ReferenceObject $neighbours -DifferenceObject @('R','D')).count -eq 0) {$Corner++}
      if (@(Compare-Object -ReferenceObject $neighbours -DifferenceObject @('R','U')).count -eq 0) {$Corner++}
      if (@(Compare-Object -ReferenceObject $neighbours -DifferenceObject @('L','U')).count -eq 0) {$Corner++}
      if (@(Compare-Object -ReferenceObject $neighbours -DifferenceObject @('L','D')).count -eq 0) {$Corner++}
      #if ($neighboursd.contains('DR') -and -not (@(Compare-Object -ReferenceObject $neighbours -DifferenceObject @('R','D')).count -eq 0)) {$Corner++}
      #if ($neighboursd.contains('DL') -and -not (@(Compare-Object -ReferenceObject $neighbours -DifferenceObject @('L','D')).count -eq 0)) {$Corner++}
    }
    #if ($neighboursd.contains('DR') -and -not (@($($neighbours | where {$_ -in @('R','D')})).count -eq 2)) {$Corner++}
    if ($neighboursd.contains('DR') -and (@($($neighbours | where {$_ -in @('R','D')})).count -eq 1)) {$Corner++}
    #if ($neighboursd.contains('DL') -and -not (@($($neighbours | where {$_ -in @('L','D')})).count -eq 2)) {$Corner++}    
    if ($neighboursd.contains('DL') -and (@($($neighbours | where {$_ -in @('L','D')})).count -eq 1)) {$Corner++}    
    Return $Corner
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
#$Summary = $Regions | Select-Object -Property @{N='RegionID';E={$RegionCount; $global:regionCount++}},@{N='Locs';E={$_}},@{N='Area';E={@($_.Locs).count}} | select-object -Property *,@{N='BoundaryCount';E={$allLocs = $_.locs; [int]($AllLocs | foreach {$locSplit = $_.loc.split(','); Get-Boundary -x $LocSplit[0] -y $LocSplit[1]} | Measure-Object -sum).sum}}
$Summary = $Regions | Select-Object -Property @{N='RegionID';E={$RegionCount; $global:regionCount++}},@{N='Locs';E={$_}},@{N='Area';E={@($_.Locs).count}} | select-object -property *,@{N='Boundaries';E={$allLocs = $_.locs;$AllLocs | foreach {$locSplit = $_.loc.split(','); Get-Boundary -x $LocSplit[0] -y $LocSplit[1]}}}
$Summary = $Summary | select-object -Property *,@{N='BoundaryCount';E={[int]($_.Boundaries | Measure-Object -sum).sum}}
$Summary = $Summary | select-object -Property *,@{N='Cost';E={$_.area * $_.BoundaryCount}}
$Summary = $Summary | Select-Object -Property *,@{N='Corners';E={$allLocs = $_.locs;$AllLocs | foreach {$locSplit = $_.loc.split(','); Get-Corner -x $LocSplit[0] -y $LocSplit[1] -Regionlocs $AllLocs}}} | Select-Object -Property *,@{N='CornerCount';E={($_.Corners | measure-object -sum).sum}}
$Summary = $Summary | select-object -Property *,@{N='Cost2';E={$_.area * $_.CornerCount}}
($Summary | Measure-Object -Property Cost -sum).sum
($Summary | Measure-Object -Property Cost2 -sum).sum


#Answer
#898684
