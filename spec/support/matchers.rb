ChefSpec::Runner.define_runner_method(:ark)

def install_archive(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :install, resource_name)
end

def put_archive(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:ark, :put, resource_name)
end
