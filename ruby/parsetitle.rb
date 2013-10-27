#!/usr/bin/env ruby


#### Packages
require 'json'
require 'net/http'

###### type:
### 0 - seed
### 1 - links
### 2 - backlinks


def parsetitle( titles, type, parentid )

  apiurl='http://en.wikipedia.org/w/api.php'

  ## resulthash
  links=Hash.new

  #### First query, no plcontinue
  query = { 
    'action'=>'query',
    'prop'=>'info',
    'redirects'=>'',
    'inprop'=>'url',
    'format'=>'json',
  }

  ### Separate by type
  case type
    when 0 
    #### seed
    continueterm='incontinue'
    query['titles'] = titles

    when 1   
    #### links
    continueterm='gplcontinue'
    linksterm='links'
    query['generator']=linksterm
    query['titles'] = titles
    query['gplnamespace'] = '0'
    query['gpllimit'] = 'max'
    
    when 2
    #### backlinks
    continueterm='gblcontinue'
    linksterm='backlinks'
    query['gbltitle'] = titles
    query['generator'] = 'backlinks'
    query['gblnamespace'] = '0'
    query['gbllimit'] = 'max'

  else 
    puts "This shouldn't happen."
    exit -1
  end
  # puts query
  # exit;
  

  postData = Net::HTTP.post_form(URI.parse(apiurl), query);
  
  ## parse and save result
  result = JSON.parse(postData.body)
  pages=result["query"]["pages"].keys
  
  result["query"]["pages"].each do |page|
    if page[1]["title"] != nil and page[1]["length"] != nil
      links[page[1]["title"]] = { 
        "length" => page[1]["length"], 
        "url"=>page[1]["fullurl"],
        "pageid"=>page[1]["pageid"],
        "parentid"=>parentid 
      }
    end
  end
  
  ### Keep going?
  while true
    if result["query-continue"] == nil
      ##puts "breaking"
      break
    end
    ##puts "didn't break"    
    
    plcontinue=result["query-continue"][linksterm][continueterm]
    ## puts plcontinue
    query[continueterm] = plcontinue

    postData = Net::HTTP.post_form(URI.parse(apiurl), query);
    result = JSON.parse(postData.body)
    
    pages=result["query"]["pages"].keys

    result["query"]["pages"].each do |page|
      if page[1]["title"] != nil and page[1]["length"] != nil
      links[page[1]["title"]] = { 
        "length" => page[1]["length"], 
        "url"=>page[1]["fullurl"],
        "pageid"=>page[1]["pageid"],
        "parentid"=>parentid 
      }
      end
    end
  end
  
  return links
end
