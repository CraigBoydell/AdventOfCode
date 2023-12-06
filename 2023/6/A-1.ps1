$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Test = @($SourceSplit[0] | Select-Object -Property @{N='Time';E={$_.replace('Time:','').trim().split(' ') | where {[string]::isnullorempty($_) -eq $false}}}; $SourceSplit[1] | Select-Object -Property @{N='Distance';E={$_.replace('Distance:','').trim().split(' ') | where {[string]::isnullorempty($_) -eq $false}}})

$RaceCard = for ($i=0;$i -lt $Test.Time.count-1; $i++) {New-Object -type PSCustomObject -Property $([ordered]@{Time=$Test.Time[$i];Distance=$Test.Distance[$i+1]})}

$RaceCard = $RaceCard | Select-Object -Property *,@{N='PossibleDistances';E={$Time= $_.Time; $MaxTimeHeld=[math]::Floor($($_.Time)/2);  0..$MaxTimeHeld | Select-Object -Property @{N='TimeHeld';E={$_}},@{N='TotalDistance';E={($Time - $_) * $_}}  }}

$Test = $RaceCard | Select-Object *,@{N='PossibleBeatHoldTimes';E={$Distance = $_.Distance;$_.PossibleDistances | where {$_.TotalDistance -gt $Distance}}}
invoke-expression ($($Test | foreach { if ($_.Time%2 -eq 0) {($_.possibleBeatHoldTimes.count * 2) -1} else { $_.possibleBeatHoldTimes.count * 2}}) -join '*')