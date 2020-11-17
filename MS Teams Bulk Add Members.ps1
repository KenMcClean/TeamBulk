$getAdminID = read-host "Enter the email address of the group administrator"
#The person adding members to the group must be an admin of the group

$Group_Info_Array = @()
#Declare a hash table in which the group values will be stored

$incrementKey = 1

connect-microsoftteams -AccountId $getAdminID
#You need to initiate a connection to the Teams backend, using the ID of the administrator

$userGroups = get-team -User $getAdminID | select-object groupid,displayname
#This gets a list of the teams that the admin is the member of, as well as the group ID of each team

Write-host "`r`nThe administrator is a member of these groups:"

foreach($userGroup in $userGroups){
write-host $incrementKey". ",$userGroup.Displayname
#for each of the groups to which the Admin belongs, list it and give it a number

$GroupInfo= New-Object -TypeName PSObject -Property @{
  GroupID = $userGroup.GroupId
  GroupName = $userGroup.DisplayName
}
#Create a new PS Custom Object containing the group ID and name

$Group_Info_Array += $GroupInfo
#Add the info to an array, to be referenced later

$incrementKey++
}

do{
#Solict input from the user regarding to which Team new members should be added
try
{$groupSelect = read-host "`r`nSelect to which Team new members should be added"}
catch{"Please enter a valid selection"}
}
while(($groupSelect -notmatch "^[1-5]?[0-9]$") -or ($groupSelect -gt $Group_Info_Array.count))
#Picked 59 as the arbitrary upper limit, and 1 as the lower limit. The input also cannot exceed the number of elements in the array

$groupSelect -= 1
#reduce the selection by 1 to account for an off-by-1 error

write-host "`r`nSelect a text file containing the email addresses of the users to be added:"
$dialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
#Initiate a Windows File Selection object

$dialog.AddExtension = $true
$dialog.Multiselect = $false
$dialog.FilterIndex = 0
$dialog.InitialDirectory = "$HOME\Documents"
$dialog.RestoreDirectory = $true
$dialog.ShowReadOnly = $true
$dialog.ReadOnlyChecked = $false
$dialog.Title = 'Select a List of Group Members'
$result = $dialog.ShowDialog()
#set the dialogue box options

if ($result = 'OK')
{
    $filename = $dialog.FileName
    #Get the path of the list of users to be added to the group. Users must be in the form of an email.
    $groupmembers = get-content $filename
    #get the content of the list
} 

do{
#Solict input from the user, confirming that they want to make these changes
try
{$confirmation = read-host "`r`nAre you sure you want to add these users to ",$Group_Info_Array[$groupSelect].GroupName,"(Y/N)?"
}
catch{"Please enter Y or N"}
}
while(("Y","N" -notcontains $confirmation))
#this confirmation is not case sensitive

if($confirmation -eq "Y"){
foreach($groupMember in $groupMembers){
write-host "Adding user $groupMember to" $Group_Info_Array[$groupSelect].GroupName, $Group_Info_Array[$groupSelect].groupID
#Tell the user what is happening
add-teamuser -GroupId $Group_Info_Array[$groupSelect].GroupID -user $groupMember
#Make the changes

}
}
else
{
write-host "`r`nExiting without making changes"
exit
#Exit without making changes, and without closing the window
}
exit
#Exit without closing the window, after users have been added to the group
#>
