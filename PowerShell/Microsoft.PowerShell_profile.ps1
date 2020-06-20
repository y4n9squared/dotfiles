Import-Module PSReadLine

function ll {
    eza -la --icons $args
}

function ln ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target -Force
}

function which ($name) { 
    Get-Command -Name $name -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue 
} 

function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

function sudo() {
    if ($args.Length -eq 1) {
        start-process $args[0] -verb "runAs"
    }
    if ($args.Length -gt 1) {
        start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
    }
}

Set-Alias time Measure-Command
Set-Alias cat bat
Set-Alias vim hx
Set-Alias grep findstr
Set-Alias -Name cd -Option AllScope -Value z

Invoke-Expression (&starship init powershell)
Invoke-Expression (&{(zoxide init powershell | Out-String)})

# Make tab completion work like it does in Linux
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Import fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

$env:FZF_DEFAULT_OPTS=@"
--layout=reverse
--cycle
--scroll-off=5
--border
--preview-window=right,60%,border-left
--bind ctrl-u:preview-half-page-up
--bind ctrl-d:preview-half-page-down
--bind ctrl-f:preview-page-down
--bind ctrl-b:preview-page-up
--bind ctrl-g:preview-top
--bind ctrl-h:preview-bottom
--bind alt-w:toggle-preview-wrap
--bind ctrl-e:toggle-preview
"@
