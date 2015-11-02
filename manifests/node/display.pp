class selenium::node::display(
  $headless         = true,
  $enable_vnc       = false,
  $use_vnc_password = false,
  $vnc_password     = 'changeme',
  $vnc_view_only    = false,
  $vnc_port         = 5900,
){

  if $use_vnc_password {
    if $vnc_password == 'changeme' {
      fail('You must set the vnc_password!')
    }
  }

  unless $::osfamily == 'Darwin' {
    if $headless {
      include selenium::node::display::headless
    } else {
      include selenium::node::display::headed
    }
  }
}
