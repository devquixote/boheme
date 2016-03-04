module Boheme::Containers
  class EmulatedContainer < BaseContainer
    attr_accessor :delay
    attr_reader :current_thread

    def self.new_service(boheme, delay=3)
      EmulatedContainer.new(boheme, :SERVICE, delay)
    end

    def self.new_task(boheme, delay=3)
      EmulatedContainer.new(boheme, :TASK, delay)
    end

    def initialize(boheme, type, delay=3)
      super(boheme, type)
      @delay = delay
      @logs = []
    end

    def launch!
      log "Entering NEW"
      enter :LAUNCHED
      @last_update = Time.now
    end


    def update_status
      if dependencies_ready?
        if Time.now - @last_update > delay
          if status == :FINISHING
            enter :SUCCESSFUL
          elsif type == :SERVICE
            enter next_service_status
          elsif type == :TASK
            enter next_task_status
          else
            raise "Unknown task type: #{type}"
          end
        end
      else
        log "Waiting on dependencies"
      end
    end

    def log(msg)
      @logs << LogEntry.new(Time.now, name, msg)
    end

    def next_service_status
      case @status
      when :NEW
        :LAUNCHED
      else
        :READY
      end
    end

    def next_task_status
      case @status
      when :NEW
        :LAUNCHED
      when :LAUNCHED
        :EXECUTING
      when :EXECUTING
        :FINISHING
      when :FINISHING
        :SUCCESSFUL
      else
        raise "Unknown status #{@status}"
      end
    end

    def enter(status)
      if status != @status
        @status = status
        log "Entering #{status}"
      end
      @status
    end

    def tear_down!
      enter :FINISHING
    end

    def get_logs
      @logs
    end

    def fail!
      enter :FAILED
    end
  end
end
