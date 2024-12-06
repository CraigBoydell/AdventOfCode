$Source = Get-Content .\ex.txt -Raw
#$Source = Get-Content .\ex2.txt -Raw
$Source = Get-Content .\I.txt -Raw

$PageRules = ($Source -split "`r`n`r`n")[0]
$PlannedPageOrders = ($Source -split "`r`n`r`n")[1]

$Rules = $PageRules.split("`n") | Select-Object -Property @{N='Page';E={$_.Split('|')[0]}},@{N='Before';E={$_.Split('|')[1].trim()}}
$RulesHT = @{}

$Rules | Group-Object -Property Page | foreach {$RulesHT[$_.Name] = $_.Group.Before}

$Plans = New-Object System.Collections.Generic.List[System.Object]

$PlannedPageOrders.split("`n") | foreach { $Plans.add($_.split(','))  }
$GoodPlans = New-Object System.Collections.Generic.List[System.Object]


$Plans | foreach { 
    $Plan = $_
    $GoodPlan = $True
    $i = 1
    do { if ($Plan[0..($i-1)] | where {$_ -in $RulesHT[[string]$Plan[$i].trim()]}) {$GoodPlan = $false} ; $i++  } while ($i -lt $plan.count -and $GoodPlan -eq $true)

    if ($GoodPlan -eq $True) {$GoodPlans.add($Plan)}

    #$RulesHT[[string]$_]
}


($GoodPlans | foreach { $_[[math]::floor($_.count /2)] } | Measure-Object -sum).sum

#Answer
#4281