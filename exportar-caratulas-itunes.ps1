# En el caso de que aparezca este error cuando es ejecutado: 
# ./exportar-caratulas-itunes.ps1 : No se puede cargar el archivo
# C:\Users\usuario\Desktop\exportar-caratulas-itunes.ps1 porque la ejecución de scripts
# está deshabilitada en este sistema. Para obtener más información, consulta el tema about_Execution_Policies en
# https:/go.microsoft.com/fwlink/?LinkID=135170.
# En línea: 1 Carácter: 1
# + ./exportar-caratulas-itunes.ps1
# + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : SecurityError: (:) [], PSSecurityException
#     + FullyQualifiedErrorId : UnauthorizedAccess

# Ejecuta en PowerShell la siguiente linea:

# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Luego aparecerá el mensaje de: Cambio de directiva de ejecución.

# La directiva de ejecución te ayuda a protegerte de scripts en los que no confías. Si cambias dicha directiva, podrías
# exponerte a los riesgos de seguridad descritos en el tema de la Ayuda about_Execution_Policies en
# https:/go.microsoft.com/fwlink/?LinkID=135170. ¿Quieres cambiar la directiva de ejecución?
# [S] Sí  [O] Sí a todo  [N] No  [T] No a todo  [U] Suspender  [?] Ayuda (el valor predeterminado es "N"):

# Dale a sí o a Sí a todo (elige la que quieras bajo tu responsabilidad). 

# Y luego vuelve a ejecutar el script con ./exportar-caratulas-itunes.ps1 y se ejecutará perfectamente
# Ejecutando itunes y seguidamente exportando todas las carátulas.

# Después para revertir el cambio, puedes ejecutar el siguiente comando:

# Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Restricted

# Y para ver siempre la política actual de las ejecuciones en el sistema solamente tienes que ejecutar: 

# Get-ExecutionPolicy -Scope LocalMachine

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$destino = [Environment]::GetFolderPath("Desktop") + "\CaratulasDeiTunes"
if (-not (Test-Path $destino)) {
    New-Item -ItemType Directory -Path $destino | Out-Null
}

$iTunes = New-Object -ComObject iTunes.Application

$library = $iTunes.LibraryPlaylist
$tracks = $library.Tracks

Write-Host "Exportando carátulas de la biblioteca de iTunes al escritorio..."

foreach ($track in $tracks) {
    if ($track -and $track.Artwork.Count -gt 0) {
        $artwork = $track.Artwork.Item(1)

        $album = $track.Album -replace '[\\/:*?"<>|]', '' 
        $artist = $track.Artist -replace '[\\/:*?"<>|]', ''
        $filename = "$artist - $album.jpg"

        # Ruta completa del archivo de salida
        $outputFile = Join-Path $destino $filename

        if (-not (Test-Path $outputFile)) {
            try {
                # Exporta la carátula como archivo JPEG
                $artwork.SaveArtworkToFile($outputFile)
                Write-Host "Carátula exportada: $filename"
            } catch {
                Write-Warning "No se pudo exportar la carátula para: $track.Name"
            }
        }
    }
}

Write-Host "Proceso completado. Las carátulas se encuentran en: $destino"