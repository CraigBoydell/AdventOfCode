function Test-NoDecrease {
  param($ToTest)
  $ToTest = $ToTest.ToString()
  1..5 | ForEach-Object {if ($ToTest[$_] -ge $ToTest[$_-1]) {}else {$false}  } | select-object -unique
}
  
#77 Seconds
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

#8 Seconds
$Doubles = $(246515..739105 | Select-String -Pattern '(.)\1' -AllMatches).line
$Pattern = '(?:0(?=[0-9])|1(?=[1-9])|2(?=[2-9])|3(?=[3-9])|4(?=[4-9])|5(?=[5-9])|6(?=[6-9])|7(?=[7-9])|8(?=[8-9])|9(?=9)){5}(?:0(?<=[0-9])|1(?<=[1-9])|2(?<=[2-9])|3(?<=[3-9])|4(?<=[4-9])|5(?<=[5-9])|6(?<=[6-9])|7(?<=[7-9])|8(?<=[8-9])|9(?<=9))+'
$Valid = ($Doubles | Select-String -Pattern $Pattern -AllMatches).line
$Valid.count

$WithGroups = $Valid | Select-String -Pattern '(.)\1{2,5}' -AllMatches
$WithDoublesNotGroups = $WithGroups | ForEach-Object {$Line = $_.Line; $_.Matches.Value | ForEach-Object {$Line = $Line.Replace($_,'')}; if ($($Line |select-string -Pattern '(.)\1')) {$_.line}}
$WithoutGroups = $Valid | Select-String -Pattern '(.)\1{2,5}' -NotMatch
$WithDoublesNotGroups.Count + $WithoutGroups.Count

#Alternative
$ResultsRegex = $Valid | Select-String -Pattern '(.)\1{2,5}|(.)\2' -AllMatches
($resultsregex | Where-Object { ($_.matches.Groups | select-object -Expandproperty Length) -like 2}).count