def main [file_path: string] {
    open -r $file_path
    | lines
    | reduce --fold {current: 50 total: 0} {|it, acc| 
        let diff =  $it | str replace 'R' '+' | str replace 'L' '-' | into int;
        let next_value = (($acc.current + $diff) mod 100);

        {
            current: $next_value,
            total: ($acc.total + ($next_value == 0 | into int)),
        }
    }
}
