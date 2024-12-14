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

$JustFileBlocks = New-Object System.Collections.Generic.List[System.Object]

$DiskMap | where {$_ -ne '.'} | foreach {$JustFileBlocks.add($_) | out-null}

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

#Answer
#6386640365805