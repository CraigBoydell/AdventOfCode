#Example: 
$i = @'
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
'@

$i = $i -split "`n"

$i = get-content I.txt


Function Test-BoardRows {
    param (
        $Board,
        $ColCount = 5
    )
    $Bingo = $false
    foreach ($row in $board) {
        if ( ($row | select-string -pattern '\*' -AllMatches).matches.count -eq $ColCount) {
            $Bingo = $true
            Break
        }
    }
    <#
    if ($Bingo) {
        $Row.replace('*','') -split ','
    }
    #>
    $Bingo
}

Function Test-BoardCols {
    param (
        $Board,
        $ColCount = 5
    )
    $Bingo = $false
    for ($i=0;$i -lt $ColCount; $i++) {
      $Col = ($Board | foreach-object { ($_ -split ',')[$i]  }) -join ','
      if ( ($Col | select-string -pattern '\*' -AllMatches).matches.count -eq $ColCount) {
        $Bingo = $true
        Break
      }
    }
    $Bingo
}

Function Get-BoardCount {
    param (
        $Board
    )

    ($Board | foreach-object { $_ -split ','  } | where-object {$_ -notmatch ".\*" } | Measure-Object -Sum).sum
}





$seq = $i[0]
$Seq = $seq -split ',' #| foreach { if ([int]$_ -lt 10) { ' ' + $_ } else {$_} }

$Boards = New-Object -TypeName "System.Collections.ArrayList"

for ($n=2; $n -lt $i.count; $n = $n + 6) {
    $Boards.add($i[$n..$($n+4)]) | out-null
}

$ModBoards = New-Object -TypeName "System.Collections.ArrayList"
foreach ($Board in $Boards ) {
    $ModBoards.add( $($Board | foreach-object {($($($_) -split '\s\s|\s') | where-object {$_ -ne ''} ) -join ','}) )  | Out-Null
}

$Bingo = $false

foreach ($num in $seq) {
    for ($b=0;$b -lt $ModBoards.count;$b++) {
        $Modboards[$b] = $ModBoards[$b] | foreach-object {
            $($_ -split ',' | foreach-object { 
                if ($_ -eq $num) {$_ +'*'} else {$_} }
            ) -join ',' 
        }
        if ((Test-BoardCols -Board $ModBoards[$b]) -eq $True -or (Test-BoardRows -Board $ModBoards[$b]) -eq $True ) {
            $Bingo = $True
            $GameResult = @{
                'Board' = $ModBoards[$b]
                'BoardNumber' = $b
                'LastNumber' = $num
                'UnmarkedSum' = $(Get-BoardCount -Board $ModBoards[$b])
            }
            break
        }
    }
    if ($Bingo) {
        $GameResult
        [int]$GameResult.LastNumber * [int]$GameResult.UnmarkedSum
        Break
    }
}