$Answers = @'
abc

a
b
c

ab
ac

a
a
a
a

b
'@


$Answers = ($Answers -split "`n`n")
$Test = $Answers | select-object -Property @{N='Answers';E={($_) -split "`n"}} | select-object -Property *,@{N='PeopleInGroup';E={$_.Answers.count}}
$Test = $Test | Select-Object -Property *,@{N='CountUnanimous';E={$ToTest = $_; @(((($ToTest.answers -join '').toCharArray() | Group-Object) | select-object -ExpandProperty Count) | where-object {$_ -eq $ToTest.PeopleInGroup}).count}}
($Test | Measure-Object -Property CountUnanimous -Sum).sum