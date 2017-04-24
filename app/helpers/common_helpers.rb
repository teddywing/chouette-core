
module CommonHelpers
  # TODO: Needs refactoring, but does not seem to be under test
  # so let us refactor this **after** test coverage.
  def access_links_pairs(access_links)
    hpairs = Hash.new
    pairs = Array.new
    access_links.each do |link|
      key = pair_key(link)
      pair = nil
      if (hpairs.has_key? key)
        pair = hpairs[key]
      else
        pair = AccessLinkPair.new
        pairs << pair
        hpairs[key] = pair
      end
      if (link.link_orientation_type == "access_point_to_stop_area")
        pair.from_access_point = link
      else
        pair.to_access_point = link
      end
    end
    pairs
  end
end
