$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$AllGames = $SourceSplit | Select-Object -Property @{N='Input';E={$_}},@{N='Card';E={$_.split(':')[0].split(' ')[1].trim().toint32($null)}},@{N='WinNums';E={$_.Split(':')[1].replace("  "," ").split('|')[0].trim().split(" ")}},@{N='MyNums';E={$_.Split(':')[1].replace("  "," ").split('|')[1].trim().split(" ")}}
$AllGames = $AllGames | Select-Object -Property *,@{N='MatchingNum';E={Compare-Object -ReferenceObject $_.WinNums -DifferenceObject $_.MyNums -IncludeEqual | where {$_.SideIndicator -eq '=='}}} -ExcludeProperty MatchingNum
$AllGames = $AllGames | Select-Object -Property *,@{N='CardValue';E={if ($_.MatchingNum) {[math]::pow(2,@($_.MatchingNum).count -1)}}}

$AllGames = $AllGames | Select-Object -Property *,@{N='PlayCount';E={1}}
for ($i=0;$i -lt $AllGames.Count;$i++) {
  for ($PlayCount=0; $PlayCount -lt $AllGames[$i].PlayCount; $PlayCount++) {
    for ($y=1;$y -le @($AllGames[$i].MatchingNum).count;$y++) {
      $AllGames[$i+$y].PlayCount++
    }
  }
}

($AllGames | Measure-Object -Property PlayCount -sum).sum

# Answer:
# 6189740