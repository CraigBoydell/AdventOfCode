$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = ($Source.trim() -split '') | where {$_ -ne ''} | foreach {[int]$_}

$i = 0
$diskMap = New-Object System.Collections.Generic.List[System.Object]
$FileID = 0
$isSpace = $false

$sourceSplit | foreach {
    #$Block = [int]$_.tostring()
    $Block = $_
    #write-host $isSpace
    if ($isSpace -eq $False) {
        #write-host 'Space is false'
        1..($Block) | foreach {$diskMap.add($FileID) | out-null}
        $FileID++
    } 
    if ($isSpace -eq $True) {
        #write-host 'Space is true'
        if ($Block -ne 0) {
          1..($Block) | foreach {$diskMap.add('.') | out-null}
        }
    }
    $i++
    if ($isSpace -eq $False) {$isSpace = $True} else {$isSpace = $False}
}
$DiskMap -join ''
<#
$y = -1
while (@($DiskMap[($DiskMap.IndexOf('.'))..($DiskMap.count)] | where {$_ -ne '.'}).count -ne 0){
    #$DiskMap[($DiskMap.IndexOf('.'))..($DiskMap.count)]
$FirstSpace = $DiskMap.IndexOf('.')
while ($DiskMap[$y] -eq '.') { $y--}
if ($FirstSpace -ge 0) {
    $BlockToMove = $DiskMap[$y]
    $DiskMap[$y] = '.'
    $DiskMap[$FirstSpace] = $BlockToMove
}

$DiskMap -join ''
}

#>



#build New Map
$TotalFileBlocks = ($DiskMap | where {$_ -ne '.'}).count
#$TotalFileBlocks; ($DiskMap | where {$_ -ne '.'}).count

#$JustFileBlocks = New-Object System.Collections.Generic.List[System.Object]
#$DiskMap | where {$_ -ne '.'} | foreach {$JustFileBlocks.add($_) | out-null}

$Grouped = $DiskMap | group-object | where {$_.Name -ne '.'} | sort-object -Property {[int]$_.Name} -Descending

$Count = 0
$Grouped | foreach {
  $ToCheck = $_
  write-progress -Activity $ToCheck.Name -PercentComplete $([math]::Round(($Count / $Grouped.Count) *100,2))
  $SpaceReq = ''
  while ($SpaceReq.length -lt $ToCheck.count) {$SpaceReq = $SpaceReq + '.'}
  #$SearchDiskMapSpace = ($DiskMap -join '').IndexOf($SpaceReq)
  $SearchDiskMapSpace = (($DiskMap | foreach { $_.tostring().substring(0,1) }) -join '').IndexOf($SpaceReq)
  #$SearchDiskMapSpace
  $SearchDiskMapFile = $DiskMap.IndexOf([int]$ToCheck.Name)
  if ($SearchDiskMapSpace -ge 0 -and $SearchDiskMapSpace -lt $SearchDiskMapFile) {
    $ToCheck.Group | foreach {
        $DiskMap[$SearchDiskMapSpace] = $_; $SearchDiskMapSpace++; $DiskMap[$SearchDiskMapFile] = '.'; $SearchDiskMapFile++
    }  
  }
  #$DiskMap -join ''
  $count++
}

$i = 0; ($DiskMap | foreach { if ($DiskMap[$i] -ne '.') {$DiskMap[$i] * $i}; $i++  } | measure-object -Sum).sum

<#
$NewMap = New-Object System.Collections.Generic.List[System.Object]

$i = 0
0..($TotalFileBlocks-1) | foreach {
    if ($DiskMap[$i] -ne '.' ) {
        $NewMap.add($DiskMap[$i]) | out-null
    } else {
        $NewMap.add($JustFileBlocks[-1]) | out-null
        $JustFileBlocks.Remove($JustFileBlocks[-1]) | out-null
    }
    $i++
}

#while ($NewMap.count -ne $DiskMap.count) { $NewMap.add('.')  }

#Computer Answer
$i = 0; ($NewMap | foreach { if ($NewMap[$i] -ne '.') {$NewMap[$i] * $i}; $i++  } | measure-object -Sum).sum

$i = 0; ($NewMap | foreach { $NewMap[$i] * $i; $i++  } | measure-object -Sum).sum

#$i = 0; $NewMap | foreach { new-object -Property @{ MapLoc = $NewMap[$i]; i = $i; check = $NewMap[$i] * $i} -type PSCustomObject ; $i++  }
#>

#Answer
#6386640365805