#!/usr/bin/env ruby

#### Packages
require 'rubygems'
require 'open-uri'

require 'json'
require 'net/http'

#### My own
require './parsetitle'
require './makejson'
<<<<<<< HEAD
=======
require './dumbifyjsonhash'
>>>>>>> ff128337f961ce2c8d1c7273ff20bd093e5188a6



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
<<<<<<< HEAD
sortedseed = seed.sort_by  { | key, value| value["length"] }
=======
sortedseed = seed.sort_by  { | key, value| -value["length"] }
>>>>>>> ff128337f961ce2c8d1c7273ff20bd093e5188a6

## Get the 1st generation links
seedid=seed[seed.keys[0]]["pageid"]


links = parsetitle( titles, 1, seedid)
<<<<<<< HEAD
sortedlinks = links.sort_by  { | key, value| value["length"] }

## Now the 1st generation backlinks
backlinks = parsetitle( titles, 2, seedid )
sortedbacklinks = backlinks.sort_by  { | key, value | value["length"] }
=======
sortedlinks = links.sort_by  { | key, value| -value["length"] }

## Now the 1st generation backlinks
backlinks = parsetitle( titles, 2, seedid )
sortedbacklinks = backlinks.sort_by  { | key, value | -value["length"] }
>>>>>>> ff128337f961ce2c8d1c7273ff20bd093e5188a6

# sortedlinks.each do |title| 
#   print title
#   print "\n"
#   # print " - "
#   # puts links[title]
# end


## Get the intersect
intersect = Hash[links.to_a & backlinks.to_a]
<<<<<<< HEAD
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
=======
sortedintersect = intersect.sort_by  { | key, value | -value["length"] }



################### 2nd generation #####################
max2 = 20  ## Max links followed
linksfollowed=0
secondlevellinks     =Array.new
secondlevelbacklinks =Array.new
secondlevelintersect =Array.new
sortedsecondlevellinks     =Array.new
sortedsecondlevelbacklinks =Array.new
sortedsecondlevelintersect =Array.new

## Combine'em all. At this level, we need no further intersection checks
combohash = sortedseed.concat(sortedintersect)

sortedintersect.each do |node| 
  if linksfollowed >= max2 
    break
  end
  ##puts linksfollowed
  nodeid=node[1]['pageid']
  secondlevellinks[linksfollowed] = parsetitle( node[0], 1, nodeid )
  secondlevelbacklinks[linksfollowed] = parsetitle( node[0], 2, nodeid )
  sortedsecondlevellinks[linksfollowed] = 
    secondlevellinks[linksfollowed].sort_by  { | key, value| -value["length"] }
  sortedsecondlevelbacklinks[linksfollowed] = 
    secondlevelbacklinks[linksfollowed].sort_by  { | key, value| -value["length"] }
  
  ## Intersect
  secondlevelintersect[linksfollowed] = 
    Hash[secondlevellinks[linksfollowed].to_a & secondlevelbacklinks[linksfollowed].to_a]
  sortedsecondlevelintersect[linksfollowed] =
      secondlevelintersect[linksfollowed].sort_by  { | key, value| -value["length"] }

  combohash = combohash.concat(  sortedsecondlevelintersect[linksfollowed] )

  linksfollowed+=1
end


out = makejson ( combohash )
dumbout = dumbifyjsonhash ( out )

puts dumbout.to_json

exit
>>>>>>> ff128337f961ce2c8d1c7273ff20bd093e5188a6

nodes = makejson ( sortedseed.concat(sortedintersect) )
#puts nodes
#nodes = nodes.merge( makejson (sortedintersect) )
#nodes = makejson ( sortedintersect )
puts nodes.to_json
#puts sortedintersect.to_json

