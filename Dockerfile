FROM debian

ENV user=acme
ENV password=acme

#COPY appdata/setup /setup
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install \
    zsh \
    wget \
    sudo \
    git \
    software-properties-common \
    gnupg \
    ssh \
    python3-venv \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    curl \
    wget \
    screenfetch \
    python3-pip \
    python3-venv \
    gnupg \
    lsb-release \
    openssh-server \
    tmux \
    npm \
    htop \
    file \
    jq \
    -y
RUN apt-get upgrade -y

# NEOVIM 
RUN wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
RUN dpkg -i --force-overwrite ./nvim-linux64.deb
RUN rm nvim-linux64.deb

# CREATE THE USER
RUN groupadd -g 1000 ${user} 
RUN useradd -rm -d /home/${user} -s /bin/zsh -u 1000 -g 1000 -G sudo -p "$(openssl passwd -1 ${password})" ${user}
#RUN /setup/setup.sh


# SET UP NEOVIM CONFIG WITH MY PREFS 
RUN git clone https://github.com/jamesstorm/nvim /home/${user}/.config/nvim

# INSTALL PACKER FOR NEOVIM
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim /home/${user}/.local/share/nvim/site/pack/packer/start/packer.nvim

# OHMYZSH AND POWERLINE10K
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git /home/${user}/.oh-my-zsh
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/${user}/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /home/${user}/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# MY DOTFILES
RUN git clone https://github.com/jamesstorm/dotfiles /home/${user}/dotfiles
RUN rm -rf /home/${user}/.zshrc
RUN rm -rf /home/${user}/.tmux.conf
RUN rm -rf /home/${user}/.p10k.sh
RUN ln /home/${user}/dotfiles/.zshrc /home/${user}/.zshrc
RUN ln /home/${user}/dotfiles/.tmux.conf /home/${user}/.tmux.conf
RUN ln /home/${user}/dotfiles/.p10k.zsh /home/${user}/.p10k.zsh

# TMUX POWERLINE
RUN git clone https://github.com/erikw/tmux-powerline.git /home/${user}/.config/tmux/tmux-powerline


# MAKE SURE THE USER OWNS ALL THE THINGS IN THEIR HOME
RUN chown -R ${user}:${user} /home/${user}

ENTRYPOINT service ssh restart && bash
