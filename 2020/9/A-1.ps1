$NumberString = @(
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
)
$NumberString = get-content '.\I.txt'
$NumberString = $NumberString | foreach-object {[int64]$_}
$Preamble = 25
$Start = 25
$Location = $Start
$Results = New-Object -TypeName "System.Collections.ArrayList"

do {
$NumberToMatch = $Numberstring[$Location]
$ArrayToCheck = $NumberString[($Location-1)..($Location-$Preamble)] | sort-object
$l=0
$r=$ArrayToCheck.Count-1
Do {
  $SumFound = $false
  switch ($ArrayToCheck[$l] + $ArrayToCheck[$r]  ) {
    $NumberToMatch {<#$('Sum Found: ' + $l + ',' + $r);#>$SumFound = $TRUE}
    {$_ -lt $NumberToMatch} {$l++}
    {$_ -gt $NumberToMatch} {$r--}
    default {'no matches'}
  }
} until ( ($l -ge $r) -or $SumFound )

$Results.Add($(New-Object -TypeName PSObject -Property @{NumberToMatch= $NumberToMatch;Result=$SumFound})) | out-null
#$SumFound
$Location++
} until (($SumFound -eq $false) -or ($Location -gt ($Numberstring.count-1)))
$NumberToMatch