Installation Prerequisites
--------------------------

This guide covers getting your system ready for Refinery. Afterwards you
will have:

-   A working version of Ruby
-   ImageMagick installed
-   Either the SQLite, MySQL, or PostgreSQL database configured

endprologue.

### Checklist

If you are already a Rails developer, you will most likely not have to
install anything else. Here’s the requirements for Refinery:

-   **Ruby** - 1.9.3, 2.0.0, Rubinius, and JRuby are all acceptable
-   **RubyGems** - Recommended that you have the latest version
    installed
-   **Database** - SQLite3 (default), MySQL, or PostgreSQL
-   **ImageMagick** - Recommended that you have the latest version
    installed

If you have all of these things, great! Proceed on to the [Getting
Started with Refinery](/guides/getting-started/) guide.

Otherwise, choose your operating system below.

### Ubuntu

#### Ruby

TIP. If you’re planning on using Ruby a lot, the best way to install it
is using the [Ruby Version Manager](https://rvm.io/rvm/install) (RVM)

<shell>sudo apt-get install ruby</shell>

WARNING. Do not install Ruby 1.9.1, there is a known bug which will not
allow Refinery to work.

#### RubyGems

TIP. If you used RVM above then this step will not be necessary.

<shell>sudo apt-get install rubygems</shell>

#### Database

For SQLite:

<shell>sudo apt-get install sqlite3 libsqlite3-dev</shell>

For MySQL:

<shell>sudo apt-get install mysql-client mysql-server
libmysqlclient-dev</shell>

#### ImageMagick

<shell>sudo apt-get install imagemagick</shell>

### Mac OS X

#### Ruby

TIP. The best way to install Ruby is using the [Ruby Version
Manager](https://rvm.io/rvm/install) (RVM)

#### Rubygems

Rubygems also comes installed by default, however, it is an old version
which will cause problems. Update using:

<shell>gem update —system</shell>

Also, due to an RDoc bug, you’ll need to update it as well:

<shell>gem install rdoc</shell>

#### Database

SQLite is most likely already installed.

#### ImageMagick

Use this shell script: <https://github.com/maddox/magick-installer>. Or,
if you have [Homebrew](http://mxcl.github.io/homebrew/) installed, you
can use:

<shell>brew install imagemagick</shell>

### Windows

#### Ruby and Rubygems

<http://www.railsinstaller.org/> provides a great installer to get you
up and running in no time. Just download the kit and follow through the
installer.

#### Database

If you used Rails Installer, then SQLite will have been installed by
default. For MySQL, follow the instructions at the MySQL website:
<http://www.mysql.com/downloads/mysql/>

#### ImageMagick

Warning. ImageMagick is tricky to install on Windows. Make sure to read
the instructions carefully, and if one version does not work for you try
an older version as well.

Follow the instructions at
<http://www.imagemagick.org/script/binary-releases.php#windows>

### Ready to Install!

Easier than expected right? Now you’re ready to start building great
websites with Refinery! Proceed on to the [Getting Started with
Refinery](/guides/getting-started/) guide.
