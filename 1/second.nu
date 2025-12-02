def main [file_path: string] {
    open -r $file_path
    | lines
    | reduce --fold {current: 50 total: 0} {|it, acc| 
        let diff =  $it | str replace 'R' '+' | str replace 'L' '-' | into int;

        let cross_zero = (
            (if $diff >= 0 {
                $acc.current + $diff
            } else {
                ((100 - $acc.current) mod 100) - $diff
            }) // 100
        );

        {
            current: (($acc.current + $diff) mod 100),
            total: ($acc.total + $cross_zero),
        }
    }
}
