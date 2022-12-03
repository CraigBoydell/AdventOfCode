#Example:
$i = @'
A Y
B X
C Z
'@
#$i = ($i -split "`n")

$i = Get-Content .\I.txt -Raw
$Scores = "p1 p2`n" + $i | convertfrom-csv -Delimiter " "
$Scores | foreach-object { if ($_.p2 -eq 'X') { if ($_.p1 -eq 'A') {$_.p2 = 'C'}; if ($_.p1 -eq 'B') {$_.p2 = 'A'};if ($_.p1 -eq 'C') {$_.p2 = 'B'} };if ($_.p2 -eq 'Y') {$_.p2 = $_.p1};if ($_.p2 -eq 'Z') { if ($_.p1 -eq 'A') {$_.p2 = 'B'}; if ($_.p1 -eq 'B') {$_.p2 = 'C'};if ($_.p1 -eq 'C') {$_.p2 = 'A'} }   }
$($Scores | Select-Object *,@{N='Result';E={switch ($_.p1+$_.p2) {'AA' {3}; 'AB' {6}; 'AC' {0}; 'BA' {0}; 'BB' {3}; 'BC' {6}; 'CA' {6}; 'CB' {0}; 'CC' {3} }}},@{N='Bonus';E={switch($_.p2) {'A' {1}; 'B' {2}; 'C' {3}} }} | Select-Object -Property *,@{N='Total';E={$_.Result + $_.Bonus}} | Measure-Object -Property Total -sum).sum
