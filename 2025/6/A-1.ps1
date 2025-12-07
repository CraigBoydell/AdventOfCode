$Source = Get-Content .\ex.txt
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt


$Problems  = New-Object System.Collections.Generic.List[System.Object]

($Source | foreach { while ($_.contains('  ')) {$_ = $_.replace('  ',' ')}; $_  }) | foreach { $Problems.add( $_.trim().split(' ') ) }



$( for ($i=0; $i -lt $Problems[0].count; $i++ ) {

  $Problem = ($Problems | foreach { $_[$i]  })
  invoke-command -ScriptBlock $([scriptblock]::Create(($Problem[0..($Problem.count-2)] -join $problem[-1])))

} ) | Measure-Object -Sum


#Answer
#5667835681547