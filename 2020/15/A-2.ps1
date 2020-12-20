$NumberStart = '0,3,6' #175594
<#
$NumberStart = '1,3,2' #2578
$numberStart = '2,1,3' #3544142
$NumberStart = '1,2,3' #261214
$numberStart = '2,3,1' #6895259
$numberStart = '3,2,1' #18
$numberStart = '3,1,2' #362
#>
#$NumberStart = get-content '.\I.txt' -raw

$LastSeen = @{}
$RoundCounter =0 
#($NumberStart -split ',') | foreach-object {$RoundCounter++; $LastSeen.(1*$_) = $RoundCounter}
($NumberStart -split ',') | foreach-object {$RoundCounter++; $LastSeen[(1*$_)] = $RoundCounter}
#$NextNumber = 6
$NextNumber = $(1*(($NumberStart -split ',') | Select-Object -last 1))

$RoundToStop = 30000000
$RoundToStop = 2020
#while ($RoundCounter -ne $RoundToStop) {
for ($RoundCounter=$RoundCounter; $RoundCounter -lt $RoundToStop; $RoundCounter++) {
  $LastSeenNumber = $LastSeen[$NextNumber] #note []'s more performant than . dot notation
  $LastSeen[$NextNumber] = $RoundCounter
  $NextNumber = if ($LastSeenNumber) {  ($RoundCounter - $LastSeenNumber) } else { 0; write-progress -Activity $('RoundCounter: ' + $RoundCounter)}
}
$NextNumber

<# Works but slow
$NumberGame = New-Object -TypeName "System.Collections.ArrayList"
$RoundCounter =0 
($NumberStart -split ',') | foreach-object {$RoundCounter++; $NumberGame.add(@{$RoundCounter = (1*$_)}) | out-null}

$ReportedProgress = 0
$RoundToStop = 30000000
#$RoundToStop = 2020
while ($RoundCounter -ne $RoundToStop) {
    $CurrentProgress = [int](($RoundCounter / $RoundToStop) * 100)
    if ( $CurrentProgress -gt $ReportedProgress ) {write-progress -Activity $('RoundCounter: ' + $RoundCounter) -PercentComplete $CurrentProgress; $ReportedProgress = $CurrentProgress} 
    switch ($(($NumberGame[-1]).values) -in (($NumberGame[-2..(-1*$NumberGame.count)])).values) {
      $true {$RoundCounter++;$NumberGame.add(@{$RoundCounter = ((($NumberGame.where({$_.values -contains $(($NumberGame[-1]).values)}) | Select-Object -last 2).keys)[1..0] -join '-' | Invoke-Expression)}) | out-null  }
      $false {$RoundCounter++;$NumberGame.add(@{$RoundCounter = 0}) | out-null;write-progress -Activity $('RoundCounter: ' + $RoundCounter) -PercentComplete $CurrentProgress}
    }
}
$NumberGame[-1]
#>