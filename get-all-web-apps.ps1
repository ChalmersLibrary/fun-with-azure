# Get all subscriptions
$subscriptions = az account list | ConvertFrom-Json
$webApps = @()

foreach ($subscription in $subscriptions) {
	Write-Host "Using subscription $($subscription.name) ($($subscription.id))"
	az account set --subscription $subscription.id
	
	# Get all webapps from subscription
	$webAppsAtSub = az webapp list | ConvertFrom-Json
	foreach ($webApp in $webAppsAtSub) {
		Write-Host "Found webapp $($webApp.name)."
		$webApp | Add-Member -NotePropertyName subscription -NotePropertyValue $subscription
		$webApps += ,$webApp
	}
}

Write-Host "Found $($webApps.Length) webapps in $($subscriptions.Length) subscriptions."

Write-Output (ConvertTo-Json $webApps)