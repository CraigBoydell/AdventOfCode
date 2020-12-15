$BagRules = @'
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
'@

$BagRules = @'
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
'@

$BagRules = $BagRules -split "`n" 
$BagRules = get-content '.\I.txt'

$BagConfigurations = New-Object -TypeName "System.Collections.ArrayList"
$AvailableBags = New-Object -TypeName "System.Collections.ArrayList"
$BagLevel = 1
$AvailableBags.Add($($BagRules | where-object {$_ -like '*shiny gold*contain*'})) | out-null
#$BagLevel | Select-Object -Property @{N='BagLevel';E={$BagLevel}},@{N='AvailableBags';E={$AvailableBags}} | Select-Object -Property *,@{N='ParentBags';E={$_.AvailableBags | foreach-object {$(($_ -split 'contain')[0]).Replace('bags','').trim()}}}

$BagConfigurations.Add($($BagLevel | Select-Object -Property @{N='BagLevel';E={$BagLevel}},@{N='AvailableBags';E={$AvailableBags}}| Select-Object -Property *,@{N='ChildBags';E={$($_.AvailableBags | foreach-object { $_}) | foreach-object {$(($_ -split 'contain')[1]).Replace(' bags','').Replace(' bag','').Replace('.','') -replace "\s\d+\s",'' -split "," } | select-object -unique }})) | out-null

do {
  $BagLevel++
  $AvailableBags = New-Object -TypeName "System.Collections.ArrayList"
  $BagConfigurations | where-object {$_.BagLevel -eq $($BagLevel - 1)} | foreach-object {
    $_.ChildBags | foreach-object {
      $BagToCheck = $_
      $BagToCheck
      $('*' + $($BagToCheck.trim())  + '*contain*')
      $AvailableBags.add($($BagRules | where-object {$_ -like $('*' + $($BagToCheck.trim())  + '*contain*')})) | out-null
    }
  }
  $AvailableBags = $AvailableBags | Select-Object -Unique
  if ($AvailableBags.count -ne 0) {
    $BagConfigurations.Add($($BagLevel | Select-Object -Property @{N='BagLevel';E={$BagLevel}},@{N='AvailableBags';E={$AvailableBags}}| Select-Object -Property *,@{N='ChildBags';E={$($_.AvailableBags | foreach-object { $_}) | foreach-object {$(($_ -split 'contain')[1]).Replace(' bags','').Replace(' bag','').Replace('.','') -replace "\s\d+\s",'' -split "," } | select-object -unique }})) | out-null
  }
} until ($AvailableBags.count -eq 0)

$BagRate = $BagConfigurations.childbags | Select-Object -Unique | where-object {$_.trim() -ne 'no other'} | foreach-object { new-object -property @{Bag = $_; Value = $null} -TypeName PSObject  }
do {
$BagRate | where-object {$_.value -eq $null} | foreach-object {
  $BagToRate = $_.bag
  $Result = $BagRules | where-object {$_ -like $($BagToRate +'*')}
  if ( $Result -like '*contain no other bags.' ) {
    $($BagRate | where-object {$_.Bag -eq $BagToRate}).value = 0
  } else {
    $BagsInBag = $($Result.replace('.','').replace(' bags','').replace(' bag','') -split ('contain '))[1]
    $BagsInBag = $BagsInBag -split (', ')
    $BagsInBag = $BagsInBag | foreach-object { $BagInBag = $_.split(' ',2); new-object -Property @{BagToValue = $BagToRate; Qty = $BagInBag[0]; BagInBag = $BagInBag[1]} -TypeName PSObject    }
    #$BagsInBag
    if ( ($BagsInBag |where-object {$_.baginbag -in $($BagRate | where-object {$_.value -ne $null}).bag}).count -eq $BagsInBag.count )
    {
      $BagValue = ($BagsInBag | foreach-object {
        $BagToLookup = $_
        ($BagRate | where-object {$_.Bag -eq $BagToLookup.BagInBag}).value * $BagToLookup.qty
      } | Measure-Object -sum).sum + ($BagsInBag.qty | Measure-Object -Sum).sum
      $($BagRate | where-object {$_.Bag -eq $BagToRate}).value = $BagValue
    }
  }
}
} until ($null -notin $BagRate.value)

#($BagConfigurations | Select-Object -ExpandProperty ParentBags -unique).count
$Result  = $BagConfigurations[0].AvailableBags
$BagsInBag = $($Result.replace('.','').replace(' bags','').replace(' bag','') -split ('contain '))[1]
$BagsInBag = $BagsInBag -split (', ')
$BagsInBag = $BagsInBag | foreach-object { $BagInBag = $_.split(' ',2); new-object -Property @{BagToValue = $BagToRate; Qty = $BagInBag[0]; BagInBag = $BagInBag[1]} -TypeName PSObject    }

<#
[int]($BagsInBag | foreach-object {
  $BagToLookup = $_
  ($BagRate | where-object {$_.Bag -eq $BagToLookup.BagInBag}).value * $BagToLookup.qty
  }) + ($BagsInBag.qty | Measure-Object -Sum).sum
#>
  ($BagsInBag | foreach-object {
    $BagToLookup = $_
    ($BagRate | where-object {$_.Bag -eq $BagToLookup.BagInBag}).value * $BagToLookup.qty} | Measure-Object -sum).sum + + ($BagsInBag.qty | Measure-Object -Sum).sum