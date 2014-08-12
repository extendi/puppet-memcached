class memcached (
  $port = '11211',
  $user = 'memcache',
  $maxconn = '1024',
  $cachesize = '64',
  $address = '0.0.0.0'
) {

  package {'memcached':
    ensure => present,
  }

  exec {'memcached stopped':
    command => "/etc/init.d/memcached stop"
  }

  tidy { '/etc/init.d/memcached': }

  include upstart
  upstart::job { 'memcached':
    description => "Memcached upstart",
    version => "1.0",
    respawn => true,
    respawn_limit => '5 10',
    user => 'memcache',
    exec => "/usr/bin/memcached -v -m $cachesize -p $port -u $user -l $address -c $maxconn -I 1",
  }

  Package['memcached'] -> Exec['memcached stopped'] -> Tidy['/etc/init.d/memcached'] -> Upstart::Job['memcached']
}