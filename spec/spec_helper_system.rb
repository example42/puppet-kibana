require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'
require 'tempfile'
FIXTURE_DIR = File.join(File.expand_path(File.dirname(__FILE__)), "fixtures") unless defined?(FIXTURE_DIR)

module LocalHelpers
  include RSpecSystem::Util
  def fixture_read(file)
    File.read(File.join(FIXTURE_DIR, file))
  end
end

include RSpecSystemPuppet::Helpers

RSpec.configure do |c|
  # Project root for the firewall code
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour in Jenkins
  c.tty = true

  # Include in our local helpers
  c.include ::LocalHelpers

  # Puppet helpers
  c.include RSpecSystemPuppet::Helpers
  c.extend RSpecSystemPuppet::Helpers

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet
    puppet_install

    # Copy this module into the module path of the test node
    puppet_module_install(:source => proj_root, :module_name => 'kibana')
    shell('puppet module install puppetlabs/stdlib')

    file = Tempfile.new('foo')
    begin
      file.write(<<-EOS)
---
:logger: noop
      EOS
      file.close
      rcp(:sp => file.path, :dp => '/etc/puppet/hiera.yaml')
    ensure
      file.unlink
    end
  end
end
