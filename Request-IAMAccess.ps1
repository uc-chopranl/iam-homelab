#Script: Request-IAM Access

function Request-IAMAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Requestor
    )

    $webhookURL = "https://chopranl.app.n8n.cloud/webhook/04158782-313e-4fa3-aa0d-71d1383b1c8e"

#Grab the requestor

    if (-not $Requestor) {
        $Requestor = Read-Host "Enter your username"
    }
    
    try {
        $adUser = Get-ADUser -Identity $Requestor -Properties Title, Department, MemberOf, Manager, UserPrincipalName, EmailAddress
    } catch {
        Write-Host "User '$Requestor' not found in AD" -ForegroundColor Red
        return
    }
    
    Write-Host ""
    Write-Host "Submitting request as: $($adUser.Name) ($($adUser.Title))" -ForegroundColor Cyan
    Write-Host ""

#Grab Manager 
$managerName = ""
if ($adUser.Manager) {
    try {
        $managerName = (Get-ADUser -Identity $adUser.Manager).SamAccountName
    } catch {
        $managerName = ""
    }
}

#Show available SG groups
    $availableGroups = Get-ADGroup -Filter "Name -like 'SG-*'" -SearchBase "OU=Groups,OU=Corporate,DC=iamlab,DC=chopra" |
                       Sort-Object Name

    if ($availableGroups.Count -eq 0) {
        Write-Host "No SG groups found." -ForegroundColor Red
        return
    }

#Get user's current groups so we can mark them
    $currentGroupNames = $adUser.MemberOf | ForEach-Object { (Get-ADGroup $_).Name }

    Write-Host "Available Security Groups:" -ForegroundColor Yellow
    Write-Host "---------------------------"

    for ($i = 0; $i -lt $availableGroups.Count; $i++) {
    $group = $availableGroups[$i]
    $isCurrentMember = $currentGroupNames -contains $group.Name
    $marker = if ($isCurrentMember) { " [already a member]" } else { "" }
    $color  = if ($isCurrentMember) { "DarkGray" } else { "White" }

    Write-Host ("  [{0}] {1}{2}" -f ($i + 1), $group.Name, $marker) -ForegroundColor $color
    }

    Write-Host ""
    $selection = Read-Host "Select a group by number"
    
#Validate selection
    $selectionInt = 0
    if (-not [int]::TryParse($selection, [ref]$selectionInt) -or $selectionInt -lt 1 -or $selectionInt -gt $availableGroups.Count) {
        Write-Host "Invalid selection." -ForegroundColor Red
        return
    }

    $selectedGroup = $availableGroups[$selectionInt - 1].Name

#Warn if user already has group
    if ($currentGroupNames -contains $selectedGroup) {
        Write-Host "You're already a member of $selectedGroup. Submit anyway? (y/n)" -ForegroundColor Yellow
        $confirm = Read-Host
        if ($confirm -ne "y") { return }
    }

#Get justification
    Write-Host ""
    $justification = Read-Host "Justification (why do you need this access?)"

    if ([string]::IsNullOrWhiteSpace($justification)) {
        Write-Host "Justification is required." -ForegroundColor Red
        return
    }

#Build JSON Payload
    $body = @{
        requestor                = $Requestor
        requestor_name           = $adUser.Name
        requestor_title          = $adUser.Title
        requestor_department     = $adUser.Department
        requestor_email          = $adUser.EmailAddress
        manager                  = $managerName
        requestor_current_groups = ($currentGroupNames -join ", ")
        resource_requested       = $selectedGroup
        justification            = $justification
        submitted_at             = (Get-Date -Format "o")
        submitted_from           = $env:COMPUTERNAME
    } | ConvertTo-Json
    
    Write-Host ""
    Write-Host "Submitting request..." -ForegroundColor Cyan
    Write-Host "  Group: $selectedGroup" -ForegroundColor Gray
    Write-Host "  Justification: $justification" -ForegroundColor Gray

    try {
        Invoke-RestMethod -Uri $webhookURL -Method Post -Body $body -ContentType "application/json" -ErrorAction Stop | Out-Null
        Write-Host ""
        Write-Host "Request submitted successfully. Check your email for status." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to submit request: $_" -ForegroundColor Red
    }
}       
