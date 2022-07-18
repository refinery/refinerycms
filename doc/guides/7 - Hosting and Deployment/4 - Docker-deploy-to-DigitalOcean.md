# Docker deploy to DigitalOcean

In this tutorial, we will show, how to run RefineryCMS example app in Docker and how to start Docker container using Docker Compose
on fresh vps from DigitalOcean.

Technology we will use:
- Postgres v14
- RefineryCMS from master branch
- Docker
- Docker Compose
- Nginx proxy
- Ubuntu 22.04 server

Lets start!

## Project init
If you want to dockerize your project, navigate `cd` to your RefineryCMS project. If you dont have project yet, you can
download the example app from Github. To download the example app, run: `git clone https://github.com/refinery/refinerycms-example-app.git`

Now, change directory to the project and open project via your favourite IDE, like RubyMine.

If you are using `RVM`, add following file: `.rvmrc` to the project root with the content:
```
rvm use ruby-2.6.5@refinery-guides --create
```
Now change the ruby version:
```
cd ..
cd refinerycms-example-app
```
Install the bundler via `gem intall bundler -v 2.1.1` and then `bundle install`

## Project dockerization
At first, we need to prepare Rails project (RefineryCMS project) to be able build Docker image with.

To `bin` folder (located in project root), create new file with name `run.docker.sh` with following content:
```
#!/bin/bash
set -x
set -e
set -o pipefail

./bin/run.symlinks.docker.sh

bundle exec rake db:migrate

service nginx start

bundle exec puma -C config/puma.rb
```

Apply executable permission:
``` 
chmod +x bin/run.docker.sh
```

Create new file with name `run.symlinks.docker.sh` also in the bin folder:
```
#!/bin/bash

# Create symlinks (use absolute paths)
for folder in 'tmp/cache' 'log' 'public/uploads' 'public/system'; do
  rm -rf "/app/$folder"
  mkdir -p "/app/shared/$folder"
  ln -sf "/app/shared/$folder" "/app/$folder"
done

mkdir -p /app/shared/nginx/cache/dragonfly
```
Apply executable permission:
``` 
chmod +x run.symlinks.docker.sh
```

Apply ENV variables for smtp communication (if you want to activate SMTP) -
open file `config/environments/production.rb` and append before the last `end`:
```
# SMTP
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_ADDRESS'],
    port: 587,
    domain: ENV['SMTP_DOMAIN'],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true,
    openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
  }
```
Now lets create nginx conf file. Create new folder `etc/nginx/conf.d` and create new file inside the folder with name `nginx.docker.conf` with the following content:
```
upstream app {
  server unix:/app/puma.sock fail_timeout=0;
}

proxy_cache_path /app/shared/nginx/cache/dragonfly levels=2:2 keys_zone=dragonfly:100m inactive=30d max_size=1g;
server {
  listen 80 default_server;
  root /app/public;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
    add_header Vary Accept-Encoding;
  }

  try_files $uri/index.html $uri $uri.html @app;
  location @app {
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Host $server_name;
    proxy_pass_request_headers      on;

    proxy_redirect off;
    proxy_pass http://app;

    proxy_connect_timeout       1800;
    proxy_send_timeout          1800;
    proxy_read_timeout          1800;
    send_timeout                1800;

    proxy_buffer_size   128k;
    proxy_buffers   4 256k;
    proxy_busy_buffers_size   256k;

    gzip             on;
    gzip_min_length  1000;
    gzip_proxied     expired no-cache no-store private auth;
    gzip_types       text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_disable     "MSIE [1-6]\.";
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;

  client_body_timeout 12;
  client_header_timeout 12;
  keepalive_timeout 20;
  send_timeout 10;

  client_body_buffer_size 10K;
  client_header_buffer_size 1k;
  large_client_header_buffers 4 32k;

  server_tokens off;
}

```
After it, in `config` folder, create `database.yml` file, with the content:
```
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV['RAILS_MAX_THREADS'].to_i * 30 %>
  host: <%= ENV.fetch("POSTGRES_HOST") { 'postgres' } %>
  database: <%= ENV.fetch("POSTGRES_DB") { 'db' } %>
  username: <%= ENV.fetch("POSTGRES_USER") { 'postgres' } %>
  password: <%= ENV.fetch("POSTGRES_PASSWORD") { 'postgres' } %>
  port: <%= ENV.fetch("POSTGRES_PORT") { 5432 } %>

development:
  <<: *default

staging:
  <<: *default

test:
  <<: *default
  database: <%= ENV.fetch("POSTGRES_TEST_DB") { 'db_test' } %><%= ENV['TEST_ENV_NUMBER'] %>

production:
  <<: *default
```
We are still in `config` folder. Replace `puma.rb` file with following content:
```
workers ENV.fetch("RAILS_WORKERS") { 2 }

threads_min = ENV.fetch("RAILS_MIN_THREADS") { 5 }
threads_max = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_min, threads_max

# Specifies the `environment` that Puma will run in
environment ENV.fetch("RAILS_ENV") { "development" }

# Executed in Docker container
if File.exists?('/.dockerenv')
  app_dir = File.expand_path("../..", __FILE__)

  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  bind "unix://#{app_dir}/puma.sock"
else
  # Listen only on port
  port ENV.fetch("PORT") { 3000 }
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
```
Next, change to the project root. Create `.dockerignore` file with:
```
Dockerfile
.byebug_history
.rspec
README.md
bin/build.docker.sh
bin/deploy.docker.sh
doc/*
log/*
tmp/*
.git/*
.idea/*
coverage/*
public/uploads/*
public/system/*
docker-compose.*
node_modules/*
!.env.production
!.env.example
```

Then create `.env.example` with content:
```
SMTP_ADDRESS=
SMTP_DOMAIN=
SMTP_USERNAME=
SMTP_PASSWORD=

POSTGRES_HOST=localhost
POSTGRES_DB=refinerycms_demo
POSTGRES_USER=root
POSTGRES_PASSWORD=

# This is only needed to start the app for asset precompilation
SECRET_KEY_BASE=12345644555ssd12166fc8b0b3a8462be050811114e351ae2f6634b284411a3acf6d923d17c778f355b45eb123456

RAILS_WORKERS=2
RAILS_MIN_THREADS=5
RAILS_MAX_THREADS=5
```

Append to `.gitignore`
```
.env.*
!.env.example
config/secrets.yml
```

Do changes in `Gemfile` - append:
```
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'

gem 'dotenv-rails'
```
and run `bundle install`

After it, create `Dockerfile` with content:
```
FROM mathosk/ruby-2.6.5-ubuntu:latest as builder

MAINTAINER Matho "martin.markech@matho.sk"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    vim \
    git \
    build-essential \
    libgmp-dev \
    libpq-dev \
    locales \
    nginx \
    cron \
    bash \
    imagemagick \
    python \
    nodejs \
    npm \
    libcurl4 \
    libcurl4-openssl-dev

RUN npm install --global yarn

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ARG RAILS_ENV

ADD ./Gemfile ./Gemfile
ADD ./Gemfile.lock ./Gemfile.lock

RUN gem install bundler -v '~> 2.1.1'
# if you have some additional private gems on Gitlab, replace password with your oauth personal token and uncomment the line
# RUN bundle config gitlab.com oauth2:password
RUN bundle install --deployment --clean --path vendor/bundle --without development test --jobs 8

COPY package.json yarn.lock $APP_HOME/
RUN yarn install  --check-files

COPY . $APP_HOME

ADD .env.development .env.development
ADD .env.production .env.production

RUN bundle exec rake assets:precompile --verbose

RUN rm -rf $APP_HOME/node_modules
RUN rm -rf $APP_HOME/tmp/*

FROM mathosk/ruby-2.6.5-ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    build-essential \
    libgmp-dev \
    libpq-dev \
    locales \
    nginx \
    cron \
    bash \
    imagemagick \
    python \
    libcurl4 \
    libcurl4-openssl-dev \
    exiftool

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Set Nginx config
ADD config/etc/nginx/conf.d/nginx.docker.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/default

COPY --from=builder /app $APP_HOME

ENV RAILS_ENV=production

RUN bundle config --local path vendor/bundle

RUN bundle config --local without development:test:assets

EXPOSE 80

CMD bin/run.docker.sh
```

and also create the last one file - `docker-compose-production.yml` with content:
```
version: "3.6"

networks:
  nw:
    driver: bridge

services:
  refinerycms-docker-example:
    image: "registry2.refinerycms-docker-example.matho.sk:5000/refinerycms-docker-example:latest"
    restart: always
    env_file: .env.production
    ports:
      - "8082:80"
    volumes:
      - /data/refinerycms-docker-example:/app/shared
    tty: true
    environment:
      - HOSTNAME=refinerycms-docker-example
      - VIRTUAL_HOST=refinerycms-docker-example.matho.sk
      - RAILS_ENV=production
      - POSTGRES_HOST=46.101.99.215
    depends_on:
      - postgres
    networks:
      - nw

  nginx_proxy:
    image: "jwilder/nginx-proxy"
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
    tty: true
    environment:
      - HOSTNAME=nginx_proxy
    depends_on:
      - refinerycms-docker-example
    networks:
      - nw

  postgres:
    image: "postgres:14.4"
    restart: always
    ports:
      - "5433:5432"
    environment:
      - POSTGRES_PASSWORD=superuserpwd123456
      - HOSTNAME=postgres
      - POSTGRES_HOST_AUTH_METHOD=md5
    volumes:
      - /data/postgres:/var/lib/postgresql/data
    networks:
      - nw
```

Do following changes in docker-compose file:
- replace `registry2.refinerycms-docker-example.matho.sk` url with your url
- replace `VIRTUAL_HOST=refinerycms-docker-example.matho.sk` with your domain, where you want to host the app. If you want to use
  also www subdomain, use comma to separate multiple domain
- change the IP in `POSTGRES_HOST=46.101.99.215` with the IP of your droplet, where you are running the project (production ENV)
- replace `image: "postgres:14.4"` with the version of Postgres you want to use. `14.4` is the latest stable at the time of writing the tutorial
- change the superuser password `POSTGRES_PASSWORD=superuserpwd123456` - this password will be assigned to Postgres superuser at the time of creating Postgres service

Commit the changes to git. Now your project is dockerized and we can use Docker to build the image.

## Docker build

You need some Docker base image - the OS you are running the Docker container in. Lets use Ubuntu. We can use the Ubuntu
base image in Dockerfile, but we need Ruby already installed. Due to it, I have prepared Docker base image based on Ubuntu with the Ruby v2.6.5.
If you would like to upgrade to another Ruby, you only need to change the Docker base image and push the new Docker image to e.g: Docker Hub.

The Docker base image you can find at `https://hub.docker.com/r/mathosk/ruby-2.6.5-ubuntu` for `amd64` architecture.
If you are going to use `aarch64`, like Raspberry Pi, you can use base docker image from `https://hub.docker.com/r/mathosk/rpi-ruby-2.6.5-ubuntu-aarch64` Replace
this mentions in the Dockerfile. Aarch64 base image was tested on Raspberry Pi 4. It should support also Apple M1 cpus, but this was not tested.

If you need another Ruby version, I recommend to you prepare new Docker image. You can see the source code at `https://github.com/Matho/rpi-ruby-2.6.5-ubuntu-aarch64/blob/main/Dockerfile`

To build your Docker image, you need to have installed Docker.
If you are using Ubuntu, you can use the following guide `https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository`

Then, on your computer, start the Docker build process via `sudo docker build --build-arg RAILS_ENV=production -t registry2.refinerycms-docker-example.matho.sk:5000/refinerycms-docker-example:latest .`
Replace the `registry2.refinerycms-docker-example.matho.sk` with your registry subdomain. Registry is tool, where you can push the Docker images to, and also pull Docker images from.

The Docker build process can take a lot of time - up to 45 min - based on the amount of gems and assets to be precompiled. For
the example app, you should be done until 10 minutes.

Did the build process finished correctly? Lets install the server, where we will push the project and start the Docker containers.

## Buy the DigitalOcean VPS

I recommend to use DigitalOcean. There is hourly pricing, so if you are going only to play with the server only for few hours, you will not need
to pay monthly/yearly fees.

Login to Digitalocean service at `https://www.digitalocean.com/` From the left menu , choose Manage > Droplets. In the right upper corner,
click Create > Droplets. I recommend to use Ubuntu 22.04, so change the Ubuntu version. Choose plan to `Basic`,
CPU options to `Regular with SSD` and the droplet with `1GB ram` and `25 GB ssd`. Choose the datacenter nearest to you. In authentication options,
select SSH keys. If you dont have one, I highly recommend to generate ssh key pair on localhost and upload `public` ssh key to DigitalOcean.
Then, the ssh daemon will be prepared with your ssh key, and you can login to droplet without needed to provide password every time you try to login in.
Click create droplet. The new droplet should be available in a minute.

## Server installation
Check the assigned IP to your droplet and copy paste it. Now you can login to the droplet via terminal:
`ssh root@46.101.99.215` Change the IP to the IP you have copy pasted. I recommend to change the ssh port and activate swap, but it is not needed,
if you are going only to play with the droplet for few hours.

Install the `ufw` firewall via `apt-get install ufw` and do some initial settings:
```
ufw default deny incoming
ufw allow 22 
ufw allow 5000
ufw allow 80
ufw allow 443
ufw allow 5433
ufw enable
```

Port `22` is for SSH, port `5000` is for Docker Registry and ports `80` and `443` are for Nginx. Port `5433` is open only temporarily.

Then, you need install Docker also on this droplet. Check the tutorial located at `https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository`
Once you have working Docker installation and you have also tried the Hello World Docker image, you can move to Registry installation.

Registry is tool, where your Docker images are stored. You can use publicly available registries like Docker Hub, or Gitlab, but
you need to pay for ability to store private images. Also the public `gitlab.com` do not enable to store docker images with the free plan.
Due to it, we are installing registry for our private Docker images.

For production running, it is not recommended to install Docker registry on the same server like the production image is running.
Because if the server goes down, you will not be able to pull and push the docker image to another vps.

### Docker Registry installation

If you are using Docker Hub or Gitlab as Docker registry, you can skip this steps.

The installation guide is located at `https://docs.docker.com/registry/insecure/#use-self-signed-certificates`
I expect, that you do not have ssl certificate for your registry domain yet, so we will use the `Use self-signed certificates` installation option.

- navigate to your home dir, via `cd`
- prepare dir for certs via `mkdir -p certs`
- generate the self-signed cert (replace `registry2.refinerycms-docker-example.matho.sk` with your domain)
```
  openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
  -addext "subjectAltName = DNS:registry2.refinerycms-docker-example.matho.sk" \
  -x509 -days 365 -out certs/domain.crt
```
- when you will be asked for `FQDN`, use the `registry2.refinerycms-docker-example.matho.sk` - replace with your domain

Now, we need the Docker / Ubuntu OS trust the self-signed cert.
Do the following steps (`on both your OS and server OS`):
- `mkdir -p /etc/docker/certs.d/registry2.refinerycms-docker-example.matho.sk:5000` (replace `registry2.refinerycms-docker-example.matho.sk`)
- `cp certs/domain.crt /etc/docker/certs.d/registry2.refinerycms-docker-example.matho.sk:5000/ca.crt` (use your path)
- `vim /usr/local/share/ca-certificates/registry2.refinerycms-docker-example.matho.sk.crt` - paste the content from `certs/domain.crt`
- `update-ca-certificates`
- you should see that 1 cert was installed
- if needed, restart docker on both machines via `sudo systemctl restart docker.service`

Login to your domain registrar and set `A dns record` to your DigitalOcean droplet. E.g: change A record to `46.101.99.215` (change with your IP)

Now we can start the registry from the root homedir:
```
docker run -d \
  --restart=always \
  --name registry \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -p 5000:5000 \
  registry:2
```

Test on the droplet, if it works: (change the domains)
- `docker pull ubuntu:16.04`
- `docker tag ubuntu:16.04 registry2.refinerycms-docker-example.matho.sk:5000/my-ubuntu`
- `docker push registry2.refinerycms-docker-example.matho.sk:5000/my-ubuntu`
- `docker pull registry2.refinerycms-docker-example.matho.sk:5000/my-ubuntu`

If the commands has passed, the Docker Registry works.

### Deploy the Docker image

Because we have installed Registry, we can now push our Docker image from our local machine via: (change the domain)
```
sudo docker push registry2.refinerycms-docker-example.matho.sk:5000/refinerycms-docker-example:latest
```
In case you need to rebuild the image from beginning, you can pass the `--no-cache` option, like:
```
sudo docker build --no-cache --build-arg RAILS_ENV=production -t registry2.refinerycms-docker-example.matho.sk:5000/refinerycms-docker-example:latest .
```

Login to droplet:
- `mkdir ~/docker-compose`
- `cd ~/docker-compose`
- `apt install docker-compose`
- `vim docker-compose-production.yml` but change the `registry2.refinerycms-docker-example.matho.sk` domain, `VIRTUAL_HOST`,`POSTGRES_HOST` , `POSTGRES_PASSWORD`
```
version: "3.6"

networks:
  nw:
    driver: bridge

services:
  refinerycms-docker-example:
    image: "registry2.refinerycms-docker-example.matho.sk:5000/refinerycms-docker-example:latest"
    restart: always
    env_file: .env.production
    ports:
      - "8082:80"
    volumes:
      - /data/refinerycms-docker-example:/app/shared
    tty: true
    environment:
      - HOSTNAME=refinerycms-docker-example
      - VIRTUAL_HOST=refinerycms-docker-example.matho.sk
      - RAILS_ENV=production
      - POSTGRES_HOST=46.101.99.215
    depends_on:
      - postgres
    networks:
      - nw

  nginx_proxy:
    image: "jwilder/nginx-proxy"
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
    tty: true
    environment:
      - HOSTNAME=nginx_proxy
    depends_on:
      - refinerycms-docker-example
    networks:
      - nw

  postgres:
    image: "postgres:14.4"
    restart: always
    ports:
      - "5433:5432"
    environment:
      - POSTGRES_PASSWORD=superuserpwd123456
      - HOSTNAME=postgres
      - POSTGRES_HOST_AUTH_METHOD=md5
    volumes:
      - /data/postgres:/var/lib/postgresql/data
    networks:
      - nw
```
- `vim .env.production` with content
```
SMTP_ADDRESS=
SMTP_DOMAIN=
SMTP_USERNAME=
SMTP_PASSWORD=

POSTGRES_HOST=postgres
POSTGRES_DB=refinery-guides-production
POSTGRES_USER=refinery
POSTGRES_PASSWORD=s145as87wa21548wd
POSTGRES_PORT=5433

SECRET_KEY_BASE=q22gt2gw555ssd12166fc8b0b3a8462be050811114e351ae2f6634b284411a3acf6d923d17c778f355b45eba5c819

RAILS_WORKERS=2
RAILS_MIN_THREADS=5
RAILS_MAX_THREADS=5
```
- `mkdir -p /data/refinerycms-docker-example`
- `mkdir /app`
- `mkdir /data/postgres`
- `docker pull registry2.refinerycms-docker-example.matho.sk:5000/refinerycms-docker-example:latest`

Cd to `~/docker-compose` dir and now we can start `docker-compose` via:
```
docker-compose -f docker-compose-production.yml up
```
If you want to run it in the background, append `-d` parameter.
```
docker-compose -f docker-compose-production.yml up -d
```
If you want to stop the docker compose, run:
- `docker-compose -f docker-compose-production.yml down`

When the first Postgres container start, the Postgres superuser with password `POSTGRES_PASSWORD` will be created. We need also some small modifications to Postgres settings.
Open another terminal window (while docker-compose is running in the first window) and login to droplet.
- open `vim /data/postgres/pg_hba.conf` from the droplet os, (not in Docker on droplet) and add at the end:
```
host all all all md5
```

Restart docker-compose (`down` and `up`)

Login to the Postgres Docker container via:
`docker container exec -it docker-compose_postgres_1 bash`

Switch to the postgres user:
- `su postgres`

and create refinery user:
- `createuser refinery -P --interactive`
- insert the password from `POSTGRES_PASSWORD` env, like `s145as87wa21548wd`
- username and password depends on you, if you change it here, do not forget to change it in the `.env.production` file with ENV variables

Next, create the database in psql shell:
- `psql -U postgres`
- `CREATE DATABASE "refinery-guides-production" WITH ENCODING 'UTF8';`

Logout from psql shell and docker container (via ctrl+d)

Restart docker-compose (`down` and `up`), or if you do no run it in detached mode, simply `ctrl + d` to quit it

Postgres should be started correctly now.

Now we need to restrict the `5433` connection to Docker only. We do not need to open 5433 port publicly, but only for inside Docker network.
We need to detect the Docker internal private IP for the `nw` network, where the containers are running.

Run:
- `apt install net-tools` to install `ifconfig` command
- `docker network ls | grep 'docker-compose_nw'`
- copy the value from first column, something like `e86fca7c7587`
- copy the IP from the result of command (replace hash for grep with the value of previous command) `ifconfig | grep 'e86fca7c7587' -A 5 | grep '172'`
- the IP should start with `172`
- allow ufw for this ip, for the result `172.23.0.0/16`, we will use `sudo ufw allow from 172.23.0.0/16 to any port 5433`

We can now delete the public allow 5433 rule in ufw:
- `ufw status numbered` with output:
```
     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    Anywhere                  
[ 2] 5000                       ALLOW IN    Anywhere                  
[ 3] 80                         ALLOW IN    Anywhere                  
[ 4] 443                        ALLOW IN    Anywhere                  
[ 5] 5433                       ALLOW IN    Anywhere                  
[ 6] 5433                       ALLOW IN    172.18.0.0/16             
[ 7] 22 (v6)                    ALLOW IN    Anywhere (v6)             
[ 8] 5000 (v6)                  ALLOW IN    Anywhere (v6)             
[ 9] 80 (v6)                    ALLOW IN    Anywhere (v6)             
[10] 443 (v6)                   ALLOW IN    Anywhere (v6)             
[11] 5433 (v6)                  ALLOW IN    Anywhere (v6)
```
- to delete 5th and 11th rules, run `ufw delete 5` and `ufw delete 11`

Note: in the Docker container, Postgres is running on `5432` port. But in the non-docker env, is running on 5433. It allows you to
use the Postgres with non-docker on `5432` and Postgres from Docker via `5433` on the host system.

Restart the docker-compose again, it should start correctly.

Now we will check, if the `5433` port is available from the public. From your local machine, run: (replace IP)  
`nmap 46.101.99.215`

You should not see `5433` port available to public.

If everything works, navigate to the browser and write the url `http://refinerycms-docker-example.matho.sk/refinery` (change the domain)
You should see Refinery form with user registration. Fill in and submit the form to be able login and work with Refinery admin.

That's all!
