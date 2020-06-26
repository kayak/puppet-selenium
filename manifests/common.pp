# Logic required by node and hub
class selenium::common{
  include selenium::conf
  include selenium::common::jar

  ensure_supported({'Ubuntu' => ['12'], 'CentOS' => ['6','7'], 'Darwin' => ['10']}, true)

  if $selenium::conf::manage_user {
    include selenium::common::user
  }

  file { $selenium::conf::install_dir:
    ensure  => directory,
    owner   => $selenium::conf::user_name,
    group   => $selenium::conf::user_group,
    recurse => true,
  }

  if $selenium::conf::cleanup {
    include selenium::cleanup
  }
}
