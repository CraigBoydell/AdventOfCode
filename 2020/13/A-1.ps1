$BusInput = @'
939
7,13,x,x,59,x,31,19
'@
$BusInput = $BusInput -split "`r?`n"
$BusInput = get-content '.\I.txt'

$StartTimestamp = $BusInput[0]
$BusRoutes = $BusInput[1].split(',') | where {$_ -ne 'x'}
$BusFound = $False
$CurrentTimeStamp = [int]$StartTimestamp
do { 
  $BusRoutes | foreach { 
    $CurrentBusRoute = $_
    if (($CurrentTimeStamp % $CurrentBusRoute) -eq 0) {
      $BusFound = $True
      break
    }
  }
  if ($BusFound -eq $false) {$CurrentTimeStamp++}
} until (
  ($CurrentTimeStamp % $CurrentBusRoute) -eq 0
)
($CurrentTimeStamp - $StartTimestamp) * $CurrentBusRoute