# Installation Prerequisites

This guide covers getting your system ready for Refinery. Afterwards you will have:

* A working version of Ruby
* ImageMagick installed
* Either the SQLite, MySQL, or Postgres database configured

## Checklist

If you are already a Rails developer, you will most likely not have to install anything else. Here's the requirements for Refinery:

* __Ruby__ - 3.2+ and JRuby are all acceptable
* __RubyGems__ - Recommended that you have the latest version installed
* __Database__ - SQLite3 (default), MySQL, or Postgres
* __ImageMagick__ - Recommended that you have the latest version installed

If you have all of these things, great! Proceed on to the [Getting Started with Refinery](/guides/getting-started/) guide.

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

## macOS

### Ruby

__TIP__: The best way to install Ruby is using [mise-en-place](https://mise.jdx.dev/)

### ImageMagick

If you have [Homebrew](https://brew.sh/) installed, you can use:

```shell
$ brew install imagemagick
```

## Windows

### Ruby and Rubygems

### Database

For MySQL, follow the instructions at the MySQL website: <https://dev.mysql.com/downloads/mysql/>. For Postgres, follow the instructions at the Postgres website: <https://www.postgresql.org/download/windows/>.

### ImageMagick

__WARNING__: ImageMagick is tricky to install on Windows. Make sure to read the instructions carefully, and if one version does not work for you try an older version as well.

Follow the instructions at <https://imagemagick.org/script/download.php#windows>

## Ready to Install!

Easier than expected right? Now you're ready to start building great websites with Refinery! Proceed on to the [Getting Started with Refinery](/guides/getting-started/) guide.
