# Script de automatización PowerShell para sincronizar la documentación con OneDrive BrainNotes
$origen = "$PSScriptRoot"
$destino = "C:\Users\misae\OneDrive\Documentos\BrainNotes\Pou"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Sincronizando documentacion PouClone con BrainNotes... " -ForegroundColor Yellow
Write-Host " Origen : $origen"
Write-Host " Destino: $destino"
Write-Host "==========================================================" -ForegroundColor Cyan

if (!(Test-Path -Path $destino)) {
    New-Item -ItemType Directory -Path $destino -Force | Out-Null
    Write-Host "[+] Carpeta creada: $destino" -ForegroundColor Green
}

Copy-Item -Path "$origen\*.md" -Destination $destino -Force
Write-Host "[V] Todos los archivos .md han sido copiados exitosamente a:" -ForegroundColor Green
Write-Host "    $destino" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
