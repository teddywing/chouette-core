module SimpleInterfacesHelper
  def self.run_interface_controlling_interruption interface, method, args
    begin
      interface.send(method, verbose: true)
    rescue Interrupt
      interface.write_output_to_csv
      raise
    ensure
    end
  end
end
