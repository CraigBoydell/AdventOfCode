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