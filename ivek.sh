#!/usr/bin/env bash

# ívek létrehozása, A4 méretű lapokra, kihagyva az első két oldalat, ami a fedőlap, négy ív van egy csoportban, az utolsó két oldal azonos a harmadikkal hátulról, avagy üres.
# P_W, P_H -- nyomtatási lap szélessége, magassága
# W, H     -- oldal szélessége, magassága
# x, y     -- oldalak száma az íven vízszintesen és függőlegesen
P_W=210
P_H=297
W=100
H=140
x=2
y=2

pdfjam \
	füzet.pdf 18,3,14,7,4,17,8,13,16,5,12,9,6,15,10,11,32,19,30,23,20,32,24,29,32,21,28,25,22,31,26,27 \
	--nup 2x2 \
	--fitpaper false \
	--noautoscale true \
	--outfile füzet_ívek_tmp.pdf
	# --papersize '{210mm,297mm}' \ #--trim '-8.5mm -5mm -8.5mm -5mm' \
	# --offset "$(dc <<< "1k ${P_W} ${W} ${x} * - 2 / _1 * p")mm $(dc <<< "1k ${P_H} ${H} ${y} * - 2 / p")mm" \

# a levágások sablonjának oldalankénti almalmazása, majd az összes oldal összefűzése egy állományba
# az oldalak száma változhat, de ebben az esetben nyolc oldala volt a nyomtatási íveknek.
for i in {1..8}; do
	echo ${i};
	pdfjam \
		--fitpaper false \
		--noautoscale true \
		--nup '2x1' \
		--delta '-210mm 0' \
		füzet_ívek_tmp.pdf ${i} levágás_a4.pdf \
		--outfile füzet_ívek_${i}.pdf;
done && rm füzet_ívek_tmp.sh
pdfjam \
	füzet_ívek_{1..8}.pdf \
	--outfile füzet_ívek.pdf
