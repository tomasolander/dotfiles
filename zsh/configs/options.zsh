# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# disable flow control (freezing the terminal)
unsetopt flowcontrol
