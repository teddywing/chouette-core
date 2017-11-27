module TreeWalker extend self
    MAX_LEVEL = 5
    def walk_tree path, max_level: MAX_LEVEL, level: 0, yield_dirs: :no, &blk
      raise RuntimeError, "too many levels in tree walk, > #{max_level}" if level > max_level
      Dir.glob(File.join(path, '*')) do | file |
        if File.directory?( file )
          blk.(:dir, file) if yield_dirs == :before 
          walk_tree(file, max_level: max_level, level: level.succ, yield_dirs: yield_dirs, &blk)
          blk.(:dir, file) if yield_dirs == :after 
        else
          blk.(:file, file)
        end
      end
    end
end
