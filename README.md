# BootCamp LocalStack 

## Installation de CentOS
Clono la VM sre-bootcamp-centos-template y cambio nombre por sre-bootcamp-localstack-ga.
En la opción de consola utilizo VNC, para conectarse con macOS hay que bajar la calidad da Low desde VNC Viewer por el error de zlib stream

## Instalación de LocalStack en modo no privilegiado y host (no docker)

User non-root: devops

Pasos previos
```
alias ssp='ss -putan | grep -i listen'
alias docker='sudo docker'
alias yum='sudo yum'
```

## Dependencias

Estos son los pasos que luego fueron traducidos a playbooks de ansible y estan en el directorio ansible. En el rol de localstack los scripts y los templates de jinja que abajo se detallan para crear el servicio de systemd.

```
alias sudo='yum sudo'
yum install epel-release vim nc net-tools git python2-pip npm  gcc python-devel 
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
pip install --upgrade pip
# add hostname /etc/hosts
git clone https://github.com/localstack/localstack
cd localstack
pip install --user localstack
localstack start --hosts
localstack web
sudo firewall-cmd --zone=public --permanent --add-port=4500-46000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --zone=public --permanent --list-ports
curl http://localhost:8080
```

### Problem 1
pip install --upgrade pip

```
  File "/usr/lib64/python2.7/shutil.py", line 302, in move
    os.unlink(src)
OSError: [Errno 13] Permission denied: '/usr/bin/pip'
You are using pip version 8.1.2, however version 19.2.2 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
```

### Solution
sudo pip install --upgrade pip

### Problem 2
pip install localstack
```
Collecting futures<4.0.0,>=2.2.0; python_version == "2.6" or python_version == "2.7" (from s3transfer<0.3.0,>=0.2.0->boto3>=1.9.71->localstack)
  Downloading https://files.pythonhosted.org/packages/d8/a6/f46ae3f1da0cd4361c344888f59ec2f5785e69c872e175a748ef6071cdb5/futures-3.3.0-py2-none-any.whl
Installing collected packages: jmespath, docutils, six, python-dateutil, urllib3, botocore, futures, s3transfer, boto3, docopt, dnspython, dnslib, pyaes, localstack-ext, localstack-client, subprocess32-ext, localstack
ERROR: Could not install packages due to an EnvironmentError: [Errno 13] Permission denied: '/usr/lib/python2.7/site-packages/jmespath'
Consider using the `--user` option or check the permissions.
```
### Solution
pip install —user localstack


- Note 1: When we are execute pip with flag --user all dependencies and biniries install into the folder ~/.local

### Problem 3
pip install --user localstack
```
    unable to execute gcc: No such file or directory

    error: command 'gcc' failed with exit status 1
```

### Solution
yum -y install gcc python-devel


### Problem 4
pip install localstack[full] —user
```
Collecting cfn-lint>=0.4.0 (from moto-ext==1.3.14.dev0->localstack[full])
  Using cached https://files.pythonhosted.org/packages/8b/4b/0145c1fb2123534daf287add4ced1d1eb281441385c10be9ed26a807021b/cfn-lint-0.23.3.tar.gz
    ERROR: Command errored out with exit status 1:
...
ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.
```

### Solution
sudo pip install --upgrade setuptools

### Problem 5
```
[devops@sre-bootcamp-localstack-ga localstack]$ localstack start --host
Starting local dev environment. CTRL-C to quit.
ERROR: [Errno 2] No such file or directory: '/home/devops/.local/lib/python2.7/site-packages/localstack/utils/../../requirements.txt'
[devops@sre-bootcamp-localstack-ga localstack]$
```

### Solution
pip install localstack[full] —user

### Problem 6
```
[devops@sre-bootcamp-localstack-ga localstack]$ localstack start --host
ERROR: 'cd "/home/devops/.local/lib/python2.7/site-packages/localstack" && npm install': exit code 127; output: /bin/sh: npm: command not found
```
### Solution
yum -y install npm java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

### Problem 7
```
2019-08-17T12:11:37:WARNING:infra.pyc: Service "s3" not yet available, retrying...
2019-08-17T12:11:52:ERROR:localstack.services.s3.s3_starter: S3 health check failed: Could not connect to the endpoint URL: "http://sre-bootcamp-localstack-ga.semperti.local:4572/" Traceback (most recent call last):
```
### Solution
add hostname to /etc/hosts

### Problem 8

```
2019-08-17T13:17:28:WARNING:infra.pyc: Service "dynamodb" not yet available, retrying...
2019-08-17T13:17:42:WARNING:infra.pyc: Service "dynamodb" not yet available, retrying...
2019-08-17T13:17:56:ERROR:localstack.services.dynamodb.dynamodb_starter: DynamoDB health check failed:  Traceback (most recent call last):
  File "/home/devops/.local/lib/python2.7/site-packages/localstack/services/dynamodb/dynamodb_starter.py", line 21, in check_dynamodb
```

### Solution
The steps for resolv the issue was to install maven and delete previus fat jar generate. 

rm -rf /home/devops/.local/lib/python2.7/site-packages/localstack/infra
localstack start --host


### Problem 9 - Firewall port
```
sudo firewall-cmd --zone=public --permanent --add-port=4500-46000/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --zone=public --permanent --list-ports
```

### Problem 10
Install service with systemd service.unit

vim /usr/lib/systemd/system/localstack-infra.service 
```
[Unit]
Description = localstack infra up 
After = network.target

[Service]
ExecStart = /home/devops/localstack-infra-start.sh

[Install]
WantedBy = multi-user.target
```

cat /home/devops/localstack-infra-start.sh
```
#!/bin/bash
cd /home/devops/localstack
su - devops -c 'echo "LocalStack Infra Starting with $USER user"'
su - devops -c 'localstack start --host &'
```

cat /usr/lib/systemd/system/localstack-web.service 
```
[Unit]
Description = localstack web up 
After = network.target

[Service]
ExecStart = /home/devops/localstack-web-start.sh

[Install]
WantedBy = multi-user.target
```

cat /home/devops/localstack-web-start.sh
```
#!/bin/bash
cd /home/devops/localstack
su - devops -c 'echo "LocalStack Web Starting with $USER user"'
su - devops -c 'localstack web --host &'
```
