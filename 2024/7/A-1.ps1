$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")


Function Get-Permutations {

    param(
        $Max = 4
    )

    0..$([math]::pow(2,$max)-1) | foreach {
      $bin = [convert]::ToString([int32]$_,2)
      if ($Bin.length -lt $Max) { do { $bin = [string]'0' + $bin } while ($bin.length -lt $Max)}
      #$Bin
      $bin.replace('0','+').replace('1','*')
  }
}
$Counter = 0
$Results = $SourceSplit | foreach {
    $Counter++
    write-progress -activity $([string]$counter + '/' + $SourceSplit.count) -PercentComplete $([math]::Round(($counter / $SourceSplit.count) * 100,2))
    $ExpectedAnswer = [bigint]($_ -split ': ')[0]
    $SumValues = ($_ -split ': ')[1] -split ' '
    $AllOperatorPatterns = Get-Permutations -Max ($SumValues.count -1)
    $isPossible = $false
    #$AllOperatorPatterns | foreach {
    foreach ($Operators in $AllOperatorPatterns) {
      #$_
      #$Operators = $_
      $i = 0
      $Total = $SumValues[$i]
      do {
        #write-host $([string]$Total + $Operators[$i] + $SumValues[$i+1])
        $Total = $(invoke-expression $([string]$Total + $Operators[$i] + $SumValues[$i+1]))
        $i++
      } until ( $i -ge $SumValues.count-1 )
      if ($Total -eq $ExpectedAnswer) {$isPossible = $True; continue}
    }
    new-object -property @{"Source" = $_; isPossible = $isPossible; expectedAnswer = $ExpectedAnswer} -TypeName PSCustomObject
}

($Results | where {$_.isPossible -eq $true} | Measure-Object -Property expectedAnswer -Sum).sum

#Answer
#3312271365652