CREATE TABLE IF NOT EXISTS `{PREFIX}blang` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `title` varchar(255) NOT NULL,
  `ru` varchar(255) NOT NULL,
  `ua` varchar(255) NOT NULL,
  `en` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;