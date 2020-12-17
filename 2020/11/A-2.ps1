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
#$SeatMap = get-content '.\I.txt'
$NewSeatMap = $Null
$Iteration = 1

Function Test-OccupiedSeatDirection {
  param(
    $Direction,
    $CurrentRow,
    $CurrentSeat,
    $SeatMapArray
  )
  switch ($Direction){
    "Up" {
      if ($CurrentRow -ne 0) {
        do { $i++ } until (($CurrentRow- $i) -lt 0 -or $($SeatMapArray[$CurrentRow- $i][$CurrentSeat]) -ne '.')
        if ($($SeatMapArray[$CurrentRow- $i][$CurrentSeat]) -eq '#') {$True} else {$false}
      } else {$false}
    }
    "Down" {
      if ($CurrentRow -ne ($SeatMapArray.count-1)) {
        do { $i++ } until (($CurrentRow+ $i) -ge ($SeatMapArray.count-1) -or $($SeatMapArray[$CurrentRow+ $i][$CurrentSeat]) -ne '.')
        if ($($SeatMapArray[$CurrentRow+ $i][$CurrentSeat]) -eq '#') {$True} else {$false}
      } else {$false}
    }
    "Left" {
      if ($CurrentSeat -ne 0) {
        do { $i++ } until (($CurrentSeat- $i) -le 0 -or $($SeatMapArray[$CurrentRow][$CurrentSeat-$i]) -ne '.')
        if ($($SeatMapArray[$CurrentRow][$CurrentSeat-$i]) -eq '#') {$True} else {$false}
        #write-host $i
      } else {$false}      
    }
    "Right" {
      if ($CurrentSeat -ne ($SeatMapArray[$CurrentRow].count-1)) {
        do { $i++ } until (($CurrentSeat+ $i) -ge ($SeatMapArray[$CurrentRow].count-1) -or $($SeatMapArray[$CurrentRow][$CurrentSeat+$i]) -ne '.')
        if ($($SeatMapArray[$CurrentRow][$CurrentSeat+$i]) -eq '#') {$True} else {$false}
      } else {$false}
    }
    "TopLeft" {
      if ($CurrentRow -ne 0 -and $CurrentSeat -ne 0) {
        do { $i++ } until (($CurrentRow- $i) -le 0 -or ($CurrentSeat- $i) -le 0 -or $($SeatMapArray[$CurrentRow-$i][$CurrentSeat-$i]) -ne '.')
        if ($($SeatMapArray[$CurrentRow-$i][$CurrentSeat-$i]) -eq '#') {$True} else {$false}
      } else {$false}
    }
    "TopRight" {
      if ($CurrentRow -ne 0 -and $CurrentSeat -ne ($SeatMapArray[$CurrentRow].count -1)) {
        do { $i++ } until (($CurrentRow- $i) -le 0 -or ($CurrentSeat+ $i) -ge ($SeatMapArray[$CurrentRow].count-1) -or $($SeatMapArray[$CurrentRow-$i][$CurrentSeat+$i]) -ne '.')
        #write-host $i
        if ($($SeatMapArray[$CurrentRow-$i][$CurrentSeat+$i]) -eq '#') {$True} else {$false}
      } else {$false}
    }
    "BottomLeft" {
      if ($CurrentRow -ne ($SeatMapArray.count -1) -and $CurrentSeat -ne 0) {
        do { $i++ } until (($CurrentRow+ $i) -ge ($SeatMapArray.count-1) -or ($CurrentSeat- $i) -le 0 -or $($SeatMapArray[$CurrentRow+$i][$CurrentSeat-$i]) -ne '.')
        if ($($SeatMapArray[$CurrentRow+$i][$CurrentSeat-$i]) -eq '#') {$True} else {$false}
      } else {$false}
    }
    "BottomRight" {
      if ($CurrentRow -ne ($SeatMapArray.count -1) -and $CurrentSeat -ne ($SeatMapArray[$CurrentRow].count -1)) {
        do { $i++ } until (($CurrentRow+ $i) -ge ($SeatMapArray.count-1) -or ($CurrentSeat+ $i) -ge ($SeatMapArray[$CurrentRow].count-1) -or $($SeatMapArray[$CurrentRow+$i][$CurrentSeat+$i]) -ne '.')
        if ($($SeatMapArray[$CurrentRow+$i][$CurrentSeat+$i]) -eq '#') {$True} else {$false}
      } else {$false}
    }
  }
}

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
    $isOccupied = @("Up","Down","Left","Right","TopLeft","TopRight","BottomLeft","BottomRight") | foreach-object { <#write-host $(convertto-json @{Row = $Row; Seat = $seat; Direction = $_});#> test-occupiedSeatDirection -Direction $_ -CurrentRow $Row -CurrentSeat $Seat -SeatMapArray $MultiDimensionalSeats}
    if ($MultiDimensionalSeats[$Row][$Seat] -eq '.') {'.'} else {
      if ($MultiDimensionalSeats[$Row][$Seat] -eq 'L' -and ($isOccupied | Group-Object | where-object {$_.Name -eq 'true'}).count -eq 0) {'#'}
      elseif ($MultiDimensionalSeats[$Row][$Seat] -eq '#' -and ($isOccupied | Group-Object | where-object {$_.Name -eq 'true'}).count -gt 4) {'L'}
      else {$MultiDimensionalSeats[$Row][$Seat] }
    }
    $Seat++
  } until ($Seat -gt $($MultiDimensionalSeats[($Row)]).count )

 $NewSeatMap.add($($NextRow -join '')) | out-null
 $row++
} until ($Row -ge $MultiDimensionalSeats.count )

$Iteration++
$NewSeatMap
#($NewSeatMap.ToCharArray() | Group-Object | where {$_.Name -eq '#'}).count
Write-host '-----------------------'
} until ((Compare-Object -ReferenceObject $SeatMap -DifferenceObject $NewSeatMap) -eq $NUll)
($SeatMap.ToCharArray() | Group-Object | where {$_.Name -eq '#'}).count