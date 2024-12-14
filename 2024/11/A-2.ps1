#Failed - Took too long

$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$Stones = $Source.split(" ") | foreach {[int]$_}

function Test-Stone {
    param ($Stone)
    
    $ToReturn = $null

    if ($Stone -eq 0) {
        $ToReturn = 1
    } elseif (([string]$stone).length % 2 -eq 0) { 
      $SplitStone =  [string]$Stone
      $ToReturn = @([bigint]$SplitStone.Substring(0,$SplitStone.length/2),[bigint]$SplitStone.Substring($SplitStone.length/2,$SplitStone.length/2) )    
    } else {
        $ToReturn = $Stone * 2024
    }

    $ToReturn
}

$MaxBlinks = 75

1..$MaxBlinks | foreach {
    $VarName = $('Blink' + $_)
    if (get-variable -name $VarName -ErrorAction SilentlyContinue) {Remove-Variable -Name $VarName}
    #New-Variable -Name $VarName -Value (New-Object System.Collections.Generic.List[System.Object])

    New-Variable -Name $VarName -Value ([System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new()))
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
      $SplitStone =  [string]$Stone
      $ToReturn = @([bigint]$SplitStone.Substring(0,$SplitStone.length/2),[bigint]$SplitStone.Substring($SplitStone.length/2,$SplitStone.length/2) )    
    } else {
        $ToReturn = $Stone * 2024
    }

    $ToReturn
}
$Blink = $using:blink<<from>>; $NextBlink = $using:blink<<to>>; while ($True) { if ($blink.count -gt 0) { $NewStone = (Test-Stone -Stone $blink[0]); if ($NewStone -is [object] ) { $NewStone | foreach {$NextBlink.add($_)|out-null}} else {$NextBlink.add($NewStone) | out-null}; $blink.remove($blink[0]) | out-null  } else {start-sleep -Milliseconds 500} } 
'@

get-job | remove-job -force
1..($MaxBlinks-1) | foreach {
  $ScriptBlock = $ScriptBlockTemplate.replace('<<from>>',$_).replace('<<to>>',$_+1)
  start-threadjob -name $('Blink' + $_) -ScriptBlock $([scriptblock]::create($ScriptBlock)) -ThrottleLimit $MaxBlinks
}

$Stones | foreach { $NewStone = (Test-Stone -Stone $_); if ($NewStone -is [object] ) { $NewStone | foreach {$Blink1.add($_)}} else {$Blink1.add($NewStone)}  }

while ($true) {
    start-sleep -seconds 10
  $Countall = 1..$MaxBlinks | foreach {(get-variable -name $('Blink'+$_)).value.count}
  $Countall
  #if (($Countall | Group-Object | where {$_.name -ne 0}).count -eq 1) {
    #get-job -state running | Remove-Job -Force; get-job  
    #get-job -state running | Stop-job
  #}
  
}

(get-variable -name ('Blink' + $MaxBlinks)).value.count
#>
#Answer
#