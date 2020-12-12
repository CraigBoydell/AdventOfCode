Function Check-FrontBack {
  param (
    $Start = 0,
    $End = 127,
    $FrontOrBack
  )
  $Front = @{ start = $Start; end = $($Start + $($Start..$End).count /2) -1}
  $Back = @{ start= $Start + $($($Start..$End).count /2); end = $End  }
  switch ($FrontOrBack) {
    'F' {$Front}
    'L' {$Front}
    'B' {$Back}
    'R' {$Back}
  }
}

$BoardingPasses = @'
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
'@
$BoardingPasses = $BoardingPasses.split("`n")

$BoardingPasses = get-content .\I.txt

$BoardingPassScanResult = $BoardingPasses | foreach-object {
  $BoardingPass = $_
  $Result = @{start = 0; End = 127}; $BoardingPass.toCharArray()[0..6] | foreach-Object { $Result = Check-FrontBack -start $Result.Start -end $Result.end -FrontOrBack $_  }
  $Row = $Result.start
  $Result = @{start = 0; End = 7}; $BoardingPass.toCharArray()[7..9] | foreach-Object { $Result = Check-FrontBack -start $Result.Start -end $Result.end -FrontOrBack $_  }
  $Column = $Result.start
  $_ | Select-Object -Property @{N='BoardingPass';E={$_}},@{N='Row';E={$Row}},@{N='Column';E={$Column}},@{N='SeatID';E={($Row*8)+$Column}}
  #($Row*8)+$Column
}

$BoardingPassScanResult | sort-object -Property SeatID | Select-Object -last 1