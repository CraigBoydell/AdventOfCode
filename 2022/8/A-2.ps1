#Example:
$i = @'
30373
25512
65332
33549
35390
'@

#$i = Get-Content .\I.txt -Raw

$Trees = $i.split("`r`n")| where {$_.trim() -ne '' }
$Trees = Get-Content .\I.txt

$ExtTreeCount = (($Trees[0].length + $Trees.count) *2)  -4

$TreeArr = New-Object -TypeName "System.Collections.ArrayList"
$Trees |foreach-object { $TreeArr.add($_.trim().tochararray()) | out-null   }

#$TreeArr[1][1]

$Results = for ($c=1; $c -lt ($Trees.count-1); $c++) {
  #write-host $c
  for ($r = 1; $r -lt $($Trees[0].length)-1; $r++) {
    #write-host $("`t" + $r)
    write-progress -Activity $([string]$c + ':' + $r)
    $TreeSize = $TreeArr[$c][$r]
    #write-host $("`t`t" + $Treesize)
    $m=0
    $visibleUp = $true
    while (($c - $m) -gt 0 -and $VisibleUp -eq $true) {
      $m++
      if ( $TreeArr[$c-$m][$r] -ge $treeSize  ) {
        $VisibleUp = $false
        #write-host $([string]$($c-$m) + ':' + $r + '-Up-' + $treeSize + '>' + $TreeArr[$c-$m][$r] + ':' + $false)
      } else {
        #write-host $([string]$($c-$m) + ':' + $r + '-Up-' + $treeSize + '>' + $TreeArr[$c-$m][$r] + ':' + $true)
      }
    }
    $ViewCountUp = $m
    $m=0
    $visibleDown = $true
    while (($c + $m) -lt $($Trees.count-1) -and $VisibleDown -eq $true) {
      $m++
      if ( $TreeArr[$c+$m][$r] -ge $treeSize  ) {
        $VisibleDown = $false
        #write-host $([string]$($c+$m) + ':' + $r + '-Down-' + $treeSize + '>' + $TreeArr[$c+$m][$r] + ':' + $false)
      } else {
        #write-host $([string]$($c+$m) + ':' + $r + '-Down-' + $treeSize + '>' + $TreeArr[$c+$m][$r] + ':' + $true)
      }
    }
    $ViewCountDown = $m
    $m=0
    $visibleLeft = $true
    while (($r - $m) -gt 0 -and $VisibleLeft -eq $true) {
      $m++
      if ( $TreeArr[$c][$r-$m] -ge $treeSize  ) {
        $VisibleLeft = $false
        #write-host $([string]$($c) + ':' + ($r-$m) + '-Left-' + $treeSize + '>' + $TreeArr[$c][$r-$m] + ':' + $false)
      } else {
        #write-host $([string]$($c) + ':' + ($r-$m) + '-Left-' + $treeSize + '>' + $TreeArr[$c][$r-$m] + ':'  + $true)
      }
    }
    $ViewCountLeft = $m
    $m=0
    $visibleRight = $true
    while (($r + $m) -lt $($Trees[0].Length-1) -and $VisibleRight -eq $true) {
      $m++
      if ( $TreeArr[$c][$r+$m] -ge $treeSize  ) {
        $VisibleRight = $false
        #write-host $([string]$($c) + ':' + ($r+$m) + '-Right-' + $treeSize + '>' + $TreeArr[$c][$r+$m] + ':'  + $false)
      } else {
        #write-host $([string]$($c) + ':' + ($r+$m) + '-Right-' + $treeSize + '>' + $TreeArr[$c][$r+$m] + ':'  + $true)
      }
    }
    $ViewCountRight = $m
    $HT = @{
      c = $c
      r = $r
      results = @( $visibleUp, $visibleDown, $visibleLeft, $visibleRight)
      ScenicValue = $($ViewCountUp * $ViewCountDown * $ViewCountLeft * $ViewCountRight)
      #down = $visibleDown
      #left = $visibleLeft
      #right = $visibleRight
    }
    New-Object -Property $HT -TypeName PSCustomObject
  }
}

#$Results |where {$_.results -contains $true}

#$intTreeCount = ($Results |where-object {$_.results -contains $true}).count

#$ExtTreeCount + $intTreeCount

$Results | Sort-Object -Property ScenicValue | select-object -last 1 -ExpandProperty ScenicValue