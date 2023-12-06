$Source = Get-Content .\ex.txt -Raw
$Source = Get-Content .\I.txt -Raw

$SourceSplit = $Source.split("`n")

for ($i = 0; $i -lt $SourceSplit.count; $i++) { $SourceSplit[$i] = $SourceSplit[$i].trim()  }

$Seeds = $SourceSplit[0].replace('seeds: ','').split(' ')

for ($i=0; $i -lt $SourceSplit.count; $i++) { if ( $SourceSplit[$i] -like '*:' ) { $Map = new-variable -Name $([string]$i + '_' + $SourceSplit[$i].replace(':','')) -PassThru; $i++; $MapValues = do { $SourceSplit[$i]; $i++  } until ( [string]::isnullorempty($SourceSplit[$i]) -or $i -gt $($SourceSplit.count-1)  ); Get-Variable -Name $Map.Name | Set-Variable -Value $MapValues  }  }

$MapVars = Get-Variable | where {$_.Name -like '*-*'} | Select-Object -Property @{N='ID';E={$_.Name.split('_')[0].toint32($null)}},Name,Value | Sort-Object -Property ID

#for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property @{N='NextStart';E={$_.Split(' ')[0].toint32($null)}},@{N='LookupStart';E={$_.Split(' ')[1].toint32($null)}},@{N='Dist';E={$_.Split(' ')[2]}} | Select-Object -Property *,@{N='Lookup';E={$_.LookupStart..($_.LookupStart+$_.Dist-1)}}  }
for ($i=0; $i -lt $MapVars.count; $i++) { $MapVars[$i].value = $MapVars[$i].value | Select-Object -Property @{N='NextStart';E={$_.Split(' ')[0].toint64($null)}},@{N='LookupStart';E={$_.Split(' ')[1].toint64($null)}},@{N='Dist';E={$_.Split(' ')[2]}}}

<# Resource Intensive
$Seeds1 = $Seeds | Select-Object -Property @{N='Seed';E={$_.toint32($null)}}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Soil';E={$Seed = $_.Seed; $LookupResult = $MapVars[0].value | where { $Seed -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Seed }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Fertilizer';E={$Soil = $_.Soil; $LookupResult = $MapVars[1].value | where { $Soil -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Soil }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Water';E={$Fertilizer = $_.Fertilizer; $LookupResult = $MapVars[2].value | where { $Fertilizer -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Fertilizer }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Light';E={$Water = $_.Water; $LookupResult = $MapVars[3].value | where { $Water -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Water }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Temperature';E={$Light = $_.Light; $LookupResult = $MapVars[4].value | where { $Light -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Light }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Humidity';E={$Temperature = $_.Temperature; $LookupResult = $MapVars[5].value | where { $Temperature -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Temperature }}
$Seeds1 = $Seeds1 | Select-Object -Property *,@{N='Location';E={$Humidity = $_.Humidity; $LookupResult = $MapVars[6].value | where { $Humidity -in $_.Lookup }; $LookupResult.NextStart - $LookupResult.LookupStart + $Humidity }}
#>

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

# Answer:
# 3374647