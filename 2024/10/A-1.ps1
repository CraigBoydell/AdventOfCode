$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

$Map = New-Object System.Collections.Generic.List[System.Object]
$SourceSplit | foreach {$Map.add($_.trim().Tochararray())}

$MaxX = $Map.count-1
$MaxY = $Map[0].count-1

$StartPoints = 0..$MaxX | foreach {
    $x = $_; 0..$MaxY | foreach { 
        $y = $_; if ($Map[$x][$y] -eq '0') { 
            new-object -type PSCustomObject -Property @{StartPoint=$Map[$x][$y]; x=$x; y=$y }
        }
    }
}

function Get-NextStep {
  param ($CurrentStepX, $CurrentStepY,$Direction)

  if ($CurrentStepX -ge 0 -and $CurrentStepY -ge 0 ) { #-and $CurrentStepX -lt $MaxX -and $CurrentStepY -lt $MaxY

    $StepValue = $Map[$CurrentStepX][$CurrentStepY]
    #write-host $StepValue
    $ToReturnX = $null; $ToReturnY = $null
    switch ($Direction) {
        'U' { if ($($Map[$CurrentStepX-1][$CurrentStepY] - $StepValue) -eq 1) { $ToReturnX=$CurrentStepX-1;$ToReturnY = $CurrentStepY } }
        'D' { if ($($Map[$CurrentStepX+1][$CurrentStepY] - $StepValue) -eq 1) { $ToReturnX=$CurrentStepX+1;$ToReturnY = $CurrentStepY }} 
        'L' { if ($($Map[$CurrentStepX][$CurrentStepY-1] - $StepValue) -eq 1) { $ToReturnX=$CurrentStepX;$ToReturnY = $CurrentStepY-1 }}
        'R' { if ($($Map[$CurrentStepX][$CurrentStepY+1] - $StepValue) -eq 1) { $ToReturnX=$CurrentStepX;$ToReturnY = $CurrentStepY+1 }}
    }

    if (-not [string]::IsNullOrEmpty($ToReturnX)) {
      New-Object -Property $([ordered]@{X=$ToReturnX;Y=$ToReturnY;height=$Map[$ToReturnX][$ToReturnY]}) -TypeName PSCustomObject
      #write-host $Map[$ToReturnX][$ToReturnY]
      if ($Map[$ToReturnX][$ToReturnY] -ne '9') { @('U','D','L','R') | foreach { get-NextStep -CurrentStepX $ToReturnX -CurrentStepY $ToReturnY -Direction $_}  }
    }
  }
}

<#
$StartPoints | foreach {
  $Steps = New-Object System.Collections.Generic.List[System.Object]


}
#>

($StartPoints | foreach { $StartPoint = $_; (@('U','D','L','R') | foreach { get-NextStep -CurrentStepX $StartPoint.x -CurrentStepY $StartPoint.y -Direction $_} | where {$_.Height -eq '9'} | Select-Object -Unique -Property x,y,height).count}) | Measure-Object -sum

#Answer
#611
