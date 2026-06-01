#Script: Create Organizational Unit 

#Specify OU Variable names:
$parentOU = "IT"
$usersOU = "IT-Users"
$groupsOU = "IT-Groups"
$domainPath = "DC=iamlab,DC=chopra"

#Create Parent OU named IT
New-ADOrganizationalUnit -Name $parentOU -ProtectedFromAccidentalDeletion $true
Write-Host "Parent OU '$parentOU' has been created" -BackgroundColor Green


#Create Nested OUs IT-Users and It-Groups
New-ADOrganizationalUnit -Name $usersOU -Path "OU=$parentOU,$domainPath" -ProtectedFromAccidentalDeletion $true
New-ADOrganizationalUnit -Name $groupsOU -Path "OU=$parentOU,$domainPath" -ProtectedFromAccidentalDeletion $true


Write-Host "Nested Organizational Units '$usersOU' and '$groupsOU' are created under '$parentOU'" -BackgroundColor Green

