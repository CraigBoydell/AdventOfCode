$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

Function Test-Hand {
    param ( $Hand)

    $TestHand = $_.hand.ToCharArray() | Group-Object | Group-Object -Property Count

    if (@($TestHand | Where {$_.Name -eq 5 -and $_.Count -eq 1}).count -eq 1) {'FiveOfAKind'}
    if (@($TestHand | Where {$_.Name -eq 4 -and $_.Count -eq 1}).count -eq 1 -and @($TestHand | Where {$_.Name -eq 1 -and $_.Count -eq 1}).count -eq 1) {'FourOfAKind'}
    if (@($TestHand | Where {$_.Name -eq 3 -and $_.Count -eq 1}).count -eq 1 -and @($TestHand | Where {$_.Name -eq 2 -and $_.Count -eq 1}).count -eq 1) {'FullHouse'}
    if (@($TestHand | Where {$_.Name -eq 3 -and $_.Count -eq 1}).count -eq 1 -and @($TestHand | Where {$_.Name -eq 1 -and $_.Count -eq 2}).count -eq 1) {'ThreeOfAKind'}
    if (@($TestHand | Where {$_.Name -eq 2 -and $_.Count -eq 2}).count -eq 1 -and @($TestHand | Where {$_.Name -eq 1 -and $_.Count -eq 1}).count -eq 1) {'TwoPair'}
    if (@($TestHand | Where {$_.Name -eq 2 -and $_.Count -eq 1}).count -eq 1 -and @($TestHand | Where {$_.Name -eq 1 -and $_.Count -eq 3}).count -eq 1) {'OnePair'}
    if (@($TestHand | Where {$_.Name -eq 1 -and $_.Count -eq 5}).count -eq 1) {'HighCard'}
}


$CardRanks = @('A','K','Q','J','T','9','8','7','6','5','4','3','2')
$Global:y=0;$CardRanks = $(for ($i = $CardRanks.count; $i -ge 0; $i--) {$CardRanks[$i]}) | select-object -Property @{N='Card';E={$_}},@{N='Rank';E={$global:y++;$global:y}}
$HTCardRanks = @{}
$CardRanks | foreach {$HTCardRanks[$_.Card] = $_.Rank}

$TypeRanks = @('FiveOfAKind','FourOfAKind','FullHouse','ThreeOfAKind','TwoPair','OnePair','HighCard')
$global:y = 0; $TypeRanks = $(for ($i = 0; $i -le $TypeRanks.count; $i++) {$TypeRanks[$i]}) | select-object -Property @{N='Type';E={$_}},@{N='Rank';E={$global:y++;$global:y}}

$Hands = $SourceSplit | Select-Object -Property @{N='Hand';E={($_ -split " ")[0]}},@{N='Bid';E={($_ -split " ")[1].toint64($null)}}

$Hands = $Hands | Select-Object -Property *,@{N='Type';E={Test-Hand -Hand $_.Hand}}

$Hands = $Hands | Select-Object -Property *,@{N='TypeRank';E={ $Type = $_.Type; $($TypeRanks | where {$_.Type -eq $Type}).Rank }}

$GroupedHands = $Hands | Sort-Object -Property TypeRank -Descending | Group-Object -Property TypeRank

$global:t = 0; $Ranked = $GroupedHands | foreach {  
    $GroupToProcess = $_.group    
    do {          
        $Swapped = $False
        for ($i=0; $i -lt $GroupToProcess.count-1; $i++) {
          $global:index =0; 
          $ComparedHands = @($GroupToProcess[$i], $GroupToProcess[$i+1])
          $c=-1; do {$c++ } until ($ComparedHands[0].hand.tochararray()[$c] -NE $ComparedHands[1].hand.tochararray()[$c])
          $TestResult = $ComparedHands.hand.tochararray()[$c,($c+5)] |Select-Object -Property @{N='Card';E={$_}},@{N='Value';E={$HTCardRanks[[string]$_]}},@{N='Index';E={$global:index;$Global:index++}}
          $TestResult = $TestResult | Sort-Object -Property Value
          if ($TestResult[0].Index -eq 1) { 
            $Swapped = $True
            $GroupToProcess[$i] = $ComparedHands[$TestResult[0].Index]
            $GroupToProcess[$i+1] = $ComparedHands[$TestResult[1].Index]
          }
        }
      } until ($Swapped -eq $False)
      $GroupToProcess
  } | Select-Object -Property *,@{N='WinRank';E={$global:t++;$global:t}}

  $Ranked = $Ranked | Select-Object *,@{N='Winnings';E={$_.Bid * $_.WinRank}}
  ($Ranked | Measure-Object -Property Winnings -sum).sum

  # Answer:
  # 252052080