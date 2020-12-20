function Search-Array {
  Param (
    $Array,
    $Value
  )
  $Results = New-Object -TypeName "System.Collections.ArrayList"
  $StartInt = 0
  while ( $Result -ne -1 ) {
    $Result = [Array]::IndexOf($Array,$Value,$StartInt)
    if ($Result -ne -1) { $Results.Add($Result) | out-null }
    $StartInt = $Result + 1
    #write-host $('Result: ' + $Result)
  }
  $Results
}

$Pattern = 'mem\[(\d+)\]\s=\s(\d+)'

$ProgramInput = @'
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
'@
$ProgramInput = get-content '.\I.txt' -raw

$Memory = @{}
$Counter = 0

$ProgramInput = $ProgramInput -split ('mask = ')
$ProgramInput | where-object {-not [string]::IsNullOrEmpty($_)} | foreach {
  $Counter
  $Program = ($_).trim() -split "`r?`n"
  $Mask1s = Search-Array -Array $Program[0].toCharArray() -Value ([char]'1')
  $Mask0s = Search-Array -Array $Program[0].toCharArray() -Value ([char]'0')
  $Program[1..($Program.length-1)] | foreach-object {
    #write-host $_
    $Result = $_ | Select-String -Pattern $Pattern -AllMatches
    #$Result
    $MemToWriteTo = $Result.Matches.groups[1].value
    $ValueBeforeMask = [convert]::ToString(($Result.Matches.groups[2].value),2)
    while ($ValueBeforeMask.length -ne $Program[0].length) { $ValueBeforeMask = '0' + $ValueBeforeMask}
    $ValueBeforeMask = $ValueBeforeMask.ToCharArray()
    $Mask1s | foreach { $ValueBeforeMask[$_] = '1' }
    $Mask0s | foreach { $ValueBeforeMask[$_] = '0' }
    #$MemToWriteTo
    #$ValueBeforeMask
    $Memory.$MemToWriteTo = [convert]::ToInt64(($ValueBeforeMask -join ''),2)
    $Counter++
  }
}
($Memory.values | Measure-Object -Sum).sum
#Decimal to Binary
#[convert]::ToString(15,2)