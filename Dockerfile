# Docker file to run AWS EB CLI tools.
FROM alpine

RUN apk --no-cache add \
        bash \
        less \
        groff \
        jq \
        git \
        curl \
        python \
        py-pip \
        openssh-client

RUN pip install --upgrade pip \
        awscli

# https://github.com/aws/aws-elastic-beanstalk-cli-setup
RUN apk --no-cache add --virtual .build-dependencies build-base python-dev libffi-dev openssl-dev && \
    git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git && \
    pip install virtualenv && \
    python aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py && \
    rm -rf aws-elastic-beanstalk-cli-setup /root/.cache && \
    apk del --purge .build-dependencies

ENV PATH /root/.ebcli-virtual-env/executables:$PATH

RUN curl -L https://github.com/barnybug/cli53/releases/download/0.8.16/cli53-linux-386 > /usr/bin/cli53 && \
    chmod +x /usr/bin/cli53

ENV PAGER="less"

# Expose credentials volume
RUN mkdir ~/.aws
