$start = Get-Content .\I.txt
$rounds = 6

$4d = New-Object 'int[,,,]' (2 + $start.count + $rounds * 2),(2+ $start[0].Length +  $rounds * 2), (2 + 1 + $rounds * 2),(2 + $rounds * 2)

for($i = 0; $i -lt $start.count; $i++){
  for($j = 0; $j -lt $start.count; $j++){
    if($start[$i][$j] -eq "#"){
      $4d[(2 + $rounds + $i),(2 + $rounds + $j),(2 + $rounds),(2 + $rounds)] = 1
    }
  }
}

function Get-SurroundCount{
  param(
    $x,$y,$z,$w
  )
  $4d[($x - 1),($y - 1),($z - 1),$w] +
  $4d[($x - 0),($y - 1),($z - 1),$w] +
  $4d[($x + 1),($y - 1),($z - 1),$w] +
  $4d[($x - 1),($y - 0),($z - 1),$w] +
  $4d[($x - 0),($y - 0),($z - 1),$w] +
  $4d[($x + 1),($y - 0),($z - 1),$w] +
  $4d[($x - 1),($y + 1),($z - 1),$w] +
  $4d[($x - 0),($y + 1),($z - 1),$w] +
  $4d[($x + 1),($y + 1),($z - 1),$w] +
  $4d[($x - 1),($y - 1),($z + 1),$w] +
  $4d[($x - 0),($y - 1),($z + 1),$w] +
  $4d[($x + 1),($y - 1),($z + 1),$w] +
  $4d[($x - 1),($y - 0),($z + 1),$w] +
  $4d[($x - 0),($y - 0),($z + 1),$w] +
  $4d[($x + 1),($y - 0),($z + 1),$w] +
  $4d[($x - 1),($y + 1),($z + 1),$w] +
  $4d[($x - 0),($y + 1),($z + 1),$w] +
  $4d[($x + 1),($y + 1),($z + 1),$w] +
  $4d[($x - 1),($y - 1),($z - 0),$w] +
  $4d[($x - 0),($y - 1),($z - 0),$w] +
  $4d[($x + 1),($y - 1),($z - 0),$w] +
  $4d[($x - 1),($y - 0),($z - 0),$w] +
  $4d[($x + 1),($y - 0),($z - 0),$w] +
  $4d[($x - 1),($y + 1),($z - 0),$w] +
  $4d[($x - 0),($y + 1),($z - 0),$w] +
  $4d[($x + 1),($y + 1),($z - 0),$w] +
  $4d[($x - 1),($y - 1),($z - 1),($w+1)] +
  $4d[($x - 0),($y - 1),($z - 1),($w+1)] +
  $4d[($x + 1),($y - 1),($z - 1),($w+1)] +
  $4d[($x - 1),($y - 0),($z - 1),($w+1)] +
  $4d[($x - 0),($y - 0),($z - 1),($w+1)] +
  $4d[($x + 1),($y - 0),($z - 1),($w+1)] +
  $4d[($x - 1),($y + 1),($z - 1),($w+1)] +
  $4d[($x - 0),($y + 1),($z - 1),($w+1)] +
  $4d[($x + 1),($y + 1),($z - 1),($w+1)] +
  $4d[($x - 1),($y - 1),($z + 1),($w+1)] +
  $4d[($x - 0),($y - 1),($z + 1),($w+1)] +
  $4d[($x + 1),($y - 1),($z + 1),($w+1)] +
  $4d[($x - 1),($y - 0),($z + 1),($w+1)] +
  $4d[($x - 0),($y - 0),($z + 1),($w+1)] +
  $4d[($x + 1),($y - 0),($z + 1),($w+1)] +
  $4d[($x - 1),($y + 1),($z + 1),($w+1)] +
  $4d[($x - 0),($y + 1),($z + 1),($w+1)] +
  $4d[($x + 1),($y + 1),($z + 1),($w+1)] +
  $4d[($x - 1),($y - 1),($z - 0),($w+1)] +
  $4d[($x - 0),($y - 1),($z - 0),($w+1)] +
  $4d[($x + 1),($y - 1),($z - 0),($w+1)] +
  $4d[($x - 1),($y - 0),($z - 0),($w+1)] +
  $4d[($x + 1),($y - 0),($z - 0),($w+1)] +
  $4d[($x - 1),($y + 1),($z - 0),($w+1)] +
  $4d[($x - 0),($y + 1),($z - 0),($w+1)] +
  $4d[($x + 1),($y + 1),($z - 0),($w+1)] +
  $4d[($x + 0),($y + 0),($z - 0),($w+1)] +
  $4d[($x - 1),($y - 1),($z - 1),($w-1)] +
  $4d[($x - 0),($y - 1),($z - 1),($w-1)] +
  $4d[($x + 1),($y - 1),($z - 1),($w-1)] +
  $4d[($x - 1),($y - 0),($z - 1),($w-1)] +
  $4d[($x - 0),($y - 0),($z - 1),($w-1)] +
  $4d[($x + 1),($y - 0),($z - 1),($w-1)] +
  $4d[($x - 1),($y + 1),($z - 1),($w-1)] +
  $4d[($x - 0),($y + 1),($z - 1),($w-1)] +
  $4d[($x + 1),($y + 1),($z - 1),($w-1)] +
  $4d[($x - 1),($y - 1),($z + 1),($w-1)] +
  $4d[($x - 0),($y - 1),($z + 1),($w-1)] +
  $4d[($x + 1),($y - 1),($z + 1),($w-1)] +
  $4d[($x - 1),($y - 0),($z + 1),($w-1)] +
  $4d[($x - 0),($y - 0),($z + 1),($w-1)] +
  $4d[($x + 1),($y - 0),($z + 1),($w-1)] +
  $4d[($x - 1),($y + 1),($z + 1),($w-1)] +
  $4d[($x - 0),($y + 1),($z + 1),($w-1)] +
  $4d[($x + 1),($y + 1),($z + 1),($w-1)] +
  $4d[($x - 1),($y - 1),($z - 0),($w-1)] +
  $4d[($x - 0),($y - 1),($z - 0),($w-1)] +
  $4d[($x + 1),($y - 1),($z - 0),($w-1)] +
  $4d[($x - 1),($y - 0),($z - 0),($w-1)] +
  $4d[($x + 1),($y - 0),($z - 0),($w-1)] +
  $4d[($x - 1),($y + 1),($z - 0),($w-1)] +
  $4d[($x - 0),($y + 1),($z - 0),($w-1)] +
  $4d[($x + 1),($y + 1),($z - 0),($w-1)] +
  $4d[($x + 0),($y + 0),($z - 0),($w-1)]
}

for($i = 0; $i -lt $rounds; $i++){
  $new4d = New-Object 'int[,,,]' (2 + $start.count + $rounds * 2),(2+ $start[0].Length +  $rounds * 2), (2 + 1 + $rounds * 2),(2 + $rounds * 2)
  for($j = 1; $j -le (1 + $start.count + $rounds * 2); $j++){
    for($k = 1; $k -le (1 +  $start[0].Length + $rounds * 2); $k++){
      for($L = 1; $L -le (2 + $rounds * 2); $L++){
        for($m = 0; $m -le (2 + $rounds * 2) ;$m++){
          $sc = Get-SurroundCount $j $k $l $m
          if($4d[$j,$k,$l,$m] -eq 1){
            if($sc -eq 2 -or $sc -eq 3 ){
                $new4d[$j,$k,$l,$m] = 1
            } else {
                $new4d[$j,$k,$l,$m] = 0
            }
          }
          if($4d[$j,$k,$l,$m] -eq 0){
            if ($sc -eq 3){
                $new4d[$j,$k,$l,$m] = 1
            } else {
                $new4d[$j,$k,$l,$m] = 0
            }
          }
        }
      }
    }
  }
  $4d = $new4d
}
foreach($a in $4d){$b = $b + $a}
$b