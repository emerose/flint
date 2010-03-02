helpers do
  def get_status(x)
    if x.to_i >= 1
      "pass"
    elsif x.to_i < 1
      "fail"
    else
      "unknown"
    end
  end
  
  def classify(str)
    str.gsub(/[-\s]/, '_').downcase
  end
  
  def user_is_admin
    u = User[session[:user]]
    u and u.is_admin?
  end
  
  def look_up_by_name(name)
    ## I feel kinda sick.
    xlate = {"www" => "http"}
    blurb = Flint::ProtocolBlurb.find(:name => name).first
    blurb ||= Flint::ProtocolBlurb.find(:name => xlate[name]).first
  end
  
  def translate(proto)
    xlate = {"www" => "http"}
    xlate[proto] || proto
  end


  def letter_grade(gr)
    if gr >= 90
      "a"
    elsif gr >= 80
      "b"
    elsif gr >= 70
      "c"
    elsif gr >= 60
      "d"
    else
      "f"
    end
  end

  def grade_firewall(sha)
    passes = Flint::TestResult.find(:sha => sha, :result => "pass").size
    fails = Flint::TestResult.find(:sha => sha, :result => "fail").size
    warns = Flint::TestResult.find(:sha => sha, :result => "warn").size
    notices = Flint::TestResult.find(:sha => sha, :result => "note").size
    
    total = passes + fails + warns + notices
    grade = ( ( passes + warns + notices ).to_f / total ) * 100
    return [ letter_grade(grade).upcase, { :pass => passes, :fail => fails,
              :warn => warns, :notice => notices } ]
  end

  def service_paths(ini, outi, name)
    Flint::ServicePath.find(:sha => @current_sha,
                            :in_interface_name => ini,
                            :out_interface_name => outi,
                            :protocol_name => name ).all
  end

  def sorted_interface_pairs_for_protocol_map(pmap)
    pmap.interface_pairs.sort { |a,b|
      ainr = @current_firewall.interface_realm(a[0])
      binr = @current_firewall.interface_realm(b[0])
      ainr ||= "z"
      binr ||= "z"
      binr.to_s <=> ainr.to_s
    }
  end
     
  def collect_lines_from_service_paths(spaths)
    lines = []
    spaths.each do |path|
      lines.concat(path.lines.all)
    end
    
    lines.uniq.sort do |a,b|
      a.to_i <=> b.to_i
    end.map do |lno|
      @current_firewall.line_at(lno)
    end.compact
  end

      
      

end
