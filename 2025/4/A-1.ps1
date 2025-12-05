$Source = Get-Content .\ex.txt
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt

$map = [ordered]@{}

for ($i=0; $i -lt $Source.count; $i++) { $Map.add($i,$Source[$i].ToCharArray()) }


Function get-adjStatus {

    param(
        $x,
        $y,
        $map
    )

    $GridToCheckX = ($x-1)..($x+1)
    $GridToCheckY = ($y-1)..($y+1)

    $XMax = $Map.Count
    $YMax = $Map[0].count

    if ( $map[$x][$y] -ne '@'  ) { 'NA - NOT a Roll'; break  }

    $GridToCheck = $GridToCheckX | foreach {
        $GridX = $_; ($GridToCheckY | foreach {
            $GridY = $_
            switch (@($GridX;$GridY) -join ',') {
                 {[int]$_.split(',')[0] -lt 0} {'-'}
                 {[int]$_.split(',')[1] -lt 0} {'-'}
                 {[int]$_.split(',')[0] -ge $XMax} {'-'}
                 {[int]$_.split(',')[1] -ge $YMax} {'-'}
                 default { $map[[int]$_.split(',')[0]][[int]$_.split(',')[1]] }
             }
            
        }) -join ''
    }

    (($GridToCheck -join '').tochararray() | Group-Object | where {$_.Name -eq '@'}).count -1

}

$XMax = $Map.Count-1
$YMax = $Map[0].count-1

$fMap = 0..$XMax | foreach {
    $x = $_; (0..$YMax | foreach { 
        $y = $_; switch ($map[$x][$y]) { 
            '@' { if ((get-adjStatus -x $x -y $y -map $map) -lt 4 ) { 'X' } else { $_ }   }
            default {$_}
         }
    }) -join ''
}

(($fMap -join '').tochararray() | Group-Object | where {$_.Name -eq 'X'}).count

#Answer
#1495