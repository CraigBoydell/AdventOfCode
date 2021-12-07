
#Example: 
$i = '3,4,3,1,2'
$i = get-content I.txt

$i = $i -split ','

$i | group-object | sort-object -Property Name

$Tracker =  New-Object 'object[]' 9
$Tracker[0] = 0
$Tracker[1] = 109
$Tracker[2] = 52
$Tracker[3] = 43
$Tracker[4] = 54
$Tracker[5] = 42
$Tracker[6] = 0
$Tracker[7] = 0
$Tracker[8] = 0

1..80 | foreach-object {

  $Labour = $Tracker[0]

  $Tracker[0] = $Tracker[1]
  $Tracker[1] = $Tracker[2]
  $Tracker[2] = $Tracker[3]
  $Tracker[3] = $Tracker[4]
  $Tracker[4] = $Tracker[5]
  $Tracker[5] = $Tracker[6] 
  $Tracker[6] = $Tracker[7] + $Labour
  $Tracker[7] = $Tracker[8]
  $Tracker[8] = $Labour

}

($Tracker | Measure-Object -Sum).sum