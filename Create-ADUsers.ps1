#Script: Create 10 Test Users Active Directory

#Specify Variables
$path = "OU=Users,OU=Corporate,DC=iamlab,DC=chopra"
$standardPassword = ConvertTo-SecureString 'P@$$w0rd2026!' -AsPlainText -Force 
$userList = @(
@{First="Michael";Last="Scott";Title="IAM Analyst"},
@{First="Tony";Last="Soprano";Title="Security Engineer"},
@{First="Carmela";Last="Soprano";Title="Cloud Administrator"},
@{First="Rachel";Last="Green";Title="IT Manager"},
@{First="Stephen";Last="Strange";Title="Help Desk Analyst"},
@{First="Monica";Last="Geller";Title="Network Engineer"},
@{First="Kim";Last="Wexler";Title="DevOps Engineer"},
@{First="James";Last="McGill";Title="SOC Analyst"},
@{First="Elliot";Last="Alderson";Title="Compliance Officer"},
@{First="Darlene";Last="Alderson";Title="IAM Architect"}
)


#Create User going through userList in for loop
foreach ($user in $userList) {
$sAMAccountName = ($user.First[0] + $user.Last).ToLower()
$UPN = "$sAMAccountName@iamlab.chopra" 
$DisplayName = "$($user.First) $($user.Last)"


New-ADUser `
    -Name $displayName `
    -GivenName $user.First `
    -Surname $user.Last `
    -SamAccountName $sAMAccountName `
    -UserPrincipalName $UPN `
    -Title $user.Title `
    -Path $path `
    -AccountPassword $standardPassword `
    -Enabled $true

Write-Host "Created: $displayName ($sAMAccountName)" -ForegroundColor Green  
} 
