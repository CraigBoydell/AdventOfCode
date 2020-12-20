function Search-Array {
  Param (
    $Array,
    $Value
  )
  $Results = New-Object -TypeName "System.Collections.ArrayList"
  $StartInt = 0
  while ( $Result -ne -1 ) {
    $Result = [Array]::IndexOf($Array,$Value,$StartInt)
    if ($Result -ne -1) { $Results.Add($Result) | out-null }
    $StartInt = $Result + 1
    #write-host $('Result: ' + $Result)
  }
  $Results
}

$NumberStart = '0,3,6' #436
<#
$NumberStart = '1,3,2' #1
$numberStart = '2,1,3' #10
$NumberStart = '1,2,3' #27
$numberStart = '2,3,1' #78
$numberStart = '3,2,1' #438
$numberStart = '3,1,2' #1836
#>
$NumberStart = get-content '.\I.txt' -raw

$NumberGame = New-Object -TypeName "System.Collections.ArrayList"
$RoundCounter =0 
($NumberStart -split ',') | foreach-object {$RoundCounter++; $NumberGame.add((1*$_)) | out-null}

$ReportedProgress = 0
$RoundToStop = 2020
while ($RoundCounter -ne $RoundToStop) {
    $CurrentProgress = [int](($RoundCounter / $RoundToStop) * 100)
    if ( $CurrentProgress -gt $ReportedProgress ) {write-progress -Activity $('RoundCounter: ' + $RoundCounter) -PercentComplete $CurrentProgress; $ReportedProgress = $CurrentProgress} 
    switch ($NumberGame[$RoundCounter-1] -in ($NumberGame[0..($NumberGame.count-2)])) {
      $true {$NumberGame.add(((Search-Array -Array $NumberGame -Value ($NumberGame[$RoundCounter-1]) |select-object -last 2)[1..0] -join '-' | Invoke-Expression)) | out-null; $RoundCounter++  }
      $false {$NumberGame.add(0) | out-null; $RoundCounter++; }
    }
}
$NumberGame[$RoundCounter-1]