module Boheme::Containers
  class EmulatedContainer < BaseContainer
    attr_accessor :delay
    attr_reader :current_thread
    attr_reader :logs

    def self.new_service(delay=3)
      EmulatedContainer.new(:SERVICE, delay)
    end

    def self.new_task(delay=3)
      EmulatedContainer.new(:TASK, delay)
    end

    def initialize(type, delay=3)
      super(type)
      @delay = delay
      @logs = []
    end

    def launch!
      @status = :LAUNCHED
      @logs << "#{name} LAUNCHED"
      @current_thread = Thread.new do
        sleep(delay)
        if (service?)
          @status = :READY
          @logs << "#{name} READY"
        else
          @status = :EXECUTING
          @logs << "#{name} EXECUTING"
          sleep(delay)
          @status = :FINISHING
          @logs << "#{name} FINISHING"
          sleep(delay/2)
          @status = :FINISHED
          @logs << "#{name} FINISHED"
        end
      end
    end

    def tear_down!
      Thread.kill @current_thread if @current_thread
      @status = :FINISHING
      @logs << "#{name} FINISHING"
      @current_thread = Thread.new do
        sleep(delay)
        @status = :FINISHED
        @logs << "#{name} FINISHED"
      end
    end

    def logs
      @logs.join("\n")
    end

    def fail!
      Thread.kill @current_thread if @current_thread
      @status = :FAILED
      @logs << "#{name} FAILED"
    end
  end
end
