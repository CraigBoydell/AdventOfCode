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
$Global:Aim = 0
$Global:Location = 0
$Global:Depth = 0

$Test = $Test | Select-Object -Property *,@{N='Aim';E={$Action=$_; switch ($_.Action) { 'down' {$Global:Aim = $Global:Aim + $Action.Value; $Global:Aim}; 'up' {$Global:Aim = $Global:Aim - $Action.value; $Global:Aim}; default {$Global:Aim}  }}} -ExcludeProperty Aim
$Result = $Test | Select-Object -Property *,@{N='Location';E={if ($_.Action -eq 'forward') {$Global:Location = $Global:Location + $_.Value; $Global:Location} else {$Global:location} }},@{N='Depth';E={if ($_.Action -eq 'forward') {$Global:Depth = $Global:Depth + $($_.Aim * $_.Value); $Global:Depth} else {$Global:Depth} }}
$Result[-1].location * $Result[-1].depth


