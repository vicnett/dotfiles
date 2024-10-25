FROM manjarolinux/base AS manjaro-base

# Download "base" packages list from Manjaro repo
ADD https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/raw/master/shared/Packages-Root .
# Update and install packages to make a "full" Manjaro environment.
RUN <<-EOF
  pacman -Syu --noconfirm
  pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort Packages-Root))
EOF

# Switch to unprivileged "builder" user already incldued in the manjaro image.
# It has passwordless sudo privileges.
# We also make sure LOGNAME is builder to avoid Ansible issues...
USER builder
ENV LOGNAME=builder

# Set an interactive bash shell as entrypoint here in case we need to debug
# before zsh is installed
ENTRYPOINT [ "/usr/bin/bash", "--login" ]

FROM manjaro-base AS install

# Install pipx, Ansible, and the packages Ansible will install so this step will
# be cached and not re-run every single docker build. Ansible is super slow to
# install for some reason, and there's no need to excessively download packages
# from the Manjaro repo every build...
COPY manjaro_packages .
RUN <<-EOF
  export USE_EMOJI=0 
  sudo pacman -S --needed --noconfirm python-pipx
  sudo pacman -S --needed --noconfirm - < manjaro_packages
  pipx install --include-deps ansible
EOF

FROM install AS copy

# Copy repo to its destination
COPY --chown=builder:builder . /builder/.dotfiles
WORKDIR /builder/.dotfiles

FROM copy AS run

RUN <<-EOF
  USE_EMOJI=0 ./setup.sh
EOF

# Now that zsh is (or should be) installed, we can make the entrypoint an
# interactive zsh shell
ENTRYPOINT [ "/usr/bin/zsh", "--login" ]
