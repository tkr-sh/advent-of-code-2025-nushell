def main [input: string] {
    let lines = open -r $input | lines;
    
    let start_idx = $lines | first | str index-of 'S';

    $lines
    | slice 1..
    | reduce --fold [{ index: $start_idx, possibility: 1}] {|line, acc_lines|
        $acc_lines
        | reduce --fold [] {|beam, acc|
            let idx = $beam.index | into int;
            if ($line | split chars | get $idx) == '^' {
                let possibility_minus = $acc | where index == ($idx - 1) | get 0 --optional | default { index: ($idx - 1), possibility: 0};

                ($acc | where index != ($idx - 1) and index != ($idx + 1) | append [
                    ($possibility_minus | update possibility {$in + $beam.possibility}),
                    ({ index: ($idx + 1), possibility: $beam.possibility})
                ])
            } else {
                let current = $acc | where index == ($idx) | get 0 --optional | default { index: $idx, possibility: 0};

                ($acc | where index != $idx | append [
                    ($current | update possibility {$in + $beam.possibility})
                ])
            }
        }
    }
    | each { $in.possibility }
    | math sum
}
