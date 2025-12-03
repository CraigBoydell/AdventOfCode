$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$l1 = New-Object System.Collections.Generic.List[System.Object]
$l2 = New-Object System.Collections.Generic.List[System.Object]

$SourceSplit | foreach { $s = $_ -split '   '; $l1.add([int]$s[0]); $l2.add([int]$s[1])}

$l1Sorted = $l1 | sort-object
$l2Sorted = $l2 | Sort-Object

$i = 0; $Sorted = do {New-Object -TypeName PSCustomObject -Property @{'L1'=$l1Sorted[$i]; 'L2'=$L2Sorted[$i]}; $i++ } until ($i -eq $l1Sorted.count)

$Sorted = $Sorted | Select-Object -Property *,@{N='Dist';E={[math]::abs($_.L1 - $_.L2)}}

($Sorted | Measure-Object -Property Dist -Sum).sum

#Answer
#1123