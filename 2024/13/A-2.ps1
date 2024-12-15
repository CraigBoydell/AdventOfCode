$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`r`n`r`n")

$ToAdd = 10000000000000

$MachineConfigs = $SourceSplit | foreach { $Line = $_.split("`r`n"); $Configs = [ordered]@{'Ax'=$Line[0].split(': ')[1].split(', ')[0].split('+')[1].trim();'Ay'=$Line[0].split(': ')[1].split(', ')[1].split('+')[1].trim();'Bx'=$Line[1].split(': ')[1].split(', ')[0].split('+')[1].trim();'By'=$Line[1].split(': ')[1].split(', ')[1].split('+')[1].trim();'Px'=[long]$($Line[2].split(': ')[1].split(', ')[0].split('=')[1].trim()) + $ToAdd;'Py'=[long]$($Line[2].split(': ')[1].split(', ')[1].split('=')[1].trim()) + $ToAdd}; new-object -TypeName PSCustomObject -Property $Configs  }

<# Exaple formula processing

a = (c*y2 - d*x2) / (x1*y2 - y1*x2)
b = (d*x1 - c*y1) / (x1*y2 - y1*x2)

c= 8400
d= 5400

x1 = 94, y1 = 34
x2 = 22, y2 = 67

(8400*67 - 5400*22) / (94*67 - 34*22)

(562800 - 118800 ) / (6298 - 748)

444000 / 5550

80

#>

Function get-SimulEquation {
    param(
      [int]$x1,
      [int]$y1,
      [int]$x2,
      [int]$y2,
      [long]$Cx,
      [long]$Cy
    )

    $ToReturnX = (($Cx*$y2) - ($Cy*$x2) ) / ( ($x1*$y2) - ($y1*$x2) ) 
    $ToReturnY = (($Cy*$x1) - ($Cx*$y1) ) / ( ($x1*$y2) - ($y1*$x2) )

    new-object -property @{X=$ToReturnX;Y=$ToReturnY} -TypeName PSCustomObject

}

$MachineConfigs = $MachineConfigs | Select-Object -Property *,@{N='SimulEquation';E={get-SimulEquation -x1 $_.Ax -y1 $_.Ay -x2 $_.Bx -y2 $_.By -Cx $_.Px -Cy $_.Py}}
$MachineConfigs = $MachineConfigs | select-object -Property *,@{N='isPossible';E={($_.SimulEquation.X % 1 -eq 0 -and $_.SimulEquation.y % 1 -eq 0)}}

$MachineConfigs | where {$_.isPossible -eq $True} | measure-object -Property {$_.SimulEquation.X * 3 + $_.SimulEquation.Y  } -Sum


#Answer
#73458657399094