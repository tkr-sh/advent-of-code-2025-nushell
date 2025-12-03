source ./utils.nu

def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let digits = $line
        | split chars
        | each { into int }
        | enumerate;

        0..11
        | each { $in }
        | reverse
        | reduce --fold {total: 0, index: 0} {|i, acc|
            let digit = $digits
            | slice ($acc.index)..(($digits | length) - $i - 1)
            | find-max;

            {
                total: ($acc.total + $digit.item * 10 ** ($i))
                index: ($digit.index + 1)
            }
        }
        | get total
    }
    | math sum
}
