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

#$i = get-content I.txt

$Test = $i | foreach-object { new-object -TypeName PSObject -property @{Value = $_;Status = $(if ($_ -gt $Previous) {'increased'} else {'decreased'})};  $Previous = $_ }
$Test[0].status = $null
$Test | Group-Object -Property Status