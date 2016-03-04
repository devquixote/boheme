RSpec.shared_context "test container factories" do
  let(:boheme) { Boheme::Instance.new {} }
  before do
    Boheme::Containers.service_factory do
      Boheme::Containers::EmulatedContainer.new_service(boheme, 0.1)
    end

    Boheme::Containers.task_factory do
      Boheme::Containers::EmulatedContainer.new_task(boheme, 0.1)
    end
  end
end
