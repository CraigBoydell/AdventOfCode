$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Instruct = $SourceSplit[0]
$InstructMax = $Instruct.trim().tochararray().Count
$InstructPTR = 0

$Map = $SourceSplit[2..($SourceSplit.count-1)]
$Map = $Map | Select-Object -Property @{N='Input';E={$_}},@{N='Node';E={$_.Split(' = ')[0]}},@{N='Next';E={$($_ -Split(" = "))[1].replace('(','').replace(')','').trim() -split ", "}}

$Steps = 0
$HTMap = @{}
$Map | foreach { $HTMap[$_.Node] = $_ }
$Location = $HTMap['AAA']

Do {
  switch ($Instruct[$InstructPTR]) {
    'R' {$pick = 1}
    'L' {$pick = 0}
  }

  $Steps++
  $Location = $HTMap[$Location.Next[$pick]]
  $InstructPTR++
  if ($InstructPTR -ge $InstructMax) {$InstructPTR = 0}

} until ($Location.Node -eq 'ZZZ')

