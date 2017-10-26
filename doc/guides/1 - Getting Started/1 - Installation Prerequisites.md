# Installation Prerequisites

This guide covers getting your system ready for Refinery. Afterwards you will have:

* A working version of Ruby
* ImageMagick installed
* Either the SQLite, MySQL, or PostgreSQL database configured

## Checklist

If you are already a Rails developer, you will most likely not have to install anything else. Here's the requirements for Refinery:

* __Ruby__ - 2.2.2+, Rubinius, and JRuby are all acceptable
* __RubyGems__ - Recommended that you have the latest version installed
* __Database__ - SQLite3 (default), MySQL, or PostgreSQL
* __ImageMagick__ - Recommended that you have the latest version installed

If you have all of these things, great! Proceed on to the [Getting Started with Refinery](https://www.refinerycms.com/guides/getting-started/) guide.

Otherwise, choose your operating system below.

## Ubuntu

### Ruby

__TIP__: The best way to install Ruby is using [rbenv](https://github.com/rbenv/rbenv)

```shell
$ sudo apt-get install ruby
```

### RubyGems

__TIP__: If you used `rbenv` above then this step will not be necessary.

```shell
$ sudo apt-get install rubygems
```

### Database

For SQLite:

```shell
$ sudo apt-get install sqlite3 libsqlite3-dev
```

For MySQL:

```shell
$ sudo apt-get install mysql-client mysql-server libmysqlclient-dev
```

### ImageMagick

```shell
$ sudo apt-get install imagemagick
```

## Mac OS X

### Ruby

__TIP__: The best way to install Ruby is using [rbenv](https://github.com/rbenv/rbenv)

### Rubygems

__TIP__: If you used `rbenv` above then this step will not be necessary.

Rubygems also comes installed by default, however, it could be an old version which will cause problems. Update using:

```shell
$ gem update --system
```

Also, in the past, we face to a RDoc bug, you should update it as well:

```shell
$ gem install rdoc
```

### Database

SQLite is most likely already installed.

### ImageMagick

Use this shell script: <https://github.com/maddox/magick-installer>. Or, if you have [Homebrew](http://mxcl.github.io/homebrew/) installed, you can use:

```shell
$ brew install imagemagick
```

## Windows

### Ruby and Rubygems

<http://www.railsinstaller.org/> provides a great installer to get you up and running in no time. Just download the kit and follow through the installer.

### Database

If you used Rails Installer, then SQLite will have been installed by default. For MySQL, follow the instructions at the MySQL website: <http://www.mysql.com/downloads/mysql/>

### ImageMagick

__WARNING__: ImageMagick is tricky to install on Windows. Make sure to read the instructions carefully, and if one version does not work for you try an older version as well.

Follow the instructions at <http://www.imagemagick.org/script/binary-releases.php#windows>

## Ready to Install!

Easier than expected right? Now you're ready to start building great websites with Refinery! Proceed on to the [Getting Started with Refinery](https://www.refinerycms.com/guides/getting-started/) guide.
