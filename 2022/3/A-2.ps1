#Example:
$i = @'
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
'@
$i = ($i -split "`n")

$i = Get-Content .\I.txt

#0..$($bp.r.length-1) | foreach-object {$bp.r[$_]} | Sort-Object | Select-Object -Unique

$Tracker=0; $(do {(compare-object (compare-object (0..$($i[$Tracker].length-1) | foreach-object {$i[$Tracker][$_]} | Sort-Object | Select-Object -Unique) (0..$($i[$Tracker+1].length-1) | foreach-object {$i[$Tracker+1][$_]} | Sort-Object | Select-Object -Unique) -ExcludeDifferent -IncludeEqual).inputObject (0..$($i[$Tracker+2].length-1) | foreach-object {$i[$Tracker+2][$_]} | Sort-Object | Select-Object -Unique) -IncludeEqual -ExcludeDifferent).inputObject; $Tracker = $Tracker+3} until ($Tracker -ge $i.count) ) | select-object -Property @{N='priValue';E={$char=$_; if ([byte][char]$char -le 90) {[byte][char]$char -38} else {[byte][char]$char -96}}} -ExcludeProperty priValue | measure-object -Property priValue -sum