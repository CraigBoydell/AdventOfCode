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

$GameCard = $GameCard | Select-Object -Property *,@{N='Combined';E={ $GameIndex = $_.GameIndex; $_.Rounds | Select-Object -Property @{N='GameIndex';E={$GameIndex}},*  }}

$GameCardWPossible = $GameCard.combined | Select-Object -Property *, @{N='Possible';E={ $_.Number.toint32($null) -le $(get-variable -Name ($_.Colour + 'Max')).value  } }

$GameCard | where {$_.GameIndex -notin ($GameCardWPossible | where {$_.Possible -eq $False}).GameIndex} | Measure-Object -Sum -Property GameIndex

#Answer:
#2204