
#Example: 
$i = '16,1,2,0,4,2,7,1,2,14'

$i = get-content I.txt -raw
$i = $i -split ','
$i = [int[]]($i)

$Sorted = $i | sort-object
$Middle = $i.length /2
$AimLine = if ($middle /2 -eq 0) {$Sorted[$middle-1]} else {($Sorted[$middle-1] + $Sorted[$($middle)])/2}
$FuelPlan = $i | select-object -Property @{N='Current';e={$_}},@{N='Target';E={$AimLine}},@{N='FuelRequired';E={[math]::Abs($_ - $AimLine)}}
($FuelPlan | Measure-Object -Property FuelRequired -sum).sum