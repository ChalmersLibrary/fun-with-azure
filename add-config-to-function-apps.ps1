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
	
	Write-Host "Received $($data.Length) function apps."

	$funApps = @()
	foreach ($funApp in $data) {
		Write-Host "Fetching configs for function app: $($funApp.name)"
		
		$config = az functionapp config show --name $funApp.name --resource-group $funApp.resourceGroup --subscription $funApp.subscription.id | ConvertFrom-Json
		$funApp | Add-Member -NotePropertyName siteConfigFull -NotePropertyValue $config
		
		$appSettings = az functionapp config appsettings list --name $funApp.name --resource-group $funApp.resourceGroup --subscription $funApp.subscription.id | ConvertFrom-Json
		$appSettingNodeDefaultVersion = $appSettings | where { $_.name -eq "WEBSITE_NODE_DEFAULT_VERSION" }
		$appSettingsLimited = @{
			'WEBSITE_NODE_DEFAULT_VERSION' = $appSettingNodeDefaultVersion.value
		}
		$funApp | Add-Member -NotePropertyName someAppSettings -NotePropertyValue $appSettingsLimited
	
		$funApps += ,$funApp
	}

	Write-Output (ConvertTo-Json $funApps)
}