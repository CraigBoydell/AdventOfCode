$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$l1 = New-Object System.Collections.Generic.List[System.Object]
$l2 = New-Object System.Collections.Generic.List[System.Object]

$SourceSplit | foreach { $s = $_ -split '   '; $l1.add([int]$s[0]); $l2.add([int]$s[1])}

$i = 0; $Lists = do {New-Object -TypeName PSCustomObject -Property @{'L1'=$l1[$i]; 'L2'=$L2[$i]}; $i++ } until ($i -eq $l1.count)

$Lists = $Lists | Select-Object -Property *,@{N='SimScore';E={ $ToCheck = $_.L1; $($Lists.L2 | where {$_ -eq $ToCheck}   ).count * $ToCheck }  }

($Lists | Measure-Object -Property SimScore -sum).sum

#Answer
#21142653