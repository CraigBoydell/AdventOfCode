Function Start-MoveDirection {
  param (
    $Location,
    $DirectionToMove,
    $ByHowMuch
  )
  Switch ($DirectionToMove) {
    "N" {$Location.rely = $Location.rely + $ByHowMuch;$Location.y = $Location.y + $ByHowMuch}
    "E" {$Location.relx = $Location.relx + $ByHowMuch;$Location.x = $Location.x + $ByHowMuch}
    "S" {$Location.rely = $Location.rely - $ByHowMuch; $Location.y = $Location.y - $ByHowMuch}
    "W" {$Location.relx = $Location.relx - $ByHowMuch;$Location.x = $Location.x - $ByHowMuch}
  }
  $Location
}

function Start-MoveForward {
  param(
    $ByHowMuch,
    $ShipLocation,
    $WaypointLocation
  )
  $NewLocation = @{x=(($WaypointLocation.relx * $ByHowMuch) + $ShipLocation.x);y=(($WaypointLocation.rely * $ByHowMuch) + $ShipLocation.y)}
  $NewLocation
}

Function Start-RotateWaypoint {
  param (
    $DirectionToTurn,
    $ByHowMuch,
    $Waypoint
  )
  $ByHowMuch = $ByHowMuch / 90
  switch ($DirectionToTurn) {
    "L" {1..$ByHowMuch | foreach {
          $TempWaypoint = $Waypoint.clone()
          $Waypoint.x = ($TempWaypoint.y * -1)
          $Waypoint.y = $TempWaypoint.x
          $Waypoint.relx = ($TempWaypoint.rely * -1)
          $Waypoint.rely = $TempWaypoint.relx
          }
        }
    "R" {1..$ByHowMuch | foreach {
          $TempWaypoint = $Waypoint.clone()
          $Waypoint.x = $TempWaypoint.y
          $Waypoint.y = ($TempWaypoint.x*-1)
          $Waypoint.relx = $TempWaypoint.rely
          $Waypoint.rely = ($TempWaypoint.relx *-1)
          }
        }
  }
  $Waypoint
}

#R(0,0),90∘​(x,y)=(−y,x)
#R(0,0),−90∘​(x,y)=(y,−x)

$Compass = @('N','E','S','W')
$Direction = 1
$Location = @{x=0;y=0}
$Waypoint = @{relx=10;rely=1;x=10;y=1}
$NavigationSet = @'
F10
N3
F7
R90
F11
'@
$MoveLog = @()

$NavigationSet = $NavigationSet -split "`r?`n"
$NavigationSet = get-content '.\I.txt'
$NavigationSet | foreach {
  switch ($_) {
    {($_).substring(0,1) -eq 'N'} {$DirectionToMove = 'N'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Waypoint = Start-MoveDirection -Location $Waypoint -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch }
    {($_).substring(0,1) -eq 'E'} {$DirectionToMove = 'E'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Waypoint = Start-MoveDirection -Location $Waypoint -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'S'} {$DirectionToMove = 'S'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Waypoint = Start-MoveDirection -Location $Waypoint -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'W'} {$DirectionToMove = 'W'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Waypoint = Start-MoveDirection -Location $Waypoint -DirectionToMove $DirectionToMove -ByHowMuch $ByHowMuch}
    {($_).substring(0,1) -eq 'F'} {$Nav= $_; $ByHowMuch = ($_).substring(1,$nav.Length-1);$Location = Start-MoveForward -ByHowMuch $ByHowMuch -ShipLocation $Location -WaypointLocation $Waypoint; $Waypoint.x = $Location.x + $waypoint.relx; $Waypoint.y = $Location.y + $waypoint.rely }
    {($_).substring(0,1) -eq 'L'} {$DirectionToTurn = 'L'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1); $Waypoint = Start-RotateWaypoint -DirectionToTurn $DirectionToTurn -ByHowMuch $ByHowMuch -Waypoint $Waypoint }
    {($_).substring(0,1) -eq 'R'} {$DirectionToTurn = 'R'; $Nav = $_; $ByHowMuch = ($_).substring(1,$nav.Length-1); $Waypoint = Start-RotateWaypoint -DirectionToTurn $DirectionToTurn -ByHowMuch $ByHowMuch -waypoint $Waypoint}
  }
  #$Location
  #$Waypoint
}

[math]::abs($Location.x) + [math]::abs($Location.y)