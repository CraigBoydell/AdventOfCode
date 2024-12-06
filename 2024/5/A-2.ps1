$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$PageRules = ($Source -split "`r`n`r`n")[0]
$PlannedPageOrders = ($Source -split "`r`n`r`n")[1]

$Rules = $PageRules.split("`n") | Select-Object -Property @{N='Page';E={$_.Split('|')[0]}},@{N='Before';E={$_.Split('|')[1].trim()}}
$RulesHT = @{}

$Rules | Group-Object -Property Page | foreach {$RulesHT[$_.Name] = $_.Group.Before}

$Plans = New-Object System.Collections.Generic.List[System.Object]

$PlannedPageOrders.split("`n") | foreach { $Plans.add($($_.split(',') | foreach {$_.trim()}) )  }
$GoodPlans = New-Object System.Collections.Generic.List[System.Object]
$BadPlans = New-Object System.Collections.Generic.List[System.Object]



$Plans | foreach { 
    $Plan = $_
    $GoodPlan = $True
    $i = 1
    do { if ($Plan[0..($i-1)] | where {$_ -in $RulesHT[[string]$Plan[$i].trim()]}) {$GoodPlan = $false} ; $i++  } while ($i -lt $plan.count -and $GoodPlan -eq $true)

    if ($GoodPlan -eq $True) {$GoodPlans.add($Plan)} else {$BadPlans.Add($Plan)}

    #$RulesHT[[string]$_]
}

$FixedPlans = New-Object System.Collections.Generic.List[System.Object]
#($GoodPlans | foreach { $_[[math]::floor($_.count /2)] } | Measure-Object -sum).sum
$BadPlans | foreach {
  $BadPlan = $_
  $GoodPlan = $false
  $i = 1
  do {
    $MoveBefore = @($RulesHT[$BadPlan[$i].trim()] | where {$_ -in $BadPlan[0..($i-1)]})

    if ($MoveBefore.count -gt 0) {
      $TestPlan = $BadPlan.clone()
      $TestPlan[$BadPlan.indexof($MoveBefore[0])] = $BadPlan[$i]
      $TestPlan[$i] = $BadPlan[$BadPlan.indexof($MoveBefore[0])]
      $BadPlan = $TestPlan.clone()
    }

    $GoodPlan = $True
    $y = 1
    do { if ($BadPlan[0..($y-1)] | where {$_ -in $RulesHT[[string]$BadPlan[$y].trim()]}) {$GoodPlan = $false} ; $y++  } while ($y -lt $BadPlan.count -and $GoodPlan -eq $true)
    $i++
    if ($i -ge $BadPlan.count) { $i = 1 }
  } until ($GoodPlan -eq $True)
  $FixedPlans.add($BadPlan)
}

($FixedPlans | foreach { $_[[math]::floor($_.count /2)] } | Measure-Object -sum).sum

#Answer
#5466