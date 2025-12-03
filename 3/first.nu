source ./utils.nu

def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let values = $line
        | split chars
        | each { into int }
        | enumerate;

        let first_digit = $values | slice ..-2 | find-max;
        let second_digit = $values | slice ($first_digit.index + 1).. | find-max;

        $first_digit.item * 10 + $second_digit.item
    }
    | math sum
}
