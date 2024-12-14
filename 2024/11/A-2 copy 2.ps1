#Success - Recursive and Hashtable for cache results

$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$Stones = $Source.split(" ")

$global:stonecache = @{}

function Test-Stone2 {
  param ([string]$Stone, [int]$numBlinks)
  
  if ($numBlinks -eq 0) {
    return 1
  }

  if(!$global:stonecache[$stone]){
    $global:stonecache.Add($stone, @{})
  }

  if($global:stonecache[$stone][($numBlinks)]){
    return $global:stonecache[$stone][($numBlinks)] 
  } elseif ($Stone -eq 0) {
    $global:stonecache[$stone].Add(($numBlinks),(Test-Stone2 -stone 1 -numBlinks ($numBlinks-1)))
    return $global:stonecache[$stone][($numBlinks)]
  } elseif (($stone).length % 2 -eq 0) { 
    $ToReturn = @([long]$Stone.Substring(0,$Stone.length/2),[long]$Stone.Substring($Stone.length/2,$Stone.length/2) )    
    $global:stonecache[$stone].Add(($numBlinks),(Test-Stone2 -Stone $ToReturn[0] -numBlinks ($numBlinks-1)) + (Test-Stone2 -Stone $ToReturn[1] -numBlinks ($numBlinks-1)))
    return $global:stonecache[$stone][($numBlinks)]
  } else {
    $global:stonecache[$stone].Add(($numBlinks),(Test-Stone2 -Stone ([long]$Stone*2024) -numBlinks ($numBlinks-1)))
    return $global:stonecache[$stone][($numBlinks)]
  }
}

#$Stones | foreach { test-stone2 -Stone $_ -numBlinks 25  }

#measure-command {
($Stones | foreach { test-stone2 -Stone $_ -numBlinks 75  } | Measure-Object -sum).sum
#}
#Answer
#223767210249237