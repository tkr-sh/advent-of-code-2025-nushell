source ./utils.nu;

def main [input: string] {
    let table = open -r $input | lines | each { split chars };
    let table_len = $table | length;

    0..($table_len - 1) | each {|$y|
        0..($table_len - 1) | each {|$x|
            print $"x ($x) ; y ($y)"
            if ($table | get $y | get $x) == '@' {
                ($table | count-close $x $y) <= 4
            } else {
                false
            }
        }
    }
    | flatten
    | where {$in}
    | length
}
