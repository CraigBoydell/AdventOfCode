$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Assess = $SourceSplit | Select-Object -Property @{N='Readings';E={$_}},@{N='Levels';E={$Split = $_ -split ' '; $i = 0; while ( $i -lt $Split.count-1 ) { $Split[$i+1] - $Split[$i]; $i++  }}} | Select-Object -Property *,@{N='Safe';E={ $($($_.Levels | where-object {$_ -lt 0}).count -eq $_.Levels.count -or $($_.Levels | where-object {$_ -gt 0}).count -eq $_.Levels.count) -and @($_.levels | where-object {$_ -notin @(-1, -2, -3, 1, 2, 3)}).count -eq 0  }},@{N='LevelCount';E={$_.levels | where {$_ -notin @(-1, -2, -3, 1, 2, 3)} }}
$test = $Assess | where-object {$_.Safe -eq $false -and ($_.Readings -split ' ').count-1 -eq $_.Levels.count }

$Assess2 = $Test | foreach-object {
  $SplitSource = $_.Readings -split ' '
  $i=0; do {$NewReadings = (0..$($SplitSource.count-1) | foreach-object { if ($i -ne $_) {$SplitSource[$_]}}) -join ' ' | Select-Object -Property @{N='Readings';E={$_}},@{N='Levels';E={$Split = $_ -split ' '; $i = 0; while ( $i -lt $Split.count-1 ) { $Split[$i+1] - $Split[$i]; $i++  }}} | Select-Object -Property *,@{N='Safe';E={ $($($_.Levels | where-object {$_ -lt 0}).count -eq $_.Levels.count -or $($_.Levels | where-object {$_ -gt 0}).count -eq $_.Levels.count) -and @($_.levels | where {$_ -notin @(-1, -2, -3, 1, 2, 3)}).count -eq 0  }},@{N='LevelCount';E={$_.levels | where {$_ -notin @(-1, -2, -3, 1, 2, 3)} }} ; $i++ } until ($i -ge $SplitSource.count -or $NewReadings.Safe -eq $true)
  if ($NewReadings.Safe) {$NewReadings}
}

@($Assess | where-object {$_.Safe -eq $True}).count + @($Assess2 | where-object {$_.Safe -eq $True}).count

#Answer
#544