#Failed - Jobs ran - but per cycle processing was around 7000 objects per 10 seconds

$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
#$Source = Get-Content .\I.txt -Raw

$Stones = $Source.split(" ") | foreach {[int]$_}

function Test-Stone {
    param ($Stone)
    
    $ToReturn = $null

    if ($Stone -eq 0) {
        $ToReturn = 1
    } elseif (([string]$stone).length % 2 -eq 0) { 
      #$SplitStone =  [string]$Stone
      #$ToReturn = @([bigint]$SplitStone.Substring(0,$SplitStone.length/2),[bigint]$SplitStone.Substring($SplitStone.length/2,$SplitStone.length/2) )    
      $SplitStone = $Stone -split('\B')
      $ToReturn = @([int]($SplitStone[0..(($SplitStone.count/2)-1)] -join ''),[int]($SplitStone[($SplitStone.count/2)..($SplitStone.Count-1)] -join ''))
    } else {
        $ToReturn = $Stone * 2024
    }

    $ToReturn
}

$MaxBlinks = 15

$MaxQueues = 15

$FinalBlink = ([System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new()))

$AllQueues = ([System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new()))

1..$MaxQueues | foreach {
    #$VarName = $('Queue' + $_)
    #if (get-variable -name $VarName -ErrorAction SilentlyContinue) {Remove-Variable -Name $VarName}
    #New-Variable -Name $VarName -Value (New-Object System.Collections.Generic.List[System.Object])

    #New-Variable -Name $VarName -Value ([System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new()))
    $AllQueues.add([System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new())) | out-null
}

<#
$ScriptBlockTemplate = @'
$Blink = $using:blink<<from>>; $NextBlink = $using:blink<<to>>; while ($True) { if ($blink.count -gt 0) { $NextBlink.add($blink[0]); $blink.remove($blink[0])  } else {start-sleep -Milliseconds 500} } 
'@
#>

$ScriptBlockTemplate = @'
function Test-Stone {
    param ($Stone)
    
    $ToReturn = $null

    if ($Stone -eq 0) {
        $ToReturn = 1
    } elseif (([string]$stone).length % 2 -eq 0) { 
      #$SplitStone =  [string]$Stone
      #$ToReturn = @([bigint]$SplitStone.Substring(0,$SplitStone.length/2),[bigint]$SplitStone.Substring($SplitStone.length/2,$SplitStone.length/2) )    
      $SplitStone = $Stone -split('\B')
      $ToReturn = @([int]($SplitStone[0..(($SplitStone.count/2)-1)] -join ''),[int]($SplitStone[($SplitStone.count/2)..($SplitStone.Count-1)] -join ''))
    } else {
        $ToReturn = $Stone * 2024
    }

    $ToReturn
}
$BlinkToAddTo = $using:FinalBlink;  $Queue = $($using:Allqueues)[<<from>>]; $AllQueuesinQ = $using:AllQueues; $MaxQueuesinQ = $using:MaxQueues; $maxBlinksinQ = $using:MaxBlinks; while ($True) { if ($queue.count -gt 0) { if ($maxBlinksinQ -eq $queue[0].Blink) {$BlinkToAddTo.Add($Queue[0]) | out-null; $queue.remove($Queue[0]) | out-null} else {Test-Stone -Stone $queue[0].value | select-object -Property @{N='Blink';E={$Queue[0].Blink+1}},@{N='Value';E={$_}} | foreach {$AllQueuesInQ[(get-random -Minimum 0 -Maximum ($MaxQueuesinQ))].add($_) | out-null}; $queue.remove($Queue[0]) | out-null  }} else {start-sleep -Milliseconds 500} } 
'@

#$BlinkToAddTo = $using:FinalBlink;  $Queue = $($using:Allqueues)[<<from>>]; $AllQueuesinQ = $using:AllQueues; $MaxQueuesinQ = $using:MaxQueues;$NextQueue = $using:queue<<to>>; $maxBlinksinQ = $using:MaxBlinks; while ($True) { if ($queue.count -gt 0) { if ($maxBlinksinQ -eq $queue[0].Blink) {$BlinkToAddTo.Add($Queue[0]) | out-null; $queue.remove($Queue[0]) | out-null} else {Test-Stone -Stone $queue[0].value | select-object -Property @{N='Blink';E={$Queue[0].Blink+1}},@{N='Value';E={$_}} | foreach {$AllQueuesInQ[(get-random -Minimum 0 -Maximum ($MaxQueuesinQ))].add($_) | out-null}; $queue.remove($Queue[0]) | out-null  }} else {start-sleep -Milliseconds 500} } 
#$Queue = $using:queue<<from>>; $NextQueue = $using:queue<<to>>; while ($True) { if ($queue.count -gt 0) { $NewStone = (Test-Stone -Stone $queue[0]); if ($NewStone -is [object] ) { $NewStone | foreach {$NextQueue.add($_)|out-null}} else {$NextQueue.add($NewStone) | out-null}; $queue.remove($blink[0]) | out-null  } else {start-sleep -Milliseconds 500} } 

get-job | remove-job -force
0..($MaxQueues-1) | foreach {
  if ($_ -eq $MaxQueues-1) {
    $ScriptBlock = $ScriptBlockTemplate.replace('<<from>>',$_).replace('<<to>>',0)
  } else {
    $ScriptBlock = $ScriptBlockTemplate.replace('<<from>>',$_).replace('<<to>>',$_+1)
  }
  start-threadjob -name $('Queue' + $_) -ScriptBlock $([scriptblock]::create($ScriptBlock)) -ThrottleLimit $MaxQueues
  #start-job -name $('Queue' + $_) -ScriptBlock $([scriptblock]::create($ScriptBlock))
}

<#
$Stones | foreach {
  $NewStone = (Test-Stone -Stone $_)
  if ($NewStone -is [object] ) {
    $NewStone | foreach {
      $Queue1.add($_)
    }
  } else {
    $Queue1.add($NewStone)
  }  
}
#>

#$Stones | foreach {test-stone -stone $_ | select-object -Property @{N='Blink';E={1}},@{N='Value';E={$_}} | foreach {$Queue1.add($_)} }
$Stones | foreach {test-stone -stone $_ | select-object -Property @{N='Blink';E={1}},@{N='Value';E={$_}} | foreach {$AllQueues[0].add($_)} }


while ($true) {
    start-sleep -seconds 2
  $Countall = $Allqueues | foreach { $_.count}
  $Countall
  #if (($Countall | Group-Object | where {$_.name -ne 0}).count -eq 1) {
    #get-job -state running | Remove-Job -Force; get-job  
    #get-job -state running | Stop-job
  #}
  write-host $('CurrentTotal: ' + ($AllQueues | foreach {$_.count} | Measure-Object -Sum).sum)
  write-host $('FinalBlink: ' + $FinalBlink.count)
}

(get-variable -name ('Blink' + $MaxBlinks)).value.count
#>
#Answer
#