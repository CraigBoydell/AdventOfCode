#Doesn't work when called as script, copy and paste into powershell
#Example: 
$i = @'
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
'@

$i = $i -split "`n"

$i = get-content I.txt


$CoOrds = $i | Select-Object -Property @{N='From';E={($_ -split ' -> ')[0] -split (',')}},@{N='To';E={($_ -split ' -> ')[1] -split (',')}}
#$CoOrds
$StraightLines = $CoOrds | where-object {($_.from)[0] -eq ($_.To)[0] -or ($_.from)[1] -eq ($_.To)[1]}
$DiagonalLines = $CoOrds | where-object {($_.from)[0] -ne ($_.To)[0] -and ($_.from)[1] -ne ($_.To)[1]}
[int]$LargestX = $(($CoOrds |Select-Object -Property From) | foreach-object {($_.from)[0]}; ($StraightLines |Select-Object -Property To) | foreach-object {($_.To)[0]}) | Sort-Object -Descending | Select-Object -First 1
[int]$Largesty = $(($CoOrds |Select-Object -Property From) | foreach-object {($_.from)[1]}; ($StraightLines |Select-Object -Property To) | foreach-object {($_.To)[1]}) | Sort-Object -Descending | Select-Object -First 1
$LargestX++;$Largesty++
$LargestX++;$Largesty++
$LargestX
$Map =  New-Object 'object[,]' $Largestx,$Largesty

$StraightLines = $StraightLines | Select-Object -ExcludeProperty Plots -Property *,@{N='Plots';E={ $CoOrd = $_; if ($_.From[1] -eq $_.To[1]) { $_.From[0]..$_.To[0] | foreach-object {@{x=$_;y=$CoOrd.from[1]} }} else {$_.From[1]..$_.To[1] | foreach-object {@{x=$CoOrd.from[0];y=$_} }}    }  }
$DiagonalLines = $DiagonalLines | Select-Object -ExcludeProperty Plots -Property *,@{N='Plots';E={ $x=$_.From[0]..$_.To[0];$y = $_.From[1]..$_.To[1]; for ($t=0; $t -lt $x.count;$t++) {@{x=$x[$t];y=$y[$t]}}    }  }
$StraightLines | foreach-object {$_.plots | foreach-object {$map[$_.x,$_.y] = [int]$map[$_.x,$_.y] + 1}}
$DiagonalLines | foreach-object {$_.plots | foreach-object {$map[$_.x,$_.y] = [int]$map[$_.x,$_.y] + 1}}

($map | where-object {$_ -ge 2}).COUNT