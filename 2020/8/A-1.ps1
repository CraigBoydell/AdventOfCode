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

$InstructionSet = $InstructionSet | foreach-object { $SPlitLine = $_.split(' '); New-Object -TypeName PSObject -Property @{op= $SplitLine[0]; arg=$SplitLine[1];ExecuteCount = 0}   }

$Cursor = 0
$accumulator = New-Object -TypeName "System.Collections.ArrayList"
$accumulator.add(0) | out-null
$loopDetected = $false

do {
  switch ($InstructionSet[$Cursor].op) {
    "acc" { if ($InstructionSet[$Cursor].ExecuteCount -eq 0) {$InstructionSet[$Cursor].ExecuteCount++;$accumulator.Add($accumulator[-1] + (1 * $InstructionSet[$Cursor].arg)) | out-null; $Cursor++} else {$loopDetected = $True; break} }
    "jmp" { if ($InstructionSet[$Cursor].ExecuteCount -eq 0) {$InstructionSet[$Cursor].ExecuteCount++;$Cursor = (1 * $InstructionSet[$Cursor].arg) + $Cursor} else {$loopDetected = $True; break} } 
    "nop" { if ($InstructionSet[$Cursor].ExecuteCount -eq 0) {$InstructionSet[$Cursor].ExecuteCount++;$Cursor++} else {$loopDetected = $True; break} } 
    default {'not matched'}
  }
} until ($loopDetected)

$accumulator[-1]