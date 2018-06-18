param(
[string]$trigger = $(Throw "'-trigger' argument is mandatory")
)

$token = ""
$chat_id = ""
$markdown_mode = "HTML"

$text = "zzz"

$tmp1=Test-Path -Path C:\scripts\$trigger.txt
if($tmp1) {
   $id = (Get-Content C:\scripts\$trigger.txt -TotalCount 1)
   $id
} else {
   New-Item -Path C:\scripts\$trigger.txt -ItemType File
}

$data = Get-EventLog -LogName Security -InstanceId $trigger | Where-Object {$_.Index -gt $id} | Sort-Object -Property Index

foreach ($item in $data) {
    $time = Get-Date ($item.TimeGenerated) -Format F 
    $time

    if ($trigger -eq 4720) {
    # User add
    $text = $time + "`n" + "Вывозить в лес: " + $item.ReplacementStrings[4] + "`n" + "Добавил пользователя: " + $item.ReplacementStrings[8] + " (" + $item.ReplacementStrings[9] + ")"
    } ElseIf ($trigger -eq 4726) {
    # Group add
    $text = $time + "`n" + "Вывозить в лес: " + $item.ReplacementStrings[4] + "`n" + "Удалил пользователя: " + $item.ReplacementStrings[8] + " (" + $item.ReplacementStrings[9] + ")"
    } ElseIf ($trigger -eq 4728 -or $trigger -eq 4732) {
    # Group add
    $sidUser = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $item.ReplacementStrings[1]
    $user = $sidUser.Translate([System.Security.Principal.NTAccount]).Value
    $text = $time + "`n" + "Вывозить в лес: " + $item.ReplacementStrings[6] + "`n" + "Добавил группу " + $item.ReplacementStrings[2] + " пользователю " + $user.Substring(9)
    } ElseIf ($trigger -eq 4729 -or $trigger -eq 4733) {
    # Group remove
    $sidUser = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $item.ReplacementStrings[1]
    $user = $sidUser.Translate([System.Security.Principal.NTAccount]).Value
    $text = $time + "`n" + "Вывозить в лес: " + $item.ReplacementStrings[6] + "`n" + "Удалил группу " + $item.ReplacementStrings[2] + " у пользователя " + $user.Substring(9)
    }
    
    $payload = @{
        "chat_id" = $chat_id;
        "text" = $text;
        "parse_mode" = $markdown_mode;
        "disable_web_page_preview" = $preview_mode;
    }

    Invoke-WebRequest `
        -Uri ("https://api.telegram.org/bot{0}/sendMessage" -f $token) `
        -Method Post `
        -ContentType "application/json;charset=utf-8" `
        -Body (ConvertTo-Json -Compress -InputObject $payload)
}

if ($item.Index) {
$item.Index | Out-File -FilePath C:\scripts\$trigger.txt
}
