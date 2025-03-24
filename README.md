# Active Directory Inactive Users and Computers Report

## Overview
This script generates an HTML report, CSV files, and sends an email containing details of inactive users and computers in Active Directory. It is designed to help system administrators monitor inactive accounts and take necessary actions, such as moving them to a disabled organizational unit (OU).

---

## Features
- Generates a structured **HTML Report** with inactive user and computer details.
- Exports inactive user and computer data to **CSV files** for further analysis.
- Automatically emails the generated report to specified recipients.
- Categorizes inactive users and computers based on inactivity durations (e.g., 90 days, 120 days).

---

## Prerequisites
1. **Active Directory Module for Windows PowerShell** must be installed and configured.
2. The script requires access to the **SMTP Server** for sending emails.
3. Ensure proper permissions to generate and save reports on the shared folder path (`\\Share\Reports\`).

---

## How It Works
1. **Fetch Data:** The script queries Active Directory for user and computer accounts that have been inactive for specific durations.
2. **Generate Report:** Creates a user-friendly HTML report containing:
   - Total active users, computers, and service accounts.
   - Breakdown of inactive user and computer counts based on inactivity duration.
3. **Save Data:**
   - Exports detailed data for inactive accounts into CSV files.
   - Saves the HTML report to a specified directory.
4. **Email Report:** Sends the HTML report via email to designated recipients with optional BCC recipients.

---

## Configuration
### Variables to Configure
- `$domainName`: The domain name for the report title.
- `$inactiveUsers90`, `$inactiveUsers120`, `$inactiveComputers60`, `$inactiveComputers90`: Data collections of inactive users and computers.
- **SMTP Configuration:**
  - `$smtpServer`: The SMTP server address.
  - `$smtpFrom`: Sender's email address.
  - `$smtpTo`: Recipient's email address(es).
  - Add BCC recipients using `$mailMessage.Bcc.Add()` if required.
- **File Paths:**
  - `$reportPath`: Location to save the HTML report.
  - CSV paths for inactive users and computers, e.g., `\\Share\Reports\InactiveUsers90.csv`.

---

## Usage
1. Open PowerShell with administrator privileges.
2. Modify the script to include your domain name, SMTP details, and any other configurations.
3. Run the script to generate the report and send it via email.

---

## Output
1. **HTML Report:** Contains a summary and detailed breakdown of inactive accounts.
2. **CSV Files:** Raw data for inactive users and computers, categorized by inactivity duration:
   - `InactiveUsers90.csv`
   - `InactiveUsers120.csv`
   - `InactiveComputers60.csv`
   - `InactiveComputers90.csv`
3. **Email:** The report is sent to specified recipients with the HTML file attached.

---

## Customization
- Adjust the inactivity thresholds (e.g., 60 days, 90 days) to suit your organizational policy.
- Add additional fields or filters if required, such as specific OUs.

---

## Notes
- This script is designed for use in environments with strict permissions and policies. Test the script in a non-production environment before deployment.
- The HTML report's styling and structure can be customized within the script.

---

## Troubleshooting
- Ensure that the script has appropriate permissions to access and write to the specified paths.
- Verify SMTP configuration if emails are not being sent.
- Debug Active Directory queries to ensure they return the expected results.

---
## Created By
**Erman ELMALI**

---
## License
This script is provided as-is and is intended for educational and organizational use. Modify and use it at your own discretion.
