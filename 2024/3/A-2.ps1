#$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

#$SourceSplit = $Source.split("`n")

$Source = $Source + 'do()'

$Test1 = $Source | Select-String -Pattern 'don\''t\(\)(.|\n|\r)*?do\(\)' -AllMatches

$Test1.Matches.value | foreach {$Source = $Source.Replace($_,'')}

#$Source = $Source -split 'don\''t\(\)(.|\n|\r)*?do\(\)' -join ''



$regex = 'mul\(\d{1,3},\d{1,3}\)'
$AllMul = $Source | Select-String -Pattern $regex -AllMatches

#$AllMul.matches.value

function mul { param ( $x )  invoke-expression $($x -join '*') }

($AllMul.matches.value | foreach { Invoke-command -ScriptBlock $([scriptblock]::Create($_))  } | Measure-Object -Sum).sum

#Answer
#75920122