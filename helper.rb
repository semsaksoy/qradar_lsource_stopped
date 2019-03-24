require 'rubygems'
require 'rubygems/gem_runner'
require 'rubygems/exceptions'
require 'net/http'
require "json"
require "time"
require 'openssl'
require "erb"
require "uri"
require 'date'
require 'net/smtp'

##config

@path=File.dirname(__FILE__)

@sender="My Qradar <qradar@q.qr>"
@subject="Log Source Stopped"
@ignore_group="Rare"
@default_group="Other"
@time_limit=12 #hours

#config


def logsources

  ls=[]
  query1= 'sudo psql -P pager=off -t -Aq -F \';\' -U qradar -c "select  sensordevice.id,devicename, hostname, devicetypedescription,timestamp_last_seen,eps60s
from sensordevice INNER JOIN sensordevicetype ON sensordevice.devicetypeid=sensordevicetype.id
where deviceenabled=\'t\' and sourcecomponentid is null AND devicetypeid<>246 order by devicename"'

  query2='sudo psql -P pager=off -t -Aq -F \';\' -U qradar -c "select sensordevice.id,fgroup.name
from sensordevice join fgroup_link on cast (fgroup_link.item_id as int) = sensordevice.id
join fgroup on fgroup_link.fgroup_id = fgroup.id where fgroup.type_id = 1;"'


  lines= `#{query1}`
  groups=`#{query2}`

  lines="" if lines.nil?
  groups=[@default_group] if groups.nil?
  lines=lines.split("\n")
  groups=groups.split("\n").map { |s| s.strip.split(";") }




  lines.each do |l|

    c=l.split(";")

    g=groups.select { |gl| gl.first==c[0] }.map { |gl| gl.last.strip }.sort


    l_event=DateTime.strptime(c[4].strip, '%Q')


    if c[4].strip=="0" &&!(g.include? @ignore_group)

      status="Unknown"
      l_ef="-"
      ls<< ["#{c[1].strip}", "#{c[2].strip}", "#{c[3].strip}", "#{l_ef}", g, "#{c[5].strip}", "#{status.strip}"]
    elsif (DateTime.now-l_event)*24 >= @time_limit && !(g.include? @ignore_group)
      status="Error"
      l_ef= l_event.strftime('%d.%m.%Y %T')
      ls<< ["#{c[1].strip}", "#{c[2].strip}", "#{c[3].strip}", "#{l_ef}", g, "#{c[5].strip}", "#{status.strip}"]

    end

  end
  ls
end





