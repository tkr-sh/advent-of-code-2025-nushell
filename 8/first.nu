def main [input: string] {
    let coordinates = open -r $input
    | lines
    | each { split row ',' | each { into int } };

    let top_pairs = $coordinates 
    | enumerate 
    | each {|i|
        $coordinates 
        | enumerate 
        | skip ($i.index + 1)
        | each {|j|
            {
                indexes: [$i.index $j.index]
                distance: (distance $i.item $j.item)
            }
        }
    }
    | flatten
    | sort-by distance
    | take 1000;

    
    $top_pairs 
    | reduce --fold [] {|i, acc|
        let matching = $acc | enumerate | where { ($i.indexes | first) in $in.item or ($i.indexes | last) in $in.item };
        match ($matching | length) {
            0 => {
                $acc | append [$i.indexes]
            }
            1 => {
                $acc | update ($matching.index | first) {
                    $in | append $i.indexes | uniq}
            }
            2 => {
                $acc
                | enumerate
                | where { $in.index not-in $matching.index }
                | each { $in.item }
                | append [
                    (($acc | get ($matching.index | first))
                    | append ($acc | get ($matching.index | last)))
                ]
            }
            _ => { print 'error' }
        }
    }
    | sort-by { length }
}

def distance [a: any, b: any] {
    (
        (($a | get 0) - ($b | get 0)) ** 2 +
        (($a | get 1) - ($b | get 1)) ** 2 +
        (($a | get 2) - ($b | get 2)) ** 2
    ) | math sqrt
}
