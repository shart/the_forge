require 'json'

def makejson( list)
  ## provide functionality for node weights, link weights
  nw=1
  lw=1

  nodes = Hash.new
  links = Hash.new
  l=0
  list.each do | node |
    id=node[1]['pageid']
    nodes[id] = { 
      "title" => node[0],
      "url"=>node[1]['url'],
      "nweight"=>nw
    }
    links[l] = {
      "source" => node[1]['parentid'],
      "target" => node[1]['pageid'],
      "lweight" => lw
    }
    l=l+1
  end
  
  jsonhash= { "nodes"=>nodes, "links"=>links }
  return jsonhash
  #return nodes
end

