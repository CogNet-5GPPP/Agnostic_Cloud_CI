os_monasca_ui
=============

Configures the Monasca Monitoring dashboard on OpenStack Horizon.

Requirements
------------

none

Role Variables
--------------

    ## Monasca
    monasca_ui_git_repo: "https://git.openstack.org/openstack/monasca-ui.git"
    monasca_git_branch: "master"
   
    ## Horizon
    # dashboard directory
    horizon_dir: "/opt/stack/horizon/openstack_dashboard"
   
     ## Grafana
    grafana_ip_address: "127.0.0.1"
    
    ## System
    monasca_ui_required_pip_packages:
      - python-monascaclient

Dependencies
------------

none

Example Playbook
----------------
 
    - name: Deploy monasca-ui on Horizon
      hosts: devstack
      user: root
      roles:
        - { role: "os_monasca_ui", tags: [ "os-monasca-ui" ] }
      vars:
        - grafana_ip_address: "{{ groups['monasca'][0] }}"

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
