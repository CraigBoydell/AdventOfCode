#Example: 
$i = @'
2199943210
3987894921
9856789892
8767896789
9899965678
'@

#$i = get-content I.txt -raw
$i = $i -replace '[012345678]','X'
$i = $i -split "`n"

#$i

$T =  New-Object 'object[]' $i.count

for ($int = 0; $int -lt $i.count;$int++) {
  $T[$int] = $i[$int] -split "" | where-object {$_ -ne "" -and $_ -ne $null}
}

<#
$Surroundings = New-Object -TypeName "System.Collections.ArrayList"

for ($y=0;$y -lt $t.Count; $y++) {
  $Row = $T[$y]
  $Surrounding = for ($x=0;$x -lt ($Row.count -1);$x++ ) {$Number = $T[$y][$x]; $Number | Select-Object -Property @{N='Number';E={$_}},@{N='Surrounding';E={ @(try{if (($x-1) -ge 0) {$T[$y][$x-1]} else {$null}} catch {$null}; try{$T[$y][$x+1]}catch{$null};try{$T[$y+1][$x]}catch{$null};Try{if (($y-1) -ge 0) {$T[$y-1][$x]} else {$null}}catch{$null}) }}  }
  $Surrounding
  $Surroundings.add($Surrounding) | out-null
}
#>

$Surroundings = for ($y=0;$y -lt $t.Count; $y++) {
  $Row = $T[$y]
  for ($x=0;$x -le $Row.count;$x++ ) {$Number = $T[$y][$x]; $Number | Select-Object -Property @{N='Number';E={$_}},@{N='Surrounding';E={ @(try{if (($x-1) -ge 0) {$T[$y][$x-1]} else {'x'}} catch {'x'}; try{if (($x+1) -lt ($Row.count-1)) {$T[$y][$x+1]} else {'x'}}catch{'x'};try{$T[$y+1][$x]}catch{'x'};Try{if (($y-1) -ge 0) {$T[$y-1][$x]} else {'x'}}catch{'x'}) }}  }
}
  

#$Surroundings

$Surroundings = $Surroundings | Select-Object -Property *,@{N='isLowest';E={$ToTest = $_;@($ToTest.surrounding | where-Object {$_ -le $Totest.Number -and $_ -ne 'x'}).count -eq 0}}
#$Surroundings

$LowestNumbers =  $Surroundings | where-object {$_.isLowest -eq $True}

#$LowestNumbers

#$LowestNumbers | foreach-object {[int]$_.Number + 1}

($LowestNumbers | measure-object -Property Number -sum).sum + $LowestNumbers.Count
