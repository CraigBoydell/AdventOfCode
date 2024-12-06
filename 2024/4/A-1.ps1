$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map.add($_.Tochararray())}

$MaxX = $Map.count
$MaxY = $Map[0].count

$PtrX = 0
$PtrY = 0
$XmasCount = 0

$ErrorActionPreference = 'SilentlyContinue'

do {
    do {
        if ($Map[$PtrX][$PtrY] -eq 'X') { 
            write-host  $([string]$PtrX + ',' + $PtrY + ' : ' +  $Map[$PtrX][$PtrY])
            #Right
            if ($(1..3 | foreach { if ($PtrY+$_ -lt $MaxY) {$Map[$PtrX][$PtrY+$_]}  }  ) -join '' -eq 'MAS'  ) {'RXMAS'; $XmasCount++}
            #Left
            if ($(1..3 | foreach { if ($PtrY-$_ -ge 0) {$Map[$PtrX][$PtrY-$_]}  }  ) -join '' -eq 'MAS'  ) {'LXMAS'; $XmasCount++}
            #Up
            if ($(1..3 | foreach { if ($PtrX-$_ -ge 0) {$Map[$PtrX-$_][$PtrY]}  }  ) -join '' -eq 'MAS'  ) {'UXMAS'; $XmasCount++}
            #Down
            if ($(1..3 | foreach { if ($PtrX+$_ -lt $MaxX) {$Map[$PtrX+$_][$PtrY]}  }  ) -join '' -eq 'MAS'  ) {'DXMAS'; $XmasCount++}
            #Up_Right
            if ($(1..3 | foreach { if ($PtrX-$_ -ge 0 -and $PtrY+$_ -lt $MaxY) {$Map[$PtrX-$_][$PtrY+$_]}  }  ) -join '' -eq 'MAS'  ) {'URXMAS'; $XmasCount++}
            #Up_Left
            if ($(1..3 | foreach { if ($PtrX-$_ -ge 0 -and $PtrY-$_ -ge 0) {$Map[$PtrX-$_][$PtrY-$_]}  }  ) -join '' -eq 'MAS'  ) {'ULXMAS'; $XmasCount++}
            #Down_Right
            if ($(1..3 | foreach { if ($PtrX+$_ -lt $MaxX -and $PtrY+$_ -lt $MaxY) {$Map[$PtrX+$_][$PtrY+$_]}  }  ) -join '' -eq 'MAS'  ) {'DRXMAS'; $XmasCount++}
            #Down_Left
            if ($(1..3 | foreach { if ($PtrX+$_ -lt $MaxX -and $PtrY-$_ -ge 0) {$Map[$PtrX+$_][$PtrY-$_]}  }  ) -join '' -eq 'MAS'  ) {'DLXMAS'; $XmasCount++}
        }
        
        $PtrY++
    } while ($PtrY -lt $MaxY)
    $PtrY=0
    $PtrX++
} while ($PtrX -lt $MaxX)
$ErrorActionPreference = 'Continue'

$XmasCount

#Answer
#2496