require 'logger'
require 'time'

module Boheme
  class Runner
    attr_reader :path, :options, :log, :dsl_files

    def initialize(path, options)
      @path = path
      @options = options
      @log = Logger.new(STDOUT)
    end

    def run!
      collect_dsl_files
      load_source_files
      setup_factories
      launch_instances!
      while any_instances_running? do
        sleep(0.2)
        update_instances
      end
      log.info "All instances finished"
      dump_logs
    end

    private

    def collect_dsl_files
      log.info "Collecting DSL files at #{path}"
      if File.directory? path
        @dsl_files = []
        Find.find(path).each do |file_path|
          if file_path =~ /\.boheme$/
            @dsl_files << file_path
          end
        end
      else
        @dsl_files = [path]
      end
      log.info("Found #{@dsl_files.size} files")
      @dsl_files
    end

    def load_source_files
      @dsl_files.each do |file|
        log.info "Loading #{file}"
        load file
        Boheme.instances.last.path = file
      end
    end

    def setup_factories
      # TODO only make this emulated if we have an emulated flag
      Boheme.instances.each do |instance|
        log.info "Setting up service/task factories for #{instance.path}"
        instance.service_factory = lambda do |instance|
          Boheme::Containers::EmulatedContainer.new_service(instance)
        end

        instance.task_factory = lambda do |instance|
          Boheme::Containers::EmulatedContainer.new_task(instance)
        end
      end
    end

    def launch_instances!
      Boheme.instances.each do |instance|
        log.info "Executing #{instance.path}"
        instance.interpret.launch!
      end
    end

    def any_instances_running?
      return false if Boheme.instances.empty?
      Boheme.instances.select{|i| i.fully_running?}.size > 0
    end

    def update_instances
      Boheme.instances.each do |instance|
        log.debug "Updating #{instance.path}"
        instance.update_status
      end
    end

    # TODO Make containers return these
    LogEntry = Struct.new(:time, :entry)

    def dump_logs
      # TODO switch to make stdout conditional based on CLI flag

      Boheme.instances.each do |instance|
        log.info "Dumping logs for #{instance.path}"
        log_entries = []
        instance.containers.each do |container|
          container.get_logs.each { |log_entry| log_entries << log_entry }
        end
        log_entries = log_entries.sort{|a, b| a.time <=> b.time}
        log_entries.each do |log_entry|
          puts "    #{log_entry.time} - #{log_entry.name} - #{log_entry.entry}"
        end
      end
    end
  end
end
