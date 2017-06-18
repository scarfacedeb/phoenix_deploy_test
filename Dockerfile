FROM ubuntu:16.04

RUN \
  apt-get update && \
  apt-get install -y wget curl

RUN \
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  apt-get update && \
  apt-get install -y esl-erlang elixir build-essential openssh-server git

RUN \
  apt-get update && \
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -y nodejs

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV MIX_ENV prod

# RUN mkdir /var/run/sshd
RUN useradd --system --shell=/bin/bash --create-home builder
# COPY ssh_key.pub /home/builder/.ssh/authorized_keys

COPY . /home/builder
# COPY config/prod.secret.exs /home/builder/prod.secret.exs

RUN mix local.hex
RUN mix local.rebar

# CMD ["/usr/sbin/sshd", "-D"]
CMD ["mix", "release"]
