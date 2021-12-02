#Example:
$i = @'
forward 5
down 5
forward 8
up 3
down 8
forward 2
'@

$i = $i -split "`n"

$i = get-content I.txt

$Test = $i | Select-Object -Property @{N='Action';E={($_ -split ' ')[0]}},@{N='Value';E={($_ -split ' ')[1]}}
$TotalSum = $Test | Group-Object -Property Action | Select-Object -Property Name,@{N='Total';E={$($_.Group | Measure-Object -Property Value -sum).sum}}
$Location = New-Object -TypeName PSObject -Property @{'position'= $($TotalSum | where-object {$_.Name -eq 'forward'}).Total; 'Depth'=$($($TotalSum | where-object {$_.Name -eq 'down'}).total - $($TotalSum | where-object {$_.Name -eq 'up'}).total) }

$Location.depth * $Location.position