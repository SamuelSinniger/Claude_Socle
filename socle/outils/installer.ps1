# Amorçage du socle dans un projet — version PowerShell.
# Équivalent strict de installer.sh, pour Windows sans Git Bash dans le PATH.
#
# À lancer AVANT toute utilisation de /socle : la commande /socle est elle-même
# distribuée par le socle, elle n'existe donc pas encore dans un projet vierge.
# La partie qui demande du jugement (réconcilier les règles d'un projet existant)
# reste à /socle adopt, disponible dès que ce script a tourné.
#
#   .\socle\outils\installer.ps1 -Projet F:\chemin\du\projet [-Mode complet|socle-seul]
#
# Modes :
#   auto (défaut)  projet vierge -> complet ; projet avec ses propres règles -> socle seul
#   socle-seul     uniquement les fichiers distribués (socle/, .claude/, .githooks/)
#   complet        + les modèles (CLAUDE.md, README.md, docs/**) là où le fichier est absent

param(
    [Parameter(Mandatory = $true)][string]$Projet,
    [ValidateSet('auto', 'complet', 'socle-seul')][string]$Mode = 'auto'
)

$ErrorActionPreference = 'Stop'

# Racine du dépôt socle, déduite de l'emplacement de ce script (socle/outils/).
$Socle = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$Manifeste = Join-Path $Socle 'socle\socle.json'

if (-not (Test-Path -PathType Container $Projet)) { throw "Projet introuvable : $Projet" }
if (-not (Test-Path -PathType Leaf $Manifeste))   { throw "Manifeste introuvable : $Manifeste" }

$Projet = (Resolve-Path $Projet).Path
$m = Get-Content $Manifeste -Raw | ConvertFrom-Json

# Le projet porte-t-il déjà des règles qui ne viennent pas du socle ?
function Test-ReglesEtrangeres {
    if (Test-Path (Join-Path $Projet 'socle\socle.json')) { return $false }  # socle déjà installé
    foreach ($f in @('CLAUDE.md', 'AGENTS.md', '.cursorrules', 'CONTRIBUTING.md')) {
        $chemin = Join-Path $Projet $f
        if (Test-Path $chemin) {
            # un fichier issu du socle porte la section « Socle commun » : il ne compte pas
            if (Select-String -Path $chemin -Pattern 'Socle commun' -Quiet) { continue }
            return $true
        }
    }
    if (Test-Path (Join-Path $Projet '.claude')) { return $true }
    return $false
}

# Détermination du mode effectif
$copierModeles = $true
if ($Mode -eq 'socle-seul') {
    $copierModeles = $false
} elseif ($Mode -eq 'auto') {
    if (Test-ReglesEtrangeres) {
        $copierModeles = $false
        Write-Host "[i] Ce projet a deja ses propres regles : je ne pose que le socle."
        Write-Host "    Les modeles (CLAUDE.md, docs/**) ne sont PAS copies - c'est /socle adopt"
        Write-Host "    qui decidera quoi faire des regles existantes, avec ta validation."
    } else {
        Write-Host "[i] Projet vierge : socle + modeles."
    }
}

Write-Host "[i] Socle $($m.version) depuis $Socle"
Write-Host "[i] Vers $Projet"
Write-Host ""

# Copie une entrée du manifeste ; $siAbsent = ne pas écraser un fichier existant.
function Copier-Entree($entree, [bool]$siAbsent) {
    $de   = Join-Path $Socle ($entree.source -replace '/', '\')
    $vers = Join-Path $Projet ($entree.destination -replace '/', '\')
    if ($siAbsent -and (Test-Path $vers)) {
        Write-Host "  ignore   $($entree.destination) (existe deja)"
        return
    }
    $dossier = Split-Path $vers -Parent
    if (-not (Test-Path $dossier)) { New-Item -ItemType Directory -Force -Path $dossier | Out-Null }
    Copy-Item -Path $de -Destination $vers -Force
    if ($siAbsent) { Write-Host "  modele   $($entree.destination)" }
    else           { Write-Host "  pose     $($entree.destination)" }
}

foreach ($f in $m.fichiers) { Copier-Entree $f $false }

# Le manifeste lui-même : c'est lui qui dit au projet quelle version il a.
$dossierSocle = Join-Path $Projet 'socle'
if (-not (Test-Path $dossierSocle)) { New-Item -ItemType Directory -Force -Path $dossierSocle | Out-Null }
Copy-Item -Path $Manifeste -Destination (Join-Path $dossierSocle 'socle.json') -Force
Write-Host "  pose     socle/socle.json"

if ($copierModeles) {
    Write-Host ""
    foreach ($f in $m.modeles) { Copier-Entree $f $true }
}

# Hook de documentation
Write-Host ""
if (Test-Path (Join-Path $Projet '.git')) {
    git -C $Projet config core.hooksPath .githooks
    Write-Host "[i] hook active : core.hooksPath = .githooks"
} else {
    Write-Host "[!] $Projet n'est pas un depot git : hook non active."
    Write-Host "    Le pipeline en a besoin (diff de conformite, commit du testeur)."
}

Write-Host ""
Write-Host "Fait. Ensuite, dans ce projet :"
if (-not $copierModeles) {
    Write-Host "  1. /socle adopt $Socle"
    Write-Host "     -> classe les regles existantes (rien n'est applique sans ta validation),"
    Write-Host "        puis termine l'installation"
} else {
    Write-Host "  1. /socle check   -> verifie l'installation"
    Write-Host "  2. remplir CLAUDE.md section Projet puis docs/conventions.md section Concretisation"
}
Write-Host "  Inscris le projet dans $Socle\projets.md (ou laisse /socle le faire)."
