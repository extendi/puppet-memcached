class memcached (
  $port = '11211',
  $user = 'memcache',
  $maxconn = '1024',
  $cachesize = '64',
  $address = '0.0.0.0'
) {
  package {'memcached':
    ensure => present,
    before => Tidy['/etc/init.d/memcached'],
  }

  tidy { '/etc/init.d/memcached':
    require => Package['memcached']
  }

  include upstart
  upstart::job { 'memcached':
    description => "Memcached upstart",
    version => "1.0",
    respawn => true,
    respawn_limit => '5 10',
    user => 'memcache',
    exec => "/usr/bin/memcached -v -m $cachesize -p $port -u $user -l $address -c $maxconn -I 1",
    require => Tidy['/etc/init.d/memcached'],
  }
}