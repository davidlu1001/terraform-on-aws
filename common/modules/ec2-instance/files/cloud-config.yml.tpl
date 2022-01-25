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
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7jymsB4fM6c3jQpVrG/+pwZEIditdShypob8I0o1zjsm8eROS4oriXsTZr1HeYOBRqyLMgR6qbyA3UYMGvVAIEhRp2ChZMn0hwISw5mV51rgeN7P/2GHRj2TfqaMBHlxc0xIOpwRwNNGcORNwZIuVIm6IKtMcSxdrSadi/hqm6BIZ1znA2lDr98uibW+csEcFFhFD9rHlx997mB9rxpFgGpK51dyYegr+MR92BHLU6YRe6vll89OSS3rIQnkoODc/nVRTJEhDfBgejLbKYseJI87ZeU4SXAt6cnZUGXq5YZPqDv9s7UT462YhSFXQ8svj24cJArvZ0nhR0KeFrUIaKtMmsUqRO2NQBxOYWE1RmdMgV/2JkdcUwy+xzZwtvULyUirSdZicc/T9bpGsURVPGJJgTtgCmXer0ILmwEwxxytwi1vA26AVbyVnEWwjW4wKnLZOqqR+CAKvFlhMoWmlHWdxngHCsDMGy0y7dXqYoV82Eqe1CTLGz97PNsaf40evTzH9fKkzFmC5jirNB1NYMsAY19IITEWG1E0Fx+tw+neiMXlU4An6f0LbhqDPqupB2u7BXN+AJk4HM8VOokY92A3aZgX969LjGWYUJUEvLmKvizfKcu5vME1D6yUmKGJrCTH5d2nVRW2l4C9OjIJlw7Hl/IoVjhTOXYvAGr0FBQ== david@adroitcreations.com

# Post scripts or Ansible playbooks
runcmd:
  - echo "Hello World"
