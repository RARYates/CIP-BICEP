##Deploy ARM teplate using powershell

#Login to Azure
#Login-AzAccount
    
#Vars
$subscriptionName="<SUBSCRIPTION_NAME>"
$resourceGroupName="simple-windowsvm-demo-rg"
$location="Australia East"
$deploymentName="SimpleWINVM"
$bicepSrc="simple-windowsvm-deploy.bicep"
$armOutput="simple-windowsvm-deploy.json"
$templateParamFile="simple-windowsvm.parameters.json"

#Create an admin password
$adminPassword=$(pwgen -c -n -s 13 1)
#echo $adminPassword

#Admin user
$adminUser="devadm01"

#Select Subscription
$subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
Select-AzSubscription -SubscriptionId $subscriptionId  

#Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

#Convert Bicep to .JSON ARM template - issues with cmdlet - New-AzResourceGroupDeployment
az bicep build --file $bicepSrc

#Deploy the Decompiled ARM template with param file
New-AzResourceGroupDeployment `
  -Name $deploymentName `
  -ResourceGroupName $resourceGroupName `
  -TemplateFile $armOutput `
  -TemplateParameterFile $templateParamFile ##-AsJob


#Deploy the Decompiled ARM template with Admin username & Password
$paramObject = @{
  'adminUsername' = $adminUser
  'adminPassword'  = $adminPassword
}

New-AzResourceGroupDeployment `
-Name $deploymentName `
-ResourceGroupName $resourceGroupName `
-TemplateFile $armOutput `
-TemplateParameterObject $paramObject ##-AsJob

#Remove Resource Group
##Remove-AzResourceGroup -Name $resourceGroupName -Force -AsJob


