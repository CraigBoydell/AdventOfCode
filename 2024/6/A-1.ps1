$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map.add($_.Tochararray())}

$MaxX = $Map.count-1
$MaxY = $Map[0].count-1

$StartFound = $false
$i = 0
do { 
  $StartY = ($Map[$i] -join '').indexof('^')
  if ($StartY -ge 0) {
    $StartFound = $True
    $PtrX = $i
    $PtrY = $StartY
  }
  $i++ 
} while ($StartFound -eq $false)

$d = @('U','R','D','L')
$dint = 0

$PathTracker = New-Object System.Collections.Generic.List[System.Object]

$PathTracker.add([string]$PtrX +','+$PtrY)

Do {
  #write-host $d[$dint]  
  if ($d[$dint] -eq 'U') {
    if ($Map[$PtrX-1][$PtrY] -ne '#') {$PtrX--; $PathTracker.add([string]$PtrX +','+$PtrY)} else { $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
  if ($d[$dint] -eq 'D') {
    if ($Map[$PtrX+1][$PtrY] -ne '#') {$PtrX++; $PathTracker.add([string]$PtrX +','+$PtrY)} else { $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
  if ($d[$dint] -eq 'R') {
    if ($Map[$PtrX][$PtrY+1] -ne '#') {$PtrY++; $PathTracker.add([string]$PtrX +','+$PtrY)} else { $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
  if ($d[$dint] -eq 'L') {
    if ($Map[$PtrX][$PtrY-1] -ne '#') {$PtrY--; $PathTracker.add([string]$PtrX +','+$PtrY)} else { $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
} until (  $PtrX -ge $MaxX -or $PtrY -ge $MaxY -or $PtrX -lt 0 -or $PtrY -lt 0  )

($PathTracker | Select-Object -Unique).count

#Answer
#5404