FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y ca-certificates curl openssh-server
RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh |  bash
RUN apt-get  update
RUN touch /.dockerenv
RUN apt-get -y install gitlab-ce
RUN echo 'external_url "gitlab.10.12.12.69.nip.io:8888"' > /etc/gitlab/gitlab.rb 
RUN echo 'gitlab_rails["initial_root_password"] = "rootp@ss"' >> /etc/gitlab/gitlab.rb
EXPOSE 8888
ENTRYPOINT (/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure && gitlab-ctl tail