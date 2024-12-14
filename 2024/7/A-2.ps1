$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
#$Source = Get-Content .\I.txt -Raw
#$Source = Get-Content .\I2.txt -Raw
$Source = Get-Content .\I3.txt -Raw

$SourceSplit = $Source.trim().split("`n")

function baseb {

    param (
      $n,
      $b
    )
  
    $e = [math]::floor($n / $b)
    $q = $n % $b
  
    if ($n -eq 0) {'0'} elseif ( $e -eq 0 ) {[string]$q} else { [string](baseb -n $e -b $b) + $q}
     
  }

Function Get-Permutations2 {

    param(
        $Max = 4
    )

  $All = 0..([math]::pow(3,$max)-1) | foreach {
    #write-host $_
    $response = baseb -n $_ -b 3
    if (  $Response.length -lt $max ) {
        do {
            $Response = [string]'0' + $Response
        } while ($Response.length -lt $max)
    }
    $response.replace('0','*').replace('1','+').replace('2','|')
  }
  #$All.replace('0','*').replace('1','+').replace('2','|') | select-object -Unique
  $All
}

$Test = $SourceSplit | select-object -Property @{N='SumValues';E={($_.trim() -split ': ')[1] -split ' '}} | select-object -Property *,@{N='CountValues';E={$_.SumValues.count}} | group-object -property CountValues
$AllPermutations = @{}

$Test | foreach { write-host ($_.name-1); $AllPermutations[[int]$_.Name-1] = Get-Permutations2 -Max ([int]$_.Name-1)  }

$Counter = 0
$Results = $SourceSplit | foreach {
    $Counter++
    write-progress -id 1 -activity $([string]$counter + '/' + $SourceSplit.count) -PercentComplete $([math]::Round(($counter / $SourceSplit.count) * 100,2))
    $ExpectedAnswer = [bigint]($_ -split ': ')[0]
    $SumValues = ($_ -split ': ')[1] -split ' '
    #$AllOperatorPatterns = Get-Permutations -Max ($SumValues.count -1)
    #$AllOperatorPatterns = Get-Permutations2 -Max ($SumValues.count -1)
    $AllOperatorPatterns = $AllPermutations[($SumValues.count -1)]
    $isPossible = $false
    #$AllOperatorPatterns | foreach {
    $Counter2 = 0
    $TotalOperators = $AllOperatorPatterns.count
    foreach ($Operators in $AllOperatorPatterns) {
      $Counter2++
      #write-host $($Operators -join '')
      #$_
      #$Operators = $_
      $i = 0
      $Total = $SumValues[$i]
      do {
        #write-host $([string]$Total + $Operators[$i] + $SumValues[$i+1])
        write-progress -id 2 -activity $([string]$Counter2 + '/' + $TotalOperators) -PercentComplete $([math]::Round(($Counter2 / $TotalOperators) * 100,2))
        $Total = $(invoke-expression $([string]$Total + $(if ($Operators[$i] -eq '|') {''} else {$Operators[$i]}   ) + $SumValues[$i+1]))
        $i++
      } until ( $i -ge $SumValues.count-1 -or [bigint]$Total -gt [bigint]$ExpectedAnswer)
      if ($Total -eq $ExpectedAnswer) {$isPossible = $True; break}
      #if ([bigint]$Total -gt [bigint]$ExpectedAnswer) {break}
    }
    new-object -property @{"Source" = $_; isPossible = $isPossible; expectedAnswer = $ExpectedAnswer} -TypeName PSCustomObject
}

($Results | where {$_.isPossible -eq $true} | Measure-Object -Property expectedAnswer -Sum).sum

#Answer
#3312271365652 + 506151217931060
#509463489296712