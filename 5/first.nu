# 643
def main [input: string] {
    let input = open -r $input | lines;
    let ranges = $input | find '-' -n;
    let ranges = $ranges | each {|range|
        let start_end = $range | split row '-' | each { str trim | into int };
        {
            start: ($start_end | get 0),
            end: ($start_end | get 1)
        }
    };
    let ids = $input | where { (($in | str length) > 0) and not ($in | str contains '-') } | each { into int };
    
    $ids | where {|id|
        $ranges | any {|range|
            $range.start <= $id and $range.end >= $id
        }
    } | length
}
