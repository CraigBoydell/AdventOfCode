$SeatMap = @'
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
'@
$SeatMap = $SeatMap -split "`r?`n"
$SeatMap = get-content '.\I.txt'
$NewSeatMap = $Null
$Iteration = 1

do {
  write-progress -Activity $('Iteration: ' + $Iteration)
  if ($NewSeatMap -ne $null) { $SeatMap = $NewSeatMap.clone()  }

# Create a new array, defaults to Object[], so can contain arrays as well
#$MultiDimensionalSeats = @()
$MultiDimensionalSeats = New-Object -TypeName "System.Collections.ArrayList"

# Iterate over each string in $Services
foreach($SeatString in $SeatMap){
    # use the unary array operator (,) to avoid flattening the array
    #$MultiDimensionalSeats += ,$SeatString.tochararray()
    $MultiDimensionalSeats.add($SeatString.tochararray()) | out-null
}

$Row = 0
$NewSeatMap = New-Object -TypeName "System.Collections.ArrayList"
do {
  $Seat = 0
  $NextRow = do {
    $Up = if (($Row-1) -ge 0) {$MultiDimensionalSeats[($Row-1)][($(if ($Seat -ne 0) {$Seat-1} else {0}))..($Seat+1)]} else {$null}
    $Down  = if (($Row+1) -lt $MultiDimensionalSeats.count) {$MultiDimensionalSeats[($Row+1)][($(if ($Seat -ne 0) {$Seat-1} else {0}))..($Seat+1)]} else {$null}
    $Current = $MultiDimensionalSeats[($Row)][($(if ($Seat -ne 0) {$Seat-1} else {0}))..($Seat+1)]
    if ($MultiDimensionalSeats[$Row][$Seat] -eq '.') {'.'} else {
      if ($MultiDimensionalSeats[$Row][$Seat] -eq 'L' -and @($($Current; $Up; $Down) | where-object {$_ -eq '#'}).count -eq 0) {'#'} elseif ($MultiDimensionalSeats[$Row][$Seat] -eq '#' -and @($($Current; $Up; $Down) | where-object {$_ -eq '#'}).count -gt 4) {'L'} else {$MultiDimensionalSeats[$Row][$Seat] }
    }
    $Seat++
  } until ($Seat -gt $($MultiDimensionalSeats[($Row)]).count )

 $NewSeatMap.add($($NextRow -join '')) | out-null
 $row++
} until ($Row -ge $MultiDimensionalSeats.count )

$Iteration++
} until ((Compare-Object -ReferenceObject $SeatMap -DifferenceObject $NewSeatMap) -eq $NUll)
($SeatMap.ToCharArray() | Group-Object | where {$_.Name -eq '#'}).count