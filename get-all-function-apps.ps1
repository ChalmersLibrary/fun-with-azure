# Get all subscriptions
$subscriptions = az account list | ConvertFrom-Json
$webApps = @()

foreach ($subscription in $subscriptions) {
	Write-Host "Using subscription $($subscription.name) ($($subscription.id))"
	az account set --subscription $subscription.id
	
	# Get all webapps from subscription
	$funAppsAtSub = az functionapp list | ConvertFrom-Json
	foreach ($funApp in $funAppsAtSub) {
		Write-Host "Found function app $($funApp.name)."
		$funApp | Add-Member -NotePropertyName subscription -NotePropertyValue $subscription
		$funApps += ,$funApp
	}
}

Write-Host "Found $($funApps.Length) function apps in $($subscriptions.Length) subscriptions."

Write-Output (ConvertTo-Json $funApps)