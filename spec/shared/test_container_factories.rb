RSpec.shared_context "test container factories" do
  before do
    Boheme::Containers.service_factory do
      Boheme::Containers::EmulatedContainer.new_service
    end

    Boheme::Containers.task_factory do
      Boheme::Containers::EmulatedContainer.new_task
    end
  end
end
