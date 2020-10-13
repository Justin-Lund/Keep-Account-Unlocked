######################################################### 
#               Account Re-Enable Tool V2.0             # 
#                Created By: Justin Lund                # 
#             https://github.com/Justin-Lund/           # 
######################################################### 


#--------------User Verification--------------#

# Define function to verify user is valid
Function Test-User {
    
    $Username = Get-ADUser -LDAPFilter "(SamAccountName=$Username)"

    # Pause if username is invalid
    If ($Username -eq $Null)
    {
        Write-Host ""
        Write-Host "User does not exist in AD"
        Pause
        Exit
    }

    # Proceed if username is valid
    Else
    {
    }
}


#--------------Start Main--------------#

#Set Username
$Username = Read-Host "Please enter a username to keep enabled"
Write-Host ""

# Verify user
Test-User

# Infinite Loop
While ($True) {

    # Loop 20 times, then clear screen
    While ($Counter -lt 20)
        {

            # Store status of whether or not user is disabled in a new variable
            # If True, user enabled. If false, user disabled.
            $EnabledStatus = (Get-ADUser $Username -Properties Enabled).Enabled

            # If the user is enabled
            If ($EnabledStatus -eq $True) {
                    Write-Host "$Username is not currently disabled."
                    Sleep 5
            }

            # If the user is disabled
            Else
                {
                    Write-Host "`n$Username is disabled. Re-enabling account" -ForegroundColor Red

                    # Enable account
                    Enable-ADAccount -Identity $Username

                    $CurrentTime = Get-Date
                    Write-Host "User unlocked at $CurrentTime`n" -ForegroundColor Cyan

                    $DisabledRecord += "$CurrentTime `n"
                    $DisabledCount += 1
                    $DisabledAtAll = $True
            
                    Sleep 10
            }

            # Increase counter
            $Counter++
        }

    # If user has been locked out at all, print the times the lockouts have occurred at after clearing the screen
    Clear-Host

    If ($DisabledAtAll -eq $True) {
        If ($DisabledCount -eq 1) {
            Write-Host "User has been disabled 1 time at:" -ForegroundColor Red
            Write-Host $DisabledRecord -ForegroundColor Cyan
        }
        Else {
            Write-Host "User has been disabled $DisabledCount times at:" -ForegroundColor Red
            Write-Host $DisabledRecord -ForegroundColor Cyan
            }
    }

    # Reset counter
    $Counter = 0
}