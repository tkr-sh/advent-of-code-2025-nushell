source ./utils.nu

def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let values = $line
        | split chars
        | each { into int }
        | enumerate;

        0..11 | each { $in } | reverse | reduce --fold { total: 0, index: -1} {|i, acc|
            let digit = find_max (
                after_index
                    (before_index $values (($values | length) - $i))
                    $acc.index  
            )

            {
                total: ($acc.total + $digit.item * 10 ** ($i))
                index: ($digit.index)
            }
        }
    }
    | math sum
}
