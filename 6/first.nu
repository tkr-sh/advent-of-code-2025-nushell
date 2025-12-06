source ./utils.nu;

def main [input: string] {
    open -r $input
    | lines
    | each {
        str trim
        | split row -r '\s+'
        | enumerate
        | reduce --fold {} { |it, acc| $acc | insert ($it.index | into string) $it.item }
    }
    | table-into-lists
    | each {|values|
        nu -c (
            $values
            | slice ..-2
            | str join $" ($values | last) "
        )
        | into int
    }
    | math sum
}
