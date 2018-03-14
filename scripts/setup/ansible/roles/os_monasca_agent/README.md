os_monasca_agent
================

Install and configure OpenStack Monasca Agent.

The following service is installed:
- monasca-agent

Requirements
------------

none

Role Variables
--------------

    ## Monasca
    monasca_agent_git_repo: "https://git.openstack.org/openstack/monasca-agent.git"
    monasca_client_git_repo: "https://git.openstack.org/openstack/python-monascaclient.git"
    monasca_git_branch: "master"
    monasca_ip_address: "127.0.0.1"
    
    ## Keystone
    keystone_ip_address: "127.0.0.1"
    os_username: "admin"
    os_password: "secretadmin"
    os_project_name: "admin"
    
    ## Database
    mysql_root_pass: "secretdatabase"
    mysql_host: "127.0.0.1"
    
    ## Apache plugin conf
    apache_status_user: "guest"
    apache_status_password: "guest"
    
    ## NTP
    agent_ntp_servers:
      - "{{ monasca_ip_address }}"
    
    ## System info
    monasca_system_user_name: monasca
    monasca_system_group_name: monasca
    monasca_system_shell: /bin/false
    monasca_system_comment: monasca system user
    monasca_system_user_home: "/var/lib/{{ monasca_system_user_name }}"
    
    monasca_agent_required_pip_packages:
      - virtualenv
      - virtualenv-tools
      - httplib2
    
    # Common pip packages
    monasca_agent_pip_packages:
      - PyMySQL
      - python-neutronclient
      - MySQL-python
      - kafka-python==0.9.2

Dependencies
------------

none

Example Playbook
----------------

    - name: Install Monasca Agent
      hosts: monasca-agent
      user: root
      roles:
        - { role: "os_monasca_agent", tags: [ "os-monasca-agent" ] }
      vars:
        - keystone_ip_address: "{{ groups['devstack'][0] }}"
        - monasca_ip_address: "{{ groups['monasca'][0] }}"

Tested on
---------

Ubuntu 16.04 xenial xerus 

Author Information
------------------
Flávio Ramalho

flaviosr@lsd.ufcg.edu.br

License
-------
Apache
