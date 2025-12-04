source ./utils.nu;

def main [input: string] {
    mut table = open -r $input | lines | each { split chars };
    let table_len = $table | length;

    mut total = 0;
    mut previous_total = -1;
    while $previous_total != $total {
        $previous_total = $total;
        let removed = $table | remove-rolls;

        print $total

        $total = $total + $removed.removed_len;
        $table = $removed.new_table;
    }

    $total
}

def remove-rolls [] {
    let table = $in;
    let table_len = $table | length;

    let to_remove = 0..($table_len - 1) | each {|$y|
        0..($table_len - 1) | each {|$x|
            if ($table | get $y | get $x) == '@' and ($table | count-close $x $y) <= 4 {
                { x: $x y: $y}
            } else {
                null
            }
        }
    }
    | flatten
    | where { $in != null };

    {
        removed_len: ($to_remove | length),
        new_table: ($to_remove | reduce --fold $table {|it, acc| $acc | set-xy $it.x $it.y}),
    }

}

def set-xy [x: number, y: number] {
    let table = $in;
    $table | update $y ($table | get $y | update $x '.')
}
