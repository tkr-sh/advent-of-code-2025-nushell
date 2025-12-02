# It takes many minutes, but I'm not here for speed :p
def main [input: string] {
    open -r $input
    | split row ','
    | each {|range_str|
        let range = $range_str | split row '-' | each { into int };

        (($range | first)..($range | last)) | filter {|n|
            if $n < 10 { return false }

            let str = $n | into string;
            let len = $str | str length;

            (1..($len // 2)) 
            | each { $in } # weird hack
            | any {|$i|
                (
                    $str
                    | split chars
                    | window $i --stride $i --remainder
                    | uniq
                    | length
                ) == 1
            }
        }
    }
    | flatten
    | math sum
}
