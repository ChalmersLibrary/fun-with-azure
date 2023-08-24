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
	
		$webApps += ,$webApp
	}

	Write-Output (ConvertTo-Json $webApps)
}