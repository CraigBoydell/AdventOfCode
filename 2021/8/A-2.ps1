Function Test-Signal {

  Param (
    $Signal
  )

  $Signal = $Signal -split ' ' | Select-Object @{N='Signal';E={$_}},@{N='SignalLength';E={$_.Length}},@{N='Value';E={}} | Sort-Object -Property SignalLength
  $JustSignal = $Signal.Signal

  #Set Value for known length
  $Signal[0].value = 1
  $Signal[1].value = 7
  $Signal[2].value = 4
  $Signal[9].value = 8
  #Set Value for 2
  3..5 | foreach-object { $ToTest = $_; if ( $($JustSignal[$ToTest] -replace $('[' + $Signal[2].signal + ']')).length -eq 3 ) {($Signal | where-object {$_.Signal -eq $JustSignal[$ToTest]}).value = 2; $JustSignal[$ToTest] = $null }  }
  #Set Value for 3
  3..5 | foreach-object { $ToTest = $_; if ( $($JustSignal[$ToTest] -replace $('[' + $Signal[0].signal + ']')).length -eq 3 ) {($Signal | where-object {$_.Signal -eq $JustSignal[$ToTest]}).value = 3; $JustSignal[$ToTest] = $null }  }
  #Set Value for 5
  3..5 | foreach-object { $ToTest = $_; if ( $null -ne $JustSignal[$ToTest] ) {($Signal | where-object {$_.Signal -eq $JustSignal[$ToTest]}).value = 5; $JustSignal[$ToTest] = $null }  }
  #Set Value for 6
  6..8 | foreach-object { $ToTest = $_; if ( $($JustSignal[$ToTest] -replace $('[' + $Signal[0].signal + ']')).length -eq 5 ) {($Signal | where-object {$_.Signal -eq $JustSignal[$ToTest]}).value = 6; $JustSignal[$ToTest] = $null }  }
  #Set Value for 0
  6..8 | foreach-object { $ToTest = $_; if ( $($JustSignal[$ToTest] -replace $('[' + $Signal[2].signal + ']')).length -eq 3 ) {($Signal | where-object {$_.Signal -eq $JustSignal[$ToTest]}).value = 0; $JustSignal[$ToTest] = $null }  }
  #Set Value for 9
  6..8 | foreach-object { $ToTest = $_; if ( $null -ne $JustSignal[$ToTest] ) {($Signal | where-object {$_.Signal -eq $JustSignal[$ToTest]}).value = 9; $JustSignal[$ToTest] = $null }  }

  $Signal

}


Function Sort-String {
  Param (
    $string
  )
  ($String -split '' | where-Object {$_ -ne ''} | Sort-Object) -join ''
}



#Example: 
$i = @'
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
'@

$i = get-content I.txt -raw
$i = $i -split "`n"

$Display = $i | select-object -Property @{N='OutputDigits';E={$($(($_) -split "\s\|\s" )[1]).trim()}},@{N='Signal';E={$($(($_) -split "\s\|\s" )[0]).trim()}}
$Known = @(2,3,7,4)
$Display = $Display | Select-Object -Property *,@{N='isKnownCount';E={@($_.OutputDigits -split " " | where-object {$_.Length -in $Known}).count }}

$Display = $Display | Select-Object -Property *, @{N='Decoded';E={Test-Signal -Signal $_.Signal}}

$Display = $Display | Select-object -Property *,@{N='OutputValue';E={ $Totest = $_; $($ToTest.OutputDigits -split ' ' | foreach-object { $Digit = $(sort-string -string $_);$Totest.Decoded | where-object { $(sort-string -string $_.Signal) -eq $Digit}}).value -join ''  }}

$Display

($Display | Measure-Object -Property isKnownCount -sum).sum

($Display | Measure-Object -Property OutputValue -Sum).sum

