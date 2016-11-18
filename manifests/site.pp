require boxen::environment
require homebrew
include brewcask
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

#ruby
class { 'ruby::global':
  version => '2.1.2'
}




Homebrew::Formula <| |> -> Package <| |>

node default {


  homebrew::tap { 'homebrew/binary': }
  homebrew::tap { 'ravenac95/sudolikeaboss': }
  homebrew::tap { 'homebrew/php': }


  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # additional (core) modules
  include iterm2::dev
  include zsh
  include ohmyzsh


exec { "set-ohmyzsh-config-zshrc":
    command => "cp -f /Users/${::boxen_user}/.oh-my-zsh/templates/zshrc.zsh-template /Users/${::boxen_user}/.zshrc",
    path    => "/usr/local/bin/:/bin/",
}

  include autojump
  include tmux
  include wget


  #Additional
  include java
  include onepassword
  include onepassword::chrome
  include ruby
  include python

  class { 'awsshell': }

  package { 'awscli': }
  package { 'hg': }
  package { 'spectacle': provider => 'brewcask' }

  include chrome
  include firefox
  include dropbox
  include virtualbox

  class { 'vmware_fusion': version => '7.0.0-2103067' }
  #license: QZKH1-G1PNZ-44JWD-2U4G1-VC533


  #vagrant setup
  class { 'vagrant':
    completion => true
    }
  #vagrant::plugin { 'vagrant-vmware-fusion':
  #  license => 'puppet:///modules/people/joe/licenses/fusion.lic',
  #}


  package { 'coreutils': }
  package { 'mutt': }
  package { 'sudolikeaboss': }
  package { 'sbt': }
  package { 'mercurial': }
  #jad = decompiler
  package { 'jad': }
  package { 'mtr': }
  package { 'git-annex': }
  package { 'nmap': }

  package { 'chrome-cli': }
  package { 'openvpn': }

  #fix tmux copy/paste https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
  package { 'reattach-to-user-namespace': }

  package { 'spark': }

  package { "s3cmd":
    ensure => present
  }

  package { 'packer': }

  #Slate
  include slate

  #Wireshark
  include wireshark

  # additional homebrew packages
  package {
    [
      'ledger',
      'tree',
      'ssh-copy-id',
      'tig',
      'ctags-exuberant',
      'direnv',
      'git-flow',
      'git-extras',
      'htop',
      'jq',
      'docker',
      'docker-compose',
      'docker-machine',
      'docker-swarm',
      'grc'
    ]:
  }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.8': }
  ruby::version { '2.2.4': }

  # common, useful packages
  package {
    [
      'ag',
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }


  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
