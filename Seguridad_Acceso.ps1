$script:AccessSessions = @{}
$script:CredentialPath = $null

function New-AccessRandom([int]$Length = 32) {
    $bytes = New-Object byte[] $Length
    [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
    [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+','-').Replace('/','_')
}

function Get-AccessHash([string]$Password, [byte[]]$Salt, [int]$Iterations) {
    $pbkdf2 = [Security.Cryptography.Rfc2898DeriveBytes]::new($Password,$Salt,$Iterations,[Security.Cryptography.HashAlgorithmName]::SHA256)
    try { $pbkdf2.GetBytes(32) } finally { $pbkdf2.Dispose() }
}

function Test-AccessHash([byte[]]$A, [byte[]]$B) {
    if ($A.Length -ne $B.Length) { return $false }
    $difference = 0
    for ($i=0; $i -lt $A.Length; $i++) { $difference = $difference -bor ($A[$i] -bxor $B[$i]) }
    $difference -eq 0
}

function Read-AccessForm($Request) {
    $reader = [IO.StreamReader]::new($Request.InputStream,$Request.ContentEncoding)
    try { $body=$reader.ReadToEnd() } finally { $reader.Dispose() }
    $form=@{}
    foreach($item in $body -split '&') {
        $pair=$item -split '=',2
        $key=[Uri]::UnescapeDataString($pair[0].Replace('+',' '))
        $value=if($pair.Count -gt 1){[Uri]::UnescapeDataString($pair[1].Replace('+',' '))}else{''}
        $form[$key]=$value
    }
    $form
}

function Send-AccessPage($Context,[string]$Message='',[int]$Status=200) {
    $setup=-not (Test-Path -LiteralPath $script:CredentialPath)
    $title=if($setup){'Crear acceso privado'}else{'Acceso privado'}
    $text=if($setup){'Configure un usuario y una contraseña de al menos 12 caracteres. Las credenciales se guardarán únicamente en este ordenador.'}else{'Introduzca sus credenciales para consultar los registros.'}
    $action=if($setup){'/__setup'}else{'/__login'}
    $button=if($setup){'Crear acceso'}else{'Entrar'}
    $error=if($Message){'<p class="error">'+[Net.WebUtility]::HtmlEncode($Message)+'</p>'}else{''}
    $html=@"
<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>$title</title><style>*{box-sizing:border-box}body{margin:0;min-height:100vh;display:grid;place-items:center;padding:22px;font-family:Segoe UI,Arial,sans-serif;color:#173c58;background:#eaf6ff}.box{width:min(440px,100%);background:#fff;border:1px solid #bad8ec;border-radius:18px;padding:28px;box-shadow:0 18px 55px #123b6338}h1{margin:0 0 8px;color:#123b63}p{line-height:1.5}.field{display:grid;gap:6px;margin:16px 0}label{font-weight:700;font-size:13px}input{width:100%;border:1px solid #9dc7e2;border-radius:9px;padding:11px;font:inherit}button{width:100%;border:0;border-radius:10px;padding:12px;background:#167dbb;color:#fff;font-weight:750;font:inherit;cursor:pointer}.error{background:#ffe4e4;border-left:4px solid #b8323c;padding:9px}.legal{font-size:12px;color:#60798c;margin-top:18px}</style></head><body><main class="box"><h1>$title</h1><p>$text</p>$error<form method="post" action="$action"><div class="field"><label for="user">Usuario</label><input id="user" name="user" required maxlength="80" autocomplete="username"></div><div class="field"><label for="password">Contraseña</label><input id="password" name="password" type="password" required minlength="12" maxlength="200" autocomplete="current-password"></div><button>$button</button></form><p class="legal">Aplicación local: no envía las credenciales ni los registros a servicios externos.</p></main></body></html>
"@
    $bytes=[Text.Encoding]::UTF8.GetBytes($html)
    $Context.Response.StatusCode=$Status
    $Context.Response.ContentType='text/html; charset=utf-8'
    $Context.Response.Headers['Cache-Control']='no-store'
    $Context.Response.Headers['X-Frame-Options']='DENY'
    $Context.Response.Headers['X-Content-Type-Options']='nosniff'
    $Context.Response.Headers['Referrer-Policy']='no-referrer'
    $Context.Response.ContentLength64=$bytes.Length
    $Context.Response.OutputStream.Write($bytes,0,$bytes.Length)
    $Context.Response.Close()
}

function Set-AccessSession($Context) {
    $token=New-AccessRandom 32
    $script:AccessSessions[$token]=[DateTime]::UtcNow.AddHours(8)
    $cookie=[Net.Cookie]::new('calendario_session',$token,'/')
    $cookie.HttpOnly=$true
    $cookie.Expires=[DateTime]::UtcNow.AddHours(8)
    $Context.Response.Cookies.Add($cookie)
}

function Send-AccessRedirect($Context,[string]$Location='/') {
    $Context.Response.StatusCode=303
    $Context.Response.RedirectLocation=$Location
    $Context.Response.Headers['Cache-Control']='no-store'
    $Context.Response.Close()
}

function Test-AccessSession($Request) {
    $cookie=$Request.Cookies['calendario_session']
    if($null -eq $cookie -or -not $script:AccessSessions.ContainsKey($cookie.Value)){return $false}
    if($script:AccessSessions[$cookie.Value] -lt [DateTime]::UtcNow){$script:AccessSessions.Remove($cookie.Value);return $false}
    $script:AccessSessions[$cookie.Value]=[DateTime]::UtcNow.AddHours(8)
    $true
}

function Invoke-AccessControl($Context,[string]$ProjectRoot) {
    if($null -eq $script:CredentialPath){$script:CredentialPath=Join-Path $ProjectRoot 'datos\credenciales.local.json'}
    $path=$Context.Request.Url.AbsolutePath
    if($path -eq '/__setup' -and $Context.Request.HttpMethod -eq 'POST'){
        if(Test-Path -LiteralPath $script:CredentialPath){Send-AccessPage $Context 'El acceso ya está configurado.' 409;return $true}
        $form=Read-AccessForm $Context.Request
        if([string]::IsNullOrWhiteSpace($form.user) -or $form.password.Length -lt 12){Send-AccessPage $Context 'Indique un usuario y una contraseña de al menos 12 caracteres.' 400;return $true}
        $salt=New-Object byte[] 32;[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($salt)
        $iterations=210000;$hash=Get-AccessHash $form.password $salt $iterations
        @{user=$form.user.Trim();salt=[Convert]::ToBase64String($salt);hash=[Convert]::ToBase64String($hash);iterations=$iterations;createdUtc=[DateTime]::UtcNow.ToString('o')}|ConvertTo-Json|Set-Content -LiteralPath $script:CredentialPath -Encoding UTF8
        Set-AccessSession $Context;Send-AccessRedirect $Context;return $true
    }
    if($path -eq '/__login' -and $Context.Request.HttpMethod -eq 'POST'){
        if(-not(Test-Path -LiteralPath $script:CredentialPath)){Send-AccessRedirect $Context;return $true}
        $form=Read-AccessForm $Context.Request;$stored=Get-Content -LiteralPath $script:CredentialPath -Raw|ConvertFrom-Json
        $candidate=Get-AccessHash $form.password ([Convert]::FromBase64String($stored.salt)) ([int]$stored.iterations)
        $validUser=[string]::Equals($form.user,$stored.user,[StringComparison]::OrdinalIgnoreCase)
        if(-not($validUser -and (Test-AccessHash $candidate ([Convert]::FromBase64String($stored.hash))))){Start-Sleep -Milliseconds 500;Send-AccessPage $Context 'Usuario o contraseña incorrectos.' 401;return $true}
        Set-AccessSession $Context;Send-AccessRedirect $Context;return $true
    }
    if($path -eq '/__logout'){
        $cookie=$Context.Request.Cookies['calendario_session'];if($null -ne $cookie){$script:AccessSessions.Remove($cookie.Value)}
        $expired=[Net.Cookie]::new('calendario_session','','/');$expired.Expires=[DateTime]::UtcNow.AddDays(-1);$Context.Response.Cookies.Add($expired)
        Send-AccessRedirect $Context;return $true
    }
    if(-not(Test-AccessSession $Context.Request)){Send-AccessPage $Context;return $true}
    return $false
}
