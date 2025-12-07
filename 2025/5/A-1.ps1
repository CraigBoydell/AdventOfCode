$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw


$Ranges = (($Source -split "`r`n`r`n")[0] -split "`r`n"); $ingredients =  (($Source -split "`r`n`r`n")[1] -split "`r`n") | foreach {[int64]$_}
$AllGood = $ranges | select-object -Property @{N='Min';E={[int64]($_ -split '-')[0]}},@{N='Max';E={[int64]($_ -split '-')[1]}}

$AllGood = $ingredients | where { $ToCheck = $_; $AllGood | where {$ToCheck -ge $_.Min -and $ToCheck -le $_.Max}}

#$AllGood = $Ranges | foreach { $($_ -split "-")[0]..$($_ -split "-")[1]  } | Select-Object -Unique

#$freshCount = $ingredients | where {$_ -in $AllGood}


#Answer
#638