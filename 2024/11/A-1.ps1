$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$Stones = $Source.split(" ") | foreach {[int]$_}

function Test-Stone {
    param ($Stone)
    
    $ToReturn = $null

    if ($Stone -eq 0) {
        $ToReturn = 1
    } elseif (([string]$stone).length % 2 -eq 0) { 
      $SplitStone =  [string]$Stone
      $ToReturn = @([bigint]$SplitStone.Substring(0,$SplitStone.length/2),[bigint]$SplitStone.Substring($SplitStone.length/2,$SplitStone.length/2) )    
    } else {
        $ToReturn = $Stone * 2024
    }

    $ToReturn
}

1..25 | foreach {$Stones = $Stones | foreach { Test-Stone -Stone $_  }}

$Stones.count

#Answer
#187738