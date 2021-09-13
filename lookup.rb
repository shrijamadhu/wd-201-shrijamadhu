def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  y=[]
  dns_raw.each do|x|
    if x[0].include?("A") || x[0].include?("C")
       y.push(x.strip.split(","))
    end
  end
  h3 = Hash[y.map {|key, value1,value2| [value1.strip ,{:type=>key.strip,:target=>value2.strip}]}]
end

def resolve(dns_records,lookup_chain,domain)
  record= dns_records[domain]
  if (!record)
    y= "Error: Record not found for #{domain}"
    lookup_chain =[y]
    return lookup_chain
  elsif record[:type] == "CNAME"
    lookup_chain<<record[:target]
    resolve(dns_records,lookup_chain,record[:target])
  elsif record[:type] == "A"
    return lookup_chain<<record[:target]
  end
end


# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
#puts dns_records
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
