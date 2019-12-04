Function CalcFuel {
  param( $intFuel )

  $ToReturn = [math]::floor($intFuel / 3) -2
  if ($ToReturn -lt 0) {$ToReturn = 0}
  $ToReturn

}

$intArray | select-object -First 1 | foreach { $Result = CalcFuel -intFuel $_; $Result; do { $Result = CalcFuel -intFuel $Result; $Result} until ($Result -eq 0) }