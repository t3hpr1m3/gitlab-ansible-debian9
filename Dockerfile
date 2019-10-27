FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

ENV PIP_PACKAGES "ansible cryptography yamllint ansible-lint flake8 testinfra molecule"

ENV ANSIBLE_ROLES_PATH=/usr/src

RUN apt-get update && \
	apt-get install -y --no-install-recommends && \
	apt-get install -y \
		build-essential \
		debconf-utils \
		gnupg \
		libffi-dev \
		libssl-dev \
		python-dev \
		python-jmespath \
		python-netaddr \
		python-pip \
		python-setuptools \
		python-wheel \
		sudo \
		systemd \
		wget && \
	pip install $PIP_PACKAGES && \
	rm -rf /var/lib/apt/lists && \
	rm -Rf /usr/share/doc && \
	rm -Rf /usr/share/man && \
	apt-get clean && \
	mkdir -p /etc/ansible && \
	echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

COPY fake_initctl .

RUN chmod +x fake_initctl && rm -rf /sbin/initctl && ln -sf /fake_initctl /sbin/initctl

VOLUME ["/sys/fs/cgroup"]

CMD ["/lib/systemd/systemd"]
