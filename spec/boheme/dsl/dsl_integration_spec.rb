require 'spec_helper'
require 'shared/test_container_factories'

context "Boheme DSL Integration Test" do
  before(:all) do
    @boheme = boheme = Boheme.parse do |root|
      root.driver :docker_cli
      root.name "project"
      root.image "ruby"

      @counter = (@counter || 0) + 1
      if @counter > 5
        raise "FAIL"
      end
      root.infrastructure :mysql do
        image "mysql"
      end

      root.app :app do
        command "bundle && bundle exec rails server"
      end

      root.tests :tests do
        command "bundle && bundle exec rake integration_tests"
      end
    end

    boheme.service_factory = lambda do |boheme|
      Boheme::Containers::EmulatedContainer.new_service(boheme, 0.1)
    end

    boheme.task_factory = lambda do |boheme|
      Boheme::Containers::EmulatedContainer.new_task(boheme, 0.1)
    end

    boheme.interpret.launch!
  end

  let(:boheme) { @boheme }
  let(:containers) { boheme.containers }
  let(:mysql) { boheme.container("project:mysql") }
  let(:app) { boheme.container("project:app") }
  let(:tests) { boheme.container("project:tests") }

  describe "mysql container" do
    it "should use the mysql image" do
      expect(mysql.image).to eql("mysql")
    end

    it "should have $(pwd) mounted to /usr/local/src/project" do
      expect(mysql.mounts).to eql({Dir.pwd => "/usr/local/src/project"})
    end
  end

  describe "app container" do
    it "should use the ruby image" do
      expect(app.image).to eql("ruby")
    end

    it "should have $(pwd) mounted to /usr/local/src/project" do
      expect(app.mounts).to eql({Dir.pwd => "/usr/local/src/project"})
    end

    it "should have the custom app runner command" do
      expect(app.command).to eql("bundle && bundle exec rails server")
    end
  end

  describe "tests containers" do
    it "should use the ruby image" do
      expect(tests.image).to eql("ruby")
    end

    it "should have $(pwd) mounted to /usr/local/src/project" do
      expect(tests.mounts).to eql({Dir.pwd => "/usr/local/src/project"})
    end

    it "should have the custom test runner command" do
      expect(tests.command).to eql("bundle && bundle exec rake integration_tests")
    end
  end
end
