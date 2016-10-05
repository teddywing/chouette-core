module RefobjectsHelper

  def table_builder collection, columns, cls = nil
    return unless collection.present?

    head = content_tag :thead do
      content_tag :tr do
        columns.each do |col|
          concat content_tag(:th, collection.first.respond_to?(col) ? col.to_s.titleize : "Doesn't exist")
        end
      end
    end

    body = content_tag :tbody do
      collection.collect { |item|
        content_tag :tr do
          columns.collect { |col|
            concat content_tag(:td, item.try(col))
          }.to_s.html_safe
        end
      }.join().html_safe
    end

    content_tag :table, head.concat(body), class: cls
  end

end
