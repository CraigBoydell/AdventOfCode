$NumberString = @(
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
)
$NumberString = get-content '.\I.txt'
$NumberString = $NumberString | foreach-object {[int64]$_}
$NumberToMatch = '20874512'
#$NumberToMatch = '127'
$Location = 0
do {
  $Results = New-Object -TypeName "System.Collections.ArrayList"
  $i = 0
  do {
    $SumFound = $False
    $Bust = $false
    $Results.add($NumberString[$Location + $i]) | out-null
    switch (($Results | Measure-Object -sum).sum) {
      {$_ -eq $NumberToMatch} {$SumFound = $True}
      {$_ -gt $NumberToMatch} {$Bust = $True}
    }
    $i++
  } until ($SumFound -or $Bust)
  if ($Bust) {$Location++}
} until ($SumFound -eq $TRUE)

(($Results | Sort-Object | Select-Object -first 1 -last 1)| Measure-Object -Sum).sum