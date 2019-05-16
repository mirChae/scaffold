TMP_DIR=/tmp
ZSH=$HOME/.oh-my-zsh

install_spf13() {
    if [ ! -d ~/.spf13-vim-3 ];
    then
        echo 'Installing spf-13 for vim...'
        curl https://raw.githubusercontent.com/farwish/spf13-vim/3.0/bootstrap.sh -L > $TMP_DIR/spf13-vim.sh && sh $TMP_DIR/spf13-vim.sh

        cp $(pwd)/vimrc.before.local ~/.vimrc.before.local
        cp $(pwd)/vimrc.local ~/.vimrc.local
        cp $(pwd)/vimrc.bundles.local ~/.vimrc.bundles.local

        vim +PluginInstall +qall
    fi
}

install_tmux_conf() {
    if [ ! -d ~/.tmux ];
    then
        echo 'Installing tmux...'

        git clone https://github.com/gpakosz/.tmux.git ~/.tmux
        ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
        cp $(pwd)/tmux.conf.local ~/.tmux.conf.local
    fi
}

install_zsh() {
    local has_zsh=$(which zsh)

    if [ "${has_zsh}" = "" ];
    then
        echo 'Installing zsh...'
        sudo apt-get -y install zsh
    fi
}

install_oh_my_zsh() {
    if [ ! -d ~/.oh-my-zsh ];
    then
        echo 'Installing oh my zsh...'
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

        # Download theme
        git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

        # Download plugin
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

        cp $(pwd)/zshrc ~/.zshrc
    fi

}

install_fzf() {
    if [ ! -f $HOME/.fzf.zsh ];
    then 
        git clone --depth 1 https://github.com/junegunn/fzf.git $TMP_DIR/.fzf
        $TMP_DIR/.fzf/install
        echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> ~/.zshrc
    fi
}

install_fonts() {
    if [ ! -f /usr/share/fonts/opentype/PowerlineSymbols.otf ]; 
    then
        echo 'Installing fonts...'
        sudo apt-get install fonts-powerline

        if [ ! -d $TMP_DIR/nerd-fonts ];
        then
            git clone https://github.com/ryanoasis/nerd-fonts.git $TMP_DIR/nerd-fonts
        fi

        $TMP_DIR/nerd-fonts/install.sh Hack
    fi
}

install_go_env() {
    local go_pkg_name='go.tar.gz'

    if [ ! -d /usr/local/go ];
    then
        wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz -O $TMP_DIR/$go_pkg_name
        sudo tar -C /usr/local -xzf $TMP_DIR/$go_pkg_name

        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    fi
}

install_python() {
    local has_python3=$(which python3)

    if [ "${python3}" = "" ];
    then 
        echo "Installing python3..."
        sudo apt-get install -y python3.6
    fi
}

install_pip() {
    local has_pip=$(which pip)

    if [ "${has_pip}" = "" ];
    then
        echo 'Installing python-pip'
        sudo apt-get install -y python-pip
        echo 'export PATH=$PATH:~/.local/bin' >> ~/.zshrc
    fi
}

install_pipenv() {
    local has_venv=$(which virtualenv)
    if [ "${has_venv}" = "" ];
    then
        echo "Installing virtualenv..."
        pip install virtualenv
    fi

    local has_pipenv=$(which pipenv)
    if [ "${has_pipenv}" = "" ];
    then
        echo "Installing pipenv..."
        pip install --upgrade pipenv
    fi
}

install_tig() {
    local has_tig=$(which tig)

    if [ "${has_tig}" = "" ];
    then
        echo 'Installing tig...'
        sudo apt-get install tig
    fi
}

install_docker_env() {
    local has_docker=$(which docker)

    if [ "${has_docker}" = "" ];
    then
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) \
            stable"

        sudo apt-get update

        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    fi
}

set_git_default_config() {
    git config --global core.editor vim
    git config --global merge.tool vimdiff
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
}

install_spf13
install_tmux_conf
install_zsh
install_oh_my_zsh
install_fzf
install_fonts
install_go_env
install_python
install_pip
install_pipenv
install_tig
install_docker_env
set_git_default_config

echo "Install complete."
