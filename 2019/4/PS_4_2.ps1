function Test-NoDecrease {
  param($ToTest)
  $ToTest = $ToTest.ToString()
  1..5 | ForEach-Object {if ($ToTest[$_] -ge $ToTest[$_-1]) {}else {$false}  } | select-object -unique
}
  
#246515..739105
$Doubles = $(246515..739105 | Select-String -Pattern '(.)\1' -AllMatches).line
$Valid = $Doubles | ForEach-Object {
  $Pass = $_
  if ((Test-NoDecrease -ToTest $Pass) -ne $FALSE)
  {
      $Pass
  }
}
$Valid.count

$WithGroups = $Valid | Select-String -Pattern '(.)\1{2,5}' -AllMatches
$WithDoublesNotGroups = $WithGroups | ForEach-Object {$Line = $_.Line; $_.Matches.Value | ForEach-Object {$Line = $Line.Replace($_,'')}; if ($($Line |select-string -Pattern '(.)\1')) {$_.line}}
$WithoutGroups = $Valid | Select-String -Pattern '(.)\1{2,5}' -NotMatch
$WithDoublesNotGroups.Count + $WithoutGroups.Count