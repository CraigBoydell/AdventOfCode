#Example:
$i = @'
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
'@
#$i = ($i -split "`n")

#$i = get-content I.txt
$($global:counter=0; $($($I.split("`n`r") -join ',').replace(',,',',none,') -split ',none,') | foreach-object { $_ | Select-Object -Property @{N='i';E={$global:counter++;$global:counter}},@{N='Sum';E={ $($_ -split ',' | Measure-Object -sum).sum}} }  | Sort-Object -Property Sum -Descending | Select-Object -first 3 | Measure-Object -Property Sum -sum).sum