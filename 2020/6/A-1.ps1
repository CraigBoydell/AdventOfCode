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
#$Answers = get-content .\I.txt
#$Answers = $Answers.Split([Environment]::NewLine, [StringSplitOptions]::RemoveEmptyEntries)

(($Answers -split "`n`n") | ForEach-Object { $($($(($_ -split "`n") -join '')).tochararray() | Select-Object -Unique).count    } | measure-object -sum).sum