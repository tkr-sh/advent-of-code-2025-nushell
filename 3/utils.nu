def find-max [] {
    sort-by -c {|a, b|
        if $a.item == $b.item {
            $a.index < $b.index
        } else {
            $a.item > $b.item
        }
    }
    | first
}
