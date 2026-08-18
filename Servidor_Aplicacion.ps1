$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $projectRoot 'Seguridad_Acceso.ps1')
$port = 8765
$prefix = "http://127.0.0.1:$port/"
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add($prefix)
try {
    $listener.Start()
} catch {
    Start-Process $prefix
    exit 0
}
Start-Process $prefix
$mime = @{
    '.html'='text/html; charset=utf-8'; '.js'='text/javascript; charset=utf-8';
    '.css'='text/css; charset=utf-8'; '.json'='application/json; charset=utf-8';
    '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'; '.png'='image/png';
    '.ods'='application/vnd.oasis.opendocument.spreadsheet';
    '.xlsx'='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    '.docx'='application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    '.txt'='text/plain; charset=utf-8'
}
while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        if (Invoke-AccessControl $context $projectRoot) { continue }
        $context.Response.Headers['Cache-Control'] = 'no-store'
        $context.Response.Headers['X-Content-Type-Options'] = 'nosniff'
        $context.Response.Headers['X-Frame-Options'] = 'DENY'
        $context.Response.Headers['Referrer-Policy'] = 'no-referrer'
        $relative = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath.TrimStart('/'))
        if ($context.Request.Url.AbsolutePath -eq '/__open') {
            $requested = [Uri]::UnescapeDataString($context.Request.QueryString['path'])
            $document = [IO.Path]::GetFullPath((Join-Path $projectRoot $requested.Replace('/', [IO.Path]::DirectorySeparatorChar)))
            $allowed = @('.ods','.xlsx','.xls','.docx','.doc','.odt')
            if (-not $document.StartsWith($projectRoot, [StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $document -PathType Leaf) -or $allowed -notcontains [IO.Path]::GetExtension($document).ToLowerInvariant()) {
                $context.Response.StatusCode = 403
                $message = [Text.Encoding]::UTF8.GetBytes('Documento no permitido o inexistente.')
                $context.Response.OutputStream.Write($message,0,$message.Length)
                $context.Response.Close()
                continue
            }
            $officeCandidates = @(
                'C:\Program Files\OpenOffice 4\program\soffice.exe',
                'C:\Program Files (x86)\OpenOffice 4\program\soffice.exe',
                'C:\Program Files\LibreOffice\program\soffice.exe',
                'C:\Program Files (x86)\LibreOffice\program\soffice.exe'
            )
            $office = $officeCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
            if (-not $office) { throw 'No se encontró OpenOffice ni LibreOffice.' }
            Start-Process -FilePath $office -ArgumentList @('--nologo', ('"' + $document + '"'))
            $message = [Text.Encoding]::UTF8.GetBytes('Documento abierto correctamente.')
            $context.Response.ContentType = 'text/plain; charset=utf-8'
            $context.Response.ContentLength64 = $message.Length
            $context.Response.OutputStream.Write($message,0,$message.Length)
            $context.Response.Close()
            continue
        }
        if ([string]::IsNullOrWhiteSpace($relative)) { $relative = 'index.html' }
        $candidate = [IO.Path]::GetFullPath((Join-Path $projectRoot $relative.Replace('/', [IO.Path]::DirectorySeparatorChar)))
        if (-not $candidate.StartsWith($projectRoot, [StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            $context.Response.StatusCode = 404
            $context.Response.Close()
            continue
        }
        $bytes = [IO.File]::ReadAllBytes($candidate)
        $ext = [IO.Path]::GetExtension($candidate).ToLowerInvariant()
        $context.Response.ContentType = $(if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' })
        $context.Response.ContentLength64 = $bytes.Length
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        $context.Response.Close()
    } catch {
        try { $context.Response.StatusCode = 500; $context.Response.Close() } catch {}
    }
}
