require_relative "helper"

begin


  @receiver_group={
      "g1" => "sems@domain.com,x@domain.com",
      "g2" => "sems2@domain.com,x@domain.com",
      "default" => "sems2@domain.com,default@test.com"
  }

  @logsource_group={
      "g1" => ["LSGroupName1"],
      "g2" => ["LSGroupName1", "LSGroupName2"],
      ##multiple group names connects by "and"
      "default" => [@default_group]

  }

  #map receiver and log source groups

  logsources.each do |z|


    z<< []

    @logsource_group.keys.each do |lsg|


      s= @logsource_group[lsg]-z[4]
      if s.count==0
        z[-1]+=@receiver_group[lsg].split(",")
      end
    end
    z[-1]=@receiver_group["default"].split(",") if z[-1].count==0
    z[-1]=z[-1].uniq

    @name=z[0]
    @last_event_time=z[3]
    @type=z[2]
    @description=z[1]
    @groups=z[4].join(" , ")
    @status=z[6]
    @eps=z[5]



    renderer = ERB.new(File.read("#{@path}/mail.erb"))
    content= renderer.result.gsub("\'", "\"")


    cmd="(echo 'To: #{z.last.join(',')}'
echo 'From: #{@sender}'
echo 'Subject: #{@subject} #{@name}'
echo 'Content-Type: text/html'
echo;
echo '#{content}' ) | sendmail -t"

    begin
      `#{cmd}`
    rescue
      p "mail error"
    end


  end
rescue => ex
  print ex.message
  print "ERROR #{Time.now} #{ex.backtrace}: #{ex.message} (#{ex.class})"


end

