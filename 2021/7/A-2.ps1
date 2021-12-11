Function Test-FuelPlan {
  param (
    $AimLine
  )

  $FuelPlan = $i | select-object -Property @{N='Current';e={$_}},@{N='Target';E={$AimLine}},@{N='FuelRequired';E={$Steps = [math]::Abs($_ - $AimLine); $($Steps/2 * (1+$Steps))}}
  ($FuelPlan | Measure-Object -Property FuelRequired -sum).sum
}

#Example: 
$i = '16,1,2,0,4,2,7,1,2,14'

$i = get-content I.txt -raw
$i = $i -split ','
$i = [int[]]($i)

$Sorted = $i | sort-object
$Middle = $i.length /2
$AimLine = if ($middle /2 -eq 0) {$Sorted[$middle-1]} else {($Sorted[$middle-1] + $Sorted[$($middle)])/2}

$Found = $False
do {
  $CurrentCheck = Test-FuelPlan -AimLine $AimLine
  switch ($CurrentCheck) {
    {$(Test-FuelPlan -AimLine ($AimLine-1)) -lt $CurrentCheck} {$AimLine = $AimLine - 1}
    {$(Test-FuelPlan -AimLine ($AimLine+1)) -lt $CurrentCheck} {$AimLine = $AimLine + 1}
    default {$Found = $True}
  }
} until ( $Found -eq $True )

$CurrentCheck
