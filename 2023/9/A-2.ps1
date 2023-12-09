$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$RunningTotal = 0

$SourceSplit | foreach {

  $Reading = $_
  $Numbers = $Reading.trim() -split ' ' | foreach {$_.ToInt64($null)}


  $Results = New-Object System.Collections.Generic.List[System.Object]
  $Results.add($Numbers.clone()) | out-null

  Do {
    $Results.Add($(for ($i = 0; $i -lt $Results[-1].count-1; $i++ ) {
      $Results[-1][$i+1] - $Results[-1][$i]
    }))

  #} until (($ToTest | select-object -Unique) -eq 0)
  } until (($Results[-1] | select-object -Unique) -eq 0)

  $numberToAdd = 0; for ($i = $Results.count-2; $i -ne -1; $i--){
    $NumberToAdd = $Results[$i][0] - $NumberToAdd
    #$NumberToAdd
  }

  $RunningTotal = $RunningTotal + $NumberToAdd
}

$RunningTotal

# Answer:
# 1089