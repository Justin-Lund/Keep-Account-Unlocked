######################################################### 
#               Account Unlock Tool V2.0                # 
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
$Username = Read-Host "Please enter a username to keep unlocked"
Write-Host ""

# Verify user
Test-User

# Infinite Loop
While ($True) {

    # Loop 20 times, then clear screen
    While ($Counter -lt 20)
        {

            # Store status of whether or not user is locked out in a new variable
            $LockedOutStatus = (Get-ADUser $Username -Properties LockedOut).LockedOut

            # If the user is locked out
            If ($LockedOutStatus -eq $True) {
                    Write-Host "`n$Username is locked out. Unlocking account" -ForegroundColor Red

                    # Unlock account
                    Unlock-ADAccount -Identity $Username

                    $CurrentTime = Get-Date
                    Write-Host "User unlocked at $CurrentTime`n" -ForegroundColor Cyan

                    $LockoutRecord += "$CurrentTime `n"
                    $LockoutCount += 1
                    $LockedOutAtAll = $True
            
                    Sleep 10
            }

            # If the user is not locked out
            Else
                {
                    Write-Host "$Username is not currently locked out."
                    Sleep 5
            }

            # Increase counter
            $Counter++
        }

    # If user has been locked out at all, print the times the lockouts have occurred at after clearing the screen
    Clear-Host

    If ($LockedOutAtAll -eq $True) {
        If ($LockoutCount -eq 1) {
            Write-Host "User has been locked out 1 time at:" -ForegroundColor Red
            Write-Host $LockoutRecord -ForegroundColor Cyan
        }
        Else {
            Write-Host "User has been locked out $LockoutCount times at:" -ForegroundColor Red
            Write-Host $LockoutRecord -ForegroundColor Cyan
            }
    }

    # Reset counter
    $Counter = 0
}
