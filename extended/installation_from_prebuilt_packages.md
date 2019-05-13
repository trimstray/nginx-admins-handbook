#### Table of Contents

* [Installation from prebuilt packages](#installation-from-prebuilt-packages)
  * [RHEL7 or CentOS 7](#rhel7-or-centos-7)
  * [Debian or Ubuntu](#debian-or-ubuntu)

#### Installation from prebuilt packages

##### RHEL7 or CentOS 7

###### From EPEL

```bash
# Install epel repository:
yum install epel-release
# or alternative:
#   wget -c https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#   yum install epel-release-latest-7.noarch.rpm

# Install NGINX:
yum install nginx
```

###### From Software Collections

```bash
# Install and enable scl:
yum install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms

# Install NGINX (rh-nginx14, rh-nginx16, rh-nginx18):
yum install rh-nginx16

# Enable NGINX from SCL:
scl enable rh-nginx16 bash
```

###### From Official Repository

```bash
# Where:
#   - <os_type> is: rhel or centos
cat > /etc/yum.repos.d/nginx.repo << __EOF__
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/<os_type>/$releasever/$basearch/
gpgcheck=0
enabled=1
__EOF__

# Install NGINX:
yum install nginx
```

##### Debian or Ubuntu

Check available flavors of NGINX before install. For more information please see [this](https://askubuntu.com/a/556382) great answer by [Thomas Ward](https://askubuntu.com/users/10616/thomas-ward).

###### From Debian/Ubuntu Repository

```bash
# Install NGINX:
apt-get install nginx
```

###### From Official Repository

```bash
# Where:
#   - <os_type> is: debian or ubuntu
#   - <os_release> is: xenial, bionic, jessie, stretch or other
cat > /etc/apt/sources.list.d/nginx.list << __EOF__
deb http://nginx.org/packages/<os_type>/ <os_release> nginx
deb-src http://nginx.org/packages/<os_type>/ <os_release> nginx
__EOF__

# Update packages list:
apt-get update

# Download the public key (or <pub_key> from your GPG error):
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <pub_key>

# Install NGINX:
apt-get update
apt-get install nginx
```
