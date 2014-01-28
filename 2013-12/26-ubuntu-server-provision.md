# Ubuntu Server Provisioning

# As Root

## Update and Add Users
```
apt-get update
apt-get upgrade

# Preliminary software
apt-get install vim git ranger multitail tmux colordiff wget rsync curl htop tree caca-utils mlocate highlight

# Clone etc_skel.git or prepare your own /etc/skel or skip

# Setup users/groups/ssh
groupadd owners
groupadd developers
useradd -m -G owners,developers bobby
useradd -m -G owners,developers dylan
useradd -m -G developers johnny
```

## SSH Keys
```
cd ~
mkdir .ssh
chmod 700 .ssh
cd .ssh
touch authorized_keys
chmod 600 authorized_keys
vim authorized_keys

# add your pubkey
```

## SSHD
```
vim /etc/ssh/sshd_config
# Change settings for security
Port 22
Protocol 2
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no

service sshd restart
```

## Sudoers
```
# Edit sudoers configuration
vim /etc/sudoers

# Add this line
# This is "the easy way", will add group "monkey" to list of users who can use the
# sudo command without a password! If you want more security, read more carefully
# the configuration file and manual.
 %owners        ALL=(ALL)       NOPASSWD: ALL
```

## Software
```
# Install Web stack
apt-get install apache2 php5 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-memcache php5-sqlite php5-tidy php5-xmlrpc php5-json

# Install PostgreSQL
apt-get install postgresql-9.3 postgresql-contrib-9.3 php5-pgsql

# Install client-side stack
add-apt-repository ppa:chris-lea/node.js
apt-get install nodejs
npm install -g bower grunt-cli requirejs

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

apt-get install ruby2.0 ruby2.0-dev
gem install bundler
```

## SMTP
```
apt-get install msmtp ca-certificates

vim /etc/msmtprc
	# Set defaults.
	defaults

	# Enable or disable TLS/SSL encryption.
	tls on
	tls_starttls on
	tls_trust_file /etc/ssl/certs/ca-certificates.crt

	# Set up a default account's settings.
	account default
	host smtp.sendgrid.net
	port 587
	auth on
	user <username>
	password <password>
	from bounces@your-doman-here
	logfile /var/log/msmtp/msmtp.log

vim /etc/php5/apache2/php.ini

	sendmail_path = /usr/bin/msmtp -t

mkdir /var/log/msmtp
chown www-data:adm /var/log/msmtp
vim /etc/logrotate.d/msmtp
	/var/log/msmtp/*.log {
		rotate 12
		monthly
		compress
		missingok
		notifempty
	}
```

## PostgreSQL
```
su - postgres createuser -s your-user-name
su - postgres createuser -D -P app-name-user
su - postgres createdb -O app-name-user app-db-name

# Examples from CLI with psql:
CREATE ROLE user WITH NOCREATEDB NOCREATEROLE NOCREATEUSER PASSWORD 'your-password';
ALTER ROLE user WITH NOLOGIN;
SELECT rolname FROM pg_roles;
GRANT ALL PRIVILEGES ON DATABASE app to user;
```

## Apache
```
a2enmod rewrite
usermod -a -G developers www-data
mkdir /srv/http
chown -R www-data:developers /srv/http
chmod -R 775 /srv/http

## Setup vhosts in /etc/apache2/sites-available/
## Enable mods (expires) in /etc/apache2/mods-enabled/

service apache2 restart
```

## Git User
Create a user for git repositories:
```
useradd -r --shell /usr/bin/git-shell -c 'git version control' -m --home-dir /home/git git
usermod -a -G developers git
# Copy git-shell commands
cp -r /usr/share/doc/git/contrib/git-shell-commands /home/git/
chmod u+x /home/git/git-shell-commands/{list,help} -R
```
Follow _SSH Keys_ and add public keys for users with access to git repositories

## Setup
Update software related commands
```
updatedb
```

## User configuration
Login as your regular user and configure software:
```
# Create a ranger filescope config for your user
ranger --copy-config=scope
```

# Project Setup

## Git Repository
Create a new detached git repo to push deploys:
```
sudo mkdir /srv/http/app
sudo chown git:developers /srv/http/app
sudo chmod g+w /srv/http/app

cd /home/git
sudo mkdir app.git
sudo chown git:developers app.git
sudo chmod g+w app.git
cd app.git
git init --bare
git config core.bare false
git config core.worktree /srv/http/app      ; NO TRAILING SLASH!!!
git config receive.denycurrentbranch ignore

# create a hook
cat > hooks/post-receive
#!/bin/sh
git checkout -f

# make it executable
chmod +x hooks/post-receive

sudo chown -R git:developers app.git
```

## Apache vhost
Create a new host for your domain app:
```
vim /etc/apache2/sites-available/app.conf
cd /etc/apache2/sites-enabled
sudo ln -s ../sites-available/app.conf app.conf
```

## Post-push setup
After pushing the first time:
```
cd /srv/http/app
sudo chgrp -R developers .

# Edit hooks/post-receve and add post-build actions
# Push again
```
