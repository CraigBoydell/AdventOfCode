$intArrays[0] = @(1,0,0,0,99)
$intArrays[1] = @(2,3,0,3,99)
$intArrays[2] = @(2,4,4,5,99,0)
$intArrays[3] = @(1,1,1,4,99,5,6,0,99)
$intArrays[4] = @(1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,6,19,23,2,23,6,27,2,6,27,31,2,13,31,35,1,10,35,39,2,39,13,43,1,43,13,47,1,6,47,51,1,10,51,55,2,55,6,59,1,5,59,63,2,9,63,67,1,6,67,71,2,9,71,75,1,6,75,79,2,79,13,83,1,83,10,87,1,13,87,91,1,91,10,95,2,9,95,99,1,5,99,103,2,10,103,107,1,107,2,111,1,111,5,0,99,2,14,0,0)
$intArrays[5] = @(1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,6,19,23,2,23,6,27,2,6,27,31,2,13,31,35,1,10,35,39,2,39,13,43,1,43,13,47,1,6,47,51,1,10,51,55,2,55,6,59,1,5,59,63,2,9,63,67,1,6,67,71,2,9,71,75,1,6,75,79,2,79,13,83,1,83,10,87,1,13,87,91,1,91,10,95,2,9,95,99,1,5,99,103,2,10,103,107,1,107,2,111,1,111,5,0,99,2,14,0,0)

$intArrays[0..$($intArrays.count-1)] | ForEach-Object {

  $IntArray = $_

  $Step = 4
  $i = 0
  do {
    $IntOpCode = $i * $Step
    #'intOpCode:' + $IntOpCode
    $IntArray[$intOpCode]
    $OpCode = $IntArray[$intOpCode]
    if ($OpCode -eq 1) {
      $IntArray[$IntArray[$intOpCode+3]] = $IntArray[$IntArray[$intOpCode+1]] + $IntArray[$IntArray[$intOpCode+2]]    
    }
    if ($OpCode -eq 2) {
      $IntArray[$IntArray[$intOpCode+3]] = $IntArray[$IntArray[$intOpCode+1]] * $IntArray[$IntArray[$intOpCode+2]]    
    }
    $i++
  } until ($OpCode -eq 99)
  $intArray -join ','
}