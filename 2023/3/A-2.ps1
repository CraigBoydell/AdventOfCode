$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$pAllNumbers = '[0-9]*'
$pAllSymbols = '(?!(\.|[0-9]|\n)).'

#$Test = $SourceSplit | select-object -Property @{N='Input';E={$_}},@{N='Numbers';E={ (Select-String $pAllNumbers -Input $_ -AllMatches).matches | where {$_.Value -ne ''}}},@{N='Symbols';E={(Select-String $pAllSymbols -Input $_ -AllMatches).matches | where {$_.Value -ne '' -and $_.Value -ne "`r"}}}
$global:Count = 0; $Test = $SourceSplit | select-object -Property @{N='Input';E={$_}},@{N='Numbers';E={ (Select-String $pAllNumbers -Input $_ -AllMatches).matches | where {$_.Value -ne ''}}},@{N='Symbols';E={(Select-String $pAllSymbols -Input $_ -AllMatches).matches | where {$_.Value -ne '' -and $_.Value -ne "`r"} | select-object -Property *,@{N='splitIndex';E={$global:count; $global:count++}}  }}

$Test1 = for ($i = 0; $i -lt $test.count; $i++) { $Test[$i].Numbers | foreach { $Number = $_; $Number | Select-Object -Property *,@{N='isPart';E={ $Test[$i+1].symbols | where {$($_.index) -ge ($Number.index -1) -and  $_.index -le $($Number.index + $Number.Length)}; if ($i -ne 0) {$Test[$i-1].symbols | where {$($_.index) -ge ($Number.index -1) -and  $_.index -le $($Number.index + $Number.Length)}}; $Test[$i].symbols | where {$($_.index) -ge ($Number.index -1) -and  $_.index -le $($Number.index + $Number.Length)}   }}  }  }


$Gears = $Test1 | where {$_.isPart.value -eq '*'} | Select-Object -Property *,@{N='splitIndex';E={$_.isPart.splitIndex}} | Group-Object -Property splitIndex

$Gears | where {$_.count -ge 2} | foreach { $_.Group.Value -join '*'  }

($Gears | where {$_.count -ge 2} | foreach { Invoke-Expression -command $($_.Group.Value -join '*')  } | Measure-Object -sum ).sum

# Answer:
# 79026871