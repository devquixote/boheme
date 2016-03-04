RSpec.shared_context "test container factories" do
  let(:service_factory) do
    lambda do |boheme|
      Boheme::Containers::EmulatedContainer.new_service(boheme, 0.1)
    end
  end

  let(:task_factory) do
    lambda do |boheme|
      Boheme::Containers::EmulatedContainer.new_task(boheme, 0.1)
    end
  end

  before do
    boheme.service_factory = service_factory
    boheme.task_factory = task_factory
  end
end
