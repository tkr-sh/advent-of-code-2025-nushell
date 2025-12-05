# 643
def main [input: string] {
    let input = open -r $input | lines;
    let ranges = $input | find '-' -n
    | each {|range|
        let range_as_list = $range | split row '-' | each { str trim | into int };
        {
            start: ($range_as_list | first),
            end:   ($range_as_list | last)
        }
    };

    let ids = $input
    | where { (($in | str length) > 0) and not ($in | str contains '-') }
    | each { into int };
    
    $ids
    | where {|id|
        $ranges | any {|range| $range.start <= $id and $range.end >= $id }
    }
    | length
}
