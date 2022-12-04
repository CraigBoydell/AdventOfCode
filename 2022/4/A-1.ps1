#Example:
$i = @'
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
'@

$i = Get-Content .\I.txt -Raw

$assTasks = $("E1,E2`n") + $i | ConvertFrom-Csv
$AssTasks = $AssTasks | select-object -property *,@{N='Test';E={(compare-object  $(invoke-command -ScriptBlock $([scriptblock]::Create(($($_.e1).replace('-','..') )  ))) $(invoke-command -ScriptBlock $([scriptblock]::Create(($($_.e2).replace('-','..') )  ))) -ExcludeDifferent -IncludeEqual).inputobject}}

($AssTasks | where-object {($_.Test -join ',') -eq $($(invoke-command -ScriptBlock $([scriptblock]::Create(($($_.e1).replace('-','..') )  ))) -join ',') -or ($_.Test -join ',') -eq $((invoke-command -ScriptBlock $([scriptblock]::Create(($($_.e2).replace('-','..') )  ))) -join ',') }).count