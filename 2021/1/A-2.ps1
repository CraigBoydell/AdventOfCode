#Example:
$i = @'
199
200
208
210
200
207
240
269
260
263
'@
$i = ($i -split "`n")

$i = get-content I.txt

$y=0
$Test = New-Object -TypeName "System.Collections.ArrayList"
do {
  $Props = [ordered]@{  
    Letter = [char](65 + $y)
    Numbers = $i[$($y..$($y+2))]
    Value = ($($i[$($y..$($y+2))]) | Measure-Object -sum).sum
    #Status = $(if ($(($($i[$($y..$($y+2))]) | Measure-Object -sum).sum) -gt $Previous) {'increased'} else {'decreased'})
    Status = $(switch (($($i[$($y..$($y+2))]) | Measure-Object -sum).sum) { {$_ -eq $Previous} {'No Change'}; {$_ -gt $Previous} {'increased'}; {$_ -lt $Previous} {'decreased'}    })
  }
  $obj = new-object -typename PSObject -property $props
  $Previous = $obj.value
  $y++
  $Test.add($obj) | Out-Null
  
} until ($($i[$($y..$($y+2))]).count -ne 3)
$Test[0].Status = $null
$Test | Group-Object -Property Status