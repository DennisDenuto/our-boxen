require boxen::environment
require homebrew
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
  package { 'awscli': }
  package { 'hg': }

  include chrome
  include firefox
  include dropbox
  include virtualbox

  class { 'vmware_fusion': version => '7.0.0-2103067' }
  #license: QZKH1-G1PNZ-44JWD-2U4G1-VC533

  package { 'typesafe-activator': }

  #vagrant setup
  class { 'vagrant':
    completion => true
    }
  #vagrant::plugin { 'vagrant-vmware-fusion':
  #  license => 'puppet:///modules/people/joe/licenses/fusion.lic',
  #}

  #android
  include android::sdk
  include android::ndk
  include android::tools
  include android::platform_tools
  android::build_tools { '18.1.1': }
  android::build_tools { '20': }
  android::build_tools { '21': }
  android::build_tools { '21.0.1': }
  android::build_tools { '21.1.2': }
  android::build_tools { '21.1.1': }
  include android::17
  include android::18
  include android::19
  include android::20
  android::system_image { 'sysimg-18': }
  include android::doc
  include android::studio

  package { 'mutt': }
  package { 'sudolikeaboss': }
  package { 'scala': }
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
  package { 'consul': }

  package { 'macvim':
    install_options => [
      '--with-cscope',
      '--override-system-vim',
    ]
  }

  package { 'maven':
    ensure => installed,
  }

  #Intellij
  class {'intellij':
         edition => 'ultimate',
         version => '14.0.3'
  }


  #Slate
  include slate

  #Wireshark
  include wireshark

  # gvm
  include gvm
  gvm::groovy { '2.4.2': 
    version => '2.4.2' }
  gvm::groovy { '2.2.2': 
    version => '2.2.2',
    default => false
  }
  gvm::groovy { '2.3.1':
    version => '2.3.1',
    default => false
  }
  gvm::grails { '2.4.0': }
  gvm::gradle { '1.12': }
  gvm::gradle { '2.3': }
  gvm::springboot { '1.1.4.RELEASE': }


  # My Config
  class {'commonscripts':
       username => "${::boxen_user}",
  }

  case $boxen_user {
    'dennis.leon':          {
      include answers
    }
    default:            {
      include networkconfig
    }
  }

  # limechat
  include limechat
  
  # mysql
#  include mysql
#  mysql::db { 'development_db': }

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
      'docker',
      'docker-compose',
      'docker-machine',
      'docker-swarm',
      'grc',
      'phpunit'
    ]:
  }

  # node versions
  nodejs::version { 'v0.6': }
  nodejs::version { 'v0.8': }
  nodejs::version { 'v0.10': }

  # install some npm modules
   nodejs::module { 'appium':
    node_version => 'v0.10'
  }
   nodejs::module { 'jsonlint':
    node_version => 'v0.10'
  }
   nodejs::module { 'bower': 
    node_version => 'v0.10'
  }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  #ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
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
