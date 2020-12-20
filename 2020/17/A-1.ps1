$start = Get-Content .\I.txt
$rounds = 6

$3d = New-Object 'int[,,]' (2 + $start.count + $rounds * 2),(2+ $start[0].Length +  $rounds * 2), (2 + 1 + $rounds * 2)

for($i = 0; $i -lt $start.count; $i++){
    for($j = 0; $j -lt $start.count; $j++){
        if($start[$i][$j] -eq "#"){
            $3d[(2 + $rounds + $i),(2 + $rounds + $j),(2 + $rounds)] = 1
        }
    }
}

function Get-SurroundCount{
    param(
        $x,$y,$z
    )
    $3d[($x - 1),($y - 1),($z - 1)] +
    $3d[($x - 0),($y - 1),($z - 1)] +
    $3d[($x + 1),($y - 1),($z - 1)] +
    $3d[($x - 1),($y - 0),($z - 1)] +
    $3d[($x - 0),($y - 0),($z - 1)] +
    $3d[($x + 1),($y - 0),($z - 1)] +
    $3d[($x - 1),($y + 1),($z - 1)] +
    $3d[($x - 0),($y + 1),($z - 1)] +
    $3d[($x + 1),($y + 1),($z - 1)] +
    $3d[($x - 1),($y - 1),($z + 1)] +
    $3d[($x - 0),($y - 1),($z + 1)] +
    $3d[($x + 1),($y - 1),($z + 1)] +
    $3d[($x - 1),($y - 0),($z + 1)] +
    $3d[($x - 0),($y - 0),($z + 1)] +
    $3d[($x + 1),($y - 0),($z + 1)] +
    $3d[($x - 1),($y + 1),($z + 1)] +
    $3d[($x - 0),($y + 1),($z + 1)] +
    $3d[($x + 1),($y + 1),($z + 1)] +
    $3d[($x - 1),($y - 1),($z - 0)] +
    $3d[($x - 0),($y - 1),($z - 0)] +
    $3d[($x + 1),($y - 1),($z - 0)] +
    $3d[($x - 1),($y - 0),($z - 0)] +
    $3d[($x + 1),($y - 0),($z - 0)] +
    $3d[($x - 1),($y + 1),($z - 0)] +
    $3d[($x - 0),($y + 1),($z - 0)] +
    $3d[($x + 1),($y + 1),($z - 0)]
}

for($i = 0; $i -lt $rounds; $i++){
    $new3d = New-Object 'int[,,]' (2 + $start.count + $rounds * 2),(2+ $start[0].Length +  $rounds * 2), (2 + 1 + $rounds * 2)
    for($j = 1; $j -le (1 + $start.count + $rounds * 2); $j++){
        for($k = 1; $k -le (1 +  $start[0].Length + $rounds * 2); $k++){
            for($L = 1; $L -le (1 + $rounds * 2); $L++){
                $sc = Get-SurroundCount $j $k $l
                #$sc
                if($3d[$j,$k,$l] -eq 1){
                    if($sc -eq 2 -or $sc -eq 3 ){
                        $new3d[$j,$k,$l] = 1
                    } else {
                        $new3d[$j,$k,$l] = 0
                    }
                }
                if($3d[$j,$k,$l] -eq 0){
                    if ($sc -eq 3){
                        $new3d[$j,$k,$l] = 1
                    } else {
                        $new3d[$j,$k,$l] = 0
                    }
                }
            }
        }
    }
    $3d = $new3d
}
foreach($a in $3d){$b = $b + $a}
$b