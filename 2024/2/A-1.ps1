$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")


$Assess = $SourceSplit | Select-Object -Property @{N='Readings';E={$_}},@{N='Levels';E={$Split = $_ -split ' '; $i = 0; while ( $i -lt $Split.count-1 ) { $Split[$i+1] - $Split[$i]; $i++  }}} | Select-Object -Property *,@{N='Safe';E={ $($($_.Levels | where {$_ -lt 0}).count -eq $_.Levels.count -or $($_.Levels | where {$_ -gt 0}).count -eq $_.Levels.count) -and @($_.levels | where {$_ -notin @(-1, -2, -3, 1, 2, 3)}).count -eq 0  }},@{N='LevelCount';E={$_.levels | where {$_ -notin @(-1, -2, -3, 1, 2, 3)} }}

($Assess | where {$_.Safe -eq $True}).count

#Answer
#502