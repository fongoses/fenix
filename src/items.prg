/*
 * Fenix Open Source accounting system
 * Item managment
 *	
 * Copyright 2015 Davor Siklic (www.msoft.cz)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.txt.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site https://www.gnu.org/).
 *
 */

#include "marinas-gui.ch"
#include "fenix.ch"
#include "hbthread.ch"

memvar cRPath, cPath, hIni

procedure browse_items()

local cWin := "item_win"
local cAll

if !OpenItems(, 2, .t.)
	return
endif
cAll := alias()

CREATE WINDOW (cWin)
	row 0
	col 0
	width 1050
	height 600
	CAPTION _I("Browse Items")
	CHILD .T.
	MODAL .t.
	//TOPMOST .t.
	FONTSIZE 16
	create Browse item_b
		row 10
		col 10
		width 800
		height 564 		
		COLUMNFIELDALL { cAll+"->idf", cAll+"->name", cAll+"->unit", cAll+"->type", cAll+"->price", cAll+"->tax" }
		COLUMNHEADERALL {_I("Ident."), _I("Name"), _I("Unit") , _I("Type"), _I("Price"), _I("Tax") }
		COLUMNWIDTHALL { 60, 350, 80, 80, 122, 60 }
		COLUMNALIGNALL { Qt_AlignRight, Qt_AlignCenter, Qt_AlignLeft, Qt_AlignLeft, Qt_AlignCenter, Qt_AlignLeft }
		workarea alias()
		value 1
		//AUTOSIZE .t.
		rowheightall 24
		FONTSIZE 16
		//ONENTER print_invoice(mg_get(cWin, "invoice_b", "cell", mg_get(cWin,"invoice_b","value"), 1))
		//ONDBLCLICK print_invoice(mg_get(cWin, "invoice_b", "cell", mg_get(cWin,"invoice_b","value"), 1))
//		ONDBLCLICK hb_threadstart(HB_THREAD_INHERIT_PUBLIC, @print_invoice(), mg_get(cWin, "invoice_b", "cell", mg_get(cWin,"invoice_b","value"), 1))

	END BROWSE
	create button edit_b
		row 190
		col 840
		width 160
		height 60
		caption _I("Change item")
		// ONCLICK new_invoice(.T.)
		tooltip _I("Change item" )
	end button
	create button Del
		row 350
		col 840
		width 160
		height 60
		caption _I("Delete Item")
//		backcolor {0,255,0}
		//ONCLICK del_inv( cWin, cAll )
		tooltip _I("Delete item")
//    picture cRPath+"task-reject.png"
	end button

	create button Back
		row 510
		col 840
		width 160
		height 60
		caption _I("Back")
//		backcolor {0,255,0}
		ONCLICK mg_do(cWin, "release")
		tooltip _I("Close and go back")
		picture cRPath+"task-reject.png"
	end button

END WINDOW

mg_Do(cWin, "center")
mg_do(cWin, "activate") 

dbcloseall()

return

/*
****************************************************************
*** Datum:  08-13-95 00:43am
*** Naziv: AddItem()
*** Opis : Zadavanje/Editovanje materijala do kategorije
****************************************************************

Procedure AddItem(lEdit,cDbfName, lNoClose, lNoType)

local nType := 0, cName := space(50), nNo := space(18), arr[14], cMJ := "     "
local cWHD := space(20), nCena := 0, nDPH := 0, cComm := space(20)
local cType := space(30), nDod := 0, nMont := 0, aNiz[2], cDov, cBuff
local nMDPH :=0, xx, yy, lExit, x := 0, lGetAll := .f., cZD := space(14)
local nOPn := 0, nZisk := 0, nRezie := 0, nMat := 0, lKat := .f., aNizB[2]
field t_idn, n_idn, mdph, name, cena, montaz, dph,wh,comm, no
field type, mera, desc, dod, dov, opn, zisk, rezie, jcena, ZD

default lEdit to .f.          // Editacija ili Novi default novi
default lNoClose to .f.       // ne zatvara baze na kraju
default lNoType to .f.

aNiz[1] := {"Ano"}; aNiz[2] := {"Ne "}
aNizB[1] := {"m�sic�"}; aNizB[2] := {"rok�  "}

if lEdit .or. lNoclose
	lExit := .t.
endif	

arr[1] :=  {" ks  "}
arr[2] :=  {" p�r "}
arr[3] :=  {" sada"}
arr[4] :=  {" bal "}
arr[5] :=  {" bm  "}
arr[6] :=  {" l   "}
arr[7] :=  {" g   "}
arr[8] :=  {" kg  "}
arr[9] :=  {" hod "}
arr[10] :=  {" km  "}
arr[11] := {" m   "}
arr[12] := {" m2  "}
arr[13] := {" m3  "}
arr[14] := {"     "}

cDbfName := alltrim(cDbfName)
if lEdit
	nType := t_idn
	cName := name
	nNo :=   n_idn
	cMJ := mera
	cWHD := wh
	nCena := cena
	nDPH := dph
	cComm := comm
	cType := type
	nDod := dod
	nMont := montaz
	l2c(@cDov,dov,aNiz)
	cBuff := desc
	nMDPH := mdph
	nRezie := rezie
	nZisk := zisk
	nOPN := opn
	nMat := jcena
	cZD := ZD
	if nMat <> 0
		lGetAll := .t.
	endif
	if !lNoType .and. select("type") <> 0
		lGetAll := type->rozp_type
		lkat := type->katno
	endif	
else	
	lGetAll := type->rozp_type
	nType := type->t_idn
	lkat := type->katno
	if !Otvori("Dist",3,!lNoclose) .or. !otvori(cDbfName,2,lNoClose)
		return
	endif
	l2c(@cDov,.F.,aNiz)
endif

@ 6, 20 Say ""
if lGetAll
	box("aaaadddd", 15, 70)
else
	box("aaaadddd", 13, 70)
endif
	
if !lEdit
	@ m_x+1, m_y+2 Say "T��da : " + str(ntype,4)
	select select(cDbfName)
	// nNo := padright(alltrim(str(val(n_idn)+1)),18)
	if lKat
		set order to 3
		dbgobottom()            // odredjivanje sledeceg broja stavke
		nNo := padright(alltrim(str(no+1)),10)
		set order to 1
	else
		nNo := space(18)
	endif
	set cursor on
	@ m_x+1, m_y+20 Say "�. " get nNo valid !empty(nNo) .and. not_in(nNo, lKat)
	read
	if lastkey() == K_ESC
		ExProc(lExit); return
	endif
else
	@ m_x+1, m_y+2 Say "T��da : " +alltrim(str(ntype))
	@ m_x+1, m_y+20 Say "�. " +alltrim(nNo)
endif

@ m_x+3, m_y+2 Say "Jm�no polo�ky: " get cName valid !empty(cName)
read
if lastkey() == K_ESC
	ExProc(lExit); return
endif
@ m_x+5, m_y+2 Say "Typ: " get cType
read

@ m_x+5, m_y+40 Say "Rozm�ry : " get cWHD
read
@ m_x+7, m_y+2 Say "Dodavatel: " get nDod Picture "9999" valid val_kom(nDod,"Dist")
read
@ m_x+7, m_y+24 Say dist->naziv
select select(cDbfName)
If lastkey() == K_ESC
	ExProc(lExit); return
endif

@ m_x+9, m_Y+2 Say "M. J." get cMj when look(arr)
read
if lastkey() == K_ESC
	ExProc(lExit); return
endif
IF lGetAll
	x:=2
	do while .t.
		set cursor on
		@ m_x+9, m_y+20 Say "Cena materialu:" get nMat picture "9999999.99" valid !Empty(nMat)
		read
		if lastkey() == K_ESC
			ExProc(lExit); return
		endif

		nCena := calccen(nmat, nRezie, nMont, nOPN, nZisk)
		@ m_x+13, m_y+2 Say "Cena: " + str(nCena,10,2) COLOR BOLDC
		@ m_x+9, m_y+55 Say "Rezie: " get nRezie picture "999"
		@ m_x+9, m_y+67 Say "%"
		read
		if lastkey() == K_ESC
			ExProc(lExit); return
		endif
		nCena := calccen(nmat, nRezie, nMont, nOPN, nZisk)
		@ m_x+13, m_y+2 Say "Cena: " + str(nCena,10,2) COLOR BOLDC
		@ m_x+11, m_y+2 Say "Mont��: " get nmont picture "999"
		@ m_x+11, m_y+15 Say "%"
		read
	
   	nCena := calccen(nmat, nRezie, nMont, nOPN, nZisk)
		@ m_x+13, m_y+2 Say "Cena: " + str(nCena,10,2) COLOR BOLDC
		@ m_x+11, m_y+24 Say "OPN: " get nOPN picture "999"
		@ m_x+11, m_y+34 Say "%"
		read

   	nCena := calccen(nmat, nRezie, nMont, nOPN, nZisk)
		@ m_x+13, m_y+2 Say "Cena: " + str(nCena,10,2) COLOR BOLDC
		@ m_x+11, m_y+42 Say "Zisk: " get nZisk picture "999"
		@ m_x+11, m_y+54 Say "%"
		read
	
		nCena := calccen(nmat, nRezie, nMont, nOPN, nZisk)
		@ m_x+13, m_y+2 Say "Cena: " + str(nCena,10,2) COLOR BOLDC
		@ m_x+13, m_y+45 Say "%"
		@ m_x+13, m_y+30 Say "Sazba DPH: " get nDPH Picture "99"
		read
		@ m_x+13, m_y+30 Say ""
		if UpitOK("Pokracovat ?",.t.)
			exit
		endif
	enddo
else
	@ m_x+9, m_y+20 Say "Mont��" get nmont picture "9999999.99"
	read
	// @ m_x+9, m_y+55 Say "%"
	@ m_x+9, m_y+40 Say "Sazba DPH (mont��): " get nMDPH Picture "99"
	@ m_x+9, m_y+65 Say "%"
	read
	If lastkey() == K_ESC
		ExProc(lExit); return
	endif

	@ m_x+11+x, m_y+2 Say "Cena : " get nCena picture "9999999.99" valid !empty(nCena)
	read
	@ m_x+11+x, m_y+45 Say "%"
	@ m_x+11+x, m_y+30 Say "Sazba DPH: " get nDPH Picture "99"
	read
endif
If lastkey() == K_ESC
	ExProc(lExit); return
endif
l2c(@cDov,.F.,aNiz)
@ m_x+11+x, m_y+55 Say "Dovoz: " get cDov when look(aNiz)
read
@ m_x+13+x, m_y+2 Say "Koment��:" get cComm
read
if empty(cZD)
	@ m_x+13+x, m_y+35 Say "Jednotka zar.:" get cZD when look(aNizB)
	read
	cZD := justright(cZD)
endif
@ m_x+13+x, m_y+35 Say "Zaru�ni doba: " get cZD
read

xx := m_x+x; yy := m_y
Box("memo",6,60)
@ m_x, m_Y+2 Say "[ Dlouh� popis polo�ky ]"
// setcolor(INVERT)
cBuff := memoedit(cBuff, m_x+1, m_y+1, m_x+6, m_y+60,.t.) 
cBuff := memotran(cBuff, " ")
// SETCOLOR(NORMAL)
BoxC()
m_x := xx; m_y := yy
@ m_x+13+x, m_y+50 say ""
// if lkat 
//	nNo := justright(nNo)
// endif
if UpitOk("Ulo�it ?",.t.)
	select select(cDbfName)
	if lEdit .or. AddRec()
		replace t_idn with nType
		// replace n_idn with str(nNo)
		replace no with val(nNo)
		replace n_idn with nNo
		replace name with cName
		replace mera with cMj
		replace wh with cWHD
		replace cena with nCena
		replace dph with nDPH
		replace type with cType
		replace dod with nDod
		replace montaz with nmont
		replace mdph with nMdph
		replace comm with cComm
		replace dov with c2l(cDov,aniz)
		replace desc with cBuff
		replace jcena with nMat
		replace rezie with nRezie
		replace opn with nopn
		replace zisk with nZisk
		replace ZD with cZD
	endif
endif

boxc()
select select(cDbfName)
if !lExit
	dbcloseall()
endif

return
*/

****************************************************************
*** Datum:  04-10-96 10:33pm
*** Naziv: CalcCen()
*** Opis : Kalkulacija cene prema 
****************************************************************

static function CalcCen(jcena, Rezie, Mont, OPN, Zisk)

local nCena

nCena := jcena + procent(jcena,zisk) + procent(jcena, rezie) +;
  procent(jcena,opn) + procent(jcena, mont)

return nCena

func procent(cena, perc)

return round(cena*(perc/100+1)-cena,2)   // Zarada