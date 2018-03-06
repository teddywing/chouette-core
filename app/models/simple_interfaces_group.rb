class SimpleInterfacesGroup
  attr_accessor :name, :shared_options

  def initialize name
    @name = name
    @interfaces = []
    @current_step = 0
  end

  def add_interface interface, name, action, opts={}
    @interfaces.push({interface: interface, name: name, action: action, opts: opts})
  end

  def run
    @interfaces.each do |interface_def|
      interface = interface_def[:interface]
      interface.interfaces_group = self
      interface.send interface_def[:action], interface_def[:opts].reverse_update(shared_options)
      return if interface.status == :error
      @current_step += 1
    end

    print_summary
  end

  def banner width=nil
    width ||= @width
    @width = width

    name = "### #{self.name} ###"
    centered_name = " " * ([width - name.size, 0].max / 2) + name
    banner = [centered_name, ""]
    banner << @interfaces.each_with_index.map do |interface, i|
      if interface[:interface].status.present?
        SimpleInterface.colorize interface[:name], SimpleInterface.status_color(interface[:interface].status)
      elsif i == @current_step
        "☕︎ #{interface[:name]}"
      else
        interface[:name]
      end
    end.join(' > ')
    banner.join("\n")
  end

  def print_summary
    puts "\e[H\e[2J"
    out = [banner]
    out << "-" * @width
    out << ""
    out << SimpleInterface.colorize("=== STATUSES ===", :green)
    out << ""
    @interfaces.each do |i|
      out << "#{i[:name].rjust(@interfaces.map{|i| i[:name].size}.max)}:\t#{SimpleInterface.colorize i[:interface].status, SimpleInterface.status_color(i[:interface].status)}"
    end
    out << ""
    out << SimpleInterface.colorize("=== DEBUG OUTPUTS ===", :green)
    out << ""
    @interfaces.each do |i|
      out << "#{i[:name].rjust(@interfaces.map{|i| i[:name].size}.max)}:\t#{i[:interface].output_filepath}"
    end
    out << ""
    out << ""

    print out.join("\n")
  end
end
