source ./utils.nu;

def main [input: string] {
    let lines = open -r $input | lines;
    let operators = $lines
    | last
    | str trim
    | split row -r '\s+';

    $lines
    | slice ..-2
    | each {
        split chars
        | enumerate
        | reduce --fold {} { |it, acc| $acc | insert ($it.index | into string) $it.item }
    }
    | table-into-lists
    | split list {$in | all { $in == ' ' }}
    | enumerate
    | each {|numbers_indexed|
        nu -c (
            $numbers_indexed.item
            | each { str join}
            | str join $" ($operators | get $numbers_indexed.index) "
        )
        | into int
    }
    | math sum
}
