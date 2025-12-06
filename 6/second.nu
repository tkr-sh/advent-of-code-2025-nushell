source ./utils.nu;

def main [input: string] {
    let lines = open -r $input | lines;

    let fold_result = $lines
    | slice ..-2
    | each {
        split chars
        | enumerate
        | reduce --fold {} { |it, acc| $acc | insert ($it.index | into string) $it.item }
    }
    | table-into-lists
    | reduce --fold { total: [], curr: [] } {|it, acc|
        if ($it | all { $in == ' ' }) {
            $acc
            | update total { append [$acc.curr] }
            | update curr []
        } else {
            $acc
            | update curr {
                $acc.curr 
                | append [($it | where { $in != ' '} | str join)]
            }
        }
    };

    let group_of_numbers = $fold_result.total | append [$fold_result.curr];

    $group_of_numbers
    | enumerate
    | each {|numbers_indexed|
        nu -c (
            $numbers_indexed.item
            | str join (
                " " +
                (
                    $lines
                    | last
                    | str trim
                    | split row -r '\s+'
                    | get $numbers_indexed.index
                ) +
                " "
            )
        )
        | into int
    }
    | math sum
}
