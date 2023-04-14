<html> 
<p>1.Print the number of items listed on all continents. </p>
&#9;
<Output1>
{
let $items := doc("auction.xml")/site/regions//item
return 
<count>{count($items)}</count>
}
</Output1>
&#10;


<p>2.List the names of items registered in Europe along with their descriptions.</p>
&#9;
<Output2>
{
    for
    $a in doc("auction.xml")/site/regions/europe/item
    return {
    <name>
    {$a/name}
    {$a/description}
    </name>
    }
}
</Output2>
&#10;


<p>3.List the names of persons and the number of items they bought.</p>
&#9;
<Output3>
{
for $person in doc("auction.xml")/site/people//person
let $id := data($person/@id)
for $closed_auction in doc("auction.xml")/site/closed_auctions//closed_auction
return if  ($id= $closed_auction/buyer/@person) then 
{
	<person>&#xa;{$person/name}&#xa;
    {doc("auction.xml")/$closed_auction/quantity/string()}&#xa;</person>,'&#xa;'
}
else
{}
}
</Output3>
&#10;

<p>4.List all persons according to their interest (ie, each interest category, display the persons on that category).</p>
&#9;
<Output4>
{
    for $a in doc("auction.xml")/site/categories/category ,
        $b in doc("auction.xml")//people/person
    where $a/@id = $b/profile/interest/@category
    group by $a/@id
    return {
        ('&#9;',<category>
        {$a/name} 
        &#9;<person> {$b/name}</person>
          </category>,'&#9;')
    }
}  
</Output4>
&#10;

<p>5.Group persons by their categories of interest and output the size of each group.</p>
&#9;
<Output5>
{
    for $a in doc("auction.xml")/site/categories/category ,
        $b in doc("auction.xml")//people/person
    where $a/@id = $b/profile/interest/@category
    group by $a/@id
    return {  
        ('&#9;',<category>
        {$a/name} &#9;
        <count> {count($b)}</count>
          </category>,'&#9;')     
    }
}  
</Output5>
&#10;

<p>6.List the names of persons and the names of the items they bought in Europe.</p>
&#9;
<Output6>
{
for $a in doc("auction.xml")/site/closed_auctions/closed_auction,
    $b in doc("auction.xml")/site/regions/europe/item,
    $c in doc("auction.xml")//people/person
where 
$a/buyer/@person = $c/@id 
and 
$a/itemref/@item= $b/@id
group by
$c/@id
return ({'&#9;',<person>{$c/name}<item>{$b/name}</item></person>,'&#9;'})
}
</Output6>
&#10;

<p>7.Give an alphabetically orderedd list of all items along with their location.</p>
&#9;
<Output7>
{
for $a in doc("auction.xml")/site/regions//item
order by $a/name
return {
    ('&#9;', $a/name, '&#9;',$a/location,'&#9;')
}
}
</Output7>
&#10;

<p>8.List the reserve prices of those open auctions wheree a certain person with id person3 issued a bid before another person with id person6. 
(Here before means listed before in the XML doc , that is, before in doc orderr.)</p>
&#9;
<Output8>
{
for $a in doc("auction.xml")/site/open_auctions/open_auction
where index-of($a/bidder/personref/@person,'person3') < index-of($a/bidder/personref/@person,'person6')
return data($a/reserve)
}
</Output8>
&#10;
</html>