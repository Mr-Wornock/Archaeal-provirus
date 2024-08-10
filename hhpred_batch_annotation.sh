#!/bin/bash
for prot in `ls *.faa`
do
	hhsearch -i $prot -d /home/Public/software/hhsuite/hhsuite_db/pdb_70/pdb70 -d /home/Public/software/hhsuite/hhsuite_db/pdb_30/pdb30 -d /home/Public/software/hhsuite/hhsuite_db/COG_KOG/COG_KOG /home/Public/software/hhsuite/hhsuite_db/pfam/pfam -e 0.001 -o $prot.hhr -blasttab $prot.blastout -cpu 24 -hide_cons -hide_pred -hide_dssp -p 85 -E 1e-3 -Z
done
