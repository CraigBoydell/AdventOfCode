$Source = Get-Content .\ex3.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

Function Get-LCM {
  param(
    $Numbers
  )
  $FoundFactors=@()
  [System.Double]$product=1
  foreach ($Number in $Numbers) {
    $sqrt=[math]::sqrt($number)
    $Factor=2
    $count=0
    while ( ($Number % $Factor) -eq 0) {
        $count+=1
        $Number=$Number/$Factor
        if (($FoundFactors | Where-Object {$_ -eq $Factor}).count -lt $count) {
            $FoundFactors+=$Factor
        }
    }
    $count=0
    $Factor=3
    while ($Factor -le $sqrt) {
      while ( ($Number % $Factor) -eq 0) {
        $count+=1
        $Number=$Number/$Factor
        if (($FoundFactors | Where-Object {$_ -eq $Factor}).count -lt $count) {
          $FoundFactors+=$Factor
        }
      }           
      $Factor+=2
      $count=0
    }
      if ($FoundFactors -notcontains $Number) {
          $FoundFactors+=$Number
      }
  }
  foreach($Factor in $FoundFactors) {$product = $product * $Factor}
  $product
}

$Instruct = $SourceSplit[0].trim()
$InstructMax = $Instruct.trim().tochararray().Count
$InstructPTR = 0

$Map = $SourceSplit[2..($SourceSplit.count-1)]
$Map = $Map | Select-Object -Property @{N='Input';E={$_}},@{N='Node';E={$_.Split(' = ')[0]}},@{N='Next';E={$($_ -Split(" = "))[1].replace('(','').replace(')','').trim() -split ", "}}

$Steps = 0
$HTMap = @{}
$Map | foreach { $HTMap[$_.Node] = $_ }
#$Location = $HTMap['AAA']
$Location = $Map | where {$_.Node -like '*A'}

$DoLCM = $False

$PatternCapture = @()
Do {
  switch ($Instruct[$InstructPTR]) {
    'R' {$pick = 1}
    'L' {$pick = 0}
  }

  #Start-Sleep 1

  $Steps++
  #$Location = $HTMap[$Location.Next[$pick]]
  
  for ($y=0; $y -lt $Location.count; $y++) {
    $Location[$y] = $HTMap[$Location[$y].Next[$pick]]
    #$([string]$y + ': ' + $Location[$y].node)
    if ($Location[$y].Node -like '*Z') {[string]$y + ': ' + $Location[$y].Node + ' - ' + $Steps; $PatternCapture = $PatternCapture + $(New-Object -TypeName PSCustomObject -property @{id = $y; Node = $Location[$y].Node; Steps = $Steps})  }
  }

  #start-sleep 2

  $InstructPTR++
  if ($InstructPTR -ge $InstructMax) {$InstructPTR = 0}


  #$HTMap[$Location[$y].Next[$pick]]
  #$pick
  #if ( $Steps%10000 -eq 0 ) {$Steps;$Location.node}
  $GroupedPatternCapture = $PatternCapture | Group-Object -Property id
} until ( ($Location | where {$_.Node -like '*Z'}).count -eq $Location.count -or ($GroupedPatternCapture.count -eq $Location.count -and ($GroupedPatternCapture | where {$_.Count -gt 1}).count -eq $Location.count))

if (($GroupedPatternCapture.count -eq $Location.count -and ($GroupedPatternCapture | where {$_.Count -gt 1}).count -eq $Location.count) -eq $True) {$DoLCM = $True}

if ($DoLCM -eq $False) { 
  $Steps
} else {
  $LCMSource = $GroupedPatternCapture | Select-Object -Property Name,@{N='Repeating';e={$_.Group[1].Steps - $_.Group[0].steps}}
  Get-LCM -Numbers $LCMSource.repeating
}



# Optimise with LCM, by measuring the distance between Z repeating as it is the same per iteration.

# Answer:
# 12030780859469