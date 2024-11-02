# My personal CLI environment configuration and tooling

This is my dotfiles repo. There are many like it, but this one is mine.

## What this installs and configures:

As of this writing I am in the process of revamping my configs, so anything
I write here will either change or become outdated soon. If you're here and
really want to know, take a peek at the repo ;)

Once I've revamped things to the point where I'm happy with it and a list of
included things would be "stable" I will update this section.

## How to use

### Requirements/compatibility

I currently use [Manjaro Linux](https://manjaro.org/) (the KDE Plasma version,
not that it matters for this CLI config), so that's the only supported system at
the moment.

I used [Solarized](https://ethanschoonover.com/solarized/) (Dark) colors, which
do require the extra step of setting up the color theme in your terminal
emulator for everything to work as expected.

Some of the configs also expect a "[nerd font](https://www.nerdfonts.com/)" to
be configured in the terminal emulator.

Anyway, all you should need for the setup script to work is a Manjaro install.

### Installing

You can download and run the install script with this handy-dandy one-liner:

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/vicnett/dotfiles/refs/heads/main/setup.sh)"
```

You will be prompted for a sudo password which will solely be used to install
packages. After a bunch of terminal output (hopefully none of it red...) you'll
be back to your prompt (which should actually look a lot more like _my_ prompt
if everything went well...

If you see no changes, you may need to reset your shell session and trigger the
config files to be read with:

```shell
exec zsh
```

That, or you happened to already have your configs (visual ones at least)
exactly the same as mine! Which would be weird but also, I mean... good on you
for having great taste!

If you're wary of running random scripts from strangers on the Internet... Well,
it's probably a good idea to be honest... Anyway, the script is super small and
simple so you can [take a peek](setup.sh) and/or run the commands inside
manually.

### Updating

Running `git pull` then `setup.sh` _should_ be sufficient to update configs,
but...

1. I actually haven't coded everything yet. Things that are missing in the
   install will definitely be missed in an update...
2. I haven't yet done a lot of testing on that front, so while I'm pretty sure
   it's at least [idempotent](https://en.wikipedia.org/wiki/Idempotence) and
   shouldn't break anything, I'm not going to make promises...

Technically, if only an existing file that's already been linked by Dotbot has
changed, you only need to `git pull`.

Technically, if you've only added/changed what files get linked by Dotbot, you
only need to `git pull` run Dotbot's `install` script.

And technically, either way you could only `git pull` and re-run the Ansible
playbook with `ansible-playbook ansible/playbook.yml`.

But eventually I'd like to either use the same `setup.sh` script or an
`update.sh` one to handle seamless updates between systems. My ideal state would
be for update checks to be automated on login, and for them to be auto-applied
with no action needed from me unless I need to put in my password to install
a package.

## How it works

Tools used:
- [pipx](https://pipx.pypa.io/stable/)
- [Ansible](https://www.ansible.com/)
- [Dotbot](https://github.com/anishathalye/dotbot)

### Bootstrapping

My eventual goal is to be able to set up these configs with a single command on
the target machine, similar to how many non-packaged Linux utilities do it these
days. I'm not quite there yet as you still need to clone the repo, but it's come
a long way! Once the repo is cloned, the `setup.sh` script bootstraps the rest
of the process by:

- Installing Git and pipx (yes, Git is redundant here, but eventually it
  won't be and this is likely where it'll be installed if needed)
- Installing Ansible via pipx (beats having to deal with setting up Python
  virtual envs just to run the Ansible playbook!)
- Running Ansible

### Ansible

Ansible is (for me at least) an overwhelming tool to learn. On one hand, it's
extremely powerful and feature-rich, but on the other hand the "official way" of
doing things can feel excessively convoluted and over-engineered, especially for
simple use cases.

For now, I've settled for a single-file playbook to do all of the (admittedly
very few) tasks I need it to do:

- Install packages for the tools being configured
- Run installation steps for tools that can't (or shouldn't) be installed via
  system packages
- Change the default shell to `zsh`
- Run some configs that aren't simple file copying/linking (i.e. Git configs)
- Run Dotbot, which in turn handles creating/linking config files

### Dotbot

Dotbot is a fairly simple-to-use tool designed to handle your dotfiles for you,
and not much more (though it can be made to do a lot if you want it to). I'm
sticking to a fairly simple use case for now, which is simply:

- Create necessary "scaffolding" (empty directories) for config files to be put
  into
- Create config files as symbolic links that point inside the repo (so simple
  updates of existing files only require `git pull` to apply)

## Testing

tl;dr:

- `docker-test-run.sh` builds and runs a minimal Manjaro image with `setup.sh`
  run based on the local state of this repo
- `docker-test-norun.sh` does the same but without running `setup.sh`, to enable
  debugging within the Docker environment

As much as I've tried to make the setup process
[idempotent](https://en.wikipedia.org/wiki/Idempotence), there always seemed to
be at least some steps I forgot to code. The reality is that idempotence only
ensures you don't break things that already work, not necessarily that they will
work again from scratch...

So I took the opportunity to get more familiar with Docker! Running the
`docker-test-run.sh` script will build a full "base" Manjaro image with the
local state of this repo copied, and run `setup.sh`. If all goes without errors,
you're then dropped into a login `zsh` shell.

If the build has some errors, you can run `docker-test-norun.sh` to skip the
"run `setup.sh`" step and get dropped into an interactive `bash` shell instead,
from which you can then run `setup.sh` and/or do whatever troubleshooting you
need to do.

I will soon be adding CI via GitHub actions which will likely work about the
same as this Dockerfile, but for now just being able to quickly iterate and test
on a fresh environment has helped me fix lots of issues already.

## Troubleshooting

### Ansible complains about a sudo password

Currently, `setup.sh` runs a `sudo pacman` command to ensure Git and pipx
are installed, and then immediately runs Ansible. Since at that point your
sudo credentials will likely still be cached, I didn't make Ansible ask for
a password as its `sudo` commands should succeed thanks to the cache.

If Ansible does complain about not having your password for some reason, you can
run:

```shell
ansible-playbook -K ansible/playbook.yml
```

It's the same command used in `setup.sh`, except the `-K` flag (short for
`--ask-become-pass`) will make it ask you for your sudo password at the
beginning of the play.

You may be wondering why I didn't just put the `-K` flag in there anyway. Well,
I couldn't find a way to have Ansible only ask for the password if and when it
needed it. If you pass the `-K` flag, it _will_ ask you for your password no
matter what, so in the scenario of running `setup.sh`, the `sudo pacman` command
would prompt you for it, then immediately after Ansible would prompt you for it.

If you can figure out how to get Ansible to play nicely, let me know, but after
hours of research, I am giving up on trying for now.

### Dotbot complains about not being able to create some files or links

As of this writing, Dotbot doesn't automatically backup existing files before
replacing them with symbolic links. If there's an existing link, it replaces it,
and if there's an existing file, it errors out unless you give it the `force`
option.

I've set the `force` option only on the files that gave me issues in the test
Docker environment, and I'm reluctant to setting it globally. If you run into
such issues, you can selectively add `force: true` in `install.conf.yaml` and
then re-run the playbook with `ansible-playbook ansible/playbook.yml`.

I might see if I can contribute a "backup file if exists" feature to Dotbot and
use it instead, but there's years-old open issues about such a feature on that
repo so we'll see how far I can get with it...

### Docker issues

To the best of my knowledge, this shouldn't affect the Docker container as I've
written it, but it may be worth noting that I'm using Docker in [rootless
mode](https://docs.docker.com/engine/security/rootless/).

If you run into issues trying to build/run the repo in Docker, that might be
a good first suspect to rule out.
