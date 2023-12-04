$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$AllGames = $SourceSplit | Select-Object -Property @{N='Input';E={$_}},@{N='Card';E={$_.split(':')[0].split(' ')[1].trim().toint32($null)}},@{N='WinNums';E={$_.Split(':')[1].replace("  "," ").split('|')[0].trim().split(" ")}},@{N='MyNums';E={$_.Split(':')[1].replace("  "," ").split('|')[1].trim().split(" ")}}
$AllGames = $AllGames | Select-Object -Property *,@{N='MatchingNum';E={Compare-Object -ReferenceObject $_.WinNums -DifferenceObject $_.MyNums -IncludeEqual | where {$_.SideIndicator -eq '=='}}} -ExcludeProperty MatchingNum
$AllGames = $AllGames | Select-Object -Property *,@{N='CardValue';E={if ($_.MatchingNum) {[math]::pow(2,@($_.MatchingNum).count -1)}}}

$AllGames | Measure-Object -Property CardValue -sum

# Answer:
# 15205