$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$Ranges = $Source.split(',')
$Ranges = $Ranges | Select-Object -Property @{N='Start';E={$_.split('-')[0]}},@{N='End';E={$_.split('-')[1]}}
#$Ranges = $Ranges | Select-Object -Property *,@{N='Matches';E={([int64]$_.start)..([int64]$_.end) | foreach { $_ | Select-String -Pattern '^(\d+)\1$' -AllMatches}}  } -ExcludeProperty Matches
#Note PWSH Number..Number doesn't seem to support Int64

$Ranges = $Ranges | Select-Object -Property *,@{N='Matches';E={ for ($i=[int64]$_.Start; $i -lt [int64]$_.end; $i++) {$i | Select-String -Pattern '^(\d+)\1+$' -AllMatches}   }  } -ExcludeProperty Matches

#for ($i=[int64]$_.Start; $i -lt [int64]$_.end; $i++) {$i | Select-String -Pattern '^(\d+)\1$' -AllMatches}


$Ranges.Matches.matches | Measure-Object -Property Value -Sum

#Answer
#48631958998