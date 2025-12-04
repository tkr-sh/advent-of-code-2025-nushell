def count-close [x: number, y: number] {
    let table = $in;
    let len = $table | length;

    -1..1 | each {|yd|
        let yi = ($y + $yd)
        if $yi < 0 or $yi == $len {
            return 0
        }

        -1..1 | each {|xd|
            let xi = ($x + $xd)
            if $xi < 0 or $xi == $len {
                return 0
            }

            (($table | get $yi | get $xi) == '@') | into int
        }
    }
    | flatten
    | math sum
}
