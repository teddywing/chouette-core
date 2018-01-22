RSpec::Matchers.define :match_actions_links_snapshot do |name|
  match do |actual|
    @content = Capybara::Node::Simple.new(rendered).find('.page_header').native.inner_html
    expect(@content).to match_snapshot(name)
  end

  failure_message do |actual|
    out = ["Snapshots did not match."]
    expected = File.read(File.dirname(method_missing(:class).metadata[:file_path]) + "/__snapshots__/#{name}.snap")
    out << "Expected: #{expected}"
    out << "Actual: #{@content}"
    out << "\n\n --- DIFF ---"
    out << differ.diff_as_string(@content, expected)
    out.join("\n")
  end

  def differ
    RSpec::Support::Differ.new(
        :object_preparer => lambda { |object| RSpec::Matchers::Composable.surface_descriptions_in(object) },
        :color => RSpec::Matchers.configuration.color?
    )
  end
end
