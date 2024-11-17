FROM archlinux AS arch-base

# Download "base" packages list from Manjaro repo
ADD https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/raw/master/shared/Packages-Root .
# Update and install packages to make a "full" Manjaro environment.
RUN <<-EOF
  pacman -Syu --noconfirm
  pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort Packages-Root))
  id -u test_user &>/dev/null || (useradd -d /test_user -m test_user && \
  echo "test_user ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers)
EOF

# Switch to unprivileged "test_user" user already incldued in the manjaro image.
# It has passwordless sudo privileges.
# We also make sure LOGNAME is test_user to avoid Ansible issues...
USER test_user
ENV LOGNAME=test_user

# Set an interactive bash shell as entrypoint here in case we need to debug
# before zsh is installed
ENTRYPOINT [ "/usr/bin/bash", "--login" ]

FROM arch-base AS install

# Install pipx and Ansible so this step will be cached and not re-run every
# single docker build. Ansible is super slow to install for some reason...
RUN <<-EOF
  export USE_EMOJI=0 
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm python-pipx
  pipx install --include-deps ansible
EOF

# Install the packages Ansible will want to install later. There's no need to
# excessively download packages from the Manjaro repo every build...
COPY manjaro_packages .
RUN <<-EOF
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm - < manjaro_packages
EOF

FROM install AS copy

# Copy repo to its destination
COPY --chown=test_user:test_user . /test_user/.dotfiles
WORKDIR /test_user/.dotfiles

FROM copy AS run

RUN <<-EOF
  USE_EMOJI=0 ./setup.sh
EOF

# Run Zsh so Zinit can get set up
RUN <<-EOF
  zsh -i -c -- '@zinit-scheduler burst'
  nvim --headless "+Lazy! restore" +qa
EOF

# Now that zsh is (or should be) installed, we can make the entrypoint an
# interactive zsh shell
ENTRYPOINT [ "/usr/bin/zsh", "--login" ]
