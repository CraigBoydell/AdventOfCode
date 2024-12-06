$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map.add($_.trim().Tochararray())}

$MaxX = $Map.count-1
$MaxY = $Map[0].count-1

$StartFound = $false
$i = 0
do { 
  $StartY = ($Map[$i] -join '').indexof('^')
  if ($StartY -ge 0) {
    $StartFound = $True
    $StartX = $i
    #$PtrY = $StartY
  }
  $i++ 
} while ($StartFound -eq $false)


$LoopTracker = New-Object System.Collections.Generic.List[System.Object]



0..$MaxX | foreach {

    #$NewX = 6
      $NewX = $_
      $('NewX: ' + $NewX)
      0..$MaxY | foreach {
    #$NewY = 3
      $NewY = $_
      #$('NewY: ' + $NewY)
      #$([string]$NewX + ',' + $NewY)
      #$Map[$NewX][$NewY]
    if ( $Map[$NewX][$NewY] -eq '.' ) {
    write-host ([string]$NewX +','+ $newY)
    $Map[$NewX][$NewY] = 'O'

    $PtrX = $StartX
    $PtrY = $StartY

$d = @('U','R','D','L')
$dint = 0

$PathTracker = New-Object System.Collections.Generic.List[System.Object]


$PathTracker.add([string]$PtrX +','+$PtrY)


$newObjHitCount = 0

Do {
  #write-host $d[$dint]  
  if ($d[$dint] -eq 'U') {
    if ($Map[$PtrX-1][$PtrY] -notin @('#','O')) {$PtrX--; $PathTracker.add([string]$PtrX +','+$PtrY)} else { if ($Map[$PtrX-1][$PtrY] -eq 'O'){$newObjHitCount++};  $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
  if ($d[$dint] -eq 'D') {
    if ($Map[$PtrX+1][$PtrY] -notin @('#','O')) {$PtrX++; $PathTracker.add([string]$PtrX +','+$PtrY)} else { if ($Map[$PtrX+1][$PtrY] -eq 'O'){$newObjHitCount++}; $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
  if ($d[$dint] -eq 'R') {
    if ($Map[$PtrX][$PtrY+1] -notin @('#','O')) {$PtrY++; $PathTracker.add([string]$PtrX +','+$PtrY)} else { if ($Map[$PtrX][$PtrY+1] -eq 'O'){$newObjHitCount++}; $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
  if ($d[$dint] -eq 'L') {
    if ($Map[$PtrX][$PtrY-1] -notin @('#','O')) {$PtrY--; $PathTracker.add([string]$PtrX +','+$PtrY)} else { if ($Map[$PtrX][$PtrY-1] -eq 'O'){$newObjHitCount++}; $dint++; if ($dint -ge 4) {$dint = 0}  }
  }
} until (  $PtrX -ge $MaxX -or $PtrY -ge $MaxY -or $PtrX -lt 0 -or $PtrY -lt 0 -or $newObjHitCount -gt 10 -or $PathTracker.count -gt 100000)

#($Pathtracker | Group-Object | Sort-Object -Property Count -Descending)[0].count -gt 100

#($PathTracker | Select-Object -Unique).count

  if ($newObjHitCount -gt 10 -or $PathTracker.count -gt 100000) {
    $LoopTracker.add([string]$NewX +','+$NewY)
  }

  $Map[$NewX][$NewY] = '.'

}

}
}

$LoopTracker.count

#Answer
#1984