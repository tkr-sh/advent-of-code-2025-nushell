def main [input: string] {
    let lines = open -r $input | lines;
    
    let start_idx = $lines | first | str index-of 'S';

    $lines
    | slice 1..
    | reduce --fold [{ index: $start_idx, possibility: 1}] {|line, acc_lines|
        $acc_lines
        | reduce --fold [] {|beam, acc|
            if ($line | split chars | get $beam.index) == '^' {
                $acc
                | where index != ($beam.index - 1) and index != ($beam.index + 1)
                | append [
                    (
                        $acc
                        | where index == ($beam.index - 1)
                        | get 0 --optional
                        | default { index: ($beam.index - 1), possibility: 0}
                        | update possibility {$in + $beam.possibility}
                    ),
                    ({ index: ($beam.index + 1), possibility: $beam.possibility})
                ]
            } else {
                $acc
                | where index != $beam.index
                | append [
                    (
                        $acc
                        | where index == ($beam.index)
                        | get 0 --optional
                        | default { index: $beam.index, possibility: 0}
                        | update possibility {$in + $beam.possibility}
                    )
                ]
            }
        }
    }
    | each { $in.possibility }
    | math sum
}
