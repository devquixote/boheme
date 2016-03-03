RSpec.shared_context "mocked container factories" do
  def stub_interface_of(obj)
    methods = Boheme::Containers::BaseContainer.instance_methods - Object.instance_methods
    methods.each do |method|
      allow(obj).to receive(method)
    end
  end

  before do
    Boheme::Containers.service_factory do
      double(Boheme::Containers::BaseContainer).tap do |service|
        stub_interface_of service
        allow(service).to receive(:type).and_return(:SERVICE)
        allow(service).to receive(:service?).and_return(true)
        allow(service).to receive(:task?).and_return(false)
      end
    end

    Boheme::Containers.task_factory do
      double(Boheme::Containers::BaseContainer).tap do |task|
        stub_interface_of task
        allow(task).to receive(:type).and_return(:TASK)
        allow(task).to receive(:service?).and_return(false)
        allow(task).to receive(:task?).and_return(true)
      end
    end
  end
end
