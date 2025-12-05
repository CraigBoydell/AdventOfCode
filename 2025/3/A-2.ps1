$Source = Get-Content .\ex.txt
$Source = Get-Content .\I.txt


Function Get-LargestNumber {
  param (
    $String,
    [int64]$Start,
    [int64]$max,
    [int]$iterate = 1,
    [int]$maxiterate
  )
  $CharArray = $String.ToCharArray()
  $Slot1 = 0
  for ($i=$start; $i -le ($Start+$max); $i++) { if ($CharArray[$i] -gt $Slot1 ) { $Slot1 = $CharArray[$i]; $loc = $i};   }
  $Slot1
  <#
  write-host $('start: ' + $start)
  write-host $('i: ' + $i)
  write-host $('slot: ' + $slot1)
  write-host $('loc: ' + $loc)
  write-host $('max: ' + $max)
  #write-host $('Iterate2: ' + $iterate)
  #>
  #if ($AmmendMax -eq $True) {  if (($max - $loc +$start -1) -gt 0 -and $max -ne 0) {$max = ($max - $loc + $start - 1)} else {$max = 0}} else {if (($max - $loc +$start) -gt 0 -and $max -ne 0) {$max = ($max - $loc + $start)} else {$max = 0}}
  if (($max - $loc +$start) -gt 0 -and $max -ne 0) {$max = ($max - $loc + $start)} else {$max = 0}
  $iterate++
  $loc++
  if ($iterate -le $maxiterate) { Get-LargestNumber -String $String -start $loc -max $max -maxiterate $maxiterate -iterate $iterate }
}

$Result = $Source | foreach { $(Get-LargestNumber -String $_ -start 0 -max ($_.Length-12) -maxiterate 12) -join ''}

#This works with the First part as well
#$Result = $Source | foreach { $(Get-LargestNumber -String $_ -start 0 -max ($_.Length-2) -maxiterate 2) -join ''}

($Result | Measure-Object -Sum).sum
#Answer
#171518260283767