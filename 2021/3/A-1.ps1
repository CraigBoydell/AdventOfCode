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

$TestHT = $i | foreach-object { for ($t=0;$t -lt $_.length; $t++) { @{ $t = $_[$t] } }}

$TestObj =$TestHT | foreach-object {new-object -Property $_ -TypeName PSObject}

#$Testobj | Group-Object -Property 0

$Telemetry = 0..$($i[0].length-1) | foreach-object { $Bit = [string]$_; $Grouped = $TestObj.$bit | Group-Object | Sort-Object -Property Count;  $Props = [ordered]@{ 'Bit'=$Bit; 'Min' = $Grouped[0].Name; 'Max'=$Grouped[1].Name}; New-Object -Property $Props -TypeName PSObject }

$gamma = [Convert]::ToInt32($($Telemetry.max -join '').trim(),2)
$epsilon = [Convert]::ToInt32($($Telemetry.min -join '').trim(),2)

$gamma * $epsilon
