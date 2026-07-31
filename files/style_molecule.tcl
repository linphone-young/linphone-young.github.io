proc QCV {{pocket_distance 5}} {
    set molid [molinfo top]
    if {$molid < 0} {puts "ERROR: No molecule loaded.";return}
    puts "QCV running on molecule ID: $molid"
    set protein_query {protein or same residue as name OC1 OC2}
    set nrep [molinfo $molid get numreps]
    for {set i [expr {$nrep-1}]} {$i>=0} {incr i -1} {mol delrep $i $molid}

        color Display Background white
        display projection Orthographic
        display depthcue off
        axes location Off

    catch {
        material change shininess Opaque 0.15
        material change shininess Transparent 0.05
    }

    color change rgb 30 0.65 0.75 0.85

    mol representation NewCartoon 0.3 10.0 4.1
    mol color Chain
    mol selection $protein_query
    mol material Opaque
    mol addrep $molid

    mol representation VDW 0.18 12
    mol color Element
    mol selection "water or resname HOH WAT TIP3 TIP3P SOL"
    mol material Opaque
    mol addrep $molid
    set water_rep [expr {[molinfo $molid get numreps]-1}]
    mol showrep $molid $water_rep off

    mol representation VDW 0.30 12
    mol color Element
    mol selection "ions or resname NA SOD CL CLA K POT CA CAL MG ZN MN FE CU BR IOD"
    mol material Opaque
    mol addrep $molid
    set ion_rep [expr {[molinfo $molid get numreps]-1}]
    mol showrep $molid  $ion_rep off
    

    set ligand_query "not ($protein_query) and not water and not ions and not resname HOH WAT TIP3 TIP3P SOL GOL ETO DMS PEG"

    set ligand_sel [atomselect $molid $ligand_query]

    if {[$ligand_sel num]>0} {

        puts "Ligand atoms: [$ligand_sel num]"

        mol representation Licorice 0.18 12 12
        mol color Name
        mol selection $ligand_query
        mol material Opaque
        mol addrep $molid

        set pocket_query "($protein_query) and same residue as within $pocket_distance of ($ligand_query)"

        set pocket_sel [atomselect $molid $pocket_query]

        if {[$pocket_sel num]>0} {

            puts "Pocket atoms: [$pocket_sel num]"

            mol representation Surf 1.5 0.6
            mol color ColorID 30
            mol selection $pocket_query
            mol material Transparent
            mol addrep $molid

            catch {material change opacity Transparent 0.30}

        } else {
            puts "No pocket residues found."
        }

        $pocket_sel delete

    } else {
        puts "No ligand detected."
    }

    $ligand_sel delete

    mol top $molid
    display resetview

    puts "=============================================="
    puts "Quick Complex View Completed"
    puts "Protein : New Cartoon / Chain"
    puts "Ligand  : Licorice / Element"
    puts "Water   : VDW"
    puts "Ion     : VDW"
    puts "Pocket  : Transparent Surface"
    puts "Distance: $pocket_distance Angstrom"
    puts "=============================================="

}