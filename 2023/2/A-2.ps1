$Source = Get-Content .\ex.txt -Raw

$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")


$GameCard = $SourceSplit | Select-Object -Property @{N='GameIndex';E={$_.Split(':')[0].trim().replace('Game ','')}},@{N='Rounds';E={$_.Split(':')[1].trim() -split "; "}}

$RedMax = 12; $GreenMax = 13; $BlueMax = 14
#$GameCard[0].rounds = $GameCard[0].rounds | foreach {$_ -split ", " | select-object @{N='Number';E={($_ -split " ")[0]}},@{N='Colour';E={($_ -split " ")[1]}}}

for ($i=0;$i -lt $GameCard.count;$i++) {
    $GameCard[$i].rounds = $GameCard[$i].rounds | foreach {
      $_ -split ", " | select-object @{N='Number';E={($_ -split " ")[0]}},@{N='Colour';E={($_ -split " ")[1]}}
    }
}

$GameCard.rounds | foreach {$_.number = $_.number.toint32($null)}

$GameCard= $GameCard | Select-Object -Property *,@{N='Reqs';E={$_.rounds | Group-Object -Property Colour | Select-Object -Property Name, @{N='MaxNeeded';E={$_.Group | Sort-Object -Property Number -Descending | Select-Object -first 1 -ExpandProperty number}} }}


($GameCard | foreach { Invoke-Expression -Command $($_.Reqs.maxneeded -join '*') } | Measure-Object -Sum).sum

#Answer:
#71036