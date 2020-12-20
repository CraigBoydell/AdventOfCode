Function Expand-Mask {
  param (
    $Mask
  )
  $ProcMaskArray = New-Object -TypeName "System.Collections.ArrayList"
  $ProcMaskArray.Add($Mask) | out-null
  $XsToProcess = Search-Array -Array $Mask.ToCharArray() -Value ([char]'X')
  $XsToProcess | foreach {
    $CurrentXIndex = $_
    $TempProcMaskArray = New-Object -TypeName "System.Collections.ArrayList"
    $ProcMaskArray | foreach {
      $CurrentProcMask = $_
      $CurrentProcMaskArray = $CurrentProcMask.ToCharArray()
      $CurrentProcMaskArray[$CurrentXIndex] = [char]'0'
      $TempProcMaskArray.Add($CurrentProcMaskArray -join '') | out-null
      $CurrentProcMaskArray[$CurrentXIndex] = [char]'1'
      $TempProcMaskArray.Add($CurrentProcMaskArray -join '') | out-null
    }
    $ProcMaskArray = $TempProcMaskArray.clone()
  }
  $ProcMaskArray
}

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
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
'@
$ProgramInput = get-content '.\I.txt' -raw

$Memory = @{}

#141 Seconds
$ProgramInput = $ProgramInput -split ('mask = ')
$ProgramInput  | where-object {-not [string]::IsNullOrEmpty($_)} |  foreach {
  $Program = ($_).trim() -split "`r?`n"
  $Mask1s = Search-Array -Array ($Program[0].ToCharArray()) -Value ([char]'1')
  $MaskXs = Search-Array -Array ($Program[0].ToCharArray()) -Value ([char]'X')
  $Program[1..($Program.length-1)] | foreach-object {
    $CurrentProgram = $_
    $Result = $CurrentProgram | Select-String -Pattern $Pattern -AllMatches
    $MemToWriteTo = $Result.Matches.groups[2].value
    #$('M: ' + $_)
      #write-host $_
      #$Result
      #$ValueBeforeMask = [convert]::ToString(($Result.Matches.groups[1].value),2)
      #while ($ValueBeforeMask.length -ne $Program[0].length) { $ValueBeforeMask = '0' + $ValueBeforeMask}
      #$ValueBeforeMask = $ValueBeforeMask.ToCharArray()
    $ValueBeforeMask = ([convert]::ToString(($Result.Matches.groups[1].value), 2).PadLeft(36, '0')).ToCharArray()
      #$('B: ' + ($ValueBeforeMask -join ''))
      #$ValueBeforeMask = $ValueBeforeMask.ToCharArray()
    $Mask1s | foreach { $ValueBeforeMask[$_] = '1' }
    $MaskXs | foreach { $ValueBeforeMask[$_] = 'X' }
    $AllValues = Expand-Mask -Mask ($ValueBeforeMask -join '')
      #$('A: ' + ($ValueBeforeMask -join ''))
      #$MemToWriteTo
      #$ValueBeforeMask
      #$Memory.$([int]$MemToWriteTo + $MaskCount) = [convert]::ToInt64(($ValueBeforeMask -join ''),2)
    $AllValues | foreach {$Memory.$_ = $MemToWriteTo}
    }    
  }
($Memory.values | Measure-Object -Sum).sum
#Decimal to Binary
#[convert]::ToString(15,2)


<# Works, but a little slow
$ProgramInput = $ProgramInput -split ('mask = ')
$ProgramInput  | where-object {-not [string]::IsNullOrEmpty($_)} |  foreach {
  $Program = ($_).trim() -split "`r?`n"
  $AllMasks = Expand-Mask -Mask $Program[0]
  
  $Program[1..($Program.length-1)] | foreach-object {
    $CurrentProgram = $_
    $Result = $CurrentProgram | Select-String -Pattern $Pattern -AllMatches
    $MemToWriteTo = $Result.Matches.groups[2].value
    $MaskCount = 0
    $AllMasks | select-object -unique | foreach {
      #$('M: ' + $_)
      $Mask1s = Search-Array -Array ($_.ToCharArray()) -Value ([char]'1')
      $Mask2s = Search-Array -Array ($_.ToCharArray()) -Value ([char]'2')
      #write-host $_
      #$Result
      #$ValueBeforeMask = [convert]::ToString(($Result.Matches.groups[1].value),2)
      #while ($ValueBeforeMask.length -ne $Program[0].length) { $ValueBeforeMask = '0' + $ValueBeforeMask}
      #$ValueBeforeMask = $ValueBeforeMask.ToCharArray()
      $ValueBeforeMask = ([convert]::ToString(($Result.Matches.groups[1].value), 2).PadLeft(36, '0')).ToCharArray()
      #$('B: ' + ($ValueBeforeMask -join ''))
      #$ValueBeforeMask = $ValueBeforeMask.ToCharArray()
      $Mask1s | foreach { $ValueBeforeMask[$_] = '1' }
      $Mask2s | foreach { $ValueBeforeMask[$_] = '0' }
      #$('A: ' + ($ValueBeforeMask -join ''))
      #$MemToWriteTo
      #$ValueBeforeMask
      #$Memory.$([int]$MemToWriteTo + $MaskCount) = [convert]::ToInt64(($ValueBeforeMask -join ''),2)
      $Memory.$(($ValueBeforeMask -join '')) = $MemToWriteTo
      $MaskCount++
    }    
  }
}
($Memory.values | Measure-Object -Sum).sum
#Decimal to Binary
#[convert]::ToString(15,2)
#>

<# Works for Example but not Input
$ProgramInput = $ProgramInput -split ('mask = ')
$ProgramInput  | where-object {-not [string]::IsNullOrEmpty($_)} | foreach {
  $Program = ($_).trim() -split "`r?`n"
  $AllMasks = Expand-Mask -Mask $Program[0]
  $MaskCount = 0
  $AllMasks | select-object -unique | foreach {
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
      $Memory.$([int]$MemToWriteTo + $MaskCount) = [convert]::ToInt64(($ValueBeforeMask -join ''),2)
    }
    $MaskCount++
  }
}
($Memory.values | Measure-Object -Sum).sum
#Decimal to Binary
#[convert]::ToString(15,2)
#>

