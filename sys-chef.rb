


system "chef" do
  
  server "chef-server", {
    base: "chef-server"
  }

  server "chef-web-ui", {
    base: "chef-server"
    # install: ["chef:recipe[chef::web-ui]"]
  }
end

