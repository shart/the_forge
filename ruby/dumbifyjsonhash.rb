require 'json'

def dumbifyjsonhash ( hash )
  newnodes = Array.new
  newlinks = Array.new

  dictionary= Hash.new
  ## Stupid translation from ids to indices cause the javascript can't handle my data :-/
  i=0
  hash['nodes'].each do |entry|
    if ( dictionary[entry[0]]== nil ) ## don't know this node yet
      dictionary[entry[0]]=i
      newnodes[i] = entry[1]
      i=i+1
    else 
      ## already know this node, do nothing
    end
  end

  i=0
  hash['links'].each do |entry|
    
    source = entry[1]['source']
    target = entry[1]['target']
    lw=entry[1]['lweight']
    if source==0
      next  ## skip seed
    end
    newsource = dictionary[source]
    newtarget = dictionary[target]

    newlinks[i]= {
      "source" => newsource,
      "target" => newtarget,
      "lweight" => lw
    }
    i=i+1
  end

  # puts dictionary
  # puts newnodes

  newhash = {
    'nodes'=>newnodes,
    'links'=>newlinks
  }

  return newhash
end


