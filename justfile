set shell := ["nu", "-c"]

scaffold n:
    mkdir {{n}}
    cp -r ./template/* ./{{n}}

run day is_first is_example:
    @nu ./run.nu {{day}} {{is_first}} {{is_example}}

run-all:
    @ls | \
        where type == 'dir' | \
        where name != 'template' | \
        each {|$file| \
            nu ./run.nu ($file.name) true false; \
            nu ./run.nu ($file.name) false false; \
        }

