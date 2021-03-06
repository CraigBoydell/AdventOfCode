function Get-AllCombinations ($list)
{
    $global:remove = { 
        param ($element, $list) 

        $newList = @() 
        $list | foreach { if ($_ -ne $element) { $newList += $_} }  
        return $newList 
    }
    $global:append = {
        param ($head, $tail)

        if ($tail.Count -eq 0) { return ,$head }
        $result =  @()

        $tail | foreach{
            $newList = ,$head
            $_ | %{ $newList += $_ }
            $result += ,$newList
        }
        return $result
    }

    if ($list.Count -eq 0) { return @() }

    $list | %{
        $permutations = Get-AllCombinations ($remove.Invoke($_, $list))
        return $append.Invoke($_, $permutations)
    }
}


Function IntCodeProcessor {
    param( $intArray, $n, $v,$value)
  
    if ( [string]::IsNullOrEmpty($n) -eq $FALSE ) { $intArray[1] = $n }
    if ( [string]::IsNullOrEmpty($v) -eq $FALSE ) { $intArray[2] = $v }
    $ValueInt = 0  
    $IntOpCode = 0
    do {
      $OpCode = $IntArray[$intOpCode]
      $Padded = $OpCode.Tostring(); do { $Padded = '0' + $Padded} until ($Padded.length -eq 5)
      $OpCode = [int]$($Padded[3] + $Padded[4])
      $ModeC = [int]$Padded[2].ToString()
      $ModeB = [int]$Padded[1].ToString()
      $ModeA = [int]$Padded[0].ToString()
      if ($OpCode -eq 1) {
        if ($ModeC -eq 0 ) { $Param1 = $IntArray[$IntArray[$intOpCode+1]]} else {$Param1 = $IntArray[$intOpCode+1]}
        if ($ModeB -eq 0 ) { $Param2 = $IntArray[$IntArray[$intOpCode+2]]} else {$Param2 = $IntArray[$intOpCode+2]}
        $IntArray[$IntArray[$intOpCode+3]] = $Param1 + $Param2
        $IntOpCode = $IntOpCode + 4    
      }
      if ($OpCode -eq 2) {
        if ($ModeC -eq 0 ) { $Param1 = $IntArray[$IntArray[$intOpCode+1]]} else {$Param1 = $IntArray[$intOpCode+1]}
        if ($ModeB -eq 0 ) { $Param2 = $IntArray[$IntArray[$intOpCode+2]]} else {$Param2 = $IntArray[$intOpCode+2]}
        $IntArray[$IntArray[$intOpCode+3]] = $Param1 * $Param2
        $IntOpCode = $IntOpCode + 4
      }
      if ($OpCode -eq 3) {
        $IntArray[$IntArray[$intOpCode+1]] = $Value[$ValueInt]
        $IntOpCode = $IntOpCode + 2
        $ValueInt++
      }
      if ($OpCode -eq 4) {
        $Value =  $IntArray[$IntArray[$intOpCode+1]]
        $Value
        $IntOpCode = $IntOpCode + 2
      }
      if ($OpCode -eq 5) {  #jump-if-true
        if ($ModeC -eq 0 ) { $Param1 = $IntArray[$IntArray[$intOpCode+1]]} else {$Param1 = $IntArray[$intOpCode+1]}
        if ($ModeB -eq 0 ) { $Param2 = $IntArray[$IntArray[$intOpCode+2]]} else {$Param2 = $IntArray[$intOpCode+2]}
        if ($Param1 -ne 0) {
            $IntOpCode = $Param2
        } else {
            $IntOpCode = $IntOpCode + 3
        }
      }
      if ($OpCode -eq 6) {  #jump-if-false
        if ($ModeC -eq 0 ) { $Param1 = $IntArray[$IntArray[$intOpCode+1]]} else {$Param1 = $IntArray[$intOpCode+1]}
        if ($ModeB -eq 0 ) { $Param2 = $IntArray[$IntArray[$intOpCode+2]]} else {$Param2 = $IntArray[$intOpCode+2]}
        if ($Param1 -eq 0) {
            $IntOpCode = $Param2
        } else {
            $IntOpCode = $IntOpCode + 3
        }
      }
      if ($OpCode -eq 7) {  #less than
        if ($ModeC -eq 0 ) { $Param1 = $IntArray[$IntArray[$intOpCode+1]]} else {$Param1 = $IntArray[$intOpCode+1]}
        if ($ModeB -eq 0 ) { $Param2 = $IntArray[$IntArray[$intOpCode+2]]} else {$Param2 = $IntArray[$intOpCode+2]}
        if ($Param1 -lt $Param2) {
            $IntArray[$IntArray[$intOpCode+3]] = 1
        } else {
            $IntArray[$IntArray[$intOpCode+3]] = 0
        }
        $IntOpCode = $IntOpCode + 4
      }
      if ($OpCode -eq 8) {  #equals
        if ($ModeC -eq 0 ) { $Param1 = $IntArray[$IntArray[$intOpCode+1]]} else {$Param1 = $IntArray[$intOpCode+1]}
        if ($ModeB -eq 0 ) { $Param2 = $IntArray[$IntArray[$intOpCode+2]]} else {$Param2 = $IntArray[$intOpCode+2]}
        if ($Param1 -eq $Param2) {
            $IntArray[$IntArray[$intOpCode+3]] = 1
        } else {
            $IntArray[$IntArray[$intOpCode+3]] = 0
        }
        $IntOpCode = $IntOpCode + 4
      }
    } until ($OpCode -eq 99)
  }
  
  
$IntCode = @(3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0)
#$IntCode = @(3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99)
$ToTest = @(4,3,2,1,0)

$IntCode = @(3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0)
$ToTest = @(0,1,2,3,4)

$IntCode = @(3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0)
$ToTest = @(1,0,4,3,2)

$IntCode = @(3,8,1001,8,10,8,105,1,0,0,21,38,55,64,81,106,187,268,349,430,99999,3,9,101,2,9,9,1002,9,2,9,101,5,9,9,4,9,99,3,9,102,2,9,9,101,3,9,9,1002,9,4,9,4,9,99,3,9,102,2,9,9,4,9,99,3,9,1002,9,5,9,1001,9,4,9,102,4,9,9,4,9,99,3,9,102,2,9,9,1001,9,5,9,102,3,9,9,1001,9,4,9,102,5,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,99)

$list = 0, 1, 2, 3,4
$AllCombinations = Get-AllCombinations $list


#$Amp = 0; $ToTest | foreach {$Amp = IntCodeProcessor -intArray $IntCode.clone() -value @($_,$Amp)}; $Amp

$Global:Signal = 0
$AllCombinations | foreach {
    $Amp = 0
    $ToTest = $_
    $ToTest | foreach {
        $Amp = IntCodeProcessor -intArray $IntCode.clone() -value @($_,$Amp)
    }
    if ($Amp -gt $Global:Signal) {$Global:Signal = $Amp}
}

