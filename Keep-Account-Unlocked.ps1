######################################################### 
#               Account Unlock Tool V1.0                # 
#                Created By: Justin Lund                # 
#             https://github.com/Justin-Lund/           # 
######################################################### 


#--------------Functions--------------#

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

# Define function to unlock the user
Function Unlock-User {
    
    # Store status of whether or not user is locked out in a new variable
    $LockedOutStatus = (Get-ADUser $Username -Properties LockedOut).LockedOut

    If ($LockedOutStatus -eq $True)
        {
            Write-Host "`n$Username is locked out. Unlocking account" -ForegroundColor Red

            # Unlock account
            Unlock-ADAccount -Identity $Username

            $CurrentTime = Get-Date
            Write-Host "User unlocked at $CurrentTime`n" -ForegroundColor Cyan
            Sleep 10
        }

    # Otherwise, pause
    Else
        {
            Write-Host "$Username is not currently locked out."
            Sleep 5
        }

    }


#--------------Start Main--------------#

#Set Username
$Username = Read-Host "Please enter a username to keep unlocked"
Write-Host ""

# Verify user
Test-User

# Infinite Loop
While ($True) {

    # Loop 25 times, then clear screen
    While ($Counter -lt 25)
        {
            Unlock-User

            # Increase counter
            $Counter++
        }
    Clear-Host

    # Reset counter
    $Counter = 0
}
