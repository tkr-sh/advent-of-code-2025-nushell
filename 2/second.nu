def main [input: string] {
    open -r $input | 
        split row ',' |
        each {|range_str|
            let range = $range_str | split row '-' | each { into int };

            (($range | first)..($range | last)) | filter {|n|
                if $n < 10 {
                    return false
                }

                # let stringified = $n | into string;
                mut cp_n = $n;
                mut len = 0;
                while $cp_n > 0 {
                    $cp_n = $cp_n // 10;
                    $len += 1;
                }
                # let len = ($stringified | str length);
                # print $len
                let len = $len;

                (1..($len // 2)) 
                    | each { $in } # weird hack
                    | any {|$i|
                        if $len mod $i != 0 {
                            return false
                        }

                        mut m = $n;
                        let div = 10 ** $i;
                        let first = $n mod $div;


                        # print $"))) ($i)"
                        # print $m;
                        # print $first;
                        # print $div;

                        while $m > 0 {
                            # print $m;
                            if $m mod $div != $first {
                                return false
                            }

                            $m = $m // $div;
                        }

                        # print tada;

                        true
                    }
            } | each { print $in; $in}
        }
        | flatten
        | math sum
}
