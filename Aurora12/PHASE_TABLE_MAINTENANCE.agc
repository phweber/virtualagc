### FILE="Main.annotation"
# Copyright:    Public domain.
# Filename:     PHASE_TABLE_MAINTENANCE.agc
# Purpose:      Part of the source code for Aurora (revision 12).
# Assembler:    yaYUL
# Contact:      Ron Burkey <info@sandroid.org>.
# Website:      https://www.ibiblio.org/apollo.
# Pages:        148-150
# Mod history:  2016-09-20 JL   Created.
#		2016-10-03 JL	Transcribed pages 148-150.

# This source code has been transcribed or otherwise adapted from
# digitized images of a hardcopy from the private collection of
# Don Eyles.  The digitization was performed by archive.org.

# Notations on the hardcopy document read, in part:

#       473423A YUL SYSTEM FOR BLK2: REVISION 12 of PROGRAM AURORA BY DAP GROUP
#       NOV 10, 1966

#       [Note that this is the date the hardcopy was made, not the
#       date of the program revision or the assembly.]

# The scan images (with suitable reduction in storage size and consequent
# reduction in image quality) are available online at
#       https://www.ibiblio.org/apollo.
# The original high-quality digital images are available at archive.org:
#       https://archive.org/details/aurora00dapg

## Page 148
# 	THE FOLLOWING ROUTINES ARE PROVIDED TO MAINTAIN THE PHASE TABLE. TWO ROUTINES ARE AVILABLE:

#		TC	PHASCHNG	SLOWER BUT LESS STORAGE.
#		OCT	PPPGG		CHANGE RESTART GROUP GG TO PHASE PPP
#					(PPP IS A SIGNED 8 BIT NUMBER).

#		CA	PPPPP		NEW PHASE ARRIVES IN A.
#		TC	NEWPHASE
#		OCT	000GG		UPDATES GG.

#	IN ALL CASES THE OLD PHASE RETURNS IN A. IF THE OLD PHASE WAS NEGATIVE, CALL A ROUTINE USING THE
# CORRESPONDING TERMCADR.

		SETLOC	ENDWAITF

PHASCHNG	INHINT
		INDEX	Q
		CAF	0		# GET PARAMETER WORD.
		TS	RUPTREG4
		MASK	LOW5		# GROUP NUMBER 0 - 37.
		DOUBLE
		XCH	RUPTREG4
		EXTEND
		MP	BIT9		# SIGNED NEW PHASE.
		TCF	PHASCH2

NEWPHASE	INHINT			# NEW PHASE ARRIVES IN A.
		TS	RUPTREG4
		INDEX	Q
		CAF	0		# GROUP NUMBER.
		DOUBLE
		XCH	RUPTREG4

PHASCH2		TS	LXCH		# DIRECT VERSION.
		COM			# COMPLEMENTED VERSION IMMEDIATELY PRE-
		INDEX	RUPTREG4	# CEDES THE DIRECT ONE.
		DXCH	-PHASE0		# COPIES DISAGREE FOR MINIMUM TIME.
		EXTEND
		BZMF	PHASEXIT	# IF NO DERAIL.

## Page 149
		TS	RUPTREG1	# IF NEGATIVE, SAVE ABSOLUTE VALUE OF
		EXTEND			# OLD PHASE AND RETURN Q.
		QXCH	RUPTREG2
		CA	RUPTREG4	# GET BACK GROUP NUMBER.
		EXTEND
		MP	HALF
		INDEX	A		# SELECT TERMCADR.
		CAF	TERMCADR
		TC	ISWCALL

		DXCH	RUPTREG1	# -OLD PHASE BITS TO A - RETURN -1 TO L.
		LXCH	Q

PHASEXIT	COM			# RETURN OLD PHASE IN A.
		RELINT
		INDEX	Q
		TC	1

TERMCADR	CADR	10000		# FILLED IN AS NEEDED.
		CADR	10000
		CADR	10000
		CADR	10000
		CADR	10000
		CADR	10000

## Page 150
#	SUBROUTINE TO UPDATE THE PROGRAM NUMBER DISPLAY ON THE DSKY.

NEWMODEX	INDEX	Q		# UPDATE MODREG.
		CAF	0
		INCR	Q
		XCH	MODREG
		COM			# IF NO CHANGE IN MODE, RETURN IMMEDIATELY
		AD	MODREG
		EXTEND
		BZF	TCQ

		CAF	+2		# CALL PINBALL SUBROUTINE.
		TCF	SWCALL		# WITH Q SET TO CALLERS RETURN.

		CADR	DSPMM

# 	RETURN TO CALLER +3 IF MODE = THAT AT CALLER +1. OTHERWISE RETURN TO CALLER +2.

CHECKMM		INDEX	Q
		CS	0
		AD	MODREG
		EXTEND
		BZF	+3

		INDEX	Q
		TC	1		# NO MATCH.

		INDEX	Q
TCQ		TC	2		# (ALWAYS AVAILABLE TO BZF & BZMF)

ENDPHMNF	EQUALS
