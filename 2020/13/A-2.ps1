
<# Very Slow
$BusInput = '7,13,x,x,59,x,31,19'
#$BusInput = '17,x,13,19'
#$BusInput = '67,7,59,61'
#$BusInput = '67,x,7,59,61'
#$BusInput = '67,7,x,59,61'
#$BusInput = '1789,37,47,1889'
$BusInput = $BusInput -split "`r?`n"
$BusInput = (get-content '.\I.txt')[1]

$BusInput
$BusRoutes = $BusInput.split(',')
$CurrentTimeStamp = [int]$BusRoutes[0]
$CurrentTimeStamp = 100000000000009
$AllMatched = $false
$LastReported = get-date
do {
  $i=0
  $y = $BusRoutes.count -1
  if ( (($CurrentTimeStamp + $y) % $BusRoutes[$y]) -eq 0  ) {
    do {
      if ($BusRoutes[$i] -eq 'x') {
        #$true
        $i++
      } elseif (($CurrentTimeStamp + $i) % $BusRoutes[$i] -eq 0 -and $i -eq ($BusRoutes.count -1)) {
        $Allmatched = $true
      } elseif (($CurrentTimeStamp + $i) % $BusRoutes[$i] -eq 0 -and $i -lt ($BusRoutes.count -1)) {
        #$true
        $i++
      } else {
        #$false
        break
      }
    } until ($AllMatched -eq $true)
  }
  if ($AllMatched -eq $false) {$CurrentTimeStamp = $CurrentTimeStamp + $BusRoutes[0] }
  #if ($AllMatched -eq $false) {$CurrentTimeStamp = $CurrentTimeStamp + 59 }
  if (((get-date) - $LastReported).TotalSeconds -gt 30 ) { $LastReported = get-date; Write-Progress -activity $($LastReported.tostring() + ' - CurrentTimeStamp: ' + $CurrentTimeStamp)  }
} until ($AllMatched -eq $true)
$CurrentTimeStamp


#($CurrentTimeStamp - $StartTimestamp) * $CurrentBusRoute
#>

# for a % m (where a and m are coprime),
# find x where (a * x) % m = 1
function Get-ModMultInv {
  param(
      [long]$a,
      [long]$m
  )

  if ($m -eq 1) { return 1 }

  $m0,$x0,$x1 = $m,0,1

  while ($a -gt 1) {
      [long]$q = [Math]::Floor($a/$m)
      $a,$m = $m,($a%$m)
      $x0,$x1 = ($x1 - $q * $x0),$x0
  }

  if ($x1 -lt 0) { $x1 + $m0 } else { $x1 }
}

function Get-ChineseRemainder {
  param(
      [int[]]$n,
      [int[]]$a
  )

  [long]$prod = $n -join '*' | invoke-expression
  $sm = 0

  for ($i=0; $i -lt $n.Count; $i++) {
      $p = [Math]::Floor($prod / $n[$i])
      $modinv = Get-ModMultInv $p $n[$i]
      $sm += $a[$i] * $modinv * $p
  }
  $sm % $prod
}

$n=@(); $a=@()
$BusInput = '17,x,13,19'
$BusInput = (get-content '.\I.txt')[1]
$i = 0
$BusInput.Split(',') | foreach {
  if ($_ -ne 'x') {
      $n += [int]$_
      $a += if ($i -eq 0) { 0 } else { [int]$_ - ($i % $_)}
  }
  $i++
}

Get-ChineseRemainder $n $a