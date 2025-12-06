def table-into-lists [] {
    let table = $in;
    $table | columns | each {|col| $table | get $col}
}
