FROM manjarolinux/base AS manjaro-base

# Update packages, and also install "base" packages to make a "full" Manjaro.
RUN <<-EOF
  pacman -Syu --noconfirm
  curl -O https://gitlab.manjaro.org/profiles-and-settings/iso-profiles/-/raw/master/shared/Packages-Root
  pacman -S --noconfirm --needed $(comm -12 <(pacman -Slq | sort) <(sort Packages-Root))
EOF

# Switch to unprivileged "builder" user already incldued in the base image.
# It has passwordless sudo privileges.
USER builder
# We also need to set this to "builder" because for some reason it would be
# "root" and Ansible would look for its stuff in /root and crap itself...
ENV LOGNAME=builder

# Make the entry point a login shell so things can be manually tested/inspected.
# ENTRYPOINT ["/bin/bash", "-l"]

FROM manjaro-base AS install

# Install git (needed to clone the repo), but also pipx and Ansible so this step
# will be cached and not re-run every single docker build. Ansible is super slow
# to install for some reason...
RUN <<-EOF
  export USE_EMOJI=0 
  sudo pacman -S --needed --noconfirm git python-pipx
  pipx install --include-deps ansible
EOF

FROM install AS copy

# Copy repo to its destination
COPY --chown=builder:builder . /builder/.dotfiles
WORKDIR /builder/.dotfiles
# Set an interactive bash shell as entrypoint here in case we need to debug the
# run step
ENTRYPOINT [ "/usr/bin/bash", "--login" ]

FROM copy AS run

RUN <<-EOF
  USE_EMOJI=0 ./setup.sh
EOF

# Now that zsh is (or should be) installed, we can make the entrypoint an
# interactive zsh shell
ENTRYPOINT [ "/usr/bin/zsh", "--login" ]
