$getAdminID = read-host "Enter the email address of the group administrator"
#The person adding members to the group must be an admin of the group

$Group_Hash = @{}
#Declare a hash table in which the group values will be stored

$incrementKey = 1
#we need a way to increment the key as the user groups are iterated. we start at 1, not zero, because we're referencing keys instead of array entries

connect-microsoftteams -AccountId $getAdminID
#You need to initiate a connection to the Teams backend, using the ID of the administrator

$userGroups = get-team -User $getAdminID | select-object groupid,displayname
#This gets a list of the teams that the admin is the member of, as well as the group ID of each team

Write-host "`r`nThe administrator is a member of these groups:"

foreach($userGroup in $userGroups){
write-host $incrementKey". ",$userGroup.Displayname
#for each of the groups to which the Admin belongs, list it and give it a number

$Group_Hash.add($incrementKey, $userGroup.GroupId)
#Add the group to a hash, along with a number to use as a key

$incrementKey++
}

$hashSelect = read-host "`r`nSelect which group new members should be added to"
#get the key from the user

$selection = $Group_Hash.[int]$hashselect
#using the key from the user, retrieve the group id with a key that matches what the user put in

write-host "`r`nSelect a text file containing the email addresses of the users to be added"
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

foreach($groupMember in $groupMembers){
write-host "Adding user"$groupMember "to the Team with a group id of" $selection
#Tell the user what is happening
#add-teamuser -GroupId $selection -user $groupMember
}