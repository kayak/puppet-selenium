require 'spec_helper'

describe 'selenium::cleanup' do
  let :pre_condition do
<<PRE
class selenium::conf{
  $user_name = 'foo'
  $user_group = 'bar'
  $install_dir = '/i'
  $logdir = '/l'
}
PRE
  end

  context 'default' do
    it do
      should contain_file('/i/cleanup.sh').with({
        :owner  => 'foo',
        :group  => 'bar',
        :mode   => '0755',
        :source => 'puppet:///modules/selenium/cleanup.sh',
      })

      should contain_cron('selenium-cleanup').with({
        :command => '/i/cleanup.sh 3 &> /l/cleanup.log',
        :user    => 'foo',
        :hour    => '*',
        :minute  => '0',
      })
    end
  end

  context 'override days_old param' do
    let :params do { :minutes_old => 5 } end

    it do
      should contain_cron('selenium-cleanup').with(
        :command => '/i/cleanup.sh 5 &> /l/cleanup.log'
      )
    end
  end

  context 'days_old param not integer' do
    let :params do { :minutes_old => 'foo' } end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /must be an integer, got: "foo"/)
    end
  end
end
