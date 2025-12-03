source ./utils.nu

# 16812
def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let values = $line
        | split chars
        | each { into int }
        | enumerate;

        let first_digit = find_max ($values | slice ..-2);
        let second_digit = find_max (after_index $values $first_digit.index)

        $first_digit.item * 10 + $second_digit.item
    }
    | math sum
}
