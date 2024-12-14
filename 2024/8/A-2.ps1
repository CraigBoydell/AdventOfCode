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

$AntennasWAntinodes = $AntennasWAntinodes | Select-Object -Property *,@{N='AntinodeDiststr';E={$_.antinodeDist -join ','}}

$AntennasWAntinodes = $AntennasWAntinodes | Select-Object -Property *,@{N='AntinodeLocation';E={ $AntX = ($_.x + $_.AntinodeDist[0]); $AntY = ($_.y + $_.AntinodeDist[1]); if ($AntX -ge 0 -and $AntY -ge 0 -and $AntX -le $MaxX -and $AntY -le $MaxY) { @($AntX,$AntY) -join ','  } else {'NA'} }} -ExcludeProperty AntinodeLocation

$Final = $AntennasWAntinodes | Select-Object -Property AntinodeLocation -Unique | where {$_.AntinodeLocation -ne 'NA'}


$AntennasWAntinodes =  $AntennasWAntinodes | select-object -Property *,@{N='AntinodesLocations';E= { write-host $_; $CurrentX = $_.x;$CurrentY=$_.y; do {$CurrentX = $CurrentX + $_.AntinodeDist[0]; $CurrentY=$CurrentY + $_.AntinodeDist[1]; if ($CurrentX -ge 0 -and $CurrentY -ge 0 -and $CurrentX -le $MaxX -and $CurrentY -le $MaxY) {@($CurrentX,$CurrentY) -join ','}} until ($CurrentX -lt 0 -or $CurrentX -ge $MaxX -or $CurrentY -lt 0 -or $CurrentY -ge $Maxy)  }}

$Final = $AntennasWAntinodes.antinodeslocations | Select-Object -Unique

$AllAn = $Antennas | foreach { @($_.x, $_.y) -join ','  }

$Final = $Final | where {$_ -notin $AllAn}

$Final.count + ($Antennas | Group-Object -Property Antenna | where {$_.Count -gt 1} | Measure-Object -Property Count -Sum).sum

#Answer
#1200

<#
$Map2 = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map2.add($_.trim().Tochararray())}

$AllAn = $Antennas | foreach { @($_.x, $_.y) -join ','  }

$Final = $Final | where {$_ -notin $AllAn}

$Final | foreach {$CoOrd = $_ -split ','; $Map2[$CoOrd[0]][$CoOrd[1]] = '#'}
#>