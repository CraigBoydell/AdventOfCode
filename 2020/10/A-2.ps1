$Adapters = @(
16
10
15
5
1
11
7
19
6
12
4
)

$Adapters = @(
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
)


$Adapters = get-content '.\I.txt'
$Adapters = $Adapters | foreach-object {[int64]$_}

$Adapters += 0
$Adapters += ($Adapters | Measure-Object -Maximum).maximum + 3
$Adapters = $Adapters | Sort-Object

$RatingWithDiff = for ($i=0; $i -le $Adapters.count-1; $i++ ) { New-Object -Property @{ Rating= $Adapters[$i]; diff = if ($i -eq 0) {0} else { $Adapters[$i] - $Adapters[$i-1]} } -TypeName PSObject   } 
invoke-command -scriptblock $([scriptblock]::Create(($RatingWithDiff.diff -join '').replace('1111','7').replace('111','4').replace('11','2').replace('3','1').replace('0','').tochararray() -join '*'))
#invoke-command -scriptblock $([scriptblock]::Create((($RatingWithDiff | Group-Object -Property diff) | where-object {$_.Name -eq 1 -or $_.name -eq 3} |Select-Object -ExpandProperty Count) -join '*'))