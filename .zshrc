#   ~/.zshrc 
#   written by Steve Wang 

# Setopt autocd 
setopt autocd 

# Shortcut 
alias term='urxvt &' 
alias edit='vim'
alias file='ranger'
alias disk='udisksctl' 

# options 
# alias feh='feh --zoom fill'

# Colors
alias ls='ls -h --color=auto --group-directories-first'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'

# Selections
zstyle ':completion:*' menu select
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Plugins  
source ~/.zsh/antigen/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle rupa/z
antigen bundle adrieankhisbe/diractions
antigen theme refined 
antigen apply

# zsh man page overview: 
#   zsh          Zsh overview
#   zshroadmap   Informal introduction to the manual
#   zshmisc      Anything not fitting into the other sections
#   zshexpn      Zsh command and parameter expansion
#   zshparam     Zsh parameters
#   zshoptions   Zsh options
#   zshbuiltins  Zsh built-in functions
#   zshzle       Zsh command line editing
#   zshcompwid   Zsh completion widgets
#   zshcompsys   Zsh completion system
#   zshcompctl   Zsh completion control
#   zshmodules   Zsh loadable modules
#   zshcalsys    Zsh built-in calendar functions
#   zshtcpsys    Zsh built-in TCP functions
#   zshzftpsys   Zsh built-in FTP client
#   zshcontrib   Additional zsh functions and utilities
#   zshall       Meta-man page containing all of the above
