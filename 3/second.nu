source ./utils.nu

def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let digits = $line
        | split chars
        | each { into int }
        | enumerate;

        -11..0 | reduce --fold {total: 0, index: 0} {|i, acc|
            let digit = $digits
            | slice $acc.index..($i - 1)
            | find-max;

            {
                total: ($acc.total + $digit.item * 10 ** ($i * -1))
                index: ($digit.index + 1)
            }
        }
        | get total
    }
    | math sum
}
