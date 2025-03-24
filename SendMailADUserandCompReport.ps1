Import-Module ActiveDirectory

# Get the domain name
$domainName = (Get-ADDomain).DNSRoot

# Define the dates 120 and 90 days ago
$thresholdDateUser90 = (Get-Date).AddDays(-90)
$thresholdDateUser120 = (Get-Date).AddDays(-120)


# Define the dates 120 and 90 days ago
$thresholdDateComp60 = (Get-Date).AddDays(-60)
$thresholdDateComp90 = (Get-Date).AddDays(-90)


# Define the "YOUR DISABLED USER OU" and "YOUR DISABLED COMPUTER OU" OUs
$disableUsersOU = "YOUR DISABLED USER OU"
$disableComputersOU = "YOUR DISABLED USER OU"

# Get total number of users
$totalUsers = (Get-ADUser -Filter *).Count

# Get total number of computers
$totalComputers = (Get-ADComputer -Filter *).Count

# Get enabled user accounts 
$enabledUsers = Get-ADUser -Filter {Enabled -eq $true} 
$totalEnabledUsers = $enabledUsers.Count 
# Created by Erman ELMALI

# Get enabled service accounts 

$groupName = "SERVICE_ACCOUNT"
$group = Get-ADGroup -Filter { Name -eq $groupName }
$totalEnabledServiceAccounts= (Get-ADGroupMember -Identity $group).Count



# Get disabled user accounts 

$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} 
$totalDisabledUsers = $disabledUsers.Count

# Get enabled computer accounts 
$enabledComputers = Get-ADComputer -Filter {Enabled -eq $true} 
$totalEnabledComputers = $enabledComputers.Count 

# Get disabled computer accounts 
$disabledComputers = Get-ADComputer -Filter {Enabled -eq $false} 
$totalDisabledComputers = $disabledComputers.Count



# Get list of inactive users for both 120 and 90 days, including enabled/disabled status and OU check
$inactiveUsers90 = Get-ADUser -Filter {LastLogonTimeStamp -lt $thresholdDateUser90 -and Enabled -eq $true} -Property LastLogonTimeStamp, Enabled, DistinguishedName -SearchBase "YOUR SEARCH BASE USER OU" | Select-Object Name, LastLogonTimeStamp, Enabled, @{Name="InDisableUsersOU";Expression={($_.DistinguishedName -like "*$disableUsersOU*")}} | Sort-Object LastLogonTimeStamp
$inactiveUsers120 = Get-ADUser -Filter {LastLogonTimeStamp -lt $thresholdDateUser120 -and Enabled -eq $true} -Property LastLogonTimeStamp, Enabled, DistinguishedName -SearchBase "YOUR SEARCH BASE USER OU" | Select-Object Name, LastLogonTimeStamp, Enabled, @{Name="InDisableUsersOU";Expression={($_.DistinguishedName -like "*$disableUsersOU*")}} | Sort-Object LastLogonTimeStamp

# Get count of enabled and disabled inactive users
$inactiveUsers90EnabledCount = ($inactiveUsers90 | Where-Object { $_.Enabled -eq $true }).Count
$inactiveUsers90DisabledCount = ($inactiveUsers90 | Where-Object { $_.Enabled -eq $false }).Count
$inactiveUsers120EnabledCount = ($inactiveUsers120 | Where-Object { $_.Enabled -eq $true }).Count
$inactiveUsers120DisabledCount = ($inactiveUsers120 | Where-Object { $_.Enabled -eq $false }).Count

# Get list of inactive computers for both 60 and 90 days, including OU check
$inactiveComputers60 = Get-ADComputer -Filter {LastLogonTimeStamp -lt $thresholdDateComp60 -and Enabled -eq $true} -Property LastLogonTimeStamp, Enabled, DistinguishedName -SearchBase "YOUR SEARCH BASE COMPUTER OU" | Select-Object Name, LastLogonTimeStamp, Enabled, @{Name="InDisableComputersOU";Expression={($_.DistinguishedName -like "*$disableComputersOU*")}} | Sort-Object LastLogonTimeStamp
$inactiveComputers90 = Get-ADComputer -Filter {LastLogonTimeStamp -lt $thresholdDateComp90 -and Enabled -eq $true} -Property LastLogonTimeStamp, Enabled, DistinguishedName -SearchBase "YOUR SEARCH BASE COMPUTER OU" | Select-Object Name, LastLogonTimeStamp, Enabled, @{Name="InDisableComputersOU";Expression={($_.DistinguishedName -like "*$disableComputersOU*")}} | Sort-Object LastLogonTimeStamp

# Get count of enabled and disabled inactive computers
$inactiveComputers60EnabledCount = ($inactiveComputers60 | Where-Object { $_.Enabled -eq $true }).Count
$inactiveComputers60DisabledCount = ($inactiveComputers60 | Where-Object { $_.Enabled -eq $false }).Count
$inactiveComputers90EnabledCount = ($inactiveComputers90 | Where-Object { $_.Enabled -eq $true }).Count
$inactiveComputers90DisabledCount = ($inactiveComputers90 | Where-Object { $_.Enabled -eq $false }).Count
# Created by Erman ELMALI
# Create HTML report
$report = @"
<html>
<head>
    <title>ACTIVE DIRECTORY INACTIVE USER AND COMPUTER REPORT: $domainName</title>
    <div class="section one" id="section1"> </div>
    <style>
        body { font-family: 'Arial', sans-serif; background-color: #f7f7f7; color: #333; }
        h2, h3 { color: #d9534f; text-align: center; }
        p, table { margin: 0 auto; width: 80%; }
        p { margin-top: 20px; text-align: center; }
        table { border-collapse: collapse; width: 100%; background-color: #fff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #d9534f; color: white; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:hover { background-color: #f5c6cb; }
        .nav { text-align: center; margin-top: 20px; }
        .btn { background-color: #d9534f; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin: 5px; display: inline-block; }
        .btn:hover { background-color: #c9302c; }
        .section { margin-top: 20px; }
    </style>
</head>
<body>
    <h2>ACTIVE DIRECTORY INACTIVE USER AND COMPUTER REPORT: $domainName</h2>
    <p>TOTAL ACTIVE COMPUTERS COUNT: <strong>$totalenabledComputers</strong></p>
    <p>TOTAL ACTIVE USERS COUNT: <strong>$totalenabledUsers</strong></p>
    <p>TOTAL ACTIVE SERVICE ACCOUNT COUNT: <strong>$totalEnabledServiceAccounts</strong></p>
    
    <h3>INACTIVE USER AND COMPUTER COUNTS</h3>
    <table>
        <tr>
            <th>CATEGORY</th>
            <th>ACCOUNT COUNT IN ACTIVE DIRECTORY WITH "ENABLE" STATUS</th>
        </tr>
        <tr>
            <td>UNUSED USERS (90 DAYS)</td>
            <td>$inactiveUsers90EnabledCount</td>
        </tr>
        <tr>
            <td>UNUSED USERS (120 DAYS)</td>
            <td>$inactiveUsers120EnabledCount</td>
        </tr>
        <tr>
            <td>UNUSED COMPUTERS (60 DAYS)</td>
            <td>$inactiveComputers60EnabledCount</td>
        </tr>
        <tr>
            <td>UNUSED COMPUTERS (90 DAYS)</td>
            <td>$inactiveComputers90EnabledCount</td>
        </tr>
    </table>
    <div class="nav">
        <a href="#section1" class="btn">Users unused for 90 days</a>
        <a href="#section2" class="btn">Users unused for 120 days</a>
        <a href="#section3" class="btn">Computers unused for 60 days</a>
        <a href="#section4" class="btn">Computers unused for 90 days</a>
    </div>
"@

if($inactiveUsers90EnabledCount -gt 0){
$report += @"
    <div class="section" id="section1"></div>
    <h3>UNUSED USERS (90 DAYS)</h3>
    <table>
        <tr>
            <th>USER</th>
            <th>LAST LOGIN</th>
            <th>IS ACTIVE?</th>
            <th>MOVED TO DISABLED OU?</th>
        </tr>
"@
    foreach ($user in $inactiveUsers90) {
        $report += "<tr><td>$($user.Name)</td><td>$((Get-Date $user.LastLogonTimeStamp).ToString('dd/MM/yy HH:mm:ss'))</td><td>$($user.Enabled)</td><td>$($user.InDisableUsersOU)</td></tr>"
    }
}

if($inactiveUsers120EnabledCount -gt 0){
$report += @"
    </table>
    <div class="section" id="section2"></div>
    <h3>UNUSED USERS (120 DAYS)</h3>
    <table>
        <tr>
            <th>USER</th>
            <th>LAST LOGIN</th>
            <th>IS ACTIVE?</th>
            <th>MOVED TO DISABLED OU?</th>
        </tr>
"@
    foreach ($user in $inactiveUsers120) {
        $report += "<tr><td>$($user.Name)</td><td>$((Get-Date $user.LastLogonTimeStamp).ToString('dd/MM/yy HH:mm:ss'))</td><td>$($user.Enabled)</td><td>$($user.InDisableUsersOU)</td></tr>"
    }
}

if($inactiveComputers60EnabledCount -gt 0){
$report += @"
    </table>
    <div class="section" id="section3"></div>
    <h3>UNUSED COMPUTERS (60 DAYS)</h3>
    <table>
        <tr>
            <th>COMPUTER</th>
            <th>LAST LOGIN</th>
            <th>IS ACTIVE?</th>
            <th>MOVED TO DISABLED OU?</th>
        </tr>
"@
    foreach ($computer in $inactiveComputers60) {
        $report += "<tr><td>$($computer.Name)</td><td>$((Get-Date $computer.LastLogonTimeStamp).ToString('dd/MM/yy HH:mm:ss'))</td><td>$($computer.Enabled)</td><td>$($computer.InDisableComputersOU)</td></tr>"
    }
}

if($inactiveComputers90EnabledCount -gt 0){
$report += @"
    </table>
    <div class="section" id="section4"></div>
    <h3>UNUSED COMPUTERS (90 DAYS)</h3>
    <table>
        <tr>
            <th>COMPUTER</th>
            <th>LAST LOGIN</th>
            <th>IS ACTIVE?</th>
            <th>MOVED TO DISABLED OU?</th>
        </tr>
"@
    foreach ($computer in $inactiveComputers90) {
        $report += "<tr><td>$($computer.Name)</td><td>$((Get-Date $computer.LastLogonTimeStamp).ToString('dd/MM/yy HH:mm:ss'))</td><td>$($computer.Enabled)</td><td>$($computer.InDisableComputersOU)</td></tr>"
    }
}

$report += @"
    </table>      
</body>
</html>
"@
# Created by Erman ELMALI

# Save the HTML report to a file
$reportPath = "\\Share\InactiveUsersComputersReport.html"
$report | Out-File -FilePath $reportPath -Encoding UTF8

# Save the data to CSV files
$inactiveUsers90 | Export-Csv -Path "\\Share\InactiveUsers90.csv" -NoTypeInformation -Encoding UTF8
$inactiveUsers120 | Export-Csv -Path "\\Share\InactiveUsers120.csv" -NoTypeInformation -Encoding UTF8
$inactiveComputers60 | Export-Csv -Path "\\Share\InactiveComputers60.csv" -NoTypeInformation -Encoding UTF8
$inactiveComputers90 | Export-Csv -Path "\\Share\InactiveComputers90.csv" -NoTypeInformation -Encoding UTF8

# Send HTML report via email
$smtpServer = "SMTP ADDRESS"
$smtpFrom = "user.name@organization.com"
$smtpTo = "user.name@organization.com"
$smtpSubject = "ACTIVE DIRECTORY INACTIVE USER AND COMPUTER REPORT"
$smtpBody = "THE REPORT IS PROVIDED IN HTML FORMAT AS AN ATTACHMENT."

## Create a MailMessage object
$mailMessage = New-Object System.Net.Mail.MailMessage($smtpFrom, $smtpTo, $smtpSubject, $smtpBody)
$mailMessage.IsBodyHtml = $true

## Add BCC recipients
$mailMessage.Bcc.Add("user.name@organization.com")

# Attach the HTML report
$attachment = New-Object System.Net.Mail.Attachment($reportPath)
$mailMessage.Attachments.Add($attachment)

# Create a SmtpClient object and set the port to 25
$smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, 25)
$smtpClient.EnableSsl = $false

# Send the email
$smtpClient.Send($mailMessage)

Write-Output "Report sent successfully."


# Created by Erman ELMALI
