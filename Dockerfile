FROM bluebonnet/ubuntu

RUN apt-get update && \
    apt-get -y install python python-pip sudo vim
RUN /usr/bin/pip install twisted numpy sklearn

RUN useradd --no-create-home --home-dir=/srv/umich-autograder --system autograder && \
    useradd --no-create-home --system guest
ADD sudoers /etc/sudoers

RUN mkdir -p /srv/umich-autograder && \
    chown autograder:autograder /srv/umich-autograder

USER autograder
ADD umich-autograder /srv/umich-autograder
WORKDIR /srv/umich-autograder
RUN python install.py
ADD user-accounts.txt /srv/umich-autograder/user-accounts.txt
#ADD sudoers /etc/sudoers

ENTRYPOINT ["/usr/bin/tini", "python", "/srv/umich-autograder/src/grader_api_server.py"]
