param(
	[parameter(ValueFromPipeline=$true)] [String] $chunk
)
Begin{
	$strData = ""
}
Process
{
	$strData += $chunk
}
End{	
	$data = $strData | ConvertFrom-Json
	
	Write-Host "Received $($data.Length) web apps."

	$webApps = @()
	foreach ($webApp in $data) {
		Write-Host "Fetching configs for web app: $($webApp.name)"
		
		$config = az webapp config show --name $webApp.name --resource-group $webApp.resourceGroup --subscription $webApp.subscription.id | ConvertFrom-Json
		$webApp | Add-Member -NotePropertyName siteConfigFull -NotePropertyValue $config
		
		$appSettings = az webapp config appsettings list --name $webApp.name --resource-group $webApp.resourceGroup --subscription $webApp.subscription.id | ConvertFrom-Json
		$appSettingNodeDefaultVersion = $appSettings | where { $_.name -eq "WEBSITE_NODE_DEFAULT_VERSION" }
		$appSettingsLimited = @{
			'WEBSITE_NODE_DEFAULT_VERSION' = $appSettingNodeDefaultVersion.value
		}
		$webApp | Add-Member -NotePropertyName someAppSettings -NotePropertyValue $appSettingsLimited
		
        $uri = "https://management.azure.com/subscriptions/$($webApp.subscription.id)/resourceGroups/$($webApp.resourceGroup)/providers/Microsoft.Web/sites/$($webApp.name)/config/metadata/list?api-version=2022-09-01"
        $moreConfigs = az rest --method post --uri $uri | ConvertFrom-Json
		$webApp | Add-Member -NotePropertyName moreConfigs -NotePropertyValue $moreConfigs
	
		$webApps += ,$webApp
	}

	Write-Output (ConvertTo-Json -Depth 10 $webApps)
}