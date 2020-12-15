$InstructionSet = @'
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
'@

$InstructionSet = ($InstructionSet -split "`n")
$InstructionSet = get-content '.\I.txt'

$i = 0
$InstructionSet = $InstructionSet | foreach-object { $SPlitLine = $_.split(' '); New-Object -TypeName PSObject -Property @{index = $i;op= $SplitLine[0]; arg=$SplitLine[1];ExecuteCount = 0;Tested = $null}; $i++   }

do {
  $Cursor = 0
  $accumulator = New-Object -TypeName "System.Collections.ArrayList"
  $accumulator.add(0) | out-null
  $loopDetected = $false
  $ProgramEnd = $False
  $InstructionSet| foreach-object { $_.ExecuteCount = 0  }
  $InstructionToTest = $InstructionSet | where-object {$_.Tested -eq $null -and ($_.op -eq 'nop' -or $_.op -eq 'jmp')} | Select-Object -first 1
  switch ($InstructionToTest.op) {
    "nop" { $InstructionSet[$InstructionToTest.index].Tested = $InstructionSet[$InstructionToTest.index].op; $InstructionSet[$InstructionToTest.index].op = "jmp"  }
    "jmp" { $InstructionSet[$InstructionToTest.index].Tested = $InstructionSet[$InstructionToTest.index].op; $InstructionSet[$InstructionToTest.index].op = "nop"  }
  }
  do {
    switch ($InstructionSet[$Cursor].op) {
      "acc" { if ($InstructionSet[$Cursor].ExecuteCount -eq 0) {$InstructionSet[$Cursor].ExecuteCount++;$accumulator.Add($accumulator[-1] + (1 * $InstructionSet[$Cursor].arg)) | out-null; $Cursor++} else {$loopDetected = $True; break} }
      "jmp" { if ($InstructionSet[$Cursor].ExecuteCount -eq 0) {$InstructionSet[$Cursor].ExecuteCount++;$Cursor = (1 * $InstructionSet[$Cursor].arg) + $Cursor} else {$loopDetected = $True; break} } 
      "nop" { if ($InstructionSet[$Cursor].ExecuteCount -eq 0) {$InstructionSet[$Cursor].ExecuteCount++;$Cursor++} else {$loopDetected = $True; break} } 
      default {'not matched'; $ProgramEnd = $True}
    }
  } until ($loopDetected -or $ProgramEnd)
  If ($loopDetected -eq $true) {$InstructionSet[$InstructionToTest.index].op = $InstructionSet[$InstructionToTest.index].Tested; $InstructionSet[$InstructionToTest.index].Tested = $true}
} until ($ProgramEnd)

$accumulator[-1]