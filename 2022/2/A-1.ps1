#Example:
$i = @'
A Y
B X
C Z
'@
#$i = ($i -split "`n")

#$i = Get-Content .\I.txt -Raw
$Scores = "p1 p2`n" + $i | convertfrom-csv -Delimiter " "
$($Scores | Select-Object *,@{N='Result';E={switch ($_.p1+$_.p2) {'AX' {3}; 'AY' {6}; 'AZ' {0}; 'BX' {0}; 'BY' {3}; 'BZ' {6}; 'CX' {6}; 'CY' {0}; 'CZ' {3} }}},@{N='Bonus';E={switch($_.p2) {'X' {1}; 'Y' {2}; 'Z' {3}} }} | Select-Object -Property *,@{N='Total';E={$_.Result + $_.Bonus}} | Measure-Object -Property Total -sum).sum
