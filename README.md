# Active Directory Inactive Users and Computers Report

## Overview
This PowerShell script is designed to generate reports identifying inactive users and computers in Active Directory. It helps system administrators monitor inactive accounts, evaluate their statuses, and determine if they should be moved to a "disabled" organizational unit (OU) for better management.

---

## Features
- **HTML Report:** A detailed report with categorized inactive user and computer information.
- **CSV Exports:** Raw data for inactive users and computers saved in separate CSV files for further analysis.
- **Email Notification:** Sends the HTML report via email to specified recipients, allowing for quick access and sharing.
- **Custom Thresholds:** Categorizes accounts based on inactivity durations (e.g., 90 days for users, 60 days for computers, etc.).
- **OU Checks:** Verifies if inactive accounts are already located in designated "disabled" OUs.

---

## Prerequisites
1. **Active Directory Module for Windows PowerShell:** The module must be installed and available on the machine running the script.
2. **SMTP Server Access:** The script requires a valid SMTP server to send email notifications.
3. **Permissions:** Ensure the account running the script has:
   - Read access to query Active Directory.
   - Write permissions to save reports to the specified directory.
4. Configure the variables such as OUs, SMTP settings, and thresholds according to your environment.

---

## Configuration
### Adjustable Variables
Before running the script, modify the following:
- **Domain and OUs:**
  - `$domainName`: Automatically fetched from your Active Directory.
  - `$disableUsersOU` and `$disableComputersOU`: Specify the distinguished names of your disabled users and computers OUs.
- **Inactivity Thresholds:**
  - Users: 90 and 120 days.
  - Computers: 60 and 90 days.
- **SMTP Settings:**
  - `$smtpServer`: Your organization's SMTP server address.
  - `$smtpFrom`: Sender's email address.
  - `$smtpTo`: Recipient's email address(es). You can add more using `BCC`.
- **File Paths:**
  - `$reportPath`: Directory path to save the HTML report.
  - CSV file paths: Adjust as needed, e.g., `\\Share\Reports\InactiveUsers90.csv`.

---

## How It Works
1. **Data Retrieval:** Queries Active Directory for:
   - Enabled and disabled user and computer accounts.
   - Inactive users (e.g., 90 days, 120 days).
   - Inactive computers (e.g., 60 days, 90 days).
2. **Report Creation:** Combines the retrieved data into a formatted HTML report.
3. **CSV Export:** Exports detailed inactive account data into categorized CSV files.
4. **Email Notification:** Sends the HTML report as an email attachment.

---

## Outputs
1. **HTML Report:** Displays:
   - Total active users, computers, and service accounts.
   - Counts of inactive users and computers by duration.
   - Detailed tables for each category, including OU verification.
2. **CSV Files:** Saved for detailed analysis:
   - `InactiveUsers90.csv`
   - `InactiveUsers120.csv`
   - `InactiveComputers60.csv`
   - `InactiveComputers90.csv`
3. **Email Delivery:** Sends the HTML report to the specified recipients.

---

## Usage
1. Open PowerShell with administrator privileges.
2. Edit the script to reflect your Active Directory environment and organizational requirements.
3. Run the script to:
   - Generate an HTML report and CSV files.
   - Send the report via email.
4. Review the outputs in the specified file paths and email inbox.

---

## Example Outputs
### HTML Report Summary
- **Total active accounts (users, computers, service accounts).**
- **Breakdown of inactive accounts by duration:**
  - Users inactive for 90 and 120 days.
  - Computers inactive for 60 and 90 days.

### Sample CSV File
A CSV file (`InactiveUsers90.csv`) includes columns like:
- **Name:** Account name.
- **Last Login:** Timestamp of the last logon.
- **Enabled:** Whether the account is active.
- **In Disabled OU?:** If the account is in the specified disabled OU.

---

## Troubleshooting
- **SMTP Issues:** Verify that the SMTP server and port are accessible.
- **Permission Denied:** Ensure that the PowerShell user account has sufficient permissions for Active Directory and file system access.
- **No Data Retrieved:** Check the search base OUs and inactivity thresholds for correctness.

---

## Created By
**Erman ELMALI**

---

## License
This script is provided as-is and is intended for internal organizational use. Modify and use it at your discretion.
