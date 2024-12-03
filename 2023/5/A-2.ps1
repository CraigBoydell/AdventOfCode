$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

for ($i = 0; $i -lt $SourceSplit.count; $i++) { $SourceSplit[$i] = $SourceSplit[$i].trim()  }


$Seeds = $SourceSplit[0].replace('seeds: ','').split(' ')

#for ($i=0; $i -lt $Seeds.count; $i++) { $Seeds[$i] = $Seeds[$i].toint64($null)  }
#$Seeds = for ($i=0;$i -lt $Seeds.count;$i++) { $Seeds[$i].toint64($null)..($Seeds[$i].toint64($null)+$Seeds[$i+1].ToInt64($null)-1); $i++  }


for ($i=0; $i -lt $SourceSplit.count; $i++) { if ( $SourceSplit[$i] -like '*:' ) { $Map = new-variable -Name $([string]$i + '_' + $SourceSplit[$i].replace(':','')) -PassThru; $i++; $MapValues = do { $SourceSplit[$i]; $i++  } until ( [string]::isnullorempty($SourceSplit[$i]) -or $i -gt $($SourceSplit.count-1)  ); Get-Variable -Name $Map.Name | Set-Variable -Value $MapValues  }  }

$MapVars = Get-Variable | where {$_.Name -like '*-*'} | Select-Object -Property @{N='ID';E={$_.Name.split('_')[0].toint32($null)}},Name,Value | Sort-Object -Property ID

#for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property @{N='NextStart';E={$_.Split(' ')[0].toint32($null)}},@{N='LookupStart';E={$_.Split(' ')[1].toint32($null)}},@{N='Dist';E={$_.Split(' ')[2]}} | Select-Object -Property *,@{N='Lookup';E={$_.LookupStart..($_.LookupStart+$_.Dist-1)}}  }
for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property @{N='NextStart';E={$_.Split(' ')[0].toint64($null)}},@{N='LookupStart';E={$_.Split(' ')[1].toint64($null)}},@{N='Dist';E={$_.Split(' ')[2].toint64($null)}}}
for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property *,@{N='LookupRange';E={ @($_.LookupStart,$($_.LookupStart+$_.Dist-1))  }},@{N='NextRange';E={ @($_.NextStart,$($_.NextStart+$_.Dist-1))  }}}



function Test-Range {

  param (
    $SeedRange,
    $MapVarValue
  )
 
   $LookupRange = $MapVarValue.LookupRange
   
 
   $mLeft = if ($SeedRange[0] -lt $LookupRange[0] -and $SeedRange[1] -lt $LookupRange[0]) {@($SeedRange[0],$SeedRange[1])}
   $mRight = if ($SeedRange[0] -gt $LookupRange[1] -and $SeedRange[1] -gt $LookupRange[1]) {@($SeedRange[0],$SeedRange[1])}
 
   $oLeft = if ($SeedRange[0] -lt $LookupRange[0] -and $SeedRange[1] -gt $LookupRange[0]) {@($SeedRange[0],($MapVars[0].value[0].LookupRange[0]-1)); $LeftMost = $LookupRange[0]  }
   $oRight = if ($SeedRange[0] -lt $LookupRange[1] -and $SeedRange[1] -gt $LookupRange[1]) {@(($MapVars[0].value[0].LookupRange[1]+1),$SeedRange[1]; $RightMost = $LookupRange[1] )}
 
   $ToUpdateBy = $MapVarValue.NextStart-$MapVarValue.lookupStart
 
   $midLeft = if ($LeftMost -gt 0 -and $SeedRange[1] -le $LookupRange[1]) {@(($LeftMost+$ToUpdateBy),($SeedRange[1]+$ToUpdateBy))}
   $midRight = if ($SeedRange[0] -ge $LookupRange[0] -and $RightMost -gt 0 ) {@(($SeedRange[0]+$ToUpdateBy),($RightMost+$ToUpdateBy))}
 
   $AllRange = if ($SeedRange[0] -ge $LookupRange[0] -and $SeedRange[1] -lt $LookupRange[1]) {@(($SeedRange[0]+$ToUpdateBy),($SeedRange[1]+$ToUpdateBy))}
 
   @(@(@($mLeft),@($mRight),@($oLeft),@($oRight),@($midLeft),@($midRight),@($allRange)) | where {$_ -ne $null})

   #Need to add something to manage processing and processed

 }


$SeedRanges = for ($i=0;$i -le $Seeds.count-2;$i=$i+2) {
  $Start = $Seeds[$i].toint64($null)
  $End = ($Seeds[$i].toint64($null)+$Seeds[$i+1].ToInt64($null)-1)
  new-object -TypeName PSCustomObject -Property @{SeedRanges = @($Start, $end)}
}
$Ranges = $SeedRanges
for ($mv = 0; $mv -lt 3; $MV++) {
$Ranges = $Ranges | foreach {
 $Range = $_.seedranges
  $MapVars[$mv] | foreach {
    $_.Value | foreach {
      write-host $($Range -join ',')
      $Range = Test-Range -SeedRange $Range -MapVarValue $_
    }
    if (($Range | foreach {$_}).length -gt 2) {
      $Range | foreach {new-object -TypeName PSCustomObject -Property @{SeedRanges = @($_[0], $_[1])}}
    } else {
      
       -TypeName PSCustomObject -Property @{SeedRanges = @($Range[0], $Range[1])}
    }
  }
}
}



# Answer:

<#

function Test-Range {

 param (
   $SeedRange,
   $MapVarValue
 )

  $LookupRange = $MapVarValue.LookupRange
  

  $mLeft = if ($SeedRange[0] -lt $LookupRange[0] -and $SeedRange[1] -lt $LookupRange[0]) {@($SeedRange[0],$SeedRange[1])}
  $mRight = if ($SeedRange[0] -gt $LookupRange[1] -and $SeedRange[1] -gt $LookupRange[1]) {@($SeedRange[0],$SeedRange[1])}

  $oLeft = if ($SeedRange[0] -lt $LookupRange[0] -and $SeedRange[1] -gt $LookupRange[0]) {@($SeedRange[0],($MapVars[0].value[0].LookupRange[0]-1)); $LeftMost = $LookupRange[0]  }
  $oRight = if ($SeedRange[0] -lt $LookupRange[1] -and $SeedRange[1] -gt $LookupRange[1]) {@(($MapVars[0].value[0].LookupRange[1]+1),$SeedRange[1]; $RightMost = $LookupRange[1] )}

  $ToUpdateBy = $MapVarValue.NextStart-$MapVarValue.lookupStart

  $midLeft = if ($LeftMost -gt 0 -and $SeedRange[1] -le $LookupRange[1]) {@(($LeftMost+$ToUpdateBy),($SeedRange[1]+$ToUpdateBy))}
  $midRight = if ($SeedRange[0] -ge $LookupRange[0] -and $RightMost -gt 0 ) {@(($SeedRange[0]+$ToUpdateBy),($RightMost+$ToUpdateBy))}

  $AllRange = if ($SeedRange[0] -ge $LookupRange[0] -and $SeedRange[1] -lt $LookupRange[1]) {@(($SeedRange[0]+$ToUpdateBy),($SeedRange[1]+$ToUpdateBy))}

  @(@(@($mLeft),@($mRight),@($oLeft),@($oRight),@($midLeft),@($midRight),@($allRange)) | where {$_ -ne $null})
}

cls
$Ranges = $SeedRanges
for ($mv = 0; $mv -lt 3; $MV++) {
$Ranges = $Ranges | foreach {
 $Range = $_.seedranges
  $MapVars[$mv] | foreach {
    $_.Value | foreach {
      write-host $($Range -join ',')
      $Range = Test-Range -SeedRange $Range -MapVarValue $_
    }
    if (($Range | foreach {$_}).length -gt 2) {
      $Range | foreach {new-object -TypeName PSCustomObject -Property @{SeedRanges = @($_[0], $_[1])}}
    } else {
      new-object -TypeName PSCustomObject -Property @{SeedRanges = @($Range[0], $Range[1])}
    }
  }
}
}

  $mLeft = if ($SeedRange[0] -lt $MapVars[0].value[1].LookupRange[0] -and $SeedRange[1] -lt $MapVars[0].value[1].LookupRange[0]) {@($SeedRange[0],$SeedRange[1])}
  $mRight = if ($SeedRange[0] -gt $MapVars[0].value[1].LookupRange[1] -and $SeedRange[1] -gt $MapVars[0].value[1].LookupRange[1]) {@($SeedRange[0],$SeedRange[1])}

  $oLeft = if ($SeedRange[0] -lt $MapVars[0].value[1].LookupRange[0] -and $SeedRange[1] -gt $MapVars[0].value[1].LookupRange[0]) {@($SeedRange[0],($MapVars[0].value[1].LookupRange[0]-1)); $LeftMost = $MapVars[0].value[1].LookupRange[0]  }
  $oRight = if ($SeedRange[0] -lt $MapVars[0].value[1].LookupRange[1] -and $SeedRange[1] -gt $MapVars[0].value[1].LookupRange[1]) {@(($MapVars[0].value[1].LookupRange[1]+1),$SeedRange[1]; $RightMost = $MapVars[0].value[1].LookupRange[1] )}

  $ToUpdateBy = $MapVars[0].value[1].NextStart-$MapVars[0].value[1].lookupStart

  $midLeft = if ($LeftMost -gt 0 -and $SeedRange[1] -le $MapVars[0].value[1].LookupRange[1]) {@(($LeftMost+$ToUpdateBy),($SeedRange[1]+$ToUpdateBy))}
  $midRight = if ($SeedRange[0] -ge $MapVars[0].value[1].LookupRange[0] -and $RightMost -gt 0 ) {@(($SeedRange[0]+$ToUpdateBy),($RightMost+$ToUpdateBy))}

  $AllRange = if ($SeedRange[0] -ge $MapVars[0].value[1].LookupRange[0] -and $SeedRange[1] -lt $MapVars[0].value[1].LookupRange[1]) {@(($SeedRange[0]+$ToUpdateBy),($SeedRange[1]+$ToUpdateBy))}

  @(@(@($mLeft),@($mRight),@($oLeft),@($oRight),@($midLeft),@($midRight),@($allRange)) | where {$_ -ne $null})
#>