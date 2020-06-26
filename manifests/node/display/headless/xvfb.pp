class selenium::node::display::headless::xvfb{

  include selenium::conf

  $package_names = {
    'CentOS' => 'xorg-x11-server-Xvfb',
    'Ubuntu' => 'xvfb'
  }

  $package = distro_lookup($package_names)

  package { $package:
    ensure => installed,
  }

  if $::operatingsystem == 'CentOS' {

    package { 'libXfont':
      ensure => latest,
      before => Package[$package],
    }
  }

  $fbdir = "${selenium::conf::rundir}/xvfb"

  file { "${selenium::conf::rundir}/xvfb":
    ensure => directory,
    owner  => $selenium::conf::user_name,
    group  => $selenium::conf::user_group,
    mode   => '0755',
  }
}
