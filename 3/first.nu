source ./utils.nu

def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let digits = $line
        | split chars
        | each { into int }
        | enumerate;

        let first_digit = $digits | slice ..-2 | find-max;
        let second_digit = $digits | slice ($first_digit.index + 1).. | find-max;

        $first_digit.item * 10 + $second_digit.item
    }
    | math sum
}
