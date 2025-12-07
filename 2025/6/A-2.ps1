 $Source = Get-Content .\ex.txt
 #$Source = Get-Content .\ex2.txt -Raw
 $Source = Get-Content .\I.txt


 $Problems  = New-Object System.Collections.Generic.List[System.Object]
 $Locations = ($Source[-1] | Select-String -Pattern '\*\s+|\+\s+' -AllMatches).matches

 $Source[0..($Source.count-2)]  | foreach {
   $Problems.add( $($_ | foreach {
     $ToSplit = $_;  0..($Locations.count-1) | foreach {
         if ($_ -ne ($Locations.count-1)) {
           $ToSplit.substring($Locations[$_].index,$locations[$_].Length-1)
         } else {
           $ToSplit.substring($Locations[$_].index,$locations[$_].Length)
         }
     }
   }))
 }

 $Problems.add( $($Locations.value | foreach {$_.replace(' ',$_[0])})  )

 #$Problems

 $TotalSum = 0; for ($p=0;$p -lt $Problems[0].count;$p++) {
    $Problem = $Problems | foreach {$_[$p]}
    $ProblemChars  = New-Object System.Collections.Generic.List[System.Object]

    #$Problems | foreach { $_[1]  } | foreach {$_[-3]}
    $Problem[0..($problem.count-1)] | foreach { $ProblemChars.add( $_.ToCharArray())   }
    $Operator = $problem[-1][0]
    #write-host $operator

    $(-1..(($ProblemChars.count-1)*-1) | foreach { $SumIndex = $_; ($ProblemChars[0..($ProblemChars.count-2)] | foreach {([string]$_[$SumIndex]).trim()}) -join ''  } | where {$_ -ne ''}) -join $Operator
    #$(-1..(($ProblemChars.count-1)*-1) | foreach { $SumIndex = $_; ($ProblemChars[0..($ProblemChars.count-2)] | foreach {$_[$SumIndex]}) -join ''  }) -join $Problem[-1][0]

    $SumResult = invoke-command -scriptblock $([scriptblock]::Create($($(-1..(($ProblemChars.count-1)*-1) | foreach { $SumIndex = $_; ($ProblemChars[0..($ProblemChars.count-2)] | foreach {([string]$_[$SumIndex]).trim()}) -join ''  } | where {$_ -ne ''}) -join $Problem[-1][0])))
    $SumResult
    $TotalSum = $TotalSum + $SumResult
 }

 $TotalSum



 <# to Work through
 $( for ($i=0; $i -lt $Problems[0].count; $i++ ) {

   $Problem = ($Problems | foreach { $_[$i]  })
   invoke-command -ScriptBlock $([scriptblock]::Create(($Problem[0..($Problem.count-2)] -join $problem[-1])))

 } ) | Measure-Object -Sum
 #>

 #Answer
 #9434900032651