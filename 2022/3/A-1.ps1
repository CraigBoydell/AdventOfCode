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

$BPs = $i | foreach-object {
  $HT = @{L=$_.substring(0,($_.length)/2);R=$_.substring($($_.length)/2,$($_.length)/2)}
  New-Object -Property $HT -TypeName PSCustomObject
}

#0..$($bp.r.length-1) | foreach-object {$bp.r[$_]} | Sort-Object | Select-Object -Unique
$BPs = $BPs | Select-Object -Property *,@{N='inBoth';E={$BPItem=$_;(Compare-Object $(0..$($bpItem.r.length-1) | foreach-object {$bpItem.r[$_]} | Sort-Object | Select-Object -Unique) $(0..$($bpItem.l.length-1) | foreach-object {$bpItem.l[$_]} | Sort-Object | Select-Object -Unique) -ExcludeDifferent -IncludeEqual).inputobject}}
$BPs = $BPs | select-object -Property *,@{N='priValue';E={$char=$_.inBoth; if ([byte][char]$char -le 90) {[byte][char]$char -38} else {[byte][char]$char -96}}} -ExcludeProperty priValue
($BPs | measure-object -Property priValue -sum).sum
