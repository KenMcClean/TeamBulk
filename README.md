**Overview:**
- This script logs onto the Teams backend using the account of a group administrator, and gets a list of the groups to which the admin is a member.
- It requests that the user indicate to which of those groups the users should be added.
- The script then accepts a list of users to be added to that team in bulk (text file, line-seperated)
- Only the administrator of a Team can add members in bulk; administrators cannot see or query Teams of which they are not a member.

**Prerequisites:**
You must first install the PowerShell Teams module by running this command in an elevated PowerShell window: Install-Module -Name MicrosoftTeams -RequiredVersion 1.1.6 
The person adding members to a group must themselves be an admin of that group

**Dependencies:**
The script expects to be fed a list of persons to be added to the group. These users must be identified USING THEIR EMAIL ADDRESSES

**#Errors:**
If the script seems to have stalled, check to see if the File Selection window has opened behind the PowerShell window
