$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

#$SourceSplit = $Source.split("`n")

$regex = 'mul\(\d{1,3},\d{1,3}\)'
$AllMul = $Source | Select-String -Pattern $regex -AllMatches

#$AllMul.matches.value

function mul { param ( $x )  invoke-expression $($x -join '*') }

($AllMul.matches.value | foreach { Invoke-command -ScriptBlock $([scriptblock]::Create($_))  } | Measure-Object -Sum).sum

#Answer
#156388521