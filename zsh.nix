{ config, ... }:

{
  programs.zsh = {
    enableCompletion = true;
    autocd = true;

    history = {
      size = 100000000;
      save = 100000000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    setOptions = [
      "INC_APPEND_HISTORY"
      "INTERACTIVE_COMMENTS"
    ];

    shellAliases = {
      l = "ls -lh";
      la = "ls -lAh";
      ll = "ls -l";
      ls = "ls --color=auto";
    };

    initContent = ''
      PROMPT='%F{green}%~%f %(?.$.%F{red}$%f) '

      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z-A-Z}={A-Z-a-z}'

      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      zmodload zsh/terminfo 2>/dev/null || true

      [[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
      [[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" down-line-or-beginning-search
      [[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line
      [[ -n "$terminfo[kend]" ]]  && bindkey "$terminfo[kend]"  end-of-line
      [[ -n "$terminfo[kpp]" ]]   && bindkey "$terminfo[kpp]"   up-line-or-history
      [[ -n "$terminfo[knp]" ]]   && bindkey "$terminfo[knp]"   down-line-or-history

      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[5~' up-line-or-history
      bindkey '^[[6~' down-line-or-history
      bindkey '^[OH' beginning-of-line
      bindkey '^[OF' end-of-line

      pbcopy() { printf "\033]52;c;$(base64 | tr -d '\n')\a"; }
    '';
  };
}
