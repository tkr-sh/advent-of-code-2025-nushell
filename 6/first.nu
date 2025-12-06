def main [input: string] {
    let lines = open -r $input
    | lines
    | each { str trim | split row -r '\s+' }




    (0..<($lines | first | length)) 
    | each {|idx|
        let sign = $lines | last | get $idx;

        nu -c ($lines | each { $in | get $idx } | slice ..-2 | str join (" " + $sign + " ")) | into int
    }
    | math sum
}
