def main [input: string] {
    let ranges = open -r $input
    | lines
    | find '-' -n
    | each {|range|
        let range_as_list = $range | split row '-' | each { str trim | into int };
        {
            start: ($range_as_list | first),
            end:   ($range_as_list | last)
        }
    }
    | sort-by { $in.start };

    let total = $ranges | reduce --fold { ranges: [], curr-range: ($ranges | first) }  {|range, acc|
        if $acc.curr-range.end >= $range.start {
            if $acc.curr-range.end <= $range.end {
                {
                    ranges: $acc.ranges,
                    curr-range: {
                        start: $acc.curr-range.start,
                        end: $range.end,
                    }
                }
            } else {
                $acc
            }
        } else {
            {
                ranges: ($acc.ranges | insert 0 $acc.curr-range),
                curr-range: $range,
            }
        }
    };

    $total.ranges | insert 0 $total.curr-range | each { $in.end - $in.start + 1} | math sum 
}
