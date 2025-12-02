def main [input: string] {
    open -r $input
    | split row ','
    | each {|range_str|
        let range = $range_str | split row '-' | each { into int };

        (($range | first)..($range | last)) | filter {|i|
            let str = $i | into string;
            let len = $stringified | str length;

            (
                $len mod 2 == 0 and
                    ($str | str substring (0..($len // 2 - 1))) ==
                    ($str | str substring (($len // 2)..$len))
            )
        }
    }
    | flatten
    | math sum
}
