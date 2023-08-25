# fun-with-azure
Some scripts to wrangle stuff from Azure.

# The Scripts

* **get-all-*.ps1**
  
  Fetches all items of the given type from all available subscriptions.
* **add-config-to-*.ps1**
  
  Adds some missing configuration data to all items.
* **map-name-and-node-version-sort-on-node-version.ps1**
  
  Extracts data about node version and returns a list sorted on that.
* **map-name-and-python-version-sort-on-python-version.ps1**
  
  Extracts data about python version and returns a list sorted on that.

# Prerequisites

* Have PowerShell installed and run the scripts in it.
* Have Azure CLI installed.
* Use for example "az login" to authenticate using the Azure CLI.

# Example Usage

* Get all function apps, add config data and sort on node version.

  > .\get-all-function-apps.ps1 | .\add-config-to-function-apps.ps1 | .\map-name-and-node-version-sort-on-node-version.ps1

* Get all web apps, add config data and sort on node version.

  > .\get-all-web-apps.ps1 | .\add-config-to-web-apps.ps1 | .\map-name-and-node-version-sort-on-node-version.ps1

* Get all web apps, add config data, store data and use stored data multiple times.

  > .\get-all-web-apps.ps1 | .\add-config-to-web-apps.ps1 > .\web-apps-with-config.json
  >
  > cat .\web-apps-with-config.json | .\map-name-and-node-version-sort-on-node-version.ps1
  >
  > cat .\web-apps-with-config.json | .\map-name-and-python-version-sort-on-python-version.ps1
