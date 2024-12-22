#$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

#$SourceSplit = $Source.split("`n")
$SourceSplit = $Source.Split("`n`r`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit[0].split("`n") | foreach {$Map.add($_.trim().Tochararray())}

$MaxX = $Map.count-1
$MaxY = $Map[0].count-1

$StartPoint = 0..$MaxX | foreach {
    $x = $_; 0..$MaxY | foreach { 
        $y = $_; if ($Map[$x][$y] -eq '@') { 
            new-object -type PSCustomObject -Property @{StartPoint=$Map[$x][$y]; x=$x; y=$y }
            #break
        }
    }
}

$InstructionSet = $SourceSplit[1].ToCharArray()

$CurrentPoint = new-object -Property @{x=$StartPoint.x; y=$StartPoint.y} -TypeName PSCustomObject


function Get-NextDotPoint {
    param (
        $Start,
        $Direction
    )
    $x = [int]$Start.x
    $y = [int]$Start.y
    $isBox = $False
    $isDot = $False
    $isWall = $False
    while ($x -ge 0 -and $x -lt $MaxX -and $y -ge 0 -and $y -lt $MaxY -and $isDot -eq $false -and $isWall -eq $false) {
      if ($Direction -eq 'Up') { $x--; if ($Map[$x][$y] -eq '.' ) { $isDot = $True };if ($Map[$x][$y] -eq 'O' ) { $isBox = $True }; if ($Map[$x][$y] -eq '#' ) { $isWall = $True }  }
      if ($Direction -eq 'Down') { $x++; if ($Map[$x][$y] -eq '.' ) { $isDot = $True };if ($Map[$x][$y] -eq 'O' ) { $isBox = $True }; if ($Map[$x][$y] -eq '#' ) { $isWall = $True }  }
      if ($Direction -eq 'Left') { $y--; if ($Map[$x][$y] -eq '.' ) { $isDot = $True };if ($Map[$x][$y] -eq 'O' ) { $isBox = $True }; if ($Map[$x][$y] -eq '#' ) { $isWall = $True }  }
      if ($Direction -eq 'Right') { $y++; if ($Map[$x][$y] -eq '.' ) { $isDot = $True };if ($Map[$x][$y] -eq 'O' ) { $isBox = $True }; if ($Map[$x][$y] -eq '#' ) { $isWall = $True }  }
    }
    if ($isDot -eq $True) {
      New-Object -Property @{x=$x;y=$y;isBox=$isBox} -typeName PSCustomObject
    }
}

$InstructionSet | foreach {
    switch ($_) {
        '^' { $TestMove = Get-NextDotPoint -Start $CurrentPoint -Direction Up; if ( $TestMove -is [object] ) { if ($TestMove.isBox -eq $True) {$Map[$TestMove.x][$TestMove.y] = 'O';$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x-1][$CurrentPoint.y] = '@'} else {$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x-1][$CurrentPoint.y] = '@'};$CurrentPoint.x = $CurrentPoint.x-1 } }
        '<' { $TestMove = Get-NextDotPoint -Start $CurrentPoint -Direction Left; if ( $TestMove -is [object] ) { if ($TestMove.isBox -eq $True) {$Map[$TestMove.x][$TestMove.y] = 'O';$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x][$CurrentPoint.y-1] = '@'} else {$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x][$CurrentPoint.y-1] = '@'};$CurrentPoint.y = $CurrentPoint.y-1 } }
        '>' { $TestMove = Get-NextDotPoint -Start $CurrentPoint -Direction Right; if ( $TestMove -is [object] ) { if ($TestMove.isBox -eq $True) {$Map[$TestMove.x][$TestMove.y] = 'O';$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x][$CurrentPoint.y+1] = '@'} else {$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x][$CurrentPoint.y+1] = '@'};$CurrentPoint.y = $CurrentPoint.y+1 }}
        'v' { $TestMove = Get-NextDotPoint -Start $CurrentPoint -Direction Down; if ( $TestMove -is [object] ) { if ($TestMove.isBox -eq $True) {$Map[$TestMove.x][$TestMove.y] = 'O';$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x+1][$CurrentPoint.y] = '@'} else {$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$CurrentPoint.x+1][$CurrentPoint.y] = '@'};$CurrentPoint.x = $CurrentPoint.x+1 }}
    }
}

$Map | foreach {$_ -join ''}


$Boxes = 0..$MaxX | foreach {
    $x = $_; 0..$MaxY | foreach { 
        $y = $_; if ($Map[$x][$y] -eq 'O') { 
            new-object -type PSCustomObject -Property @{StartPoint=$Map[$x][$y]; x=$x; y=$y }
            #break
        }
    }
}

($Boxes | Select-Object -Property *,@{N='GPS';E={(100*$_.x)+$_.y}} | Measure-Object -Property GPS -Sum).sum

#$NextPoint = new-object -Property @{x=$CurrentPoint.x-1; y=$CurrentPoint.y} -TypeName PSCustomObject; if ($Map[$NextPoint.x][$NextPoint.y] -eq '.') {$Map[$CurrentPoint.x][$CurrentPoint.y] = '.'; $Map[$NextPoint.x][$NextPoint.y] = '@'}

#Answer
#1514333