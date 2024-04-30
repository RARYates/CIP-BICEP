

Connect-AzAccount

Get-AzSubscription

Set-AzContext -SubscriptionId {Your subscription ID}

$templateFile = 'main.bicep'
$today = Get-Date -Format 'MM-dd-yyyy'
$deploymentName = "sub-scope-$today"
$virtualNetworkName = 'rnd-vnet-001'
$virtualNetworkAddressPrefix = '10.0.0.0/24'


#Convert Bicep to .JSON ARM template - issues with cmdlet - New-AzSubscriptionDeployment
az bicep build --file $templateFile

New-AzSubscriptionDeployment `
  -Name $deploymentName `
  -Location australiaeast `
  -TemplateFile "main.json" `
  -virtualNetworkName $virtualNetworkName `
  -virtualNetworkAddressPrefix $virtualNetworkAddressPrefix


$subscriptionId = (Get-AzContext).Subscription.Id
Remove-AzPolicyAssignment -Name 'DenyFandGSeriesVMs' -Scope "/subscriptions/$subscriptionId"
Remove-AzPolicyDefinition -Name 'DenyFandGSeriesVMs' -SubscriptionId $subscriptionId
Remove-AzResourceGroup -Name ToyNetworking