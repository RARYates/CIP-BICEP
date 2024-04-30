Connect-AzAccount

Get-AzSubscription

$templateFile = 'main.bicep'
$resourceGroupname = "template-spec-demo-rg"


Set-AzContext -SubscriptionId  {Your subscription ID}

Set-AzDefault -ResourceGroupName $resourceGroupname


#Convert Bicep to .JSON ARM template - issues with cmdlet - New-AzResourceGroupDeployment
az bicep build --file $templateFile

#######################################
##Publish as Template spec
New-AzTemplateSpec `
  -ResourceGroupName $resourceGroupname `
  -Name ToyCosmosDBAccount `
  -Location australiaeast `
  -DisplayName 'Cosmos DB account' `
  -Description "This template spec creates a Cosmos DB account that meets our company's requirements." `
  -Version '1.0' `
  -TemplateFile 'main.json'

##Verify Template spec has been created

#######################################
  
  ##Deploy from Template spec
$templateSpecVersionResourceId = (`
Get-AzTemplateSpec `
    -ResourceGroupName $resourceGroupname `
    -Name ToyCosmosDBAccount `
    -Version 1.0 `
).Versions[0].Id

New-AzResourceGroupDeployment -TemplateSpecId $templateSpecVersionResourceId

##Verify deployment of resource

Remove-AzResourceGroup -Name $resourceGroupname

   #######################################