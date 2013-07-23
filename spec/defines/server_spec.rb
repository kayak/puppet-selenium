require 'spec_helper'

describe 'selenium::server' do
  let :pre_condition do
<<PP
class selenium::conf {
 $install_dir = '/i'
 $user_name = 'u'
 $user_group = 'g'
 $logdir = '/l'
 $rundir = '/r'
}
class selenium::common::jar {
 $path = '/s.jar'
}
class myjava {
}
PP
  end
  let :title do 'foo' end
  let :params do
    {
      :env_vars => { 'e2' => '2 e' },
      :java_args => ['-Xmx800m'],
      :system_properties => {'p.q' => 'r'},
      :java_command => '/tmp/the java',
      :java_classname => 'myjava',
      :selenium_args => ['a','b','c']
    }
  end
  it do
    should include_class('myjava')
    should contain_bluepill__app('selenium-foo').with({
      :service_name => 'selenium-foo',
      :logfile      => '/l/foo.log',
      :content      => %r{<<CONFIG
appname: selenium-foo
user: u
group: g
pidfile: /r/foo.pid
logfile: /l/foo.log
CONFIG

start_command = <<CMD
/usr/bin/env e2=2\\ e /tmp/the\\ java -Xmx800m \
-Dp.q=r -jar /s.jar a b c
CMD}m,
    })
  end
end