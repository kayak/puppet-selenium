class selenium::node::display::headless(
  $display          = 0,
  $width            = 768,
  $height           = 1024,
  $color            = '24+32',
  $enable_vnc       = $selenium::node::display::enable_vnc,
  $vnc_password     = $selenium::node::display::vnc_password,
  $use_vnc_password = $selenium::node::display::use_vnc_password,
  $vnc_view_only    = $selenium::node::display::vnc_view_only,
  $vnc_port         = $selenium::node::display::vnc_port,
){
  include selenium::node::display::headless::xvfb

  selenium::node::display::headless::xvfb_display { 'main':
    display       => $display,
    width         => $width,
    height        => $height,
    color         => $color,
    vnc           => $enable_vnc,
    vnc_password  => $vnc_password,
    vnc_view_only => $vnc_view_only,
    vnc_port      => $vnc_port,
  }
}
