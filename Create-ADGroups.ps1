#Script: Create Security Groups and Adding AD Users to Groups

#Define Variables
$path = "OU=Groups,OU=Corporate,DC=iamlab,DC=chopra"
$ADGroups = @(
"SG-IAM-Admins", "SG-Cloud-Admins", "SG-Helpdesk", "SG-VPN-Users", "SG-MFA-Enforced"
)
$ADUsers = @("mscott", "tsoprano", "csoprano","rgreen","sstrange","mgeller","kwexler","jmcgill","ealderson","dalderson")

#Create AD Groups
ForEach($group in $ADGroups) {
New-ADGroup `
    -Name $group `
    -GroupScope Global `
    -GroupCategory Security `
    -Path $path `
    -ErrorAction Stop
Write-Host "Created: $group" -ForegroundColor Cyan
}

#Add AD members to Groups
Add-ADGroupMember -Identity "SG-IAM-Admins"   -Members "dalderson","mscott"
Add-ADGroupMember -Identity "SG-Cloud-Admins" -Members "csoprano","kwexler"
Add-ADGroupMember -Identity "SG-Helpdesk"     -Members "sstrange","rgreen"
Add-ADGroupMember -Identity "SG-VPN-Users"    -Members $ADUsers
Add-ADGroupMember -Identity "SG-MFA-Enforced" -Members "dalderson","mscott","csoprano","kwexler"


