# Amorcage du socle depuis le projet — le fichier a deposer dans le dossier du projet.
#
# Différence avec installer.ps1 : celui-ci se lance DEPUIS le projet et n'a besoin de
# rien d'autre que lui-même. Il trouve le dépôt socle sur la machine, le clone s'il est
# absent, le met à jour, puis passe la main à installer.ps1 — qui reste la seule
# mécanique de copie (une seule source de vérité, toujours celle du socle publié).
#
#   .\amorcer.ps1                     depuis le dossier du projet
#   .\amorcer.ps1 -Projet <chemin>    depuis ailleurs
#
# Si PowerShell refuse d'exécuter le fichier (stratégie d'exécution par défaut) :
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\amorcer.ps1
#
# Une fois l'installation faite, il s'efface : déposé dans le projet, il n'a rien à y
# faire ensuite — ni en fichier non suivi qui traîne, ni commité par mégarde.
#
# Options :
#   -Socle <chemin>   forcer l'emplacement du dépôt socle (sinon : recherche puis clone)
#   -Mode complet|socle-seul   forcer ce que pose l'installeur (sinon : détection)
#   -Oui              ne rien demander (clone, git init) : répondre oui à tout
#   -Garder           ne pas s'effacer à la fin (pour amorcer plusieurs projets de suite)

param(
    [string]$Projet,
    [string]$Socle,
    [ValidateSet('auto', 'complet', 'socle-seul')][string]$Mode = 'auto',
    [switch]$Oui,
    [switch]$Garder
)

$ErrorActionPreference = 'Stop'

$Depot = 'https://github.com/SamuelSinniger/Claude_Socle.git'
$NomDuClone = 'Claude_Socle'

function Demander([string]$question) {
    if ($Oui) { return $true }
    $r = Read-Host "$question [O/n]"
    return ($r -eq '' -or $r -match '^[oOyY]')
}

# Un dossier est un dépôt socle s'il porte le manifeste.
function Test-Socle([string]$chemin) {
    if ([string]::IsNullOrWhiteSpace($chemin)) { return $false }
    return (Test-Path -PathType Leaf (Join-Path $chemin 'socle\socle.json'))
}

# --- 1. le projet ---------------------------------------------------------------

# Sans -Projet : le dossier où se trouve ce fichier (le cas « déposé dans le projet »),
# ou le dossier courant si le script a été exécuté sans fichier (collé dans un terminal).
if (-not $Projet) {
    if ($PSScriptRoot) { $Projet = $PSScriptRoot } else { $Projet = (Get-Location).Path }
}
if (-not (Test-Path -PathType Container $Projet)) { throw "Projet introuvable : $Projet" }
$Projet = (Resolve-Path $Projet).Path

# Garde-fou : lancé depuis socle/outils/ du dépôt socle lui-même, sans -Projet, il
# installerait le socle dans le socle.
if (Test-Socle (Join-Path $Projet '..\..')) {
    throw "Tu es dans le depot socle. Depuis ici, utilise installer.ps1 -Projet <projet> ; amorcer.ps1 se depose dans le projet."
}

Write-Host "[i] Projet : $Projet"

# --- 2. le depot socle ----------------------------------------------------------

if ($Socle) {
    if (-not (Test-Socle $Socle)) { throw "Pas de socle/socle.json dans : $Socle" }
    $Socle = (Resolve-Path $Socle).Path
} else {
    # Emplacements plausibles, du plus proche au plus general. Le premier qui porte
    # le manifeste gagne.
    $parent = Split-Path $Projet -Parent
    $pistes = @(
        $env:CLAUDE_SOCLE,
        (Join-Path $parent $NomDuClone),
        (Join-Path $HOME $NomDuClone),
        (Join-Path $HOME "GitHub\$NomDuClone"),
        (Join-Path $HOME "Documents\GitHub\$NomDuClone")
    )
    foreach ($p in $pistes) {
        if (Test-Socle $p) { $Socle = (Resolve-Path $p).Path; break }
    }
}

if (-not $Socle) {
    # Absent de la machine : on le clone a cote du projet, jamais dedans.
    $cible = Join-Path (Split-Path $Projet -Parent) $NomDuClone
    Write-Host "[i] Depot socle introuvable sur cette machine."
    Write-Host "    A cloner depuis $Depot"
    Write-Host "    vers $cible"
    if (-not (Demander "    Cloner maintenant ?")) {
        throw "Interrompu. Relance avec -Socle <chemin-du-depot-socle> si tu l'as ailleurs."
    }
    git clone $Depot $cible
    if ($LASTEXITCODE -ne 0) { throw "git clone a echoue. Verifie que git est installe et que le depot est accessible." }
    if (-not (Test-Socle $cible)) { throw "Clone termine mais socle/socle.json est absent de $cible" }
    $Socle = (Resolve-Path $cible).Path
} elseif (Test-Path (Join-Path $Socle '.git')) {
    # Present : on recupere l'amont avant d'installer. Comparer a un clone en retard
    # de trois versions donnerait un « a jour » faux.
    Write-Host "[i] Depot socle : $Socle"
    git -C $Socle fetch --quiet
    $sale = git -C $Socle status --porcelain
    if ($sale) {
        Write-Host "[!] Le clone a des modifications non commitees : je n'y touche pas."
        Write-Host "    La version installee sera celle de ce clone, pas forcement celle publiee."
    } else {
        git -C $Socle pull --ff-only --quiet
        if ($LASTEXITCODE -ne 0) { Write-Host "[!] Mise a jour du clone impossible (pas d'amont ?) : je continue avec l'etat local." }
    }
} else {
    Write-Host "[i] Depot socle : $Socle (pas un depot git : pas de mise a jour)"
}

# --- 3. le depot du projet ------------------------------------------------------

# Un depot git n'est pas facultatif : le hook de documentation, le controle de
# conformite (qui lit le diff d'un point) et le commit du testeur en dependent.
if (-not (Test-Path (Join-Path $Projet '.git'))) {
    Write-Host ""
    Write-Host "[!] $Projet n'est pas un depot git."
    Write-Host "    Le pipeline en a besoin : hook de doc, diff de conformite, commit du testeur."
    if (Demander "    Faire git init -b main ici ?") {
        git -C $Projet init -b main
    }
}

# --- 4. l'installation ----------------------------------------------------------

$installeur = Join-Path $Socle 'socle\outils\installer.ps1'
if (-not (Test-Path -PathType Leaf $installeur)) {
    throw "Installeur introuvable : $installeur (clone incomplet ou version de socle trop ancienne)"
}

Write-Host ""
& $installeur -Projet $Projet -Mode $Mode

# --- 5. la suite ----------------------------------------------------------------

# L'amorceur se retire du projet : il n'a de raison d'etre qu'une fois. PowerShell a lu
# tout le fichier avant de l'executer, le supprimer ici ne coupe rien. Deux reserves :
# on ne s'efface que depuis le projet ou l'on a ete depose (pas depuis une boite a outils
# lancee avec -Projet), et jamais un fichier que git suit deja, sous peine de fabriquer
# une suppression a commiter.
if (-not $Garder -and $PSCommandPath -and (Split-Path $PSCommandPath -Parent) -eq $Projet) {
    $moi = Split-Path $PSCommandPath -Leaf
    Write-Host ""
    # `ls-files <chemin>` sans --error-unmatch : il imprime le chemin s'il est suivi,
    # rien sinon, et sort toujours en 0 — pas de stderr a rediriger, donc pas de
    # NativeCommandError sous $ErrorActionPreference = 'Stop'.
    $suivi = git -C $Projet ls-files $moi
    if ($suivi) {
        Write-Host "[!] $moi est suivi par git dans ce projet : je ne le supprime pas."
        Write-Host "    Retire-le toi-meme (git rm --cached $moi) - il n'a rien a faire"
        Write-Host "    dans l'historique du projet."
    } else {
        Remove-Item -LiteralPath $PSCommandPath -Force
        Write-Host "  $moi s'est efface : il avait fait son travail."
    }
}
