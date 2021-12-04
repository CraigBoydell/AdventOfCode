#Example: 
$i = @'
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
'@

$i = $i -split "`n"

$i = get-content I.txt

function Process-Input {
  param (
      $i,
      [string]$bit,
      $prefer
  )

  $TestHT = $i | foreach-object { for ($t=0;$t -lt $_.length; $t++) { @{ $t = $_[$t] } }}

  $TestObj =$TestHT | foreach-object {new-object -Property $_ -TypeName PSObject}

  $Grouped = $TestObj.$bit | Group-Object | Sort-Object -Property Count
  if ($Grouped[0].count -eq $Grouped[1].count){
    $Props = [ordered]@{ 'Bit'=$Bit; 'Min' = $Prefer; 'Max'=$Prefer}
  } else {
    $Props = [ordered]@{ 'Bit'=$Bit; 'Min' = $Grouped[0].Name; 'Max'=$Grouped[1].Name}
  }
  
  #write-host $(New-Object -Property $Props -TypeName PSObject)
  New-Object -Property $Props -TypeName PSObject
}

$O2GenRate = $i

$Bit = 0
do {
    $Assess = Process-Input -i $O2GenRate -bit $bit -prefer 1
    $O2GenRate = $O2GenRate | where-object {$_[$Bit] -eq [string]$Assess.max}
    $Bit++
} until (
    $Bit -eq $i[0].length -or $O2GenRate.count -eq 1
)

$O2GenRate = [Convert]::ToInt32($($O2GenRate).trim(),2)

$CO2ScrubRate = $i

$Bit = 0
do {
    $Assess = Process-Input -i $CO2ScrubRate -bit $bit -prefer 0
    $CO2ScrubRate = $CO2ScrubRate | where-object {$_[$Bit] -eq [string]$Assess.min}
    $Bit++
} until (
    $Bit -eq $i[0].length -or $CO2ScrubRate.count -eq 1
)

$CO2ScrubRate = [Convert]::ToInt32($($CO2ScrubRate).trim(),2)


$O2GenRate * $CO2ScrubRate
