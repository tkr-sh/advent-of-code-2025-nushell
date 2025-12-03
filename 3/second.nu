source ./utils.nu

def main [input: string] {
    open -r $input
    | lines
    | each {|line|
        let values = $line
        | split chars
        | each { into int }
        | enumerate;

        0..11
        | each { $in }
        | reverse
        | reduce --fold { total: 0, index: -1} {|i, acc|
            let digit = $values
           | before-index (($values | length) - $i)
           | after-index $acc.index  
           | find-max;

           {
               total: ($acc.total + $digit.item * 10 ** ($i))
               index: ($digit.index)
           }
        }
        | get total
    }
    | math sum
}
