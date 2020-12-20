$TicketInput = @'
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
'@

#$TicketInput = get-content .\I.txt -raw
$TicketInput = $((get-content .\I.txt -raw) -split ("`r?`n`r?`n"))

$Pattern = '(\d+-\d+)'
$InRange = ($TicketInput[0]) -split "`n" | foreach {(($_ | Select-String -Pattern $pattern -AllMatches).matches.value | foreach { $_.replace('-','..')  }) -join ';' | Invoke-Expression}
$NT = $TicketInput[2].split("`n")
($NT[1..$($NT.getupperbound(0))] | foreach { $_ -split (",") | foreach { if ($_ -notin $InRange) {$_}   }   } | Measure-Object -sum).sum