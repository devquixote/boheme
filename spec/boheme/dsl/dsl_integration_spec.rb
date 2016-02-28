require 'spec_helper'

context "Boheme DSL Integration Test" do
  before do
    Boheme::Containers.service_factory do
      Boheme::Containers::EmulatedContainer.new_service
    end

    Boheme::Containers.task_factory do
      Boheme::Containers::EmulatedContainer.new_task
    end
  end

  let(:boheme) do
    Boheme.parse do |boheme|
      boheme.driver :docker_cli
      boheme.name "project"
      boheme.image "ruby"

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
  end
  let(:containers) { boheme.launch! }
  let(:mysql) { containers.detect{|c| c.name == "project:mysql"} }
  let(:app) { containers.detect{|c| c.name == "project:app"} }
  let(:tests) { containers.detect{|c| c.name == "project:tests"} }

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
