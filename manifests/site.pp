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

exec { "set-boxen-path-to-zshrc":
    command => "echo '[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh' >> /Users/${::boxen_user}/.zshrc",
    path    => "/usr/local/bin/:/bin/",
}

exec { "set-custom-modules-to-zshrc":
    command => "/usr/bin/sed -i bak 's/plugins=(git)/plugins=(git codecompletions)/'  /Users/${::boxen_user}/.zshrc",
    path    => "/usr/local/bin/:/bin/",
}
  include autojump
  include tmux
  include wget


 
  #Additional
  #include java
  include onepassword
  include ruby
  include chrome
  include chrome::dev
  include dropbox
  include virtualbox
  include vagrant

#android
include android::sdk
include android::ndk
include android::tools
include android::platform_tools
android::build_tools { '18.1.1': }
include android::17
include android::18
include android::19
include android::20
android::system_image { 'sysimg-18': }
include android::doc
  
  package { 'mercurial': }
  package { 'vim':
    require         => Package[mercurial],
    install_options => [
      '--with-cscope',
      '--override-system-vim',
      '--enable-pythoninterp'
    ]
  }
  package { 'macvim':
    install_options => [
      '--with-cscope',
    ]
  }

  #Intellij
  class {'intellij':
         edition => 'ultimate',
         version => '13.1.3'
  }

  # Maven
  include maven

  # My Config
  class {'common-scripts':
       username => "${::boxen_user}",
  }
  include limechat

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
      'boot2docker',
      'grc'
    ]:
  }

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  nodejs::version { 'v0.6': }
  nodejs::version { 'v0.8': }
  nodejs::version { 'v0.10': }

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
