require 'spec_helper'

context "Boheme DSL Integration Test" do
  before(:all) do
    @boheme = boheme = Boheme.parse do |boheme|
      boheme.driver :docker_cli
      boheme.name "project"
      boheme.image "ruby"

      @counter = (@counter || 0) + 1
      if @counter > 5
        raise "FAIL"
      end
      boheme.infrastructure :mysql do
        image "mysql"
      end

      boheme.app :app do
        command "bundle && bundle exec rails server"
      end

      boheme.tests :tests do
        command "bundle && bundle exec rake integration_tests"
      end
    end

    Boheme::Containers.service_factory do
      Boheme::Containers::EmulatedContainer.new_service(boheme, 0.1)
    end

    Boheme::Containers.task_factory do
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
