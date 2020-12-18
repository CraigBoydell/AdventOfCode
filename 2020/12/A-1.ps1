Function Start-ChangeDirection {
  param (
    $DirectionToTurn,
    $ByHowMuch,
    $Direction
  )
  $ByHowMuch = $ByHowMuch / 90
  switch ($DirectionToTurn) {
    "L" {1..$ByHowMuch | foreach { $Direction = $Direction - 1; if ($Direction -lt 0) {$Direction = 3} }}
    "R" {1..$ByHowMuch | foreach { $Direction = $Direction + 1; if ($Direction -gt 3) {$Direction = 0} }}
  }
  $Direction
}

Function Start-MoveDirection {
  param (
    $Location,
    $DirectionToMove,
    $ByHowMuch
  )
  Switch ($DirectionToMove) {
    "N" {$Location.y = $Location.y + $ByHowMuch}
    "E" {$Location.x = $Location.x + $ByHowMuch}
    "S" {$Location.y = $Location.y - $ByHowMuch}
    "W" {$Location.x = $Location.x - $ByHowMuch}
  }
  $Location
}

$Compass = @('N','E','S','W')
$Direction = 1
$Location = @{x=0;y=0}
$NavigationSet = @'
F10
N3
F7
R90
F11
'@

$NavigationSet = $NavigationSet -split "`r?`n"
$NavigationSet = get-content '.\I.txt'
$NavigationSet | foreach {
  switch ($_) {
    {($_).substring(0,1) -eq 'N'} {$DirectionToMove = 'N'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Location = Start-MoveDirection -Location $Location -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch }
    {($_).substring(0,1) -eq 'E'} {$DirectionToMove = 'E'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Location = Start-MoveDirection -Location $Location -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'S'} {$DirectionToMove = 'S'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Location = Start-MoveDirection -Location $Location -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'W'} {$DirectionToMove = 'W'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Location = Start-MoveDirection -Location $Location -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'F'} {$DirectionToMove = $Compass[$Direction]; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Location = Start-MoveDirection -Location $Location -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'L'} {$DirectionToTurn = 'L'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1); $Direction = Start-ChangeDirection -DirectionToTurn $DirectionToTurn -ByHowMuch $ByHowMuch -Direction $Direction }
    {($_).substring(0,1) -eq 'R'} {$DirectionToTurn = 'R'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1); $Direction = Start-ChangeDirection -DirectionToTurn $DirectionToTurn -ByHowMuch $ByHowMuch -Direction $Direction}
  }

}

[math]::abs($Location.x) + [math]::abs($Location.y)