def main [input: string] {
    let lines = open -r $input 
    | lines
    | each { split row ',' | each { into int }};
    
    $lines
    | enumerate
    | each {|i|
        $lines 
        | skip ($i.index + 1)
        | each {|j| area $i.item $j}
    }
    | flatten
    | sort-by { $in * -1 }
    | first
}   

def area [a, b] {
    (
        (((($a | first) - ($b | first)) | math abs) + 1) * 
        (((($a | last) - ($b | last)) | math abs) + 1)
    )
}
