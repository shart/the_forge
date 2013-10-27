#!/usr/bin/env ruby

#### Packages
require 'rubygems'
require 'open-uri'

require 'json'
require 'net/http'

#### My own
require './parsetitle'
require './makejson'



##################################
############## Main ##############
##################################

### Where we start
titles='Ruby, Alaska'
if ARGV[0] != nil
  titles=ARGV[0]
end


## Seed
seed = parsetitle( titles, 0, 0 )
sortedseed = seed.sort_by  { | key, value| value["length"] }

## Get the 1st generation links
seedid=seed[seed.keys[0]]["pageid"]


links = parsetitle( titles, 1, seedid)
sortedlinks = links.sort_by  { | key, value| value["length"] }

## Now the 1st generation backlinks
backlinks = parsetitle( titles, 2, seedid )
sortedbacklinks = backlinks.sort_by  { | key, value | value["length"] }

# sortedlinks.each do |title| 
#   print title
#   print "\n"
#   # print " - "
#   # puts links[title]
# end


## Get the intersect
intersect = Hash[links.to_a & backlinks.to_a]
sortedintersect = intersect.sort_by  { | key, value | value["length"] }


# sortedlinks.each do |title| 
#   print " links - "
#   print title
#   print "\n"
# end

# sortedbacklinks.each do |title| 
#   print " backlinks - "
#   print title
#   print "\n"
# end

# sortedintersect.each do |title| 
#   print " intersect - "
#   print title
#   print "\n"
# end

nodes = makejson ( sortedseed.concat(sortedintersect) )
#puts nodes
#nodes = nodes.merge( makejson (sortedintersect) )
#nodes = makejson ( sortedintersect )
puts nodes.to_json
#puts sortedintersect.to_json

