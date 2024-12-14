$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map.add($_.trim().Tochararray())}


$MaxX = $Map.count-1
$MaxY = $Map[0].count-1


$Antennas = 0..$MaxX | foreach {
    $x = $_; 0..$MaxY | foreach { 
        $y = $_; if ($Map[$x][$y] -ne '.') { 
            new-object -type PSCustomObject -Property @{Antenna=$Map[$x][$y]; x=$x; y=$y }
        }
    }
}


$AntennasWAntinodes = $Antennas | foreach { 
    $Tocheck = $_
    $FindAntinodesOf = $Antennas | where { $_.Antenna -ceq $Tocheck.Antenna  }
    $FindAntinodesOf | Select-Object -Property *,@{N='AntinodeDist';E={@(($_.x - $Tocheck.x), ($_.y - $Tocheck.y))}} | where {$_.antinodeDist -join ',' -ne '0,0'}
}

$AntennasWAntinodes = $AntennasWAntinodes | Select-Object -Property *,@{N='AntinodeLocation';E={ $AntX = ($_.x + $_.AntinodeDist[0]); $AntY = ($_.y + $_.AntinodeDist[1]); if ($AntX -ge 0 -and $AntY -ge 0 -and $AntX -le $MaxX -and $AntY -le $MaxY) { @($AntX,$AntY) -join ','  } else {'NA'} }} -ExcludeProperty AntinodeLocation

$Final = $AntennasWAntinodes | Select-Object -Property AntinodeLocation -Unique | where {$_.AntinodeLocation -ne 'NA'}

<#
$Map2 = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map2.add($_.trim().Tochararray())}

$AllAn = $Antennas | foreach { @($_.x, $_.y) -join ','  }

$Final = $Final | where {$_.AntinodeLocation -notin $AllAn}

$Final | foreach {$CoOrd = $_.AntinodeLocation -split ','; $Map2[$CoOrd[0]][$CoOrd[1]] = '#'}
#>

#Answer
#396