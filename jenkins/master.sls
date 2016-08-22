{% from "jenkins/map.jinja" import jenkins with context %}

create_ssh_directory_on_master:
  file.directory:
    - name: {{ jenkins.home }}/.ssh
    - user: {{ jenkins.user }}
    - group: {{ jenkins.group }}
    - mode: 700

# This is just a static key, during production dynamic key generation is
# recommended
deploy_private_key_on_master:
  file.managed:
    # The private key is on master
    - name: {{ jenkins.home }}/.ssh/id_rsa
    # Set here the location of the pillar item where you have stored your key
    - contents_pillar: jenkins:master:private_key
    - user: {{ jenkins.user }}
    - group: {{ jenkins.group }}
    - mode: 600
    - require:
      - file: create_ssh_directory_on_master

set_known_host_for_git_login_on_master:
  file.managed:
    - name: {{ jenkins.home }}/.ssh/known_hosts
    - contents_pillar: jenkins:master:known_hosts
    - user: {{ jenkins.user }}
    - group: {{ jenkins.group }}
    - mode: 600
    - require:
      - file: create_ssh_directory_on_master
