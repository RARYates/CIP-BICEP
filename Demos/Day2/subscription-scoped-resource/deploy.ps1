
Connect-AzAccount

Get-AzSubscription

Set-AzContext -SubscriptionId {Your subscription ID}

$templateFile = 'main.bicep'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "sub-scope-$today"
$location ="Australia East"

#Convert Bicep to .JSON ARM template - issues with cmdlet - New-AzSubscriptionDeployment
az bicep build --file $templateFile

New-AzSubscriptionDeployment `
  -Name $deploymentName `
  -Location $location `
  -TemplateFile "main.json"