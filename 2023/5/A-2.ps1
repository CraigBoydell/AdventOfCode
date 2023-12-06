$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

for ($i = 0; $i -lt $SourceSplit.count; $i++) { $SourceSplit[$i] = $SourceSplit[$i].trim()  }


$Seeds = $SourceSplit[0].replace('seeds: ','').split(' ')

#for ($i=0; $i -lt $Seeds.count; $i++) { $Seeds[$i] = $Seeds[$i].toint64($null)  }
#$Seeds = for ($i=0;$i -lt $Seeds.count;$i++) { $Seeds[$i].toint64($null)..($Seeds[$i].toint64($null)+$Seeds[$i+1].ToInt64($null)-1); $i++  }


for ($i=0; $i -lt $SourceSplit.count; $i++) { if ( $SourceSplit[$i] -like '*:' ) { $Map = new-variable -Name $([string]$i + '_' + $SourceSplit[$i].replace(':','')) -PassThru; $i++; $MapValues = do { $SourceSplit[$i]; $i++  } until ( [string]::isnullorempty($SourceSplit[$i]) -or $i -gt $($SourceSplit.count-1)  ); Get-Variable -Name $Map.Name | Set-Variable -Value $MapValues  }  }

$MapVars = Get-Variable | where {$_.Name -like '*-*'} | Select-Object -Property @{N='ID';E={$_.Name.split('_')[0].toint32($null)}},Name,Value | Sort-Object -Property ID

#for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property @{N='NextStart';E={$_.Split(' ')[0].toint32($null)}},@{N='LookupStart';E={$_.Split(' ')[1].toint32($null)}},@{N='Dist';E={$_.Split(' ')[2]}} | Select-Object -Property *,@{N='Lookup';E={$_.LookupStart..($_.LookupStart+$_.Dist-1)}}  }
for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property @{N='NextStart';E={$_.Split(' ')[0].toint64($null)}},@{N='LookupStart';E={$_.Split(' ')[1].toint64($null)}},@{N='Dist';E={$_.Split(' ')[2]}}}

$Current = @{'Location' = 99999999999999999999999999999}
$Current = 99999999999999999999999999999

$MaxThreads = 100

$Script = @'
$MapVars = $Args[0];$y = $Args[1]
$ToProcess = $y
$ToProcess = $($LookupResult = $MapVars[0].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$ToProcess = $($LookupResult = $MapVars[1].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$ToProcess = $($LookupResult = $MapVars[2].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$ToProcess = $($LookupResult = $MapVars[3].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$ToProcess = $($LookupResult = $MapVars[4].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$ToProcess = $($LookupResult = $MapVars[5].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$ToProcess = $($LookupResult = $MapVars[6].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
$Processing = $ToProcess
$Processing
'@
$ScriptBlock = [scriptblock]::Create($Script)


for ($i=0;$i -lt $Seeds.count;$i++) { 
  $Start = $Seeds[$i].toint64($null)
  $End = ($Seeds[$i].toint64($null)+$Seeds[$i+1].ToInt64($null)-1)
  $i++
  write-host $([string]$Start + ' : ' + $End)
  <#
    for ($y=$Start;$y -lt $End; $y++) {
    write-progress -Activity $([string]$y + '/' + $End)
    $Seeds1 = $y | Select-Object -Property @{N='Seed';E={$_}}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Soil';E={$Seed = $_.Seed; $LookupResult = $MapVars[0].value | where { $Seed -ge $_.LookupStart -and $seed -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Seed }}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Fertilizer';E={$Soil = $_.Soil; $LookupResult = $MapVars[1].value | where { $Soil -ge $_.LookupStart -and $Soil -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Soil }}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Water';E={$Fertilizer = $_.Fertilizer; $LookupResult = $MapVars[2].value | where { $Fertilizer -ge $_.LookupStart -and $Fertilizer -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Fertilizer }}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Light';E={$Water = $_.Water; $LookupResult = $MapVars[3].value | where { $Water -ge $_.LookupStart -and $Water -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Water }}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Temperature';E={$Light = $_.Light; $LookupResult = $MapVars[4].value | where { $Light -ge $_.LookupStart -and $Light -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Light }}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Humidity';E={$Temperature = $_.Temperature; $LookupResult = $MapVars[5].value | where { $Temperature -ge $_.LookupStart -and $Temperature -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Temperature }}
    $Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Location';E={$Humidity = $_.Humidity; $LookupResult = $MapVars[6].value | where { $Humidity -ge $_.LookupStart -and $Humidity -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Humidity }}
    $Processing = $Seeds1
    If ($Processing.Location -lt $Current.Location) {$Current = $Processing; write-host $('Current Updated. New Closest Location: ' + $Current.Location)}
  
  }  
  #>
  <#
  for ($y=$Start;$y -lt $End; $y++) {
    write-progress -Activity $([string]$y + '/' + $End)
    $ToProcess = $y
    $ToProcess = $($LookupResult = $MapVars[0].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $ToProcess = $($LookupResult = $MapVars[1].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $ToProcess = $($LookupResult = $MapVars[2].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $ToProcess = $($LookupResult = $MapVars[3].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $ToProcess = $($LookupResult = $MapVars[4].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $ToProcess = $($LookupResult = $MapVars[5].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $ToProcess = $($LookupResult = $MapVars[6].value | where { $ToProcess -ge $_.LookupStart -and $ToProcess -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $ToProcess)
    $Processing = $ToProcess
    If ($Processing -lt $Current) {$Current = $Processing; write-host $('Current Updated. New Closest Location: ' + $Current)}
  }
  #>

  for ($y=$Start;$y -lt $End; $(if ($isChanged -eq $true) {$y++} else {$y = $y + 1000})) {
    #if ($y%1000 -eq 0) { 
      write-progress -Activity $([string]$y + '/' + $End)
      $itCount++
      if ($itCount -gt 100) {
        Get-Job | Group-Object -Property State | Select-Object -Property @{N='TimeGenerated';E={get-date (get-date).ToUniversalTime() -format o}},Name,Count
        $itCount = 0
      }
    #}

    do {
        start-sleep -Milliseconds 1
    } while ((Get-Job -State Running).count -gt $MaxThreads -or (Get-Job -State NotStarted).count -gt $MaxThreads)

    Start-ThreadJob -name $y -ScriptBlock $ScriptBlock -ArgumentList $MapVars,$y -ThrottleLimit 30 | out-null
    #Start-Job -name $y -ScriptBlock $ScriptBlock -ArgumentList $MapVars,$y | out-null

    get-job -State Completed | foreach {
        $JobResult = $_ | receive-job -keep
        #$JobResult
        if ($JobResult -lt $Current -and $JobResult -ne $null) {$Current = $JobResult; write-host $('Current Updated. New Closest Location: ' + $Current);$isChanged = $true} else {$isChanged = $False}
        $_ | Remove-Job
    }

    #If ($Processing -lt $Current) {$Current = $Processing; write-host $('Current Updated. New Closest Location: ' + $Current)}
  }
  do {
    get-job -State Completed | foreach {
      $JobResult = $_ | receive-job -keep
      $JobResult
      if ($JobResult -lt $Current -and $JobResult -ne $null) {$Current = $JobResult; write-host $('Current Updated. New Closest Location: ' + $Current);$isChanged = $true} else {$isChanged = $False}
      $_ | Remove-Job
    }
  } until ((Get-Job).count -eq 0)
}


<#
#Take 2
$Seeds1 = $Seeds | Select-Object -Property @{N='Seed';E={$_.toint32($null)}}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Soil';E={$Seed = $_.Seed; $LookupResult = $MapVars[0].value | where { $Seed -ge $_.LookupStart -and $seed -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Seed }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Fertilizer';E={$Soil = $_.Soil; $LookupResult = $MapVars[1].value | where { $Soil -ge $_.LookupStart -and $Soil -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Soil }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Water';E={$Fertilizer = $_.Fertilizer; $LookupResult = $MapVars[2].value | where { $Fertilizer -ge $_.LookupStart -and $Fertilizer -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Fertilizer }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Light';E={$Water = $_.Water; $LookupResult = $MapVars[3].value | where { $Water -ge $_.LookupStart -and $Water -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Water }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Temperature';E={$Light = $_.Light; $LookupResult = $MapVars[4].value | where { $Light -ge $_.LookupStart -and $Light -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Light }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Humidity';E={$Temperature = $_.Temperature; $LookupResult = $MapVars[5].value | where { $Temperature -ge $_.LookupStart -and $Temperature -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Temperature }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Location';E={$Humidity = $_.Humidity; $LookupResult = $MapVars[6].value | where { $Humidity -ge $_.LookupStart -and $Humidity -lt $($_.LookupStart+$_.Dist)}; $LookupResult.NextStart - $LookupResult.LookupStart + $Humidity }}

($Seeds1 | Sort-Object -Property Location | Select-Object -first 1).location
#>

# Answer:
