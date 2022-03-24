#cloud-config
bootcmd:
 - cloud-init-per instance my_set_hostname sh -xc "echo ${prefix}-$${INSTANCE_ID##i-} > /etc/hostname; hostname -F /etc/hostname"
 - cloud-init-per instance my_etc_hosts sh -xc "sed -i -e '/^127.0.1.1/d' /etc/hosts; echo 127.0.1.1 ${prefix}-$${INSTANCE_ID##i-}.${domain} ${prefix}-$${INSTANCE_ID##i-} >> /etc/hosts"

preserve_hostname: true
manage_etc_hosts: false

package_update: false
package_upgrade: false
package_reboot_if_required: false

ssh_authorized_keys:
  - ssh-rsa ***

# Post scripts or Ansible playbooks
runcmd:
  - sudo yum install mysql telnet -y
