$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

<#

           [1,0] (U)
(L) [0,-1] [0,0] [0,1] (R)
           [-1,0] (D)

#Inverted
           [-1,0] (U)
(L) [0,-1] [0,0] [0,1] (R)
           [1,0] (D)

Possible pipes

(U) = |, 7, F
(D) = |, L, J 
(L) = -, F, L
(R) = -, 7, J
#>

$ValidU = @('|', '7', 'F','S')
$ValidD = @('|', 'L', 'J','S' )
$ValidL = @('-', 'F', 'L','S' )
$ValidR = @('-', '7', 'J','S' )

$ValidU = @('||', '|7', '|F','J|','J7','JF','L|','L7','LF')
$ValidD = @('||', '|L', '|J','7|','7L','7J','F|','FL','FJ')
$ValidL = @('--', '-F', '-L','J-','JF','JL','7-','7F','7L')
$ValidR = @('--', '-7', '-J','F-','F7','FJ','L-','L7','LJ')

#$Valid = @( '7|', 'F|', '|L', 'J|','F-','L-','-7','-J','F7','LJ','FL' )

$Grid = New-Object System.Collections.Generic.List[System.Object]

for ($i = 0; $i -lt $SourceSplit.count; $i++) {
  $Grid.add( $SourceSplit[$i].ToChararray() ) | Out-Null
}

$StartLIne = ($SourceSplit | where {$_ -like '*S*'})
$Global:Sx = $SourceSplit.indexof($Startline)
$Global:Sy = $SourceSplit[$Global:Sx].indexOf('S')

$SourceS = 'F' #ex2
$SourceS = 'J' #Input

$PossibleSteps = @('D','U','R','L')

$TotalSteps = 0

do {
    $Checker = New-Object -TypeName PSCustomObject -Property @{Current = $Grid[$Global:Sx][$Global:Sy]; L = try {$Grid[$Global:Sx][$Global:Sy-1] } catch {$null}; R= try{$Grid[$Global:Sx][$Global:Sy+1]} catch {$null}; U = try{$Grid[$Global:Sx-1][$Global:Sy]} catch {$null};D=try{$Grid[$Global:Sx+1][$Global:Sy]} catch {$null} }
#    $Checker | FT
Foreach ($Step in $($PossibleSteps | where {$_ -ne $ExcludeStep})) {
    #if ($Checker.$Step -in $(get-variable -name $('Valid' + $Step)).Value) {Break}
    $CheckerStep = $Checker.$Step
    if ($CheckerStep -eq 'S') {$CheckerStep = $SourceS}
    if ($TotalSteps -eq 0) {
      if ([string]$SourceS + $CheckerStep -in $(get-variable -name $('Valid' + $Step)).Value) {Break}
    } else {
      if ([string]$Checker.Current + $CheckerStep -in $(get-variable -name $('Valid' + $Step)).Value) {Break}
    }
}

switch ($Step) {
    'U' {$Global:Sx--; $ExcludeStep = 'D'}
    'D' {$Global:Sx++; $ExcludeStep = 'U'}
    'L' {$Global:Sy--; $ExcludeStep = 'R'}
    'R' {$Global:Sy++; $ExcludeStep = 'L'}
}

#'Ex: ' + $ExcludeStep
#'Next: ' + $Step


#$Grid[$Global:Sx][$Global:Sy]

$TotalSteps++
#start-sleep -Seconds 2
} until ($Grid[$Global:Sx][$Global:Sy] -eq 'S')

$TotalSteps/2

# Answer
# 6697