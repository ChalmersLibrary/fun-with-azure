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

	$output = @()
	foreach ($webApp in $data) {
		$mapObj = @{
			'name' = $webApp.name
			'websiteNodeDefaultVersion' = $webApp.someAppSettings.WEBSITE_NODE_DEFAULT_VERSION
			'nodeVersion' = $webApp.siteConfigFull.nodeVersion
			'linuxFxVersion' = $webApp.siteConfigFull.linuxFxVersion
			'runtime' = $webApp.moreConfigs.properties.CURRENT_STACK
			'scmType' = $webApp.siteConfigFull.scmType
		}
		$output += ,$mapObj
	}

	$output = $output | Sort-Object @{Expression = { $_.websiteNodeDefaultVersion }; Descending = $true },
		@{Expression = { $_.nodeVersion }; Descending = $true },
		@{Expression = { $_.linuxFxVersion }; Descending = $true },
		{ $_.name }

	Write-Output (ConvertTo-Json $output)
}