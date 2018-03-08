class Export::Base < ActiveRecord::Base
  self.table_name = "exports"

  validates :type, presence: true

  def self.messages_class_name
    "Export::Message"
  end

  def self.resources_class_name
    "Export::Resource"
  end

  def self.human_name
    self.name.demodulize.humanize
  end

  if Rails.env.development?
    def self.force_load_descendants
      path = Rails.root.join 'app/models/export'
      Dir.chdir path do
        Dir['**/*.rb'].each do |src|
          next if src =~ /^base/
          klass_name = "Export::#{src[0..-4].classify}"
          Rails.logger.info "Loading #{klass_name}"
          begin
            klass_name.constantize
          rescue => e
            Rails.logger.info "Failed: #{e.message}"
            nil
          end
        end
      end
    end
  end

  def self.option name, opts
    store_accessor :options, name
    if !!opts[:required]
      validates name, presence: true
    end
    @options ||= {}
    @options[name] = opts
  end

  def self.options
    @options
  end

  include IevInterfaces::Task

  def self.model_name
    ActiveModel::Name.new Export::Base, Export::Base, "Export"
  end

  def self.user_visible_descendants
    descendants.select &:user_visible?
  end

  def self.user_visible?
    true
  end

  private

  def initialize_fields
    super
    self.token_upload = SecureRandom.urlsafe_base64
  end

end
