FROM theiaide/theia-full:next

ARG K8S_VERSION=1.14.0
ARG HELM_VERSION=2.13.1
ARG EXA_VERSION=0.8.0

ENV LC_CTYPE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8"

USER root

RUN apt-get update && apt-get install -y \
        apt-transport-https \
        fonts-powerline \
        locales-all && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&  \
    curl -L https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar zx -C /tmp linux-amd64/helm && \
    mv /tmp/linux-amd64/helm /usr/local/bin/ && \
    chmod +x /usr/local/bin/helm && \
    rm -rf /tmp/linux-amd64 && \
    wget -nc -O - https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-${EXA_VERSION}.zip | gunzip - > /usr/local/bin/exa && \
    chmod +x /usr/local/bin/exa && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl zsh neovim jq gawk && \
    apt-get clean -y && \
    rm -rf /tmp/* 

ADD scripts/entrypoint.sh /bin/

USER theia

ENV SHELL=/bin/zsh \
    VSCODE_EXTENSIONS="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-kubernetes-tools/vsextensions/vscode-kubernetes-tools/0.1.18/vspackage https://marketplace.visualstudio.com/_apis/public/gallery/publishers/redhat/vsextensions/vscode-yaml/0.4.0/vspackage"

ADD --chown=theia:theia dotfiles/init.vim $HOME/.config/nvim/init.vim
ADD --chown=theia:theia settings.json /home/theia/.theia/settings.json

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    mkdir -p ~/.zsh && \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting && \
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k && \
    nvim "+PlugInstall" "+qall" && \
    mkdir -p ~/.fonts/adobe-fonts/source-code-pro && \
    git clone https://github.com/adobe-fonts/source-code-pro.git ~/.fonts/adobe-fonts/source-code-pro && \
    fc-cache -f -v ~/.fonts/adobe-fonts/source-code-pro

ADD --chown=theia:theia dotfiles/.zshrc $HOME

ENTRYPOINT [ "/bin/entrypoint.sh" ]
