Import-Module ActiveDirectory
#Указываем общий сетевой ресурс
$Dir = "\\domain.local\profiles$"
#Указываем имя домена
$Domain = "domain.local"
#Получаем в переменную $Users пользователей для которых необходимо провести модификацию
$Users = Get-ADGroupMember -Identity "Domain Users"
foreach ($User in $Users) {
    # Складываем каждый необходимый параметр в переменную
    $User = $User.sAMAccountName
    #Создаем директорию с именем пользователя
    $Path = "$Dir\$User"
    If(!(Test-Path $Path))
    {
        New-Item -ItemType Directory -Path $Dir -Name $User
        New-Item -ItemType Directory -Path $Dir\$User -Name .telegram
        #Устанавливаем права на папку
        $ACL = Get-Acl $Path
        $AccessRule = new-object System.Security.AccessControl.FileSystemAccessRule($User, "DeleteSubdirectoriesAndFiles, Write, ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
        $ACL.SetAccessRule($AccessRule)
        Set-Acl -Path $Path -AclObject $ACL
    }
    $ACL = Get-Acl $Path
    $AccessRule = new-object System.Security.AccessControl.FileSystemAccessRule($User, "DeleteSubdirectoriesAndFiles, Write, ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $ACL.SetAccessRule($AccessRule)
    Set-Acl -Path $Path -AclObject $ACL
}
