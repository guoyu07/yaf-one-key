#! /bin/bash
echo "请输入要创建的程序根目录名称,如在当前目录则为空";
read dir;
if [ "$dir" != "" ]; then
	mkdir $dir
	cd $dir
fi
mkdir -p application/controllers application/models application/views/index config library public
cat > application/Bootstrap.php<<-EOF
<?php
class Bootstrap extends \Yaf\Bootstrap_Abstract
{
    public function _initConfig() {
        \$config = \Yaf\Application::app()->getConfig();
        \Yaf\Registry::set('config', \$config);
    }
}
EOF
cat > application/controllers/Base.php<<-EOF
<?php
class BaseController extends \Yaf\Controller_Abstract
{
    public function init() {
        \$this->config = \Yaf\Registry::get('config');
        \$this->_init();
    }
    public function _init() {
    }
}
EOF
cat > application/controllers/Index.php<<-EOF
<?php
class IndexController extends BaseController
{
    public function indexAction()
    {
        \$this->getView()->assign([
            'foo'   => 'bar'
        ]);
    }
}
EOF
cat > application/views/index/index.phtml<<-EOF
<?php
    echo \$foo;
?>
EOF
cat > public/index.php<<-EOF
<?php
include realpath(__DIR__ . '/../config') . '/config.php';
\$app = new \Yaf\Application(SITE_PATH . '/config/application.ini');
\$app->bootstrap();
\$app->run();
EOF
cat > config/application.ini<<-EOF
[product]
;支持直接写PHP中的已定义常量
application.directory = SITE_PATH "/application"
application.library = SITE_PATH "/library"
application.bootstrap = SITE_PATH "/application/Bootstrap.php"
application.modules = Index
application.dispatcher.throwException = 1
application.dispatcher.catchException = 1
EOF
cat > config/config.php<<-EOF
<?php
header('Content-type:text/html; charset=utf-8');
define('SITE_PATH', realpath(dirname(__FILE__) . '/../'));
EOF
echo Done
