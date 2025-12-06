source ./utils.nu;

def main [input: string] {
    let lines = open -r $input | lines;
    let operators = $lines
    | last
    | str trim
    | split row -r '\s+';

    let fold_result = $lines
    | slice ..-2
    | each {
        split chars
        | enumerate
        | reduce --fold {} { |it, acc| $acc | insert ($it.index | into string) $it.item }
    }
    | table-into-lists
    | reduce --fold { total: [], curr: [] } {|i, acc|
        if ($i | all { $in == ' ' }) {
            $acc
            | update total { append [$acc.curr] }
            | update curr []
        } else {
            $acc
            | update curr {
                $acc.curr 
                | append [($i | where $it != ' ' | str join)]
            }
        }
    };

    $fold_result.total
    | append [$fold_result.curr]
    | enumerate
    | each {|numbers_indexed|
        nu -c (
            $numbers_indexed.item
            | str join $" ($operators | get $numbers_indexed.index) "
        )
        | into int
    }
    | math sum
}
