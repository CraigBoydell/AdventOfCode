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

$BagRules = $BagRules -split "`n" 
$BagRules = get-content '.\I.txt'

$BagConfigurations = New-Object -TypeName "System.Collections.ArrayList"
$AvailableBags = New-Object -TypeName "System.Collections.ArrayList"
$BagLevel = 1
$AvailableBags.Add($($BagRules | where-object {$_ -like '*contain*shiny gold*'})) | out-null
#$BagLevel | Select-Object -Property @{N='BagLevel';E={$BagLevel}},@{N='AvailableBags';E={$AvailableBags}} | Select-Object -Property *,@{N='ParentBags';E={$_.AvailableBags | foreach-object {$(($_ -split 'contain')[0]).Replace('bags','').trim()}}}

$BagConfigurations.Add($($BagLevel | Select-Object -Property @{N='BagLevel';E={$BagLevel}},@{N='AvailableBags';E={$AvailableBags}}| Select-Object -Property *,@{N='ParentBags';E={$($_.AvailableBags | foreach-object { $_}) | foreach-object {$(($_ -split 'contain')[0]).Replace('bags','').trim()} | select-object -unique}})) | out-null

do {
  $BagLevel++
  $AvailableBags = New-Object -TypeName "System.Collections.ArrayList"
  $BagConfigurations | where-object {$_.BagLevel -eq $($BagLevel - 1)} | foreach-object {
    $_.parentBags | foreach-object {
      $BagToCheck = $_
      #$BagToCheck
      $AvailableBags.add($($BagRules | where-object {$_ -like '*contain*' + $($BagToCheck.trim())  + '*'})) | out-null
    }
  }
  $AvailableBags = $AvailableBags | Select-Object -Unique
  if ($AvailableBags.count -ne 0) {
    $BagConfigurations.Add($($BagLevel | Select-Object -Property @{N='BagLevel';E={$BagLevel}},@{N='AvailableBags';E={$AvailableBags}}| Select-Object -Property *,@{N='ParentBags';E={$($_.AvailableBags | foreach-object { $_}) | foreach-object {$(($_ -split 'contain')[0]).Replace('bags','').trim()} | select-object -unique}})) | out-null
  }
} until ($AvailableBags.count -eq 0)

($BagConfigurations | Select-Object -ExpandProperty ParentBags -unique).count