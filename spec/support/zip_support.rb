module ZipSupport

  module Helper extend self
    MAX_LEVEL = 5
    def remove_dir_tree path, level: 0
      raise RuntimeError, "too many levels in tree, > #{MAX_LEVEL}" if level > MAX_LEVEL

      Dir.glob(path) do | file |
        if File.directory? file
          remove_dir_tree(File.join(file, '*'), level: level.succ)
          Dir.unlink(file)
        else
          File.unlink(file)
        end
      end
    end
  end

  def zip_fixtures_path(file_name)
    fixtures_path(File.join('zip', file_name))
  end

  def clear_all_zip_fixtures! relpath = '*'
    raise ArgumentError, 'up dir not allowed (..)' if %r{\.\.} === relpath
    Helper.remove_dir_tree zip_fixtures_path(relpath)
  end
end

RSpec.configure do |conf|
  conf.include ZipSupport, type: :zip
end

