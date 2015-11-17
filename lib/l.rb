module L
  def self.init(rid, logger = nil)
    RequestStore.store[:logger] = logger || Rails.logger
    now = Time.zone.now.to_f
    RequestStore.store[:started] = now
    RequestStore.store[:last_timestamp] = now
    RequestStore.store[:rid] = rid
  end

  def self.rid
    RequestStore.store[:rid]
  end

  def self.i(msg, *args)
    tags = []
    args.each do |arg|
      if arg.is_a? String
        tags << arg
      end
      if arg.is_a? Hash
        tags += transform_hash(arg)
      end
    end

    if tags.length > 0
      tags = "[#{tags.join("] [")}] "
    else
      tags = nil
    end
    logger.info "#{tags}#{msg}"
  end

  def self.local_delta(now)
    from_last = now - RequestStore.store[:last_timestamp]
    RequestStore.store[:last_timestamp] = now
    format(from_last)
  end

  def self.req_delta(now)
    format(now - RequestStore.store[:started])
  end

  def self.transform_hash(hash)
    res = []
    hash.each do |k,v|
      res << "#{k}=#{v}"
    end
    res
  end

  def self.format(num)
    sprintf('%.4f', num)
  end

  def self.logger
    RequestStore.store[:logger]
  end
end
