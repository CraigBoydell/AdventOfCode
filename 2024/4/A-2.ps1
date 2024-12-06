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
        if ($Map[$PtrX][$PtrY] -eq 'A') { 
            write-host  $([string]$PtrX + ',' + $PtrY + ' : ' +  $Map[$PtrX][$PtrY])
            #ULeft-M and DRight-S and ( DLeft-M and URight-S or DLeft-S and URight-M ) 
            if ($PtrX-1 -ge 0 -and $PtrY-1 -ge 0) {if (($Map[$PtrX-1][$PtrY-1] -eq 'M' -and $Map[$PtrX+1][$PtrY+1] -eq 'S') -and (($Map[$PtrX+1][$PtrY-1] -eq 'M' -and $Map[$PtrX-1][$PtrY+1] -eq 'S') -or ($Map[$PtrX+1][$PtrY-1] -eq 'S' -and $Map[$PtrX-1][$PtrY+1] -eq 'M') ) ) {'UL-DR-MAS'; $XmasCount++}}
            #ULeft-S and DRight-M and ( DLeft-M and URight-S or DLeft-S and URight-M ) 
            if ($PtrX-1 -ge 0 -and $PtrY-1 -ge 0) {if (($Map[$PtrX-1][$PtrY-1] -eq 'S' -and $Map[$PtrX+1][$PtrY+1] -eq 'M' ) -and (($Map[$PtrX+1][$PtrY-1] -eq 'M' -and $Map[$PtrX-1][$PtrY+1] -eq 'S') -or ($Map[$PtrX+1][$PtrY-1] -eq 'S' -and $Map[$PtrX-1][$PtrY+1] -eq 'M') ) ) {'UL-DR-MAS'; $XmasCount++}}

        }
        
        $PtrY++
    } while ($PtrY -lt $MaxY)
    $PtrY=0
    $PtrX++
} while ($PtrX -lt $MaxX)
$ErrorActionPreference = 'Continue'

$XmasCount

#Answer
#1967