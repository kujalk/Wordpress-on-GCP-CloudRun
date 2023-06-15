<?php
define('FORCE_SSL_ADMIN', true);
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
    $_SERVER['HTTPS']='on';

define( 'DB_NAME', getenv('DB_NAME') );
define( 'DB_USER', getenv('DB_USER') );
define( 'DB_PASSWORD', getenv('DB_PASSWORD') );
define( 'DB_HOST', getenv('DB_HOST') );

define( 'DB_CHARSET', 'utf8' );

define( 'DB_COLLATE', '' );

//Must for WP-Super cache to work
define('WP_CACHE', true);
define('WPCACHEHOME', '/var/www/html/wp-content/plugins/wp-super-cache/');


define('AS3CF_SETTINGS', serialize(array(
    'provider' => 'gcp',
    'key-file-path' => '/var/www/html/svc.json',
)));

define('AUTH_KEY',         '|2z^C-qcE1,|W]<WQ);}g$#~j&MQx&]d[HO-5CE+4oP~[O|POO#bz9acHHu.kw Z');
define('SECURE_AUTH_KEY',  'oJbmv5F7S-g/]!Tr.q+i7vE~Z!|,Aqn?vCOjl% heY[s%+v_N!)Px0K%q>-Xm`od');
define('LOGGED_IN_KEY',    'p=GnX:moc_5bAZ`8JL:X+pp!En(6/5Nbtciu%rG:6H-83Sg>qE/:29tB:J#<L$/6');
define('NONCE_KEY',        'ph;+P@&JY4#t7>-(J@.+C|RGF(VK~N8?zWa[[,I<)*)<CUygd-{90nG/W]G><p{o');
define('AUTH_SALT',        'zrFX+neB=P.|-r~&_vFw-j[}&)5UfV89} S>7B%ac$7+ZkLbg OK7xuU3u%.=!&.');
define('SECURE_AUTH_SALT', 'HyDFdwkM,#aSMIpuR!JPGLrHCMzI!prID9|HsCTRD@=eS&-N|0+ }$x$-y#&f!8k');
define('LOGGED_IN_SALT',   'W{-t9]?%tL~hG5q-N-X1^jatZH>_0W3 nYt@]@iqYy[gd@|EejuSP$#ZJ/]|;l+x');
define('NONCE_SALT',       'x>@}6VIw%u?jn[{>-?jmwD;+w!i#Uuv8q~A l*H-ZUC->q| g)!jd_HQLqxuSx@-');

$table_prefix = 'CblEt_';

define( 'WP_DEBUG', false );

// adjust Redis host and port if necessary 
define( 'WP_REDIS_HOST', getenv('WP_REDIS_HOST') );
define( 'WP_REDIS_PORT', 6379 );

//change the prefix and database for each site to avoid cache data collisions
define( 'WP_REDIS_PREFIX', 'my-site' );
define( 'WP_REDIS_DATABASE', 0 ); // 0-15

//reasonable connection and read+write timeouts
define( 'WP_REDIS_TIMEOUT', 3 );
define( 'WP_REDIS_READ_TIMEOUT', 3 );

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';