def find_max [in_table: table] {
    $in_table
    | sort-by -c {|a, b|
        if $a.item == $b.item {
            $a.index < $b.index
        } else {
            $a.item > $b.item
        }
    }
    | first
}

def after_index [$in_table: table, index: number] {
    $in_table
    | filter {$in.index > $index }
}

def before_index [$in_table: table, index: number] {
    $in_table
    | filter {$in.index < $index }
}
