#!/usr/bin/env ruby

def ssh_opts
  %Q{ -i ./misc/vagrant_private_key -o "StrictHostKeyChecking no" \
      -o "UserKnownHostsFile /dev/null" \
      -o "PasswordAuthentication yes"}
end

def ssh_cmd
  %Q{ssh #{ssh_opts} -p 3333 testuser@localhost}
end

def ssh_do cmd
  cmd = "#{ssh_cmd} '#{cmd}'"
  puts "running #{cmd}"
  system cmd
end

puts "stop old vm if it is started."
system "VBoxManage controlvm mavericks-test poweroff"

puts "delete old vm if it exists."
system "VBoxManage unregistervm mavericks-test --delete"

puts "import VM..."
system "VBoxManage import ~/Documents/mavericks-base-ssh-enabled.ova"

puts "set up NAT for ssh."
system "VBoxManage modifyvm mavericks-test --natpf1 'guestssh,tcp,,3333,,22'"

puts "start VM."
system "VBoxManage startvm mavericks-test"

puts "Sleep for 10 seconds while VM boots.."
sleep 10

# change the permissions for the vm private key
# required for ssh/scp below
system "chmod 0600 misc/vagrant_private_key"

puts "copy secret key to vm."
system "scp #{ssh_opts} -P 3333 ~/var/secrets/encrypted_data_bag_secret testuser@localhost:~"

puts "get install.sh."
ssh_do "curl -LO https://raw.githubusercontent.com/joelmccracken/dotfiles/master/install.sh"

puts "run install.sh."
ssh_do "bash install.sh"

puts "run chef installer."
ssh_do "cd ~/dotfiles; DOTFILES_TEST=true bin/omnibus-env ./bin/install-chef-standalone.sh"

puts "enable sudo nopassword."
ssh_do "echo testuser | sudo -S dotfiles/bin/toggle-sudo-nopassword on"

puts "run chef bootstrap."
ssh_do "cd dotfiles; echo testuser | sudo -S bash -c \"EDB_SECRET=~/encrypted_data_bag_secret bin/omnibus-env bin/bootstrap.sh\""

puts "run chef."
ssh_do "cd dotfiles; echo testuser | sudo -S bash -c \"EDB_SECRET=~/encrypted_data_bag_secret bin/omnibus-env bin/run-chef.sh\""

puts "disable sudo nopassword."
ssh_do "echo testuser | sudo -S dotfiles/bin/toggle-sudo-nopassword off"
