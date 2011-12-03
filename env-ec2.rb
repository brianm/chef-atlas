
natty_useast_i386_ebs = "ami-e358958a"

# http://wiki.opscode.com/display/RUS/Bootstrap+Chef+RubyGems+Installation

run_chef_solo = <<EOS 
  exec:sudo chef-solo \
    -c /etc/chef/solo.rb \
    -j /etc/chef/solo-node.json \
    -r http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz
EOS

dir = File.dirname __FILE__

environment "ec2" do

  listener com.ning.atlas.aws.AWSConfigurator, {
    ssh_ubuntu: "ubuntu@default",
  }

  provisioner "ec2", com.ning.atlas.aws.EC2Provisioner

  installer "apt", com.ning.atlas.packages.AptInstaller
  installer "gem", com.ning.atlas.packages.GemInstaller
  installer "file", com.ning.atlas.files.FileInstaller
  installer "erb", com.ning.atlas.files.ERBFileInstaller
  installer "script", com.ning.atlas.files.ScriptInstaller
  installer "exec", com.ning.atlas.ExecInstaller

  base "chef-client", {
    provisioner: "ec2:#{natty_useast_i386_ebs}?instance_type=m1.small",
    init: ["apt:ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert",
           "script:#{dir}/src/install_rubygems.sh",
           "gem:chef ohai",
           "exec:sudo mkdir /etc/chef",
           "file:#{dir}/src/solo.rb > /etc/chef/solo.rb",
           "erb:#{dir}/src/client_node.json.erb > /etc/chef/solo-node.json",
           run_chef_solo]
  }

  base "chef-server", {
    inherit: "chef-client",
    init: ["file:#{dir}/src/server_node.json > /etc/chef/solo-node.json",
           run_chef_solo]
  }
end
