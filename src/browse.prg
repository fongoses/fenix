/*
 * Fenix Open Source accounting system
 * invoices
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

memvar cRPath
function my_mg_browse(cWin, cDbf, aOptions, bOnClick, lSearch, lnavigate, cBrow)

local nHeight := 0,x

default cBrow to cDbf+"_brw_"+strx(hb_random(1,25000))
default lNavigate to .f.
default lSearch to .f.

	for x:=1 to len(aOptions[3])
		nHeight += aOptions[3][x]
	next

	DbSelectArea( cDbf )
	dbgotop()
	if lNavigate
		navigate()
	endif
   /*
	if mg_iscontrolcreated(mg_getLastFocusedWindowname(), cBrow)
		mg_Do( mg_getLastFocusedWindowname() , cBrow , "setfocus")
		return nil
	endif
	*/
   CREATE BROWSE (cBrow) of (cWin)
	   ROW aOptions[5][1]
   	COL aOptions[5][2]
      WIDTH aOptions[5][3]
      HEIGHT aOptions[5][4]
		
		FONTCOLOR {57,134,101}
		BACKCOLOR { 237,236,173 }
		BACKCOLORDYNAMIC {|nRow| if( mod( nRow , 5 ) == 0 , {174,171,241} , NIL ) }
//		backcolordynamic {|nRow| if (markrecord( cWin, cBrow, cDbf, nRow ), {0,240,0}, NIL )} 
//    SELECTIONFONTCOLOR  { 237,236,173 }
//    SELECTIONBACKCOLOR  {57,134,101}
//    ALTERNATINGROWCOLOR .T.
      FONTBOLD .T.
      FONTSIZE 12

      WORKAREA cDbf

//if lSearch
			//EasySkip .t.
//		endif

		COLUMNFIELDALL aOptions[1] 		
		COLUMNHEADERALL aOptions[2]
		COLUMNWIDTHALL aOptions[3]
		COLUMNALIGNALL	aOptions[4]
//		ONHEADERCLICKALL	aOptions[5]
		Value 1
      NAVIGATEBY "ROW"
      TOOLTIP _I("Browse")
		if valtype(bOnClick)	== "B"
			// Msg("OK detected block")
			ONDBLCLICK eval(bOnClick)
			ONENTER eval(bOnClick)
		endif

   END BROWSE
	mg_Do( cWin, cBrow, "setfocus")
//	mg_set(cWin, cbrow, "disableSync",.t.)
	
return NIL

function Navigate()
*---------------------------------------------------*   

     CREATE FRAMEBOX FrameBox_4
         ROW    517
         COL    345
         WIDTH  191
         HEIGHT 060
         CAPTION _I("Navigation")
     END FRAMEBOX            

     CREATE BUTTON But_01  
         ROW 538
         COL 350           
         WIDTH 30
         HEIGHT 30 
         PICTURE cRPath+'01.bmp'  
         TOOLTIP 'Za��tek'    
         ONCLICK  DbGoTop()                            
     END BUTTON

     CREATE BUTTON But_02 
         ROW 538
         COL 380
         WIDTH 30
         HEIGHT 30 
         PICTURE cRPath+'02.bmp'  
         TOOLTIP 'Anterior - 12'    
         ONCLICK DbSkip(-12)                   
     END BUTTON

     CREATE BUTTON But_03 
         ROW 538
         COL 410
         WIDTH 30
         HEIGHT 30 
         PICTURE cRPath+'03.bmp'  
         TOOLTIP 'Dozadu'   
         ONCLICK DbSkip(-1)                    
     END BUTTON
 
     CREATE BUTTON But_04
         ROW 538
         COL 440
         WIDTH 30
         HEIGHT 30 
         PICTURE cRPath+'04.bmp'  
         TOOLTIP 'Dop�edu'
         ONCLICK  DbSkip(1)             
     END BUTTON    
               
     CREATE BUTTON But_05
         ROW 538
         COL 470
         WIDTH 30
         HEIGHT 30 
         PICTURE cRPath+'05.bmp'  
         TOOLTIP 'Siguiente + 12'
         ONCLICK  DbSkip(12)              
     END BUTTON                    

     CREATE BUTTON But_06
         ROW 538
         COL 500
         WIDTH 30
         HEIGHT 30 
         PICTURE cRPath+'06.bmp'  
         TOOLTIP _I('Exit')
         ONCLICK DbGoBottom()                         
     END BUTTON     

return nil

function my_grid(cWin, aNiz, aOptions, bOnClick, lSearch, lnavigate, cBrow)

default cBrow to "mygrid"+strx(hb_random(1,25000))
default lNavigate to .f.
default lSearch to .f.

	if lNavigate
		navigate()
	endif
	if mg_iscontrolcreated(cWin, cBrow)
		mg_do(cWin, cBrow, "release")
		//return
	endif
// mg_log(cWin + "/"+cBrow)

	CREATE grid (cBrow) of (cWin)
      ROW aOptions[5][1]
      COL aOptions[5][2]
      WIDTH aOptions[5][3]
      HEIGHT aOptions[5][4]
      FONTCOLOR {57,134,101}
      BACKCOLOR { 237,236,173 }
//    DYNAMICBACKCOLOR {|nRow,nCol| if( mod( nRow , 5 ) == 0 , {174,171,241} , NIL ) }
//    SELECTIONFONTCOLOR  { 237,236,173 }
//    SELECTIONBACKCOLOR  {57,134,101}
//    ALTERNATINGROWCOLOR .T.
//      FONTBOLD .T.
//      FONTSIZE 10

		if lSearch
			EasySkip .t.
		endif
	//rowlabelall .f.		

		COLUMNHEADERALL aOptions[2]
		COLUMNWIDTHALL aOptions[3]
		COLUMNALIGNALL	aOptions[4]
		Items aNiz
      NAVIGATEBY "ROW"
      TOOLTIP _I("Browse")
		if valtype(bOnClick)	== "B"
			ONDBLCLICK { || bOnClick } 
			//ONDBLCLICK goandrun(cWin, cBrow, aNiz, bOnClick)
			//ONENTER goandrun(cWin, cBrow, aNiz, bOnClick)
		endif
     	value 1 
   END GRID
	mg_Do( cWin, cBrow, "setfocus")
	
return NIL

Function del_br_item( cWin, cBrowse )

local lRet := .f.
if dbrlock()
	dbdelete()
	mg_do(cWin, cBrowse, "refresh")
	mg_msginfo( _I( "Record deleted" ) )
	lRet := .T.
endif

return lRet


