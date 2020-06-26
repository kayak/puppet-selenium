define selenium::node::display::headless::xvfb_display(
  $display       = $title,
  $height        = 768,
  $width         = 1280,
  $color         = '24+32',
  $vnc           = false,
  $vnc_password  = undef,
  $vnc_view_only = false,
  $vnc_port      = 5900,
){

  include selenium::conf
  include selenium::node::display::headless::xvfb

  $fbdir = $selenium::node::display::headless::xvfb::fbdir

  $command = template('selenium/xvfb_command.erb')

  bluepill::simple_app { "xvfb-${title}":
    start_command => $command,
    service_name  => "xvfb-${title}",
    user          => $selenium::conf::user_name,
    group         => $selenium::conf::user_group,
    logfile       => "${selenium::conf::logdir}/xvfb-${title}",
    pidfile       => "${selenium::conf::rundir}/xvfb-${title}.pid",
    rotate_logs   => true,
    require       => [Package[$xvfb::package],File[$fbdir]]
  }

  if $vnc {
    include selenium::node::display::headless::x11vnc

    if $vnc_password {
      $pwfile   = "${selenium::conf::confdir}/x11vnc-${title}-password"

      file { $pwfile:
        owner   => $selenium::conf::user_name,
        group   => $selenium::conf::user_group,
        mode    => '0400',
        content => $vnc_password,
      }
    }

    $vnc_cmd = template('selenium/x11vnc_command.erb')

    bluepill::simple_app { "x11vnc-${title}":
      start_command => $vnc_cmd,
      service_name  => "x11vnc-${title}",
      user          => $selenium::conf::user_name,
      group         => $selenium::conf::user_group,
      logfile       => "${selenium::conf::logdir}/x11vnc-${title}",
      pidfile       => "${selenium::conf::rundir}/x11vnc-${title}.pid",
      rotate_logs   => true,
    }
  }
}
