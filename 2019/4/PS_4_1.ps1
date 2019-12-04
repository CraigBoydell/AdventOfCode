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