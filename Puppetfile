# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    if version == "master"
        mod name, :git=> "git://github.com/#{options[:repo]}.git"
    else
        mod name, version, :github_tarball => options[:repo]
    end
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod "puppet-#{name}", :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

def test(name, *args)
  mod "puppet-#{name}", :path => "#{ENV['HOME']}/code/github/me/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.10.2"

# Support for default hiera data in modules

github "module_data", "0.0.3", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "brewcask",    "0.0.6"
github "dnsmasq",     "2.0.1"
github "foreman",     "1.2.0"
github "gcc",         "2.2.0"
github "git",         "2.7.5"
github "go",          "2.1.0"
github "homebrew",    "1.12.0"
github "hub",         "1.4.0"
github "inifile",     "1.1.1", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.4.4"
github "nodejs",      "4.0.0"
github "openssl",     "1.0.0"
github "phantomjs",   "2.3.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "ruby",        "8.1.7"
github "python",      "2.0.1"
github "stdlib",      "4.2.1", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",     "1.2.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.
#
github "intellij",    "1.5.1"
github "java",        "1.8.2"

github "onepassword", "1.1.5"
#
github "commonscripts", "1.2.8", :repo => "DennisDenuto/puppet-commonscripts"

github "networkconfig", "master", :repo => "DennisDenuto/puppet-networkconfig"

github "appstore", "0.0.6", :repo => "xdissent/puppet-appstore"
mod 'oracle_sqldeveloper', '0.0.3', :github_tarball => "anthonywu/puppet-oracle-sqldeveloper"
dev "parallels"
dev "answers"

github "awsshell",      "1.0.1", :repo => "DennisDenuto/puppet-awsshell"
github "iterm2",      "1.2.4.1", :repo => "DennisDenuto/puppet-iterm2"
github "emacs",       "1.1.0"
github "osx",         "1.6.0"


github "ohmyzsh",         "0.0.2", :repo => "DennisDenuto/puppet-ohmyzsh"
github "limechat",         "1.1.0", :repo => "mozilla-boxen/puppet-limechat"
github "maven",         "1.0.7", :repo => "steinim/puppet-maven"
github "gvm",         "1.0.2", :repo => "DennisDenuto/puppet-gvm"
github "zsh",         "1.0.0"
github "autojump",    "1.0.0"
github "tmux",        "0.0.2", :repo => "DennisDenuto/puppet-tmux"

github "wget",        "1.0.0"

github "chrome",      "1.2.0"
github "firefox",      "1.2.2"

github "dropbox",     "1.1.1"

github "virtualbox",  "1.0.13"
github "vagrant",     "3.2.0"
github "android",     "1.4.0"
github "vmware_fusion",     "1.2.0"
github "slate",       "1.0.1"
#github "mysql", "1.99.15"
github "wireshark", "1.1.0", :repo => "carwin/puppet-wireshark"
