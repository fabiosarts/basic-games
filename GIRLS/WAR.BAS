DEFINT A-Z
DECLARE SUB mousehide ()
DECLARE SUB MouseShow ()
DECLARE SUB mousestatus (lb%, rb%, xmouse%, ymouse%)
DECLARE FUNCTION MouseInit% ()
DECLARE SUB MouseDriver (AX%, bx%, CX%, DX%)

DIM SHARED mouse$
DIM x(30), y(30), tx(30), ty(30), t(30)
RESTORE
mouse$ = SPACE$(57)
FOR I% = 1 TO 57
  READ a$
  H$ = CHR$(VAL("&H" + a$))
  MID$(mouse$, I%, 1) = H$
NEXT I%
DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
DATA 8B,5E,06,89,17,5D,CA,08,00
DIM me1%(50)
DIM me2%(50)
SCREEN 12
FOR y = 1 TO 10
FOR x = 1 TO 10
READ c
IF c > 0 THEN
PSET (x, y), c + 8
PSET (x + 10, y), c + 12
END IF
NEXT x
NEXT y
GET (1, 1)-(10, 10), me1%
GET (11, 1)-(20, 10), me2%
CLS
MS% = MouseInit%
IF NOT MS% THEN
  PRINT "Mouse not found": LET AMOUSE$ = "NO":
  PRINT "This Game Won't Run Without Mouse"
  END
END IF
LET AMOUSE$ = "YES"

SCREEN 12
x1 = -1
life1 = 200
life2 = 200
DO
ox1 = x1: oy1 = y1: ox2 = x2: oy2 = y2
mousestatus lb1, rb1, x1, y1
x2 = x2 + (STICK(0) - 100) / 5
y2 = y2 + (STICK(1) - 100) / 5
lb2 = STRIG(0)
rb2 = STRIG(4)
IF lb1 THEN
    GOSUB freebomb
    x(a) = x1: y(a) = y1
    tx(a) = x2: ty(a) = y2
    t(a) = 2
    life1 = life1 - 1
END IF
IF lb2 THEN
    GOSUB freebomb
    x(a) = x2: y(a) = y2
    tx(a) = x1: ty(a) = y1
    t(a) = 1
    life2 = life2 - 1
END IF
IF rb1 THEN
LINE (x1, y1)-(x2, y2), 10
SOUND 500, .1
LINE (x1, y1)-(x2, y2), 2
SOUND 37, .1
LINE (x1, y1)-(x2, y2), 0
SOUND 200, .1
life1 = life1 - 6
life2 = life2 - 3
END IF
IF rb2 THEN
LINE (x1, y1)-(x2, y2), 9
SOUND 100, .1
LINE (x1, y1)-(x2, y2), 1
SOUND 200, .1
LINE (x1, y1)-(x2, y2), 0
SOUND 300, .1
life2 = life2 - 6
life1 = life1 - 3
END IF
IF x2 < 0 THEN x2 = 0
IF y2 < 0 THEN y2 = 0
IF x2 > 620 THEN x2 = 620
IF y2 > 460 THEN y2 = 460
IF x1 < 0 THEN x1 = 0
IF y1 < 0 THEN y1 = 0
IF x1 > 620 THEN x1 = 620
IF y1 > 460 THEN y1 = 460
IF ox1 > -1 THEN PUT (ox1, oy1), me1%: PUT (ox2, oy2), me2%
PUT (x1, y1), me1%, PSET
PUT (x2, y2), me2%, PSET
FOR a = 1 TO 30
    IF x(a) <> tx(a) OR y(a) <> ty(a) THEN
        CIRCLE (x(a), y(a)), 5, 0
        FOR mv = 1 TO 20
        IF tx(a) < x(a) THEN x(a) = x(a) - 1
        IF tx(a) > x(a) THEN x(a) = x(a) + 1
        IF ty(a) < y(a) THEN y(a) = y(a) - 1
        IF ty(a) > y(a) THEN y(a) = y(a) + 1
        NEXT mv
        IF x(a) <> tx(a) OR y(a) <> ty(a) THEN CIRCLE (x(a), y(a)), 5, 15
        IF t(a) = 1 THEN
            IF x(a) + 5 > x1 AND x(a) - 5 < x1 + 10 AND y(a) + 5 > y1 AND y(a) - 5 < y1 + 10 THEN life1 = life1 - 8: FOR p = 1 TO 10: SOUND 37 + p * 20 * RND, .1: NEXT p
        ELSE
            IF x(a) + 5 > x2 AND x(a) - 5 < x2 + 10 AND y(a) + 5 > y2 AND y(a) - 5 < y2 + 10 THEN life2 = life2 - 8: FOR p = 1 TO 10: SOUND 37 + p * 20 * RND, .1: NEXT p
        END IF
    END IF
NEXT a
LINE (0, 0)-(life1, 10), 11, BF
LINE (life1, 0)-(200, 10), 0, BF
LINE (640, 0)-(640 - life2, 10), 15, BF
LINE (640 - life2, 0)-(440, 10), 0, BF
LOOP WHILE life1 > 0 AND life2 > 0
FOR a = 1 TO 100
IF life1 <= 0 THEN CIRCLE (x1, y1), a, 12 + CINT(RND) * 2
IF life2 <= 0 THEN CIRCLE (x2, y2), a, 12 + CINT(RND) * 2
NEXT a

END


DATA 0,0,2,2,2,2,2,2,0,0
DATA 0,2,3,3,3,3,3,3,2,0
DATA 2,3,1,1,3,3,1,1,3,2
DATA 2,3,1,1,3,3,1,1,3,2
DATA 2,3,3,3,3,1,3,3,3,2
DATA 2,3,3,3,1,1,3,3,3,2
DATA 2,3,3,3,3,3,3,3,3,2
DATA 2,3,1,3,3,3,3,1,0,2
DATA 0,2,3,1,1,1,1,3,2,0
DATA 0,0,2,2,2,2,2,2,0,0

freebomb:
f = 0
FOR a = 1 TO 30
IF x(a) = tx(a) AND y(a) = ty(a) THEN f = a: a = 30
NEXT a
a = f
RETURN

DEFSNG A-Z
SUB bmp (filename$, x$)
CLS
OPEN filename$ FOR BINARY AS #1

header$ = SPACE$(14)
sizing$ = SPACE$(4)
GET #1, 1, header$
GET #1, 15, sizing$
bmpinfosize = CVI(sizing$)
IF bmpinfosize = 12 THEN
   infoheader$ = SPACE$(12)
   GET #1, 15, infoheader$
   nbits = CVI(MID$(infoheader$, 15, 4))
 
   IF nbits = 1 THEN
      palet$ = SPACE$(6)
      GET #1, bmpinfosize + 15, palet$
   ELSEIF nbits = 4 THEN
      palet$ = SPACE$(48)
      GET #1, bmpinfosize + 15, palet$
   ELSEIF nbits = 8 THEN
      palet$ = SPACE$(768)
      GET #1, bmpinfosize + 15, palet$
   END IF
ELSEIF bmpinfosize = 40 THEN
   infoheader$ = SPACE$(40)
   GET #1, 15, infoheader$
   nbits = CVI(MID$(infoheader$, 15, 4))
   IF nbits = 1 THEN
      palet$ = SPACE$(8)
      GET #1, bmpinfosize + 15, palet$
   ELSEIF nbits = 4 THEN
      palet$ = SPACE$(64)
      GET #1, bmpinfosize + 15, palet$
   ELSEIF nbits = 8 THEN
      palet$ = SPACE$(1024)
      GET #1, bmpinfosize + 15, palet$
   END IF
END IF
    

ft$ = MID$(header$, 1, 2)

filesize = CVL(MID$(header$, 3, 4))

r1 = CVI(MID$(header$, 7, 2))

r2 = CVI(MID$(header$, 9, 2))

offset = CVL(MID$(header$, 11, 4))


headersize = CVL(MID$(infoheader$, 1, 4))

picwidth = CVL(MID$(infoheader$, 5, 4))

picheight = CVL(MID$(infoheader$, 9, 4))

nplanes = CVI(MID$(infoheader$, 13, 4))


IF headersize = 40 THEN
   comptype = CVL(MID$(infoheader$, 17, 4))
 
   imagesize = CVL(MID$(infoheader$, 21, 4))
 
   xsize = CVL(MID$(infoheader$, 25, 4))
 
   ysize = CVL(MID$(infoheader$, 29, 4))
 
   colorsused = CVL(MID$(infoheader$, 33, 4))
 
   neededcolours = CVL(MID$(infoheader$, 37, 4))
END IF

IF nbits = 1 THEN
   SCREEN 11
ELSEIF nbits = 4 THEN
   SCREEN 12
ELSEIF nbits = 8 OR nbits = 24 THEN
   SCREEN 13
END IF
LOCATE 1, 40: PRINT "Loading Palette..."
IF bmpinfosize = 40 THEN ngroups = 4
IF bmpinfosize = 12 THEN ngroups = 3

IF nbits = 24 THEN
   IF ngroups = 3 THEN
      FOR c = 0 TO 63
         d = c * 4
         palet$ = palet$ + CHR$(d) + CHR$(d) + CHR$(d)
         palet$ = palet$ + CHR$(d) + CHR$(d) + CHR$(d + 1)
         palet$ = palet$ + CHR$(d) + CHR$(d + 1) + CHR$(d)
         palet$ = palet$ + CHR$(d + 1) + CHR$(d) + CHR$(d)
      NEXT c
   ELSEIF ngroups = 4 THEN
      FOR c = 0 TO 63
         d = c * 4
         palet$ = palet$ + CHR$(d) + CHR$(d) + CHR$(d) + CHR$(0)
         palet$ = palet$ + CHR$(d) + CHR$(d) + CHR$(d + 1) + CHR$(0)
         palet$ = palet$ + CHR$(d) + CHR$(d + 1) + CHR$(d) + CHR$(0)
         palet$ = palet$ + CHR$(d + 1) + CHR$(d) + CHR$(d) + CHR$(0)
      NEXT c
   END IF
END IF

FOR x = 1 TO LEN(palet$) STEP ngroups
   zb# = INT((ASC(MID$(palet$, x, 1))) / 4): '''45345353thghfdgdhg gfhfd
   zg# = INT((ASC(MID$(palet$, x + 1, 1))) / 4)
   zr# = INT((ASC(MID$(palet$, x + 2, 1))) / 4)
   zc# = zb# * 65536# + zg# * 256# + zr#
   cres = ASC(MID$(palet$, x + 3, 1))
   PALETTE ((x - 1) / ngroups), zc#
NEXT x

IF nbits = 24 THEN
   y = picheight - 1
   x = 0
   dat$ = "   "
   WHILE y >= 0
      WHILE x < picwidth
         GET 1, , dat$
         p1 = INT((ASC(MID$(dat$, 1, 1)) + ASC(MID$(dat$, 1, 1)) + ASC(MID$(dat$, 1, 1))) / 3)
         x = x + 1
      WEND
      y = y - 1
      x = 0
   WEND
ELSEIF nbits = 8 THEN
   y = picheight - 1
   x = 0
   dat$ = " "
   WHILE y >= 0
      WHILE x < picwidth
         GET 1, , dat$
         x = x + 1
      WEND
      y = y - 1
      x = 0
   WEND
ELSEIF nbits = 4 THEN
   y = picheight - 1
   x = 0
   dat$ = " "
   WHILE y >= 0
      WHILE x < picwidth
        GET 1, , dat$
        LOCATE 1, 1
        p1 = ASC(dat$) AND 15
        p2 = ASC(dat$) AND 240 / 16
        x = x + 2
      WEND
      y = y - 1
      x = 0
   WEND
ELSEIF nbits = 1 THEN
   y = picheight - 1
   x = 0
   dat$ = " "
   WHILE y >= 0
      WHILE x < picwidth
        GET 1, , dat$
        p1 = ASC(dat$)
        FOR p = 0 TO 7
        NEXT p
        x = x + 8
      WEND
      y = y - 1
      x = 0
   WEND
END IF

CLOSE

END SUB

SUB getbutton
DO
mousestatus lb%, rb%, xmouse%, ymouse%
IF lb% = -1 THEN EXIT DO
LOOP UNTIL INKEY$ <> ""
hotmail:
mousestatus lb%, rb%, xmouse%, ymouse%
IF lb% = -1 THEN GOTO hotmail
END SUB

SUB MouseDriver (AX%, bx%, CX%, DX%)
  DEF SEG = VARSEG(mouse$)
  mouse% = SADD(mouse$)
  CALL Absolute(AX%, bx%, CX%, DX%, mouse%)
END SUB

SUB mousehide
 AX% = 2
 MouseDriver AX%, 0, 0, 0

END SUB

FUNCTION MouseInit%
  AX% = 0
  MouseDriver AX%, 0, 0, 0
  MouseInit% = AX%

END FUNCTION

SUB Mouseput
  AX% = 4
  CX% = x%
  DX% = y%
  MouseDriver AX%, 0, CX%, DX%

END SUB

SUB MouseShow
  AX% = 1
  MouseDriver AX%, 0, 0, 0

END SUB

SUB mousestatus (lb%, rb%, xmouse%, ymouse%)
  AX% = 3
  MouseDriver AX%, bx%, CX%, DX%
  lb% = ((bx% AND 1) <> 0)
  rb% = ((bx% AND 2) <> 0)
  xmouse% = CX%
  ymouse% = DX%
END SUB

