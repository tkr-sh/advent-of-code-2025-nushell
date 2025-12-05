def main [input: string] {
    let input = open -r $input | lines;
    let ranges = $input | find '-' -n;
    let ranges = $ranges | each {|range|
        let start_end = $range | split row '-' | each { str trim | into int };
        {
            start: ($start_end | get 0),
            end: ($start_end | get 1)
        }
    } | sort-by { $in.start };


    let a = $ranges | reduce --fold { ranges: [], curr-range: ($ranges | first) }  {|range, acc|
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
                ranges: ($acc.ranges | append [$acc.curr-range]),
                curr-range: ($range)
            }
        }
    };

    $a.ranges | append [$a.curr-range] | each { $in.end - $in.start + 1} | math sum
}
